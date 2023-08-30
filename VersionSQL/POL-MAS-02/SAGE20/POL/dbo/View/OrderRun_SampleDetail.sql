/****** Object:  View [dbo].[OrderRun_SampleDetail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[OrderRun_SampleDetail]
AS
SELECT     MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo, MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode, MAS_POL.dbo.PO_PurchaseOrderDetail.LineKey, 
                      MAS_POL.dbo.PO_PurchaseOrderDetail.ItemType, MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered, MAS_POL.dbo.CI_ITEM.SALESUNITOFMEASURE, MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, 
                      MAS_POL.dbo.CI_ITEM.UDF_VINTAGE
FROM         MAS_POL.dbo.PO_PurchaseOrderHeader INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderDetail ON 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo INNER JOIN
                      MAS_POL.dbo.CI_ITEM ON MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode = MAS_POL.dbo.CI_ITEM.ITEMCODE
where MAS_POL.dbo.PO_PurchaseOrderDetail.ItemType = '1'
