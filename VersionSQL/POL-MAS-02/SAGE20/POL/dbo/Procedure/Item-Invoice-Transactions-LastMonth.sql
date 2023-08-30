/****** Object:  Procedure [dbo].[Item-Invoice-Transactions-LastMonth]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Item-Invoice-Transactions-LastMonth]
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @LastMonthDate datetime = DATEADD(month, -1, GETDATE());
	DECLARE @LastMonthYr int = YEAR(@LastMonthDate);
	DECLARE @LastMonthMnth int = MONTH(@LastMonthDate);
WITH base as
(
SELECT        ItemCode AS Item_Polaner, Item AS Item_Fdl, EntryNo AS Invoice_Polaner, Invoice as Invoice_Fdl, - TransactionQty AS Quantity_Polaner, Quantity AS Quantity_Fdl
FROM           dbo.IM_ItemTransactionHistory_Sum p
LEFT OUTER JOIN AR_InvoiceHistoryHeader h ON CONCAT(h.InvoiceNo,'-',h.InvoiceType) = p.EntryNo
FULL OUTER JOIN Glue_FdlTransactions_Sum f on f.Invoice = p.EntryNo and f.Item = p.ItemCode
WHERE        (WarehouseCode = '000') AND (TransactionCode = 'SO') AND Year(p.TransactionDate) = @LastMonthYr and Month(p.TransactionDate) = @LastMonthMnth and h.UDF_IS_BH_INV <> 'Y' and h.InvoiceType <> 'CM'
)
SELECT	Invoice_Polaner as Invoice
		, Item_Polaner as Item
		, Cast(Round(Quantity_Polaner,2) as numeric(36,2)) as [Qty-POL]
		, IsNull(Convert(varchar,Quantity_Fdl), 'MISSING') as [Qty-FDL]
FROM base
where ABS(IsNull(Quantity_Polaner,0) - IsNull(Quantity_Fdl,0)) > 0.05
order by Invoice, item
END
