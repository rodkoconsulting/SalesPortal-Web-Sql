/****** Object:  View [dbo].[AR_INVOICEHISTORYHEADER_3YR]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_INVOICEHISTORYHEADER_3YR]
AS
SELECT
InvoiceNo,
InvoiceType,
HeaderSeqNo,
ModuleCode,
InvoiceDate as TransactionDate,
ARDivisionNo,
CustomerNo
FROM MAS_POL.dbo.AR_INVOICEHISTORYHEADER
WHERE INVOICEDATE >= DATEFROMPARTS ( DATEPART(yyyy, GETDATE()) - 3, 1, 1 )
