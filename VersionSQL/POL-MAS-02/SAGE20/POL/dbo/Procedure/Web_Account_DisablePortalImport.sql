/****** Object:  Procedure [dbo].[Web_Account_DisablePortalImport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_DisablePortalImport]
AS
BEGIN
	UPDATE [dbo].[Web_MasFlags]
	Set IsMasActive=0, DisableTime=GETDATE()
	WHERE (ID = 1) 
END
