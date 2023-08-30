/****** Object:  Procedure [dbo].[PortalInvoiceHistoryHeader_sync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalInvoiceHistoryHeader_sync]
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
		   left(MAS_POL.dbo.AR_Customer.ARDivisionNo,2) as ARDivisionNo,
		   left(MAS_POL.dbo.AR_Customer.CustomerNo,20) as CustomerNo,
		   left(MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo,7) as InvoiceNo,
		   right(MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo,1) as HSeqNo,
		   left(MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceType,2) as InvoiceType,
		   MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate as InvoiceDate,
		   left(MAS_POL.dbo.AR_InvoiceHistoryHeader.Comment,30) as Comment
INTO #temp_PortalInvoiceHistoryHeader_Current
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader INNER JOIN
                      MAS_POL.dbo.AR_Customer ON MAS_POL.dbo.AR_InvoiceHistoryHeader.ARDivisionNo = MAS_POL.dbo.AR_Customer.ARDivisionNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.CustomerNo = MAS_POL.dbo.AR_Customer.CustomerNo
WHERE     (MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate >= DATEADD(YEAR, - 1, GETDATE())) AND (MAS_POL.dbo.AR_InvoiceHistoryHeader.ModuleCode = 'S/O') 
and ((@AccountType = 'REP' and MAS_POL.dbo.AR_Customer.SalespersonNo = @RepCode) or (@AccountType = 'OFF' and MAS_POL.dbo.AR_Customer.SalespersonNo not like 'XX%'))
SELECT @TimeSyncPrev = MAX(TimeSync) FROM PortalInvoiceHistoryHeader_Previous where RepCode=@RepCode
IF(@TimeSyncPrev = @TimeSync)
BEGIN
	SELECT
	CONVERT(varchar, @CurrentDate , 121) as TimeSync,
	MIN(Operation) as Operation,
	[InvoiceNo],
	right(HSeqNo,1) as HSeqNo,
	CASE WHEN MIN(Operation)<>'D' THEN [ARDivisionNo] ELSE '' END AS ARDivisionNo,
	CASE WHEN MIN(Operation)<>'D' THEN [CustomerNo] ELSE '' END AS CustomerNo,
	CASE WHEN MIN(Operation)<>'D' THEN [InvoiceType] ELSE '' END AS InvoiceType,
	CASE WHEN MIN(Operation)<>'D' THEN CONVERT(varchar, [InvoiceDate], 12) ELSE '' END AS InvoiceDate,
	CASE WHEN MIN(Operation)<>'D' THEN [Comment] ELSE '' END AS Comment
FROM
(
  SELECT 'D' as Operation, [InvoiceNo],[HSeqNo],[ARDivisionNo],[CustomerNo],[InvoiceType],[InvoiceDate],[Comment]
  FROM dbo.PortalInvoiceHistoryHeader_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [InvoiceNo],[HSeqNo],[ARDivisionNo],[CustomerNo],[InvoiceType],[InvoiceDate],[Comment]
  FROM #temp_PortalInvoiceHistoryHeader_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [InvoiceNo],[HSeqNo],[ARDivisionNo],[CustomerNo],[InvoiceType],[InvoiceDate],[Comment]
   
HAVING COUNT(*) = 1
 
ORDER BY  [InvoiceNo],[HSeqNo]

END
ELSE
BEGIN
 SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
	'C' as Operation,
	[InvoiceNo], [HSeqNo],[ARDivisionNo],[CustomerNo],[InvoiceType],CONVERT(varchar, [InvoiceDate], 12) as 'InvoiceDate',[Comment]
  FROM #temp_PortalInvoiceHistoryHeader_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalInvoiceHistoryHeader_Previous where RepCode = @RepCode
INSERT PortalInvoiceHistoryHeader_Previous(TimeSync, RepCode,[InvoiceNo],[HSeqNo],[ARDivisionNo],[CustomerNo],[InvoiceType],[InvoiceDate],[Comment])
SELECT
	TimeSync,
	RepCode,
	[InvoiceNo], HSeqNo as HeaderSeqNo,[ARDivisionNo],[CustomerNo],[InvoiceType],[InvoiceDate],[Comment]
FROM #temp_PortalInvoiceHistoryHeader_Current
WHERE RepCode = @RepCode
END

END
