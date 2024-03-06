/****** Object:  View [dbo].[PO_InventoryHeld]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.PO_InventoryHeld
AS
SELECT      MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode, Sum(MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered) as POQuantityHeld 
					
FROM        MAS_POL.dbo.PO_PurchaseOrderHeader INNER JOIN
            MAS_POL.dbo.PO_PurchaseOrderDetail  ON MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo
WHERE  (MAS_POL.dbo.PO_PurchaseOrderHeader.OrderStatus='O' or MAS_POL.dbo.PO_PurchaseOrderHeader.OrderStatus='N' ) and MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType='X' and MAS_POL.dbo.PO_PurchaseOrderDetail.ItemType='1' and MAS_POL.dbo.PO_PurchaseOrderDetail.WarehouseCode='000'
	
GROUP BY MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode
