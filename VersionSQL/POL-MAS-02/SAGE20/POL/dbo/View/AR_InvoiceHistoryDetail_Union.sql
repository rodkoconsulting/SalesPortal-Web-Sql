/****** Object:  View [dbo].[AR_InvoiceHistoryDetail_Union]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_InvoiceHistoryDetail_Union]
AS
SELECT       InvoiceNo, HeaderSeqNo, DetailSeqNo, ItemCode, ItemCodeDesc, ItemType, UnitOfMeasure, QuantityShipped, UnitPrice, ExtensionAmt, WarehouseCode, CostOfGoodsSoldAcctKey
FROM            MAS_POL.dbo.AR_InvoiceHistoryDetail
UNION ALL
SELECT        InvoiceNo, InvoiceNo as HeaderSeqNo, LineKey as DetailSeqNo, ItemCode, ItemCodeDesc, ItemType, UnitOfMeasure, QuantityShipped, UnitPrice, ExtensionAmt, WarehouseCode, CostOfGoodsSoldAcctKey
FROM            MAS_POL.dbo.SO_InvoiceDetail
