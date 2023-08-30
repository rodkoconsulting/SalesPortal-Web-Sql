/****** Object:  View [dbo].[IM_ItemWarehouse_000]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_ItemWarehouse_000]
AS
SELECT     ItemCode, QuantityOnHand, QuantityOnPurchaseOrder
FROM         MAS_POL.dbo.IM_ItemWarehouse
WHERE     (WarehouseCode = '000')
