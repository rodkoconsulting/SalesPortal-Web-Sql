/****** Object:  Procedure [dbo].[Init_SS_WebSiteExportData]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Init_SS_WebSiteExportData]
WITH EXECUTE AS owner
AS
BEGIN
	SET NOCOUNT ON;
TRUNCATE TABLE WebsiteExportData_Previous
END
