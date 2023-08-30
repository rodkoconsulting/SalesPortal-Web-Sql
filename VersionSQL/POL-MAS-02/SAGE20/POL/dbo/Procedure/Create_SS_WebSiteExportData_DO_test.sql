/****** Object:  Procedure [dbo].[Create_SS_WebSiteExportData_DO_test]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Create_SS_WebSiteExportData_DO_test]
AS
BEGIN
	SET NOCOUNT ON;
DELETE FROM WebSiteExportData_Previous_DO_test
INSERT INTO WebSiteExportData_Previous_DO_test
SELECT * from WebsiteExportData_Current
END
