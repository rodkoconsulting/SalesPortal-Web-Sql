/****** Object:  Procedure [dbo].[Create_SS_WebSiteExportData_Lambda]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.Create_SS_WebSiteExportData_Lambda
AS
BEGIN
	SET NOCOUNT ON;
DELETE FROM WebSiteExportData_Previous_Lambda
INSERT INTO WebSiteExportData_Previous_Lambda
SELECT * from WebsiteExportData_Current
END
