/****** Object:  Procedure [dbo].[PortalWebOrdersProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebOrdersProc]
	-- Add the parameters for the stored procedure here
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
SELECT @RepCode = RepCode FROM Web_ActiveUsers where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_ActiveUsers where UserName=@UserName   
SELECT Main = (SELECT
	   h.OrdNo
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
	  ,Item
	  ,[Desc]
      ,[Qty]
      ,[Pri]
      ,[Tot]
	  ,ItmCmt
	  ,BoEta
  FROM [dbo].[PortalWebOrdersMain] h INNER JOIN
  [dbo].[PortalWebOrdersDet] Det on h.OrdNo = Det.OrdNo
where ((@AccountType = 'REP' and h.Rep = @RepCode) or (@AccountType = 'OFF') )
order by h.OrdNo
FOR JSON AUTO
),
Acct = (SELECT DISTINCT
	   [AcctNo]
      ,[Acct]
      ,[Aff]
      ,[Prem]
  FROM [dbo].[PortalWebOrdersAccount]        
where ((@AccountType = 'REP' and Rep = @RepCode) or (@AccountType = 'OFF') )
FOR JSON PATH
),
Item = (
SELECT DISTINCT Code
      ,[Desc]
      ,Allo
  FROM [dbo].[PortalWebOrdersItem]
                  
where ((@AccountType = 'REP' and Rep = @RepCode) or (@AccountType = 'OFF') )
FOR JSON PATH
)
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
