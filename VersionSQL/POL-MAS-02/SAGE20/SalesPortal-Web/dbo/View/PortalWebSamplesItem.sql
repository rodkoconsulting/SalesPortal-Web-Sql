/****** Object:  View [dbo].[PortalWebSamplesItem]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebSamplesItem] AS
SELECT 			DISTINCT s.SalespersonNo as RepNo 
				, d.ItemCode as Code
				, i.UDF_COUNTRY as Ctry
				, IsNull(r.UDF_REGION,'') as Reg
				, IsNull(ap.UDF_NAME,'') as App
				, i.UDF_BRAND_NAMES as Brnd
				, Trim(i.UDF_BRAND_NAMES + ' ' + i.UDF_DESCRIPTION + ' ' + i.UDF_VINTAGE + ' (' + REPLACE(i.SalesUnitOfMeasure, 'C', '') + '/' + (CASE WHEN CHARINDEX('ML', 
                      i.UDF_BOTTLE_SIZE) > 0 THEN REPLACE(i.UDF_BOTTLE_SIZE, ' ML', '') ELSE REPLACE(i.UDF_BOTTLE_SIZE, ' ', '') END) 
                      + ') ' + i.UDF_DAMAGED_NOTES) as 'Desc'
				, v.VENDORNAME as Vend
				, v.UDF_MASTER_VENDOR AS Mv
				, CASE WHEN i.UDF_SAMPLE_FOCUS='Y' THEN 'x' ELSE '' END AS 'Foc'
				, CASE WHEN i.UDF_BM_FOCUS='Y' THEN 'x' ELSE '' END AS 'BmFoc'
FROM         MAS_POL.dbo.PO_PurchaseOrderHeader h INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderDetail d ON 
                      h.PurchaseOrderNo = d.PurchaseOrderNo INNER JOIN
                      MAS_POL.dbo.CI_Item i ON d.ItemCode = i.ItemCode INNER JOIN
                      MAS_POL.dbo.PO_ShipToAddress a ON h.ShipToCode = a.ShipToCode INNER JOIN
                      MAS_POL.dbo.AR_Salesperson s ON a.UDF_REP_CODE = s.SalespersonNo INNER JOIN
                      MAS_POL.dbo.AP_Vendor v ON i.PrimaryAPDivisionNo = v.APDivisionNo AND i.PrimaryVendorNo = v.VendorNo LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON i.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION ap ON i.UDF_SUBREGION_T = ap.UDF_APPELLATION
WHERE     h.OrderType = 'X' AND h.CompletionDate >= DATEADD(year, - 2, GETDATE()) AND s.SalesPersonDivisionNo = '00' and d.PurchasesAcctKey = '00000001K'
