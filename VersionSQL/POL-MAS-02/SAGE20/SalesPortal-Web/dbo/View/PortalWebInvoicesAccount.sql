﻿/****** Object:  View [dbo].[PortalWebInvoicesAccount]    Committed by VersionSQL https://www.versionsql.com ******/

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
	, c.SalespersonNo AS AcctR
	, h.SalespersonNo as InvR
	, CASE WHEN SUBSTRING(c.CUSTOMERTYPE, 3, 2) = 'ON' THEN 'On' ELSE 'Off' END AS Prem
	, CASE WHEN rep.UDF_TERRITORY<>'' THEN rep.UDF_TERRITORY ELSE 'NDD' END AS Ter
FROM InvHist h INNER JOIN
	MAS_POL.dbo.AR_Customer AS c ON h.ARDivisionNo = c.ARDivisionNo AND h.CustomerNo = c.CustomerNo INNER JOIN
	MAS_POL.dbo.AR_Salesperson as rep ON c.SalespersonDivisionNo = rep.SalespersonDivisionNo and c.SalespersonNo = rep.SalespersonNo 
