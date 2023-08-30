/****** Object:  Procedure [dbo].[Web_Account_MasActiveQuery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_MasActiveQuery]
AS
BEGIN
	SELECT ISNULL([IsMasActive],1)
  FROM [dbo].[Web_MasFlags]
WHERE     (ID = 1) 

END
