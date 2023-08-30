/****** Object:  Procedure [dbo].[Web_Account_MasChangeCutOffTime]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_MasChangeCutOffTime]	
	@Time varchar(8)	
AS
UPDATE [dbo].[Web_MasFlags]
	Set CutOffTime=@Time
	WHERE (ID = 1) 
