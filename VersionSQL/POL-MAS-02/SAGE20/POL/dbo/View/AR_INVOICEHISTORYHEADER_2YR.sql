/****** Object:  View [dbo].[AR_INVOICEHISTORYHEADER_2YR]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_INVOICEHISTORYHEADER_2YR]
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
WHERE INVOICEDATE >= DATEFROMPARTS ( DATEPART(yyyy, GETDATE()) - 2, 1, 1 )
