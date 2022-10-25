/****** Object:  View [dbo].[PO_Inventory_CR]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PO_Inventory_CR]
AS
SELECT     TOP (100) PERCENT  MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode,MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo, MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered, MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityReceived, MAS_POL.dbo.PO_PurchaseOrderDetail.LineKey,
                      MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderDate as 'PoDate',MAS_POL.dbo.PO_PurchaseOrderHeader.RequiredExpireDate as 'RequiredDate', MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType, MAS_POL.dbo.PO_PurchaseOrderHeader.WarehouseCode, 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.APDivisionNo, MAS_POL.dbo.PO_PurchaseOrderHeader.VendorNo, PO_PurchaseOrderHeader.UDF_AVAILABLE_COMMENT as 'AvailableComment'
FROM         MAS_POL.dbo.PO_PurchaseOrderHeader INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderDetail ON 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo
WHERE     (MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType = 'S' OR
                      MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType = 'M') AND (MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered - MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityReceived > 0) AND MAS_POL.dbo.PO_PurchaseOrderHeader.OrderStatus<>'B'
ORDER BY MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode
