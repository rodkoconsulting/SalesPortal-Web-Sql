/****** Object:  View [dbo].[PO_CompletedThreeMonths]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PO_CompletedThreeMonths]
AS
SELECT     distinct MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode
FROM         MAS_POL.dbo.PO_PurchaseOrderHeader INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderDetail ON MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo
where MAS_POL.dbo.PO_PurchaseOrderHeader.WarehouseCode='000' and MAS_POL.dbo.PO_PurchaseOrderDetail.PurchasesAcctKey<>'000000011'  AND MAS_POL.dbo.PO_PurchaseOrderHeader.CompletionDate >= DATEADD(MONTH, -3, GETDATE())
