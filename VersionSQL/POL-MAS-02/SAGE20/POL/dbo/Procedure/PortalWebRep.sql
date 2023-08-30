/****** Object:  Procedure [dbo].[PortalWebRep]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebRep]
@UserName varchar(25)
AS
BEGIN
SELECT RepCode as 'Rep'
		,AccountType as 'AcctType'
	FROM Web_UserMappings where UserName=@UserName 
END
