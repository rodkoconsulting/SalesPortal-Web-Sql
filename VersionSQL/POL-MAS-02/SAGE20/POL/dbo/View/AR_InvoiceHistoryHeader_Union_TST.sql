/****** Object:  View [dbo].[AR_InvoiceHistoryHeader_Union_TST]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_InvoiceHistoryHeader_Union_TST]
AS
SELECT       InvoiceNo, HeaderSeqNo, InvoiceType, InvoiceDate, TransactionDate, ARDivisionNo, CustomerNo, SalesPersonDivisionNo, SalesPersonNo, Comment, UDF_NJ_COOP, ShipToName, ShipVia
FROM            MAS_TST.dbo.AR_InvoiceHistoryHeader
WHERE ModuleCode = 'S/O'
UNION ALL
SELECT        InvoiceNo, InvoiceNo as HeaderSeqNo, InvoiceType, ShipDate as InvoiceDate, ShipDate as TransactionDate, i.ARDivisionNo, i.CustomerNo, i.SalesPersonDivisionNo, i.SalesPersonNo, i.Comment, IsNull(o.UDF_NJ_COOP,'') as UDF_NJ_COOP, i.ShipToName, i.ShipVia
FROM            MAS_TST.dbo.SO_InvoiceHeader i LEFT OUTER JOIN MAS_POL.dbo.SO_SalesOrderHeader o on i.SalesOrderNo = o.SalesOrderNo
