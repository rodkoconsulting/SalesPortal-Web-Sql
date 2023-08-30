/****** Object:  Procedure [dbo].[SevenFifty_Clear]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SevenFifty_Clear]
WITH EXECUTE AS owner	
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON;
TRUNCATE TABLE [dbo].[SevenFifty_Previous]
INSERT INTO [dbo].[SevenFifty_Previous]
SELECT * FROM [dbo].[SevenFifty_Current]
TRUNCATE TABLE [dbo].[SevenFifty_Current]
END
