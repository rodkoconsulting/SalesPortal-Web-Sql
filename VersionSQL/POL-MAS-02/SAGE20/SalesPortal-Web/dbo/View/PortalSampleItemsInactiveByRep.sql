/****** Object:  View [dbo].[PortalSampleItemsInactiveByRep]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalSampleItemsInactiveByRep]
AS
WITH ITEMHISTORY AS
(
SELECT     
	 MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode, dbo.PortalPoAddress.Rep
FROM         MAS_POL.dbo.PO_PurchaseOrderHeader INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderDetail ON PO_PurchaseOrderHeader.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo INNER JOIN
                      dbo.PortalPoAddress ON MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToCode = dbo.PortalPoAddress.ShipToCode
WHERE     (MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType = 'X') and (MAS_POL.dbo.PO_PurchaseOrderHeader.CompletionDate >= DATEADD(year, - 1, GETDATE())) AND QuantityOrdered > 0
)
SELECT DISTINCT ITEMHISTORY.Rep, ITEMHISTORY.ItemCode FROM ITEMHISTORY INNER JOIN
                      dbo.CI_Item ON ITEMHISTORY.ITEMCODE = dbo.CI_Item.ItemCode INNER JOIN
                      dbo.IM_ItemWarehouse ON ITEMHISTORY.ItemCode = dbo.IM_ItemWarehouse.ItemCode
 WHERE dbo.IM_ItemWarehouse.WarehouseCode= '000' AND (dbo.CI_ITEM.CATEGORY1 = 'N' OR
                      (dbo.IM_ItemWarehouse.QuantityOnHand + dbo.IM_ItemWarehouse.QuantityOnPurchaseOrder + dbo.IM_ItemWarehouse.QuantityOnSalesOrder + dbo.IM_ItemWarehouse.QuantityOnBackOrder
                       <= 0.04))
