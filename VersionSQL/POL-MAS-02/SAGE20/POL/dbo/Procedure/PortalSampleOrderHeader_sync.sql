/****** Object:  Procedure [dbo].[PortalSampleOrderHeader_sync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalSampleOrderHeader_sync]
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
		   left(PurchaseOrderNo,7) as PurchaseOrderNo,
		   left(Rep,4) as OrderRep,
		   LEFT(MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToCode,4) as ShipToCode,
		   CASE WHEN MAS_POL.dbo.PO_PurchaseOrderHeader.OrderStatus = 'X' THEN CompletionDate ELSE RequiredExpireDate END as Date,
		   CASE WHEN MAS_POL.dbo.PO_PurchaseOrderHeader.OrderStatus = 'X' THEN 1 ELSE 0 END AS isPosted
INTO #temp_PortalSampleOrderHeader_Current
FROM         MAS_POL.dbo.PO_PurchaseOrderHeader INNER JOIN dbo.PortalPoAddress ON MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToCode = dbo.PortalPoAddress.ShipToCode
WHERE    (MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType = 'X') and (MAS_POL.dbo.PO_PurchaseOrderHeader.CompletionDate >= DATEADD(year, - 1, GETDATE()) or MAS_POL.dbo.PO_PurchaseOrderHeader.OrderStatus != 'X') and ((@AccountType = 'REP' and Rep = @RepCode) or (@AccountType = 'OFF'))
SELECT @TimeSyncPrev = MAX(TimeSync) FROM PortalSampleOrderHeader_Previous where RepCode=@RepCode
IF(@TimeSyncPrev = @TimeSync)
BEGIN
	SELECT
	CONVERT(varchar, @CurrentDate , 121) as TimeSync,
	MIN(Operation) as Operation,
	[PurchaseOrderNo],
	CASE WHEN MIN(Operation)<>'D' THEN OrderRep ELSE '' END AS OrderRep,
	CASE WHEN MIN(Operation)<>'D' THEN ShipToCode ELSE '' END AS ShipToCode,
	CASE WHEN MIN(Operation)<>'D' THEN CONVERT(varchar, [Date], 12) ELSE '' END AS Date,
	CASE WHEN MIN(Operation)<>'D' THEN isPosted ELSE 0 END AS isPosted
FROM
(
  SELECT 'D' as Operation, [PurchaseOrderNo],[OrderRep],ShipToCode,[Date],isPosted
  FROM dbo.PortalSampleOrderHeader_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [PurchaseOrderNo],[OrderRep],ShipToCode,[Date],isPosted
  FROM #temp_PortalSampleOrderHeader_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [PurchaseOrderNo],[OrderRep],ShipToCode,[Date],isPosted
   
HAVING COUNT(*) = 1
 
ORDER BY  [PurchaseOrderNo]

END
ELSE
BEGIN
 SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
	'C' as Operation,
	[PurchaseOrderNo],[OrderRep],ShipToCode,CONVERT(varchar, [Date], 12) as 'Date',isPosted
  FROM #temp_PortalSampleOrderHeader_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalSampleOrderHeader_Previous where RepCode = @RepCode
INSERT PortalSampleOrderHeader_Previous(TimeSync, RepCode,[PurchaseOrderNo],[OrderRep],ShipToCode,[Date],isPosted)
SELECT
	TimeSync,
	RepCode,
	[PurchaseOrderNo],[OrderRep],ShipToCode,[Date],isPosted
FROM #temp_PortalSampleOrderHeader_Current
WHERE RepCode = @RepCode
END

END
