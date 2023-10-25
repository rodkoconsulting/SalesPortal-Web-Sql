/****** Object:  Procedure [dbo].[PortalWebHolidays]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebHolidays]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT Holidays = (
		SELECT CONVERT(varchar, Holiday, 12) as [Date]
		FROM [POL].[dbo].[Holidays]
		FOR JSON AUTO)
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
