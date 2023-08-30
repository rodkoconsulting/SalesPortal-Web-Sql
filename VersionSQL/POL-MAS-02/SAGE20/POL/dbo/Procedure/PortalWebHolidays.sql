/****** Object:  Procedure [dbo].[PortalWebHolidays]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebHolidays]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT CONVERT(varchar, Holiday, 12) as Holiday
  FROM [dbo].[Holidays]

END
