/****** Object:  View [dbo].[PortalWebSamplesDet]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebSamplesDet] AS
SELECT			DISTINCT h.PurchaseOrderNo AS PoNo
				, d.ItemCode AS Code
				, CONVERT(DECIMAL(9,4),(ROUND(d.QuantityOrdered,4))) AS Qty
				, CONVERT(DECIMAL(9,2),(ROUND(d.QuantityOrdered * d.UnitCost,2))) AS Cost
				, d.CommentText as ItemComment
FROM         MAS_POL.dbo.PO_PurchaseOrderHeader h INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderDetail d ON 
                      h.PurchaseOrderNo = d.PurchaseOrderNo INNER JOIN
                      MAS_POL.dbo.PO_ShipToAddress a ON h.ShipToCode = a.ShipToCode INNER JOIN
                      MAS_POL.dbo.AR_Salesperson s ON a.UDF_REP_CODE = s.SalespersonNo 
WHERE     h.OrderType = 'X' AND h.CompletionDate >= DATEADD(year, - 2, GETDATE()) AND s.SalesPersonDivisionNo = '00' and d.PurchasesAcctKey = '00000001K'
