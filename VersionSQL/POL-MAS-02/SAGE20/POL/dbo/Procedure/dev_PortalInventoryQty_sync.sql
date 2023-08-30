/****** Object:  Procedure [dbo].[dev_PortalInventoryQty_sync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[dev_PortalInventoryQty_sync]
	@UserName varchar(25),
	@TimeSync datetime
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CurrentDate Datetime;
	DECLARE @TimeSyncPrev DateTime;
	DECLARE @RepCode varchar(4);
    Set @CurrentDate=GETDATE();

SELECT @RepCode = RepCode FROM Web_UserMappings where UserName=@UserName
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   MAS_POL.dbo.CI_Item.ItemCode, 
           CASE WHEN dbo.IM_InventoryAvailable.QuantityAvailable > 0.01 THEN CAST(ROUND(dbo.IM_InventoryAvailable.QuantityAvailable, 2) AS FLOAT) ELSE 0 END AS QuantityAvailable, 
           CAST(ROUND(dbo.IM_InventoryAvailable.QtyOnHand, 2) AS FLOAT) AS QtyOnHand,
           CAST(ROUND(dbo.IM_InventoryAvailable.OnSO,2) AS FLOAT) AS OnSO,
           CAST(ROUND(dbo.IM_InventoryAvailable.OnMO,2) AS FLOAT) AS OnMO, 
           CAST(ROUND(dbo.IM_InventoryAvailable.OnBO,2) AS FLOAT) AS OnBO
INTO #temp_dev_PortalInventoryQty_Current
FROM       MAS_POL.dbo.CI_Item INNER JOIN
           MAS_POL.dbo.IM_ItemWarehouse ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.IM_ItemWarehouse.ItemCode INNER JOIN
           dbo.IM_InventoryAvailable ON MAS_POL.dbo.CI_Item.ItemCode = dbo.IM_InventoryAvailable.ITEMCODE
WHERE     (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND (MAS_POL.dbo.CI_Item.ItemType = '1') AND (MAS_POL.dbo.CI_Item.Category1 = 'Y') AND (MAS_POL.dbo.IM_ItemWarehouse.WarehouseCode = '000') AND 
          (MAS_POL.dbo.IM_ItemWarehouse.QuantityOnHand + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnPurchaseOrder + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnSalesOrder
          + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnBackOrder > 0.04)
SELECT @TimeSyncPrev = MAX(TimeSync) FROM dev_PortalInventoryQty_Previous where RepCode=@RepCode
IF(@TimeSyncPrev = @TimeSync)
BEGIN
	SELECT
	CONVERT(varchar, @CurrentDate , 121) as TimeSync,
	MIN(Operation) as Operation,
	[ItemCode],
	CASE WHEN MIN(Operation)<>'D' THEN [QuantityAvailable] ELSE 0 END AS QuantityAvailable,
	CASE WHEN MIN(Operation)<>'D' THEN [QtyOnHand] ELSE 0 END AS QtyOnHand,
	CASE WHEN MIN(Operation)<>'D' THEN [OnSO] ELSE 0 END AS OnSO,
	CASE WHEN MIN(Operation)<>'D' THEN [OnMO] ELSE 0 END AS OnMO,
	CASE WHEN MIN(Operation)<>'D' THEN [OnBO] ELSE 0 END AS OnBO
FROM
(
  SELECT 'D' as Operation, [RepCode],[ItemCode],[QuantityAvailable],[QtyOnHand],[OnSO],[OnMO],[OnBO]
  FROM dbo.dev_PortalInventoryQty_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [RepCode],[ItemCode],[QuantityAvailable],[QtyOnHand],[OnSO],[OnMO],[OnBO]
  FROM #temp_dev_PortalInventoryQty_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [ItemCode],[QuantityAvailable],[QtyOnHand],[OnSO],[OnMO],[OnBO]
   
HAVING COUNT(*) = 1
 
ORDER BY  [ItemCode], Operation

END
ELSE
BEGIN
 SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
	'C' as Operation,
	[ItemCode],
	QuantityAvailable,
	QtyOnHand,
	OnSO,
	OnMO,
	OnBO
  FROM #temp_dev_PortalInventoryQty_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM dev_PortalInventoryQty_Previous where RepCode = @RepCode
INSERT dev_PortalInventoryQty_Previous(TimeSync, RepCode, ItemCode, QuantityAvailable, QtyOnHand, OnSO, OnMO, OnBO)
SELECT
	TimeSync,
	RepCode,
	ItemCode,
	QuantityAvailable,
	QtyOnHand,
	OnSO,
	OnMO,
	OnBO
FROM #temp_dev_PortalInventoryQty_Current
WHERE RepCode = @RepCode
END

END
