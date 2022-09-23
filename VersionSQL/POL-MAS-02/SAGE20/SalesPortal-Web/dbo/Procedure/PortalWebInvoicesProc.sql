/****** Object:  Procedure [dbo].[PortalWebInvoicesProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebInvoicesProc]
	-- Add the parameters for the stored procedure here
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
SELECT @RepCode = RepCode FROM Web_ActiveUsers where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_ActiveUsers where UserName=@UserName   
SELECT Acct = (SELECT DISTINCT [AcctNo]
      ,[Acct]
      ,[Aff]
      ,[AcctR]
      ,[Prem]
      ,[Ter]
  FROM [dbo].[PortalWebInvoicesAccount]
  
                  
where ((@AccountType = 'REP' and (InvR = @RepCode or AcctR = @RepCode)) or (@AccountType = 'OFF') )
--ORDER BY AcctNo
FOR JSON PATH
),
Main = (
SELECT     
h.[InvNo]
      ,[Typ]
      ,[AcctNo]
      ,[Date]
      ,[Cmt]
      ,[Coop]
      ,[InvR]
	  , [Desc]
	, ItemCode as Item
	, Qty
	, Pri
	, Tot
  FROM [dbo].[PortalWebInvoicesMain] h INNER JOIN
  [dbo].[PortalWebInvoicesDet] Det on h.InvNo = Det.InvNo and h.HeaderSeqNo = Det.HeaderSeqNo
where ((@AccountType = 'REP' and (InvR = @RepCode or AcctR = @RepCode)) or (@AccountType = 'OFF') )
order by invno
FOR JSON AUTO
),
Item = (
SELECT DISTINCT [ItemCode] as Code
      ,[Desc]
      ,[ITyp]
      ,[Vari]
      ,[Ctry]
      ,[Reg]
      ,[App]
      ,[Mv]
      ,[Foc]
  FROM [dbo].[PortalWebInvoicesItem]
                  
where ((@AccountType = 'REP' and (InvR = @RepCode or AcctR = @RepCode)) or (@AccountType = 'OFF') )
FOR JSON PATH
)
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
