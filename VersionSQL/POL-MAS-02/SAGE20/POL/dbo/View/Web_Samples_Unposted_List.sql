/****** Object:  View [dbo].[Web_Samples_Unposted_List]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Samples_Unposted_List]
AS
SELECT     s.SALESPERSONNAME AS RepName
			, s.UDF_TERRITORY AS Territory
			, s.SALESPERSONNO AS RepNo
			, h.RequiredExpireDate AS Date
			, i.UDF_COUNTRY as 'Country'
			, IsNull(r.UDF_REGION,'') as 'Region'
			, IsNull(app.UDF_NAME,'') as 'Appellation'
			, i.ITEMCODE
			, i.UDF_BRAND_NAMES AS Brand
			, i.UDF_BRAND_NAMES + ' ' + i.UDF_DESCRIPTION + ' ' + i.UDF_VINTAGE + ' (' + REPLACE(i.SalesUnitOfMeasure, 'C', '') + '/' + (CASE WHEN CHARINDEX('ML', i.UDF_BOTTLE_SIZE) > 0 THEN REPLACE(i.UDF_BOTTLE_SIZE, ' ML', '') ELSE REPLACE(i.UDF_BOTTLE_SIZE, ' ', '') END) 
                      + ') ' + i.UDF_DAMAGED_NOTES AS ItemDescription
			, v.VENDORNAME
			, v.UDF_MASTER_VENDOR AS MasterVendor
			, d.QuantityOrdered AS Quantity
			, h.PurchaseOrderNo AS PoNo
			, d.LineKey AS LineIndex
			, CAST(CASE WHEN ISNUMERIC(REPLACE(i.SalesUnitOfMeasure, 'C', '')) = 1 THEN REPLACE(i.SalesUnitOfMeasure, 'C', '') ELSE '1' END AS INT) AS UOM
			, CASE WHEN i.UDF_SAMPLE_FOCUS='Y' THEN 'x' ELSE '' END AS 'SampleFocus'
			, CASE WHEN i.UDF_BM_FOCUS='Y' THEN 'x' ELSE '' END AS 'BmFocus'
			, a.ShipToName AS ShipTo
			, d.CommentText as Comment
FROM         MAS_POL.dbo.PO_PurchaseOrderHeader h INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderDetail d INNER JOIN
                      MAS_POL.dbo.CI_Item i ON d.ItemCode = i.ItemCode ON 
                      h.PurchaseOrderNo = d.PurchaseOrderNo INNER JOIN
                      MAS_POL.dbo.PO_ShipToAddress a ON h.ShipToCode = a.ShipToCode INNER JOIN
                      MAS_POL.dbo.AR_Salesperson s ON a.UDF_REP_CODE = s.SalespersonNo INNER JOIN
                      MAS_POL.dbo.AP_Vendor v ON i.PrimaryAPDivisionNo = v.APDivisionNo AND i.PrimaryVendorNo = v.VendorNo LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION r ON i.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as app ON i.UDF_SUBREGION_T = app.UDF_APPELLATION
WHERE     (s.SalespersonDivisionNo = '00') AND (h.OrderType = 'X') AND (h.OrderStatus != 'X') AND 
                      (d.PurchasesAcctKey = '00000001K')
