/****** Object:  View [dbo].[PortalWebInvoicesMain]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebInvoicesMain] AS
WITH InvHist AS
(
SELECT       DISTINCT h.InvoiceNo, h.HeaderSeqNo, InvoiceType, InvoiceDate, ARDivisionNo, CustomerNo, SalesPersonNo, Comment, UDF_NJ_COOP
FROM            MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN
				MAS_POL.dbo.AR_InvoiceHistoryDetail d on h.InvoiceNo = d.InvoiceNo and h.HeaderSeqNo = d.HeaderSeqNo
WHERE ModuleCode = 'S/O' and InvoiceDate >= DATEADD(YEAR, - 2, GETDATE()) and ItemCode NOT IN ('/C','/COBRA')
UNION ALL
SELECT        DISTINCT h.InvoiceNo, h.InvoiceNo, InvoiceType, ShipDate, ARDivisionNo, CustomerNo, SalesPersonNo, Comment, UDF_NJ_COOP
FROM            MAS_POL.dbo.SO_InvoiceHeader h INNER JOIN
				MAS_POL.dbo.SO_InvoiceDetail d on h.InvoiceNo = d.InvoiceNo
WHERE ItemCode NOT IN ('/C','/COBRA')
)
SELECT 
	h.InvoiceNo as 'InvNo'
	,h.HeaderSeqNo
	,h.InvoiceType AS Typ
	, h.ARDivisionNo + h.CustomerNo AS AcctNo
	, CONVERT(varchar,h.InvoiceDate,23) as Date
	, h.Comment as Cmt
	, h.UDF_NJ_COOP AS Coop
	, h.SalespersonNo AS InvR
	, c.SalespersonNo AS AcctR
FROM InvHist h INNER JOIN
	MAS_POL.dbo.AR_Customer AS c ON h.ARDivisionNo = c.ARDivisionNo AND h.CustomerNo = c.CustomerNo
