/****** Object:  Procedure [dbo].[Web_Account_EnablePortalImport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_EnablePortalImport]
AS
BEGIN
	UPDATE [dbo].[Web_MasFlags]
	Set IsMasActive=1, DisableTime=NULL
	WHERE (ID = 1) 
END
