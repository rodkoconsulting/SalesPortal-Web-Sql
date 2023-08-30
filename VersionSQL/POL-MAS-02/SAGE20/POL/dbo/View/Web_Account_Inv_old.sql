/****** Object:  View [dbo].[Web_Account_Inv_old]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Account_Inv_old]
AS
SELECT      CASE WHEN MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.ITEMTYPE = 1 THEN MAS_POL.dbo.CI_ITEM.UDF_BRAND_NAMES +' '+
				MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION +' '+MAS_POL.dbo.CI_ITEM.UDF_VINTAGE+' ('+
				REPLACE(MAS_POL.dbo.ci_item.SalesUnitOfMeasure,'C','')+'/'+
				(CASE WHEN CHARINDEX('ML',MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE)>0 THEN
				REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE,' ML','') ELSE REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE,' ','') END)+') '+
				MAS_POL.dbo.CI_ITEM.UDF_DAMAGED_NOTES ELSE MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.ITEMCODEDESC END AS ItemDescription,
			ISNULL(TRY_CONVERT(int, REPLACE(MAS_POL.dbo.CI_ITEM.SalesUnitOfMeasure, 'C', '')),12) AS UOM,
			CASE WHEN MAS_POL.dbo.AR_SALESPERSON.UDF_TERRITORY<>'' THEN MAS_POL.dbo.AR_SALESPERSON.UDF_TERRITORY ELSE 'NDD' END AS Territory,
			MAS_POL.dbo.AR_SALESPERSON.SALESPERSONNO,
			MAS_POL.dbo.AR_INVOICEHISTORYHEADER.INVOICENO,
		    MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNAME AS Customer,
		    MAS_POL.dbo.AR_INVOICEHISTORYHEADER.TRANSACTIONDATE, 
            MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.QUANTITYSHIPPED,
            MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.UNITPRICE AS Price,
            MAS_POL.dbo.AR_INVOICEHISTORYHEADER.INVOICETYPE,
            MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.EXTENSIONAMT AS Total,
            MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.ITEMCODE,
            MAS_POL.dbo.AR_INVOICEHISTORYHEADER.COMMENT, 
            MAS_POL.dbo.AR_INVOICEHISTORYHEADER.HEADERSEQNO,
            MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.DETAILSEQNO,
			CASE WHEN MAS_POL.dbo.AR_INVOICEHISTORYHEADER.UDF_NJ_COOP<>'' THEN TRY_CONVERT(int,MAS_POL.dbo.AR_INVOICEHISTORYHEADER.UDF_NJ_COOP) ELSE NULL END AS CoopNo,
			CASE WHEN RIGHT(MAS_POL.dbo.AR_CUSTOMER.CUSTOMERTYPE, 1) = 'N' THEN 'On'
			WHEN RIGHT(MAS_POL.dbo.AR_CUSTOMER.CUSTOMERTYPE, 1) = 'F' THEN 'Off' ELSE '' END AS Premise,
			MAS_POL.dbo.AR_CUSTOMER.ARDivisionNo,
			MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNO,
			MAS_POL.dbo.AR_CUSTOMER.UDF_AFFILIATIONS as 'Affiliations',
            MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR as 'WineType',
			IsNull(v.UDF_VARIETAL,'') as 'Varietal',
			MAS_POL.dbo.CI_ITEM.UDF_COUNTRY as 'Country',
			IsNull(r.UDF_REGION,'') as 'Region',
			IsNull(a.UDF_NAME,'') as 'Appellation',
			CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_SAMPLE_FOCUS='Y' THEN 'x' ELSE '' END AS 'SampleFocus',
			CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_BM_FOCUS='Y' THEN 'x' ELSE '' END AS 'BmFocus',
			MAS_POL.dbo.AP_VENDOR.UDF_MASTER_VENDOR as 'MasterVendor'
FROM         MAS_POL.dbo.AR_Customer INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryHeader ON MAS_POL.dbo.AR_Customer.CustomerNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.CustomerNo AND 
                      MAS_POL.dbo.AR_Customer.ARDivisionNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.ARDivisionNo INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryDetail ON MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo INNER JOIN
                      MAS_POL.dbo.CI_Item ON MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode = MAS_POL.dbo.CI_Item.ItemCode INNER JOIN
                      MAS_POL.dbo.AR_Salesperson ON MAS_POL.dbo.AR_Customer.SalespersonDivisionNo = MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo AND 
                      MAS_POL.dbo.AR_Customer.SalespersonNo = MAS_POL.dbo.AR_Salesperson.SalespersonNo INNER JOIN
                      MAS_POL.dbo.AP_Vendor ON MAS_POL.dbo.CI_Item.PrimaryAPDivisionNo = MAS_POL.dbo.AP_Vendor.APDivisionNo AND 
                      MAS_POL.dbo.CI_Item.PrimaryVendorNo = MAS_POL.dbo.AP_Vendor.VendorNo LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_VARIETALS AS v ON MAS_POL.dbo.CI_Item.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_Item.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON MAS_POL.dbo.CI_Item.UDF_SUBREGION_T = a.UDF_APPELLATION
WHERE     (MAS_POL.dbo.AR_INVOICEHISTORYHEADER.MODULECODE = 'S/O') and (MAS_POL.dbo.AR_INVOICEHISTORYHEADER.TRANSACTIONDATE >= DATEADD(year, - 2, GETDATE()))
