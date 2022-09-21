/****** Object:  Procedure [dbo].[PortalWebSamplesProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebSamplesProc]
	-- Add the parameters for the stored procedure here
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
SELECT @RepCode = RepCode FROM Web_ActiveUsers where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_ActiveUsers where UserName=@UserName   
SELECT Acct = (SELECT RepNo
      ,Ter
      ,RepName
  FROM [dbo].[PortalWebSamplesRep]
  
where ((@AccountType = 'REP' and (1=2)) or (@AccountType = 'OFF') )
--ORDER BY AcctNo
FOR JSON PATH
),
Main = (
SELECT     
CASE WHEN @AccountType = 'OFF' THEN h.RepNo ELSE '' END as RepNo
      ,CONVERT(varchar,h.Date,23) AS Date
      ,h.PoNo
      ,h.ShpTo
      ,Det.Code
      ,Det.Qty
  FROM [dbo].[PortalWebSamplesMain] h INNER JOIN
  [dbo].[PortalWebSamplesDet] Det on h.PoNo = Det.PoNo
where (@AccountType = 'REP' and h.RepNo = @RepCode) or (@AccountType = 'OFF')
order by h.PoNo
FOR JSON AUTO
),
Item = (
SELECT DISTINCT Code
				, Ctry
				, Reg
				, App
				, Brnd
				, [Desc]
				, Vend
				, Mv
				, Foc
				, BmFoc
  FROM [dbo].[PortalWebSamplesItem]
                  
where ((@AccountType = 'REP' and RepNo = @RepCode) or (@AccountType = 'OFF') )
FOR JSON PATH
)
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
