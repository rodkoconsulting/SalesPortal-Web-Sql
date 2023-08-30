/****** Object:  View [dbo].[IM_SalesOrderTransactionsOneMonth]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_SalesOrderTransactionsOneMonth]
AS
SELECT DISTINCT ItemCode
FROM         MAS_POL.dbo.IM_ItemTransactionHistory
WHERE     (WarehouseCode = '000') and (TransactionDate >= DATEADD(MONTH, -1, GETDATE())) and EntryNo NOT LIKE '%CM' and TransactionCode='SO'
