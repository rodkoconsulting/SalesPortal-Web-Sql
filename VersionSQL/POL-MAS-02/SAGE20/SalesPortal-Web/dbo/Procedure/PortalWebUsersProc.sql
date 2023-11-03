/****** Object:  Procedure [dbo].[PortalWebUsersProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebUsersProc]
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @AccountType char(3);
SELECT @AccountType = AccountType FROM Web_ActiveUsers where UserName=@UserName  
SELECT     DISTINCT u.UserName, u.AccountType, u.RepCode,IsNull(s.UDF_STATE,'NY') 
                      AS State
FROM         POL.dbo.Web_UserMappings u LEFT OUTER JOIN
                      MAS_POL.dbo.AR_Salesperson s ON u.RepCode = s.SalespersonNo
WHERE s.SalespersonDivisionNo IS NULL OR s.SalespersonDivisionNo = '00' AND @AccountType != 'EXT'
FOR JSON PATH
END
