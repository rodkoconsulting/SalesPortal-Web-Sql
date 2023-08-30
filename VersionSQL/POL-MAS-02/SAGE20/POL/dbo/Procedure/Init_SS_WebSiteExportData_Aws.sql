/****** Object:  Procedure [dbo].[Init_SS_WebSiteExportData_Aws]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Init_SS_WebSiteExportData_Aws]
AS
BEGIN
	SET NOCOUNT ON;
DELETE FROM WebsiteExportData_Previous_Aws
END
