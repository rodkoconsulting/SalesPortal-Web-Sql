/****** Object:  Procedure [dbo].[PortalWebOrderMainProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebOrderMainProc]
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
	   [OrdNo]
      ,[Typ]
      ,[AcctNo]
      ,[OrdDate]
	  ,[ShpDate]
	  ,[ExpDate]
	  ,[ArrDate]
	  ,[Hold]
      ,[Cmt]
      ,[Coop]
	  ,[Inv]
      ,[Ter]
	  ,[Rep]
	  ,[Item]
	  ,[Desc]
      ,[Qty]
      ,[Pri]
      ,[Tot]
	  ,ItmCmt
	  ,BoEta
  FROM [dbo].[PortalWebOrdersMain]
                  
where ((@AccountType = 'REP' and (Rep = @RepCode)) or (@AccountType = 'OFF') )
ORDER BY OrdNo
END
