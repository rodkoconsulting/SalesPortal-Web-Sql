/****** Object:  Procedure [dbo].[Web_Account_MasCutOffTimeQuery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_MasCutOffTimeQuery]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT ISNULL([CutOffTime],'4:10 pm')
  FROM [dbo].[Web_MasFlags]
WHERE     (ID = 1) 

END
