/****** Object:  Procedure [dbo].[PortalWebInvoiceItemProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebInvoiceItemProc]
	-- Add the parameters for the stored procedure here
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
SELECT @RepCode = RepCode FROM Web_ActiveUsers where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_ActiveUsers where UserName=@UserName   
SELECT DISTINCT [ItemCode]
      ,[Desc]
      ,[ITyp]
      ,[Vari]
      ,[Ctry]
      ,[Reg]
      ,[App]
      ,[Mv]
      ,[Foc]
      ,[FocBm]
  FROM [dbo].[PortalWebInvoicesItem]
                  
where ((@AccountType = 'REP' and (InvR = @RepCode or AcctR = @RepCode)) or (@AccountType = 'OFF') )
ORDER BY ItemCode
END
