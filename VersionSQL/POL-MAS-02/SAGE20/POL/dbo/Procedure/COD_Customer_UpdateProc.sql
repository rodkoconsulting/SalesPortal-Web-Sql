/****** Object:  Procedure [dbo].[COD_Customer_UpdateProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[COD_Customer_UpdateProc] 
AS
BEGIN
	UPDATE [POL].[dbo].[COD_Customer_UpdateView]
	SET [TermsCode] = [TermsCodeNew]
      ,[CreditHold] = [CreditHoldNew]
      ,[TermsCodeDesc] = [TermsCodeDescNew]
END
