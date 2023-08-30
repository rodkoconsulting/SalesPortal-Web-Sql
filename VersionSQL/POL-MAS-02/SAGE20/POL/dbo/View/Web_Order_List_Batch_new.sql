/****** Object:  View [dbo].[Web_Order_List_Batch_new]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Order_List_Batch_new]
AS
SELECT        inh.InvoiceNo
			, CustomerName AS BILLTONAME
			, CASE WHEN Year(OrderDate) < 2000 then InvoiceDate ELSE OrderDate END as OrderDate
			, InvoiceDate AS SHIPDATE
			, CASE WHEN inh.Comment like 'BILL & HOLD TRANSFER%' THEN 'BHT'
				   WHEN inh.Comment like 'BILL & HOLD INVOICE%' OR (inh.Comment like 'BILL & HOLD%' AND ExtensionAmt > 0) THEN 'BHI'
				   ELSE InvoiceType END AS INVOICETYPE
			, QuantityOrdered
			, UnitPrice
			, ExtensionAmt
			, CASE WHEN ind.ITEMTYPE = 1 THEN UDF_BRAND_NAMES + ' ' + UDF_DESCRIPTION + ' ' + UDF_VINTAGE + ' (' + REPLACE(SalesUnitOfMeasure, 'C', '') + '/'
				 + (CASE WHEN CHARINDEX('ML', UDF_BOTTLE_SIZE) > 0 THEN REPLACE(UDF_BOTTLE_SIZE, ' ML', '') ELSE REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ', '') END) + ') '
				 + UDF_DAMAGED_NOTES ELSE ind.ITEMCODEDESC END AS ItemDescription
			, ind.ItemCode
			, CAST(REPLACE(UnitOfMeasure, 'C', '') AS INT) AS UOM
			, UDF_TERRITORY AS Territory
			, inh.SalespersonNo
			, LineKey
			, inh.Comment
			, CASE WHEN IsNumeric(inh.UDF_NJ_COOP) = 1 AND CHARINDEX('.', inh.UDF_NJ_COOP) = 0 THEN CAST(inh.UDF_NJ_COOP AS INT) ELSE NULL END AS CoopNo
			, CASE WHEN RIGHT(c.CUSTOMERTYPE, 1) = 'N' THEN 'On' WHEN RIGHT(c.CUSTOMERTYPE, 1) = 'F' THEN 'Off' ELSE '' END AS Premise
			, UDF_AFFILIATIONS as Affiliations
FROM            MAS_POL.dbo.SO_InvoiceHeader as inh INNER JOIN
                         MAS_POL.dbo.AR_Customer as c ON inh.CustomerNo = c.CustomerNo AND 
                         inh.ARDivisionNo = c.ARDivisionNo INNER JOIN
                         MAS_POL.dbo.AR_Salesperson ON inh.SalespersonDivisionNo = MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo AND 
                         inh.SalespersonNo = MAS_POL.dbo.AR_Salesperson.SalespersonNo INNER JOIN
                         MAS_POL.dbo.SO_InvoiceDetail as ind ON inh.InvoiceNo = ind.InvoiceNo INNER JOIN
                         MAS_POL.dbo.CI_Item ON ind.ItemCode = MAS_POL.dbo.CI_Item.ItemCode
WHERE        (MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo = '00') and inh.SalesOrderNo = ''
