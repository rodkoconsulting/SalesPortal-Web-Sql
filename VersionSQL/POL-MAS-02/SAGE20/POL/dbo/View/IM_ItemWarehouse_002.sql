/****** Object:  View [dbo].[IM_ItemWarehouse_002]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_ItemWarehouse_002]
AS
SELECT     ItemCode, QuantityOnSalesOrder, QuantityOnHand, QuantityOnBackOrder
FROM         MAS_POL.dbo.IM_ItemWarehouse
WHERE     (WarehouseCode = '002')
