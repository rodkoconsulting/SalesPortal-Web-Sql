/****** Object:  Procedure [dbo].[Web_Account_MasChangeDefaultCutOffTime]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_MasChangeDefaultCutOffTime]
	@Time varchar(8)
	
AS
UPDATE [dbo].[Web_MasFlags]
	Set CutOffTimeDefault=@Time
	WHERE (ID = 1) 
