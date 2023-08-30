/****** Object:  View [dbo].[PolanerDb_PoDetails_test]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PolanerDb_PoDetails_test]
AS
WITH PO as
(
SELECT     MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo, MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered as Qty, 
                      MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode, MAS_POL.dbo.PO_PurchaseOrderDetail.UnitOfMeasure
FROM         MAS_POL.dbo.PO_PurchaseOrderHeader INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderDetail ON MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo
)
SELECT PO.PurchaseOrderNo, PO.ItemCode, CAST(ROUND(SUM(dbo.TryConvertUom(REPLACE(PO.UnitOfMeasure, 'C', '')) * PO.Qty),0) AS INT) AS Qty FROM 
PO 
GROUP BY PO.PurchaseOrderNo, PO.ItemCode
