/****** Object:  View [dbo].[PortalWebSamplesMain]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebSamplesMain] AS
SELECT 			DISTINCT s.SalespersonNo as RepNo
				, CONVERT(varchar,h.CompletionDate,23) AS Date
				, h.PurchaseOrderNo AS PoNo 
                , a.ShipToName AS ShpTo
FROM         MAS_POL.dbo.PO_PurchaseOrderHeader h INNER JOIN
                      MAS_POL.dbo.PO_ShipToAddress a ON h.ShipToCode = a.ShipToCode INNER JOIN
                      MAS_POL.dbo.AR_Salesperson s ON a.UDF_REP_CODE = s.SalespersonNo 
WHERE      h.OrderType = 'X' AND h.CompletionDate >= DATEADD(year, - 2, GETDATE()) AND s.SalesPersonDivisionNo = '00'
