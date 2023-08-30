/****** Object:  Procedure [dbo].[Web_Account_MasDefaultCutOffTimeQuery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_MasDefaultCutOffTimeQuery]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT ISNULL([CutOffTimeDefault],'3:40 pm')
  FROM [dbo].[Web_MasFlags]
WHERE     (ID = 1) 

END
