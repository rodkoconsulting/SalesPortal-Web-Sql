/****** Object:  View [dbo].[Web_Order_List_Batch_old]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Order_List_Batch_old]
AS
SELECT        MAS_POL.dbo.SO_InvoiceHeader.InvoiceNo, MAS_POL.dbo.AR_Customer.CustomerName AS BILLTONAME
			, CASE WHEN Year(MAS_POL.dbo.SO_InvoiceHeader.OrderDate) < 2000 then MAS_POL.dbo.SO_InvoiceHeader.InvoiceDate ELSE MAS_POL.dbo.SO_InvoiceHeader.OrderDate END as OrderDate, 
                         MAS_POL.dbo.SO_InvoiceHeader.InvoiceDate AS SHIPDATE, 
                         CASE WHEN MAS_POL.dbo.SO_InvoiceDetail.ExtensionAmt = 0 or MAS_POL.dbo.SO_InvoiceHeader.Comment like 'BILL & HOLD%' THEN 'BH' ELSE MAS_POL.dbo.SO_InvoiceHeader.InvoiceType END AS INVOICETYPE, 
                         MAS_POL.dbo.SO_InvoiceDetail.QuantityOrdered, MAS_POL.dbo.SO_InvoiceDetail.UnitPrice, MAS_POL.dbo.SO_InvoiceDetail.ExtensionAmt, 
                         CASE WHEN MAS_POL.dbo.SO_INVOICEDETAIL.ITEMTYPE = 1 THEN MAS_POL.dbo.CI_ITEM.UDF_BRAND_NAMES + ' ' + MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION
                          + ' ' + MAS_POL.dbo.CI_ITEM.UDF_VINTAGE + ' (' + REPLACE(MAS_POL.dbo.ci_item.SalesUnitOfMeasure, 'C', '') + '/' + (CASE WHEN CHARINDEX('ML', 
                         MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE) > 0 THEN REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ML', '') 
                         ELSE REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ', '') END) 
                         + ') ' + MAS_POL.dbo.CI_ITEM.UDF_DAMAGED_NOTES ELSE MAS_POL.dbo.SO_INVOICEDETAIL.ITEMCODEDESC END AS ItemDescription, 
                         MAS_POL.dbo.SO_InvoiceDetail.ItemCode, CAST(REPLACE(MAS_POL.dbo.SO_InvoiceDetail.UnitOfMeasure, 'C', '') AS INT) AS UOM, 
                         MAS_POL.dbo.AR_Salesperson.UDF_TERRITORY AS Territory, MAS_POL.dbo.SO_InvoiceHeader.SalespersonNo, MAS_POL.dbo.SO_InvoiceDetail.LineKey, 
                         MAS_POL.dbo.SO_InvoiceHeader.Comment, CASE WHEN IsNumeric(MAS_POL.dbo.SO_INVOICEHEADER.UDF_NJ_COOP) = 1 AND CHARINDEX('.', 
                         MAS_POL.dbo.SO_INVOICEHEADER.UDF_NJ_COOP) = 0 THEN CAST(MAS_POL.dbo.SO_INVOICEHEADER.UDF_NJ_COOP AS INT) ELSE NULL END AS CoopNo, 
                         CASE WHEN RIGHT(MAS_POL.dbo.AR_CUSTOMER.CUSTOMERTYPE, 1) = 'N' THEN 'On' WHEN RIGHT(MAS_POL.dbo.AR_CUSTOMER.CUSTOMERTYPE, 1) 
                         = 'F' THEN 'Off' ELSE '' END AS Premise
						 , MAS_POL.dbo.AR_Customer.UDF_AFFILIATIONS as Affiliations
FROM            MAS_POL.dbo.SO_InvoiceHeader INNER JOIN
                         MAS_POL.dbo.AR_Customer ON MAS_POL.dbo.SO_InvoiceHeader.CustomerNo = MAS_POL.dbo.AR_Customer.CustomerNo AND 
                         MAS_POL.dbo.SO_InvoiceHeader.ARDivisionNo = MAS_POL.dbo.AR_Customer.ARDivisionNo INNER JOIN
                         MAS_POL.dbo.AR_Salesperson ON MAS_POL.dbo.SO_InvoiceHeader.SalespersonDivisionNo = MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo AND 
                         MAS_POL.dbo.SO_InvoiceHeader.SalespersonNo = MAS_POL.dbo.AR_Salesperson.SalespersonNo INNER JOIN
                         MAS_POL.dbo.SO_InvoiceDetail ON MAS_POL.dbo.SO_InvoiceHeader.InvoiceNo = MAS_POL.dbo.SO_InvoiceDetail.InvoiceNo INNER JOIN
                         MAS_POL.dbo.CI_Item ON MAS_POL.dbo.SO_InvoiceDetail.ItemCode = MAS_POL.dbo.CI_Item.ItemCode
WHERE        (MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo = '00') and MAS_POL.dbo.SO_InvoiceHeader.SalesOrderNo = ''
