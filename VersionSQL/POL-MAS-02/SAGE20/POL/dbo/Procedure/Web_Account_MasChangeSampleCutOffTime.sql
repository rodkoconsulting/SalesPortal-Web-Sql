/****** Object:  Procedure [dbo].[Web_Account_MasChangeSampleCutOffTime]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_MasChangeSampleCutOffTime]
	@Time varchar(8)
	
AS
UPDATE [dbo].[Web_MasFlags]
	Set CutOffTimeSamples=@Time
	WHERE (ID = 1) 
