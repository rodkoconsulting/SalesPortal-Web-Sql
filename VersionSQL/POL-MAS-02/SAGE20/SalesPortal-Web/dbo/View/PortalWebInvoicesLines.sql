/****** Object:  View [dbo].[PortalWebInvoicesLines]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebInvoicesLines] AS
WITH InvHist AS
(
SELECT       h.InvoiceNo, InvoiceType, InvoiceDate, ARDivisionNo, CustomerNo, SalesPersonNo, Comment, UDF_NJ_COOP, ItemCode, ItemCodeDesc, QuantityShipped, UnitPrice, ExtensionAmt,ItemType
FROM            MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN
				MAS_POL.dbo.AR_InvoiceHistoryDetail d on h.InvoiceNo = d.InvoiceNo and h.HeaderSeqNo = d.HeaderSeqNo
WHERE ModuleCode = 'S/O' and InvoiceDate >= DATEADD(YEAR, - 2, GETDATE()) and ItemCode NOT IN ('/C','/COBRA')
UNION ALL
SELECT        h.InvoiceNo, InvoiceType, ShipDate, ARDivisionNo, CustomerNo, SalesPersonNo, Comment, UDF_NJ_COOP, ItemCode, ItemCodeDesc, QuantityShipped, UnitPrice, ExtensionAmt,ItemType
FROM            MAS_POL.dbo.SO_InvoiceHeader h INNER JOIN
				MAS_POL.dbo.SO_InvoiceDetail d on h.InvoiceNo = d.InvoiceNo
WHERE ItemCode NOT IN ('/C','/COBRA')
)
SELECT 
	h.InvoiceNo as 'InvNo'
	, CASE WHEN h.InvoiceType = 'CM' THEN 'C' ELSE 'I' END AS Typ
	, h.ARDivisionNo + h.CustomerNo AS AcctNo
	, CONVERT(varchar,h.InvoiceDate,23) as Date
	, h.Comment as Cmt
	, h.UDF_NJ_COOP AS Coop
	, h.SalespersonNo AS InvR
	, c.SalespersonNo AS AcctR
	, CASE WHEN h.ItemType = '1' THEN '' ELSE h.ItemCodeDesc END AS 'Desc'
	, h.ItemCode
	, CONVERT(DECIMAL(9,4),(ROUND(QuantityShipped,4))) AS Qty
	, CONVERT(DECIMAL(9,2),(ROUND(UnitPrice,2))) AS Pri
	, CONVERT(DECIMAL(9,2),(ROUND(ExtensionAmt,2))) AS Tot
FROM InvHist h INNER JOIN
	MAS_POL.dbo.AR_Customer AS c ON h.ARDivisionNo = c.ARDivisionNo AND h.CustomerNo = c.CustomerNo
