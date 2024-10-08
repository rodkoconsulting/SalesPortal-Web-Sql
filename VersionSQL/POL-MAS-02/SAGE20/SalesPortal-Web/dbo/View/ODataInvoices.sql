﻿/****** Object:  View [dbo].[ODataInvoices]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[ODataInvoices]
AS
SELECT        h.InvoiceNo as 'InvNo',
			CASE WHEN h.InvoiceType = 'CM' THEN 'C' ELSE 'I' END AS Typ
			, d.ItemCode as 'Item'
			, c.CustomerName AS 'Acct'
			, c.UDF_AFFILIATIONS AS 'Aff'
			, CASE WHEN i.UDF_BRAND_NAMES = '' THEN d .ItemCodeDesc ELSE i.UDF_BRAND_NAMES + ' ' + i.UDF_DESCRIPTION + ' ' + i.UDF_VINTAGE + ' (' + REPLACE(i.SalesUNITOFMEASURE, 'C', '') 
                         + '/' + (CASE WHEN CHARINDEX('ML', i.UDF_BOTTLE_SIZE) > 0 THEN REPLACE(i.UDF_BOTTLE_SIZE, ' ML', '') ELSE REPLACE(i.UDF_BOTTLE_SIZE, ' ', '') END) + ')' + i.UDF_DAMAGED_NOTES END AS 'Desc'
			, h.InvoiceDate AS Date
			, d.QuantityShipped AS Qty
			, d.UnitPrice AS Pri
			, d.ExtensionAmt AS Tot
			, h.Comment as Cmt
			, CASE WHEN c.UDF_PREMISIS_STATE = 'NJ' THEN h.UDF_NJ_COOP ELSE '' END AS Coop
			, c.SalespersonNo AS AcctR
			, h.SalespersonNo AS InvR, i.UDF_WINE_COLOR AS ITyp
			, IsNull(v.UDF_VARIETAL,'') AS Vari
			, i.UDF_COUNTRY AS Ctry
			, IsNull(r.UDF_REGION,'') AS Reg
			, IsNull(ap.UDF_NAME,'') AS App
			, i.UDF_MASTER_VENDOR AS Mv
			, CASE WHEN SUBSTRING(c.CUSTOMERTYPE, 3, 2) = 'ON' THEN 'On' ELSE 'Off' END AS Prem
			, CASE WHEN i.UDF_SAMPLE_FOCUS = 'Y' THEN 'Y' ELSE '' END AS Foc
			, CASE WHEN i.UDF_BM_FOCUS = 'Y' THEN 'Y' ELSE '' END AS FocBm
			,  CASE WHEN s.UDF_TERRITORY = 'NY Metro' THEN 'NYM' WHEN UDF_TERRITORY = 'NY Long Island' THEN 'NYLI' WHEN UDF_TERRITORY = 'NY Upstate' THEN 'NYU' WHEN UDF_TERRITORY = 'NY Westchester / Hudson' THEN
                          'NYW' WHEN UDF_TERRITORY = 'NJ' THEN 'NJ' WHEN UDF_TERRITORY = 'Pennsylvania' THEN 'PA' ELSE 'Manager' END AS Ter
FROM            POL.dbo.AR_InvoiceHistoryHeader_Union AS h INNER JOIN
                         POL.dbo.AR_InvoiceHistoryDetail_Union AS d ON h.InvoiceNo = d.InvoiceNo AND h.HeaderSeqNo = d.HeaderSeqNo INNER JOIN
                         MAS_POL.dbo.AR_Customer AS c ON h.ARDivisionNo = c.ARDivisionNo AND h.CustomerNo = c.CustomerNo INNER JOIN
                         MAS_POL.dbo.CI_Item AS i ON i.ItemCode = d.ItemCode LEFT OUTER JOIN
                         MAS_POL.dbo.CI_UDT_VARIETALS AS v ON i.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
                         MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON i.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
                         MAS_POL.dbo.CI_UDT_APPELLATION AS ap ON i.UDF_SUBREGION_T = ap.UDF_APPELLATION INNER JOIN
                         MAS_POL.dbo.SO_ShipToAddress AS a ON c.ARDivisionNo = a.ARDivisionNo AND c.CustomerNo = a.CustomerNo AND c.PrimaryShipToCode = a.ShipToCode INNER JOIN
                         MAS_POL.dbo.AR_UDT_SHIPPING AS s ON a.UDF_REGION_CODE = s.UDF_REGION_CODE
WHERE        (h.InvoiceDate >= DATEADD(YEAR, - 2, GETDATE())) AND (d.ItemCode <> '/C')
