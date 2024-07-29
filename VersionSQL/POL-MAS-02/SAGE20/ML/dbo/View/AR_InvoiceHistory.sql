/****** Object:  View [dbo].[AR_InvoiceHistory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_InvoiceHistory]
AS
SELECT        CASE WHEN Year(h.InvoiceDate) > 1900 THEN Year(h.InvoiceDate) else Year(h.TransactionDate) END as InvoiceYear
				, h.InvoiceType
				, CASE WHEN Year(h.InvoiceDate) > 1900 THEN h.InvoiceDate else h.TransactionDate END AS InvoiceDate
				, h.ARDivisionNo
				, h.CustomerNo
				, h.TermsCode
				, h.SalespersonDivisionNo
				, h.SalespersonNo
				, h.Comment
                , h.ShipVia
				, h.PaymentType
				, h.NonTaxableSalesAmt
				, h.UDF_NJ_COOP as CoopNo 
                , h.UDF_CORP_NAME as CorporateName
				, h.UDF_GUARANTEED_AM as IsGuaranteedAm
				, h.UDF_IS_BH_INV as IsBhInvoice
				, d.ItemCode
				, d.ItemType
				, d.SalesAcctKey
				, d.CostOfGoodsSoldAcctKey
				, d.WarehouseCode
				, d.PriceLevel
				, d.ProductLine
				, d.CommentText as LineComment
				, CONVERT(int, ROUND(d.QuantityShipped * ISNULL(TRY_CONVERT(int, REPLACE(i.SalesUnitOfMeasure, 'C', '')),12), 0)) as QuantityShipped
				, d.UnitPrice
				, d.UnitCost
				, d.CommissionAmt
				, d.ExtensionAmt
FROM            MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN
                         MAS_POL.dbo.AR_InvoiceHistoryDetail d ON h.InvoiceNo = d.InvoiceNo AND h.HeaderSeqNo = d.HeaderSeqNo INNER JOIN
						 MAS_POL.dbo.CI_Item i on d.ItemCode = i.ItemCode
