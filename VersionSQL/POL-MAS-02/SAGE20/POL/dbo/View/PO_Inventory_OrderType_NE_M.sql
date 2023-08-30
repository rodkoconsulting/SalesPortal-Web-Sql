/****** Object:  View [dbo].[PO_Inventory_OrderType_NE_M]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PO_Inventory_OrderType_NE_M]
AS
SELECT     ItemCode, LineKey, PurchaseOrderNo, QuantityOrdered, QuantityReceived, PoDate, RequiredDate, OrderType, WarehouseCode, AvailableComment
FROM         dbo.PO_Inventory_CR
WHERE     (OrderType <> 'M')
