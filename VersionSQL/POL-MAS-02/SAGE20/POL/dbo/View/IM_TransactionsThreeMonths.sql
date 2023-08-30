/****** Object:  View [dbo].[IM_TransactionsThreeMonths]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_TransactionsThreeMonths]
AS
SELECT DISTINCT ItemCode
FROM         MAS_POL.dbo.IM_ItemTransactionHistory
WHERE     (WarehouseCode = '000') and (TransactionDate >= DATEADD(MONTH, -3, GETDATE())) and EntryNo NOT LIKE '%CM' and TransactionCode<>'PM' and TransactionCode<>'IA'
