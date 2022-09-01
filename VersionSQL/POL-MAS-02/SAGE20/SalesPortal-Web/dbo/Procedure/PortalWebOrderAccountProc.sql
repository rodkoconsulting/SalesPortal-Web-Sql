/****** Object:  Procedure [dbo].[PortalWebOrderAccountProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebOrderAccountProc]
	-- Add the parameters for the stored procedure here
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
SELECT @RepCode = RepCode FROM Web_ActiveUsers where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_ActiveUsers where UserName=@UserName   
SELECT [AcctNo]
      ,[Acct]
      ,[Aff]
      ,[Prem]
  FROM [dbo].[PortalWebOrdersAccount]
                  
where ((@AccountType = 'REP' and (Rep = @RepCode)) or (@AccountType = 'OFF') )
ORDER BY AcctNo
END
