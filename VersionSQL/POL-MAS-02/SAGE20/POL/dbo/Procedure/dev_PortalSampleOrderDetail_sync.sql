/****** Object:  Procedure [dbo].[dev_PortalSampleOrderDetail_sync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[dev_PortalSampleOrderDetail_sync]
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
		   left(MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo,7) as PurchaseOrderNo,
		   right(LineKey,3) as LineKey,
		   left(ItemCode,30) as ItemCode,
		   CAST(ROUND(QuantityOrdered,2) AS FLOAT) as Quantity,  
		   LEFT(MAS_POL.dbo.PO_PurchaseOrderDetail.CommentText,2048) as Comment
INTO #temp_dev_PortalSampleOrderDetail_Current
FROM         MAS_POL.dbo.PO_PurchaseOrderDetail INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderHeader ON MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo INNER JOIN
                      dbo.PortalPoAddress ON MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToCode = dbo.PortalPoAddress.ShipToCode
WHERE    (MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType = 'X') and (MAS_POL.dbo.PO_PurchaseOrderHeader.CompletionDate >= DATEADD(year, - 1, GETDATE()) or MAS_POL.dbo.PO_PurchaseOrderHeader.OrderStatus != 'X') and ((@AccountType = 'REP' and Rep = @RepCode) or (@AccountType = 'OFF')) and QuantityOrdered > 0.04
SELECT @TimeSyncPrev = MAX(TimeSync) FROM dev_PortalSampleOrderDetail_Previous where RepCode=@RepCode
IF(@TimeSyncPrev = @TimeSync)
BEGIN
	SELECT
	CONVERT(varchar, @CurrentDate , 121) as TimeSync,
	MIN(Operation) as Operation,
	[PurchaseOrderNo],
	[LineKey],
	CASE WHEN MIN(Operation)<>'D' THEN [ItemCode] ELSE '' END AS ItemCode,
	CASE WHEN MIN(Operation)<>'D' THEN [Quantity] ELSE 0 END AS Quantity,
	CASE WHEN MIN(Operation)<>'D' THEN [Comment] ELSE '' END AS Comment
FROM
(
  SELECT 'D' as Operation, [PurchaseOrderNo],[LineKey],[ItemCode],[Quantity],[Comment]
  FROM dbo.dev_PortalSampleOrderDetail_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [PurchaseOrderNo],[LineKey],[ItemCode],[Quantity],[Comment]
  FROM #temp_dev_PortalSampleOrderDetail_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [PurchaseOrderNo],[LineKey],[ItemCode],[Quantity],[Comment]
   
HAVING COUNT(*) = 1
 
ORDER BY  [PurchaseOrderNo],[LineKey],[ItemCode],[Quantity],[Comment]

END
ELSE
BEGIN
 SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
	'C' as Operation,
	[PurchaseOrderNo],[LineKey],[ItemCode],[Quantity],[Comment]
  FROM #temp_dev_PortalSampleOrderDetail_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM dev_PortalSampleOrderDetail_Previous where RepCode = @RepCode
INSERT dev_PortalSampleOrderDetail_Previous(TimeSync, RepCode, PurchaseOrderNo, LineKey, ItemCode, Quantity,Comment)
SELECT
	TimeSync,
	RepCode,
	[PurchaseOrderNo],[LineKey],[ItemCode],[Quantity],[Comment]
FROM #temp_dev_PortalSampleOrderDetail_Current
WHERE RepCode = @RepCode
END

END
