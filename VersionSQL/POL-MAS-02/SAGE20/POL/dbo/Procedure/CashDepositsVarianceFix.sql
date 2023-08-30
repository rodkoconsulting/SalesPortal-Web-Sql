/****** Object:  Procedure [dbo].[CashDepositsVarianceFix]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[CashDepositsVarianceFix] 
AS
BEGIN
	UPDATE [POL].[dbo].[VarianceFixUpdate]
   SET [CashDepositAmt] = [Total]
END
