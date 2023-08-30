/****** Object:  Procedure [dbo].[Create_SS_WebSiteExportData_Aws]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Create_SS_WebSiteExportData_Aws]
AS
BEGIN
	SET NOCOUNT ON;
DELETE FROM WebSiteExportData_Previous_Aws
INSERT INTO WebSiteExportData_Previous_Aws
SELECT * from WebsiteExportData_Current
END
