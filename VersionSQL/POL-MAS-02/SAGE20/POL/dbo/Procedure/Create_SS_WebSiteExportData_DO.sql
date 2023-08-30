/****** Object:  Procedure [dbo].[Create_SS_WebSiteExportData_DO]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Create_SS_WebSiteExportData_DO]
AS
BEGIN
	SET NOCOUNT ON;
DELETE FROM WebSiteExportData_Previous_DO
INSERT INTO WebSiteExportData_Previous_DO
SELECT * from WebsiteExportData_Current
END
