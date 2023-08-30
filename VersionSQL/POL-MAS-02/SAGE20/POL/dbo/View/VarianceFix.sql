/****** Object:  View [dbo].[VarianceFix]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[VarianceFix]
AS
SELECT     CashDepositAmt, CashBalanceAmt, SUM(AmountPosted) AS Total, MAS_POL.dbo.AR_CashReceiptsDeposit.DepositBalance, MAS_POL.dbo.AR_CashReceiptsDeposit.DepositNo
FROM          MAS_POL.dbo.AR_CashReceiptsDeposit INNER JOIN
                      MAS_POL.dbo.AR_CashReceiptsDetail ON MAS_POL.dbo.AR_CashReceiptsDeposit.DepositNo = MAS_POL.dbo.AR_CashReceiptsDetail.DepositNo
GROUP BY CashDepositAmt, CashBalanceAmt, MAS_POL.dbo.AR_CashReceiptsDeposit.DepositNo,DepositBalance
