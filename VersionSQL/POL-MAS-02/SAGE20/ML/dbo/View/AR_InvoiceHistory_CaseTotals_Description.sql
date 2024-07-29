/****** Object:  View [dbo].[AR_InvoiceHistory_CaseTotals_Description]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_InvoiceHistory_CaseTotals_Description]
AS
SELECT        h.InvoiceYear, Cast(h.InvoiceDate as date) as InvoiceDate, i.UDF_BRAND_NAMES as Brand, i.UDF_DESCRIPTION as Description, i.UDF_VINTAGE as Vintage, i.SalesUnitOfMeasure AS CaseSize, i.UDF_BOTTLE_SIZE as BottleSize, SUM(h.QuantityShipped) AS QuantityShipped
FROM            dbo.AR_InvoiceHistory h INNER JOIN MAS_POL.dbo.CI_Item i on h.ItemCode = i.ItemCode
WHERE h.ItemType = 1 and h.WarehouseCode = '000' and UnitCost > 0
GROUP BY h.InvoiceYear, h.InvoiceDate, i.UDF_BRAND_NAMES, i.UDF_DESCRIPTION, i.UDF_VINTAGE, i.SalesUnitOfMeasure, i.UDF_BOTTLE_SIZE
