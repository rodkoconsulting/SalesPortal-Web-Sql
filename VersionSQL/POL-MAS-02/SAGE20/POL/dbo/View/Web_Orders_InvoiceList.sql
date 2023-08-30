/****** Object:  View [dbo].[Web_Orders_InvoiceList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Orders_InvoiceList]
AS
SELECT     CASE WHEN i.ItemType='1' THEN UDF_BRAND_NAMES + ' ' + UDF_DESCRIPTION + ' ' + UDF_VINTAGE + ' (' + REPLACE(SalesUnitOfMeasure, 'C', '') + '/'
				+ (CASE WHEN CHARINDEX('ML', UDF_BOTTLE_SIZE) > 0 THEN REPLACE(UDF_BOTTLE_SIZE, ' ML', '') ELSE REPLACE(UDF_BOTTLE_SIZE, ' ', '') END) 
                + ') ' + UDF_DAMAGED_NOTES ELSE i.ItemCodeDesc END AS ItemDescription
		   , CASE WHEN i.ItemType='1' THEN CAST(REPLACE(SalesUNITOFMEASURE, 'C', '') AS INT) ELSE 1 END AS UOM
		   , UDF_TERRITORY AS Territory
		   , inh.SALESPERSONNO
		   , CASE WHEN LEFT(inh.INVOICENO,1)='0' THEN SUBSTRING(inh.INVOICENO,2,LEN(inh.INVOICENO)-1) ELSE inh.INVOICENO END AS INVOICENO
		   , CUSTOMERNAME AS Customer
		   , INVOICEDATE AS TRANSACTIONDATE
		   , QUANTITYSHIPPED
		   , UNITPRICE AS Price
		   , CASE WHEN inh.Comment like 'BILL & HOLD TRANSFER%' THEN 'BHT'
				  WHEN inh.Comment like 'BILL & HOLD INVOICE%' OR (inh.Comment like 'BILL & HOLD%' AND ExtensionAmt > 0) THEN 'BHI'
				  WHEN ExtensionAmt = 0 THEN 'BHS'
				  ELSE InvoiceType END AS INVOICETYPE
		   , EXTENSIONAMT AS Total
		   , ind.ITEMCODE as ItemCode
		   , inh.COMMENT as Comment
		   , inh.HEADERSEQNO
		   , DETAILSEQNO
		   , CASE WHEN IsNumeric(inh.UDF_NJ_COOP)=1 AND CHARINDEX('.',inh.UDF_NJ_COOP)=0 THEN CAST(inh.UDF_NJ_COOP AS INT) ELSE NULL END as 'CoopNo'
		   , CASE WHEN RIGHT(CUSTOMERTYPE,1)='N' THEN 'On'
				  WHEN RIGHT(CUSTOMERTYPE,1)='F' THEN 'Off'
				  ELSE ''
				  END as 'Premise'
		   , UDF_WINE_COLOR as 'WineType'
		   , IsNull(v.UDF_VARIETAL,'') as 'Varietal'
		   , IsNull(r.UDF_REGION,'') as 'Region'
		   , IsNull(a.UDF_NAME,'') as 'Appellation'
		   , UDF_COUNTRY AS 'Country'
		   , CASE WHEN UDF_SAMPLE_FOCUS='Y' THEN 'x' ELSE '' END AS 'SampleFocus'
		   , CASE WHEN UDF_BM_FOCUS='Y' THEN 'x' ELSE '' END AS 'BmFocus'
		   , UDF_AFFILIATIONS as 'Affiliations'
		   , Replace(inh.ShipToName,'''','') as ShipTo
		   , IsNull(i.UDF_ORGANIC,'') as Organic
		   , IsNull(i.UDF_BIODYNAMIC,'') as Biodynamic
FROM         MAS_POL.dbo.AR_Customer INNER JOIN
                      POL.dbo.AR_InvoiceHistoryHeader_Union AS inh ON MAS_POL.dbo.AR_Customer.CustomerNo = inh.CustomerNo AND 
                      MAS_POL.dbo.AR_Customer.ARDivisionNo = inh.ARDivisionNo INNER JOIN
                      POL.dbo.AR_InvoiceHistoryDetail_Union AS ind ON inh.InvoiceNo = ind.InvoiceNo AND 
                      inh.HeaderSeqNo = ind.HeaderSeqNo INNER JOIN
                      MAS_POL.dbo.CI_Item AS i ON ind.ItemCode = i.ItemCode INNER JOIN
                      MAS_POL.dbo.AR_Salesperson as sp ON inh.SalespersonDivisionNo = sp.SalespersonDivisionNo AND 
                      inh.SalesPersonNo = sp.SalespersonNo LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_VARIETALS AS v ON i.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON i.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON i.UDF_SUBREGION_T = a.UDF_APPELLATION
WHERE     --i.ItemType='1' AND
		  sp.SALESPERSONNO NOT LIKE 'XX%' AND
		  --(sp.SALESPERSONDIVISIONNO = '00' OR sp.SALESPERSONDIVISIONNO = '02') AND 
          INVOICEDATE >= DATEADD(year, - 2, GETDATE())  AND (i.ItemCode <> '/C')
