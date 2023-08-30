/****** Object:  Procedure [dbo].[Init_SS_WebSiteExportData_DO]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Init_SS_WebSiteExportData_DO]
AS
BEGIN
	SET NOCOUNT ON;
DELETE FROM WebsiteExportData_Previous_DO
END
