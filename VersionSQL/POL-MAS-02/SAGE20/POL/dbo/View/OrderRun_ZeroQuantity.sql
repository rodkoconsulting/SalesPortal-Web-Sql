/****** Object:  View [dbo].[OrderRun_ZeroQuantity]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[OrderRun_ZeroQuantity]
AS
SELECT       h.InvoiceNo, ItemCode
FROM            MAS_POL.dbo.SO_InvoiceHeader h INNER JOIN MAS_POL.dbo.SO_InvoiceDetail d ON h.InvoiceNo = d.InvoiceNo
where ItemType = '1' and QuantityOrdered <= 0 and h.InvoiceType = 'IN'
UNION ALL
SELECT        h.PurchaseOrderNo, d.ItemCode
FROM         MAS_POL.dbo.PO_MaterialReqHeader h INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderHeader ON 
                      h.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderDetail d ON MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo = d.PurchaseOrderNo
where d.ItemType = '1' and QuantityOrdered <= 0
