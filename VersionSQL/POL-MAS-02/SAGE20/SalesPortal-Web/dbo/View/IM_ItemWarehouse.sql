/****** Object:  View [dbo].[IM_ItemWarehouse]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_ItemWarehouse]
AS
SELECT     
ItemCode,
WarehouseCode,
QuantityOnHand,
QuantityOnSalesOrder,
QuantityOnPurchaseOrder,
QuantityOnBackOrder,
ReorderPointQty,
AverageCost
FROM         MAS_POL.dbo.IM_ItemWarehouse
