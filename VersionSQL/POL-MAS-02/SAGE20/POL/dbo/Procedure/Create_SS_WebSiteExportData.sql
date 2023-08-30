/****** Object:  Procedure [dbo].[Create_SS_WebSiteExportData]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Create_SS_WebSiteExportData]
WITH EXECUTE AS owner
AS
BEGIN
	SET NOCOUNT ON;
DROP TABLE WebSiteExportData_Previous
select * INTO WebSiteExportData_Previous
from WebsiteExportData_Current
END
