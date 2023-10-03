/****** Object:  Procedure [dbo].[EmpireWines_Clear]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[EmpireWines_Clear]
WITH EXECUTE AS owner	
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON;
TRUNCATE TABLE [dbo].[EmpireWines_Snapshot]
END
