/****** Object:  Procedure [dbo].[PortalWebInvoiceMainProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebInvoiceMainProc]
	-- Add the parameters for the stored procedure here
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
SELECT @RepCode = RepCode FROM Web_ActiveUsers where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_ActiveUsers where UserName=@UserName   
SELECT     
[InvNo]
      ,[Typ]
      ,[AcctNo]
      ,[Date]
      ,[Cmt]
      ,[Coop]
      ,[InvR]
      ,[Desc]
      ,[Qty]
      ,[Pri]
      ,[Tot]
  FROM [dbo].[PortalWebInvoicesMain]
                  
where ((@AccountType = 'REP' and (InvR = @RepCode or AcctR = @RepCode)) or (@AccountType = 'OFF') )
ORDER BY InvNo
END
