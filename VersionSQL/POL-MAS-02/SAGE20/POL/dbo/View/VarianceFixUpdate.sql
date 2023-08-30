/****** Object:  View [dbo].[VarianceFixUpdate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[VarianceFixUpdate]
AS
SELECT     MAS_POL.dbo.AR_CashReceiptsDeposit.CashDepositAmt, MAS_POL.dbo.AR_CashReceiptsDeposit.CashBalanceAmt, MAS_POL.dbo.AR_CashReceiptsDeposit.DepositBalance, Total
FROM         MAS_POL.dbo.AR_CashReceiptsDeposit INNER JOIN
                      dbo.VarianceFix ON MAS_POL.dbo.AR_CashReceiptsDeposit.DepositNo = dbo.VarianceFix.DepositNo
