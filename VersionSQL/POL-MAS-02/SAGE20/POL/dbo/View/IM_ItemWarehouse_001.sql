/****** Object:  View [dbo].[IM_ItemWarehouse_001]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_ItemWarehouse_001]
AS
SELECT     ItemCode, QuantityOnSalesOrder, QuantityOnHand, QuantityOnBackOrder
FROM         MAS_POL.dbo.IM_ItemWarehouse
WHERE     (WarehouseCode = '001')
