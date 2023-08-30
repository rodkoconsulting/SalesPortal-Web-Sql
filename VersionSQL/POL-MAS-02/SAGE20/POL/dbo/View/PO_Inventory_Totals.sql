/****** Object:  View [dbo].[PO_Inventory_Totals]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PO_Inventory_Totals]
AS
SELECT     TOP (100) PERCENT  MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode,MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo, Sum(MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered) as QuantityOrdered, Sum(MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityReceived) as QuantityReceived,
                      MAS_POL.dbo.PO_PurchaseOrderHeader.RequiredExpireDate as 'RequiredDate', MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType, MAS_POL.dbo.PO_PurchaseOrderHeader.WarehouseCode, 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.APDivisionNo, MAS_POL.dbo.PO_PurchaseOrderHeader.VendorNo, IsNull(MAS_POL.dbo.PO_PurchaseOrderHeader.UDF_AVAILABLE_COMMENT,'') AS Comment
FROM         MAS_POL.dbo.PO_PurchaseOrderHeader INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderDetail ON 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo
WHERE     (MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType = 'S' OR
                      MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType = 'M') AND (MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered - MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityReceived > 0) AND MAS_POL.dbo.PO_PurchaseOrderHeader.OrderStatus<>'B'
GROUP BY MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode, MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo, MAS_POL.dbo.PO_PurchaseOrderHeader.RequiredExpireDate,MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType, MAS_POL.dbo.PO_PurchaseOrderHeader.WarehouseCode,MAS_POL.dbo.PO_PurchaseOrderHeader.APDivisionNo,MAS_POL.dbo.PO_PurchaseOrderHeader.VendorNo,MAS_POL.dbo.PO_PurchaseOrderHeader.UDF_AVAILABLE_COMMENT                     
ORDER BY MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode
