/****** Object:  View [dbo].[AR_InvoiceHistory_CaseTotals_Item]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_InvoiceHistory_CaseTotals_Item]
AS
SELECT        InvoiceYear, Cast(InvoiceDate as date) as InvoiceDate, ItemCode, SUM(QuantityShipped) AS QuantityShipped
FROM            dbo.AR_InvoiceHistory
WHERE ItemType = 1 and WarehouseCode = '000' and UnitCost > 0
GROUP BY InvoiceYear, InvoiceDate, ItemCode
