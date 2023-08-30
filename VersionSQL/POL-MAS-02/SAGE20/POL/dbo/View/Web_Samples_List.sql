/****** Object:  View [dbo].[Web_Samples_List]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Samples_List]
AS
SELECT     MAS_POL.dbo.AR_SALESPERSON.SALESPERSONNAME AS RepName, MAS_POL.dbo.AR_SALESPERSON.UDF_TERRITORY AS Territory, 
                      MAS_POL.dbo.AR_SALESPERSON.SALESPERSONNO AS RepNo, 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.CompletionDate AS Date, MAS_POL.dbo.CI_ITEM.UDF_COUNTRY as 'Country',
					  IsNull(r.UDF_REGION,'') as 'Region', IsNull(a.UDF_NAME,'') as 'Appellation', MAS_POL.dbo.CI_ITEM.ITEMCODE, 
                      MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES AS Brand, MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES + ' ' + MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION 
                      + ' ' + MAS_POL.dbo.CI_ITEM.UDF_VINTAGE + ' (' + REPLACE(MAS_POL.dbo.CI_ITEM.SalesUnitOfMeasure, 'C', '') + '/' + (CASE WHEN CHARINDEX('ML', 
                      MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE) > 0 THEN REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ML', '') ELSE REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ', '') END) 
                      + ') ' + MAS_POL.dbo.CI_ITEM.UDF_DAMAGED_NOTES AS ItemDescription, MAS_POL.dbo.AP_VENDOR.VENDORNAME, 
                      MAS_POL.dbo.AP_VENDOR.UDF_MASTER_VENDOR AS MasterVendor, MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered AS Quantity, 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo AS PoNo, MAS_POL.dbo.PO_PurchaseOrderDetail.LineKey AS LineIndex, 
                      CAST(CASE WHEN ISNUMERIC(REPLACE(MAS_POL.dbo.CI_ITEM.SalesUnitOfMeasure, 'C', '')) 
                      = 1 THEN REPLACE(MAS_POL.dbo.CI_ITEM.SalesUnitOfMeasure, 'C', '') ELSE '1' END AS INT) AS UOM,
                      CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_SAMPLE_FOCUS='Y' THEN 'x' ELSE '' END AS 'SampleFocus',
                      CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_BM_FOCUS='Y' THEN 'x' ELSE '' END AS 'BmFocus',
                      MAS_POL.dbo.PO_ShipToAddress.ShipToName AS ShipTo
FROM         MAS_POL.dbo.PO_PurchaseOrderHeader INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderDetail INNER JOIN
                      MAS_POL.dbo.CI_Item ON MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode = MAS_POL.dbo.CI_Item.ItemCode ON 
                      MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo INNER JOIN
                      MAS_POL.dbo.PO_ShipToAddress ON MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToCode = MAS_POL.dbo.PO_ShipToAddress.ShipToCode INNER JOIN
                      MAS_POL.dbo.AR_Salesperson ON MAS_POL.dbo.PO_ShipToAddress.UDF_REP_CODE = MAS_POL.dbo.AR_Salesperson.SalespersonNo INNER JOIN
                      MAS_POL.dbo.AP_Vendor ON MAS_POL.dbo.CI_Item.PrimaryAPDivisionNo = MAS_POL.dbo.AP_Vendor.APDivisionNo AND MAS_POL.dbo.CI_Item.PrimaryVendorNo = MAS_POL.dbo.AP_Vendor.VendorNo LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_Item.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON MAS_POL.dbo.CI_Item.UDF_SUBREGION_T = a.UDF_APPELLATION
WHERE     (MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo = '00') AND (MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType = 'X') AND (MAS_POL.dbo.PO_PurchaseOrderHeader.CompletionDate >= DATEADD(year, - 2, GETDATE())) AND 
                      (MAS_POL.dbo.PO_PurchaseOrderDetail.PurchasesAcctKey = '00000001K')
