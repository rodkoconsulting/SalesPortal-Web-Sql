/****** Object:  View [dbo].[PortalWebInvoicesAccount]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebInvoicesAccount] AS
WITH InvHist AS
(
SELECT       DISTINCT ARDivisionNo, CustomerNo, SalespersonNo
FROM            MAS_POL.dbo.AR_InvoiceHistoryHeader h
WHERE ModuleCode = 'S/O' and InvoiceDate >= DATEADD(YEAR, - 2, GETDATE())
UNION ALL
SELECT        DISTINCT ARDivisionNo, CustomerNo, SalespersonNo
FROM            MAS_POL.dbo.SO_InvoiceHeader h
)
SELECT DISTINCT
	h.ARDivisionNo + h.CustomerNo AS AcctNo
	, c.CustomerName AS 'Acct'
	, c.UDF_AFFILIATIONS AS 'Aff'
	, h.SalespersonNo AS InvR
	, c.SalespersonNo AS AcctR
	, CASE WHEN SUBSTRING(c.CUSTOMERTYPE, 3, 2) = 'ON' THEN 'On' ELSE 'Off' END AS Prem
	, s.UDF_TERRITORY AS Ter
FROM InvHist h INNER JOIN
	MAS_POL.dbo.AR_Customer AS c ON h.ARDivisionNo = c.ARDivisionNo AND h.CustomerNo = c.CustomerNo INNER JOIN
    MAS_POL.dbo.SO_ShipToAddress AS a ON c.ARDivisionNo = a.ARDivisionNo AND c.CustomerNo = a.CustomerNo AND c.PrimaryShipToCode = a.ShipToCode INNER JOIN
    MAS_POL.dbo.AR_UDT_SHIPPING AS s ON a.UDF_REGION_CODE = s.UDF_REGION_CODE
