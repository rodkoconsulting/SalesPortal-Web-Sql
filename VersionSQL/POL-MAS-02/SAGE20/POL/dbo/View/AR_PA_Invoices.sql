/****** Object:  View [dbo].[AR_PA_Invoices]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_PA_Invoices]
AS
WITH PaInvoices AS
(
	SELECT Invoice
			, REPLACE(REPLACE(Invoice, 'SO', ''), ' DM', '') AS PoNoPa
			, InvoiceDate as InvoiceDate
			, DueDate as InvoiceDueDate
			, Convert(float, Replace(Replace(Amount,'USD',''),',','')) as Amount
    FROM dbo.AR_PA_INV
)
, PolInvoices AS
(
	SELECT InvoiceNo
			, REPLACE(REPLACE(REPLACE((REPLACE(Comment, ' ', '')),'PO#',''),':',''),'-reshipment','') AS PoNoPol
			, InvoiceDueDate
			, NonTaxableAmt
			,c.CustomerName
			, InvoiceType
    FROM  MAS_POL.dbo.AR_OpenInvoice i INNER JOIN AR_Customer c
		ON i.ARDivisionNo = c.ARDivisionNo and i.CustomerNo = c.CustomerNo

)
SELECT DISTINCT TOP (100) PERCENT
	 pa.Invoice AS InvoicePa
	 , pa.InvoiceDate AS InvoiceDatePa
	 , pa.Amount as AmountPa
	 , pa.InvoiceDueDate as DueDatePa
	 , pol.InvoiceDueDate as DueDatePol
	 , pol.InvoiceNo AS InvoicePol
	 , NonTaxableAmt AS AmountPol
	 , Amount - NonTaxableAmt as AmountDiff
	 , CustomerName
FROM            PaInvoices AS pa LEFT OUTER JOIN
                              PolInvoices AS pol ON pa.PoNoPa = pol.PoNoPol
WHERE ((pol.InvoiceType = 'IN' and pa.Invoice NOT LIKE '%DM%') OR (pol.InvoiceType = 'CM' and pa.Invoice LIKE '%DM%'))
ORDER BY InvoicePol DESC
