/****** Object:  View [dbo].[AR_BillHoldCustom]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_BillHoldCustom]
AS
SELECT     MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate as TransactionDate, MAS_POL.dbo.CI_Item.ItemCode, MAS_POL.dbo.AR_Customer.CustomerName, 
                      MAS_POL.dbo.AR_Customer.SalespersonNo, MAS_POL.dbo.AR_InvoiceHistoryDetail.CostOfGoodsSoldAcctKey, 
                      CASE WHEN MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate > '11/6/19' and (MAS_POL.dbo.AR_InvoiceHistoryHeader.Comment like '%BILL & HOLD%'  or MAS_POL.dbo.AR_InvoiceHistoryHeader.UDF_IS_BH_INV = 'Y') THEN
					   -MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped
					  ELSE MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped END as QuantityShipped,
					  --MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped,
					  MAS_POL.dbo.AR_InvoiceHistoryDetail.UnitPrice, MAS_POL.dbo.AR_InvoiceHistoryDetail.UnitCost, 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceType, MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate, MAS_POL.dbo.CI_Item.SalesUnitOfMeasure, 
                      MAS_POL.dbo.CI_Item.UDF_VINTAGE, MAS_POL.dbo.CI_Item.UDF_BOTTLE_SIZE, MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES, 
                      MAS_POL.dbo.CI_Item.UDF_DESCRIPTION, MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES, dbo.AR_BhTotals.QuantityOrdered, 
                      MAS_POL.dbo.AR_Customer.ARDivisionNo, MAS_POL.dbo.AR_Customer.CustomerNo, MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo, 
                      MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo, '' as ItemDescription, '' As Comment
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryDetail ON MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo INNER JOIN
                      MAS_POL.dbo.AR_Customer ON MAS_POL.dbo.AR_InvoiceHistoryHeader.ARDivisionNo = MAS_POL.dbo.AR_Customer.ARDivisionNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.CustomerNo = MAS_POL.dbo.AR_Customer.CustomerNo INNER JOIN
                      MAS_POL.dbo.CI_Item ON MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode = MAS_POL.dbo.CI_Item.ItemCode LEFT OUTER JOIN
                      dbo.AR_BhTotals ON MAS_POL.dbo.AR_Customer.ARDivisionNo = dbo.AR_BhTotals.ARDivisionNo AND 
                      MAS_POL.dbo.AR_Customer.CustomerNo = dbo.AR_BhTotals.CustomerNo AND MAS_POL.dbo.CI_Item.ItemCode = dbo.AR_BhTotals.ItemCode
WHERE     (MAS_POL.dbo.AR_InvoiceHistoryDetail.WarehouseCode='001' OR MAS_POL.dbo.AR_InvoiceHistoryDetail.CostOfGoodsSoldAcctKey='00000008M' and MAS_POL.dbo.AR_Customer.SalespersonNo <> 'XXXX')
			or  (MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate > '11/6/19' and (UPPER(MAS_POL.dbo.AR_InvoiceHistoryHeader.Comment) like '%BILL & HOLD%' or MAS_POL.dbo.AR_InvoiceHistoryHeader.UDF_IS_BH_INV = 'Y'))
