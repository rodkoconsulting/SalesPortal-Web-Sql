/****** Object:  View [dbo].[PortalWebInvoicesMain]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebInvoicesMain] AS
WITH InvHist AS
(
SELECT       h.InvoiceNo, h.HeaderSeqNo, InvoiceType, InvoiceDate, ARDivisionNo, CustomerNo, SalesPersonNo, Comment, UDF_NJ_COOP, ItemCode, ItemCodeDesc, QuantityShipped, UnitPrice, ExtensionAmt
FROM            MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN
				MAS_POL.dbo.AR_InvoiceHistoryDetail d on h.InvoiceNo = d.InvoiceNo and h.HeaderSeqNo = d.HeaderSeqNo
WHERE ModuleCode = 'S/O' and InvoiceDate >= DATEADD(YEAR, - 2, GETDATE()) and ItemCode NOT IN ('/C','/COBRA')
UNION ALL
SELECT        h.InvoiceNo, h.InvoiceNo, InvoiceType, ShipDate, ARDivisionNo, CustomerNo, SalesPersonNo, Comment, UDF_NJ_COOP, ItemCode, ItemCodeDesc, QuantityShipped, UnitPrice, ExtensionAmt
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
	, CASE WHEN UDF_TERRITORY = 'NJ' THEN h.UDF_NJ_COOP ELSE '' END AS Coop
	, h.SalespersonNo AS InvR
	, c.SalespersonNo AS AcctR
	, CASE WHEN i.UDF_BRAND_NAMES = '' THEN h.ItemCodeDesc ELSE '' END AS 'Desc'
	, h.ItemCode
	, CAST(ROUND(QuantityShipped,2) AS FLOAT) AS Qty
	, CAST(ROUND(UnitPrice,2) AS FLOAT) AS Pri
	, CAST(ROUND(ExtensionAmt,2) AS FLOAT) AS Tot
FROM InvHist h INNER JOIN
	MAS_POL.dbo.AR_Customer AS c ON h.ARDivisionNo = c.ARDivisionNo AND h.CustomerNo = c.CustomerNo INNER JOIN
    MAS_POL.dbo.CI_Item AS i ON i.ItemCode = h.ItemCode INNER JOIN
    MAS_POL.dbo.SO_ShipToAddress AS a ON c.ARDivisionNo = a.ARDivisionNo AND c.CustomerNo = a.CustomerNo AND c.PrimaryShipToCode = a.ShipToCode INNER JOIN
    MAS_POL.dbo.AR_UDT_SHIPPING AS s ON a.UDF_REGION_CODE = s.UDF_REGION_CODE
