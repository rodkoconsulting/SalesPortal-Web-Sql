/****** Object:  View [dbo].[PortalWebInvoicesItem]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebInvoicesItem] AS
WITH InvHist AS
(
SELECT        DISTINCT d.ItemCode, ARDivisionNo, CustomerNo, SalespersonNo
FROM            MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN
				MAS_POL.dbo.AR_InvoiceHistoryDetail d on h.InvoiceNo = d.InvoiceNo and h.HeaderSeqNo = d.HeaderSeqNo
WHERE ModuleCode = 'S/O' and InvoiceDate >= DATEADD(YEAR, - 2, GETDATE()) and ItemCode NOT IN ('/C','/COBRA')
UNION ALL
SELECT        DISTINCT d.ItemCode, ARDivisionNo, CustomerNo, SalespersonNo
FROM            MAS_POL.dbo.SO_InvoiceHeader h INNER JOIN
				MAS_POL.dbo.SO_InvoiceDetail d on h.InvoiceNo = d.InvoiceNo
WHERE ItemCode NOT IN ('/C','/COBRA')
)
SELECT DISTINCT 
	h.ItemCode
	, CASE WHEN i.UDF_BRAND_NAMES = '' THEN '' ELSE i.UDF_BRAND_NAMES + ' ' + i.UDF_DESCRIPTION + ' ' + i.UDF_VINTAGE + ' (' + REPLACE(i.SalesUNITOFMEASURE, 'C', '') 
                         + '/' + (CASE WHEN CHARINDEX('ML', i.UDF_BOTTLE_SIZE) > 0 THEN REPLACE(i.UDF_BOTTLE_SIZE, ' ML', '') ELSE REPLACE(i.UDF_BOTTLE_SIZE, ' ', '') END) + ')' + i.UDF_DAMAGED_NOTES END AS 'Desc'
	, i.UDF_WINE_COLOR AS ITyp
	, IsNull(v.UDF_VARIETAL,'') AS Vari
	, i.UDF_COUNTRY AS Ctry
	, IsNull(r.UDF_REGION,'') AS Reg
	, IsNull(ap.UDF_NAME,'') AS App
	, i.UDF_MASTER_VENDOR AS Mv
	, i.UDF_ORGANIC as 'Org'
	, i.UDF_BIODYNAMIC as 'Bio'
	, CASE WHEN i.UDF_SAMPLE_FOCUS = 'Y' THEN 'Y' ELSE '' END AS Foc
	, h.SalespersonNo AS InvR
	, c.SalespersonNo AS AcctR
FROM InvHist h INNER JOIN
	MAS_POL.dbo.AR_Customer AS c ON h.ARDivisionNo = c.ARDivisionNo AND h.CustomerNo = c.CustomerNo INNER JOIN
    MAS_POL.dbo.CI_Item AS i ON h.ItemCode = i.ItemCode LEFT OUTER JOIN
    MAS_POL.dbo.CI_UDT_VARIETALS AS v ON i.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
    MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON i.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
    MAS_POL.dbo.CI_UDT_APPELLATION AS ap ON i.UDF_SUBREGION_T = ap.UDF_APPELLATION
	WHERE i.UDF_BRAND_NAMES != ''
