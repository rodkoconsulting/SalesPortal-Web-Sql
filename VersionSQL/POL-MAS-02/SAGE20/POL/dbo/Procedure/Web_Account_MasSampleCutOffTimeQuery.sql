/****** Object:  Procedure [dbo].[Web_Account_MasSampleCutOffTimeQuery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_MasSampleCutOffTimeQuery]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT ISNULL([CutOffTimeSamples],'1:00 pm')
  FROM [dbo].[Web_MasFlags]
WHERE     (ID = 1) 

END
