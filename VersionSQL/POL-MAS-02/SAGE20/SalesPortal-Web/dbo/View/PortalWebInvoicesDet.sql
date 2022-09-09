/****** Object:  View [dbo].[PortalWebInvoicesDet]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebInvoicesDet] AS
WITH InvHist AS
(
SELECT       h.InvoiceNo, h.HeaderSeqNo, ItemCode, ItemCodeDesc, QuantityShipped, UnitPrice, ExtensionAmt
FROM            MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN
				MAS_POL.dbo.AR_InvoiceHistoryDetail d on h.InvoiceNo = d.InvoiceNo and h.HeaderSeqNo = d.HeaderSeqNo
WHERE ModuleCode = 'S/O' and InvoiceDate >= DATEADD(YEAR, - 2, GETDATE()) and ItemCode NOT IN ('/C','/COBRA')
UNION ALL
SELECT        h.InvoiceNo, h.InvoiceNo, ItemCode, ItemCodeDesc, QuantityShipped, UnitPrice, ExtensionAmt
FROM            MAS_POL.dbo.SO_InvoiceHeader h INNER JOIN
				MAS_POL.dbo.SO_InvoiceDetail d on h.InvoiceNo = d.InvoiceNo
WHERE ItemCode NOT IN ('/C','/COBRA')
)
SELECT 
	h.InvoiceNo as 'InvNo'
	, h.HeaderSeqNo
	, CASE WHEN i.UDF_BRAND_NAMES = '' THEN h.ItemCodeDesc ELSE '' END AS 'Desc'
	, h.ItemCode
	, CONVERT(DECIMAL(9,2),(ROUND(QuantityShipped,2))) AS Qty
	, CONVERT(DECIMAL(9,2),(ROUND(UnitPrice,2))) AS Pri
	, CONVERT(DECIMAL(9,2),(ROUND(ExtensionAmt,2))) AS Tot
FROM InvHist h INNER JOIN
    MAS_POL.dbo.CI_Item AS i ON i.ItemCode = h.ItemCode
