/****** Object:  View [dbo].[AR_InvoiceHistoryDetail_Union_TST]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_InvoiceHistoryDetail_Union_TST]
AS
SELECT       InvoiceNo, HeaderSeqNo, DetailSeqNo, ItemCode, ItemCodeDesc, ItemType, UnitOfMeasure, QuantityShipped, UnitPrice, ExtensionAmt, WarehouseCode, CostOfGoodsSoldAcctKey
FROM            MAS_TST.dbo.AR_InvoiceHistoryDetail
UNION ALL
SELECT        InvoiceNo, InvoiceNo as HeaderSeqNo, LineKey as DetailSeqNo, ItemCode, ItemCodeDesc, ItemType, UnitOfMeasure, QuantityShipped, UnitPrice, ExtensionAmt, WarehouseCode, CostOfGoodsSoldAcctKey
FROM            MAS_TST.dbo.SO_InvoiceDetail
