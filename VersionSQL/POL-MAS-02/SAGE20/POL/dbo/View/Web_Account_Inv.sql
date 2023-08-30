/****** Object:  View [dbo].[Web_Account_Inv]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Account_Inv]
AS
SELECT      CASE WHEN d.ITEMTYPE = 1 THEN i.UDF_BRAND_NAMES +' '+
				i.UDF_DESCRIPTION +' '+i.UDF_VINTAGE+' ('+
				REPLACE(i.SalesUnitOfMeasure,'C','')+'/'+
				(CASE WHEN CHARINDEX('ML',i.UDF_BOTTLE_SIZE)>0 THEN
				REPLACE(i.UDF_BOTTLE_SIZE,' ML','') ELSE REPLACE(i.UDF_BOTTLE_SIZE,' ','') END)+') '+
				i.UDF_DAMAGED_NOTES ELSE d.ITEMCODEDESC END AS ItemDescription,
			ISNULL(TRY_CONVERT(int, REPLACE(i.SalesUnitOfMeasure, 'C', '')),12) AS UOM,
			CASE WHEN MAS_POL.dbo.AR_SALESPERSON.UDF_TERRITORY<>'' THEN MAS_POL.dbo.AR_SALESPERSON.UDF_TERRITORY ELSE 'NDD' END AS Territory,
			MAS_POL.dbo.AR_SALESPERSON.SALESPERSONNO,
			h.INVOICENO,
		    MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNAME AS Customer,
		    h.InvoiceDate AS TRANSACTIONDATE, 
            d.QUANTITYSHIPPED,
            d.UNITPRICE AS Price,
            h.INVOICETYPE,
            d.EXTENSIONAMT AS Total,
            d.ITEMCODE,
            h.COMMENT, 
            h.HEADERSEQNO,
            d.DETAILSEQNO,
			CASE WHEN h.UDF_NJ_COOP<>'' THEN TRY_CONVERT(int,h.UDF_NJ_COOP) ELSE NULL END AS CoopNo,
			CASE WHEN RIGHT(MAS_POL.dbo.AR_CUSTOMER.CUSTOMERTYPE, 1) = 'N' THEN 'On'
			WHEN RIGHT(MAS_POL.dbo.AR_CUSTOMER.CUSTOMERTYPE, 1) = 'F' THEN 'Off' ELSE '' END AS Premise,
			MAS_POL.dbo.AR_CUSTOMER.ARDivisionNo,
			MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNO,
			MAS_POL.dbo.AR_CUSTOMER.UDF_AFFILIATIONS as 'Affiliations',
            i.UDF_WINE_COLOR as 'WineType',
			IsNull(v.UDF_VARIETAL,'') as 'Varietal',
			i.UDF_COUNTRY as 'Country',
			IsNull(r.UDF_REGION,'') as 'Region',
			IsNull(a.UDF_NAME,'') as 'Appellation',
			CASE WHEN i.UDF_SAMPLE_FOCUS='Y' THEN 'x' ELSE '' END AS 'SampleFocus',
			CASE WHEN i.UDF_BM_FOCUS='Y' THEN 'x' ELSE '' END AS 'BmFocus',
			MAS_POL.dbo.AP_VENDOR.UDF_MASTER_VENDOR as 'MasterVendor',
			IsNull(i.UDF_ORGANIC,'') as Organic,
			IsNull(i.UDF_BIODYNAMIC,'') as Biodynamic
FROM         MAS_POL.dbo.AR_Customer INNER JOIN
                      POL.dbo.AR_InvoiceHistoryHeader_Union h ON MAS_POL.dbo.AR_Customer.CustomerNo = h.CustomerNo AND 
                      MAS_POL.dbo.AR_Customer.ARDivisionNo = h.ARDivisionNo INNER JOIN
                      POL.dbo.AR_InvoiceHistoryDetail_Union d ON h.InvoiceNo = d.InvoiceNo AND 
                      h.HeaderSeqNo = d.HeaderSeqNo INNER JOIN
                      MAS_POL.dbo.CI_Item as i ON d.ItemCode = i.ItemCode INNER JOIN
                      MAS_POL.dbo.AR_Salesperson ON MAS_POL.dbo.AR_Customer.SalespersonDivisionNo = MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo AND 
                      MAS_POL.dbo.AR_Customer.SalespersonNo = MAS_POL.dbo.AR_Salesperson.SalespersonNo LEFT OUTER JOIN
                      MAS_POL.dbo.AP_Vendor ON i.PrimaryAPDivisionNo = MAS_POL.dbo.AP_Vendor.APDivisionNo AND 
                      i.PrimaryVendorNo = MAS_POL.dbo.AP_Vendor.VendorNo LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_VARIETALS AS v ON i.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON i.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON i.UDF_SUBREGION_T = a.UDF_APPELLATION
WHERE     (h.InvoiceDate >= DATEADD(year, - 2, GETDATE()))
