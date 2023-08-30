/****** Object:  Procedure [dbo].[PortalInvoiceHistoryDetail_sync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalInvoiceHistoryDetail_sync]
	@UserName varchar(25),
	@TimeSync datetime
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CurrentDate Datetime;
	DECLARE @TimeSyncPrev DateTime;
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
    Set @CurrentDate=GETDATE();
SELECT @RepCode = RepCode FROM Web_UserMappings where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_UserMappings where UserName=@UserName      
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo,7) as InvoiceNo,
		   right(MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo,1) as HSeqNo,
		   right(MAS_POL.dbo.AR_InvoiceHistoryDetail.DetailSeqNo,3) as DSeqNo,
		   left(MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode,30) as ItemCode,
		   CAST(ROUND(MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped,2) AS FLOAT) as Quantity,
		   CAST(ROUND(MAS_POL.dbo.AR_InvoiceHistoryDetail.UnitPrice,2) AS FLOAT) AS UnitPrice,
		   CAST(ROUND(MAS_POL.dbo.AR_InvoiceHistoryDetail.ExtensionAmt,2) AS FLOAT) AS Total
INTO #temp_PortalInvoiceHistoryDetail_Current
FROM         MAS_POL.dbo.AR_InvoiceHistoryDetail INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryHeader ON MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo INNER JOIN
                      MAS_POL.dbo.AR_Customer ON MAS_POL.dbo.AR_InvoiceHistoryHeader.ARDivisionNo = MAS_POL.dbo.AR_Customer.ARDivisionNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.CustomerNo = MAS_POL.dbo.AR_Customer.CustomerNo
WHERE     (MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate >= DATEADD(YEAR, - 1, GETDATE())) AND (MAS_POL.dbo.AR_InvoiceHistoryHeader.ModuleCode = 'S/O') 
and ((@AccountType = 'REP' and MAS_POL.dbo.AR_Customer.SalespersonNo = @RepCode) or (@AccountType = 'OFF' and MAS_POL.dbo.AR_Customer.SalespersonNo not like 'XX%'))
SELECT @TimeSyncPrev = MAX(TimeSync) FROM PortalInvoiceHistoryDetail_Previous where RepCode=@RepCode
IF(@TimeSyncPrev = @TimeSync)
BEGIN
	SELECT
	CONVERT(varchar, @CurrentDate , 121) as TimeSync,
	MIN(Operation) as Operation,
	[InvoiceNo],
	[HSeqNo],
	[DSeqNo],
	CASE WHEN MIN(Operation)<>'D' THEN [ItemCode] ELSE '' END AS ItemCode,
	CASE WHEN MIN(Operation)<>'D' THEN [Quantity] ELSE 0 END AS Quantity,
	CASE WHEN MIN(Operation)<>'D' THEN [UnitPrice] ELSE 0 END AS UnitPrice,
	CASE WHEN MIN(Operation)<>'D' THEN [Total] ELSE 0 END AS Total
FROM
(
  SELECT 'D' as Operation, [InvoiceNo],[HSeqNo],[DSeqNo],[ItemCode],[Quantity],[UnitPrice],[Total]
  FROM dbo.PortalInvoiceHistoryDetail_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [InvoiceNo],[HSeqNo],[DSeqNo],[ItemCode],[Quantity],[UnitPrice],[Total]
  FROM #temp_PortalInvoiceHistoryDetail_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [InvoiceNo],[HSeqNo],[DSeqNo],[ItemCode],[Quantity],[UnitPrice],[Total]
   
HAVING COUNT(*) = 1
 
ORDER BY  [InvoiceNo],[HSeqNo],[DSeqNo]

END
ELSE
BEGIN
 SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
	'C' as Operation,
	[InvoiceNo],[HSeqNo],[DSeqNo],[ItemCode],[Quantity],[UnitPrice],[Total]
  FROM #temp_PortalInvoiceHistoryDetail_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalInvoiceHistoryDetail_Previous where RepCode = @RepCode
INSERT PortalInvoiceHistoryDetail_Previous(TimeSync, RepCode,[InvoiceNo],[HSeqNo],[DSeqNo],[ItemCode],[Quantity],[UnitPrice],[Total])
SELECT
	TimeSync,
	RepCode,
	[InvoiceNo],[HSeqNo],[DSeqNo],[ItemCode],[Quantity],[UnitPrice],[Total]
FROM #temp_PortalInvoiceHistoryDetail_Current
WHERE RepCode = @RepCode
END

END
