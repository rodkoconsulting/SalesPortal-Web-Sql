/****** Object:  View [dbo].[AR_InvoiceHistoryHeader]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_InvoiceHistoryHeader]
AS
SELECT
InvoiceNo,
InvoiceType,
HeaderSeqNo,
InvoiceDate,
ModuleCode,
TransactionDate,
ARDivisionNo,
CustomerNo,
SalespersonDivisionNo,
SalesPersonNo,
Comment,
UDF_NJ_COOP,
InvoiceDueDate,
DateCreated,
DateUpdated,
UDF_IS_BH_INV
FROM MAS_POL.dbo.AR_INVOICEHISTORYHEADER
