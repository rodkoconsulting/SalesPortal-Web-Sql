/****** Object:  View [dbo].[Web_Inventory_PO]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Inventory_PO]
AS
SELECT ItemCode, SUM(OnPO) as OnPO, MAX(PoDate) as PoDate, MAX(RequiredDate) as RequiredDate, AvailableComment, PurchaseOrderNo FROM 
(SELECT     ItemCode, SUM(QuantityOrdered-QuantityReceived) AS OnPO, MAX(PoDate) as PoDate, MAX(RequiredDate) as RequiredDate, AvailableComment, PurchaseOrderNo
FROM         dbo.PO_Inventory_OrderType_NE_M
WHERE WarehouseCode='000'
GROUP BY ItemCode, PurchaseOrderNo, AvailableComment
UNION ALL
SELECT ItemCode, OnPO, PoDate, RequiredDate, '' as AvailableComment, PurchaseOrderNo
FROM IM_ItemWarehouse_900) Derived GROUP BY ItemCode, PurchaseOrderNo, AvailableComment
