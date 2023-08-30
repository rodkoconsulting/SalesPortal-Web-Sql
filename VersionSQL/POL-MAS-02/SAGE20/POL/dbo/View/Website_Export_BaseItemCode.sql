/****** Object:  View [dbo].[Website_Export_BaseItemCode]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Website_Export_BaseItemCode]
AS
SELECT     MIN([Item Code]) AS [Base Item Code], Description, Vendor, Vintage
FROM         dbo.Website_Export
WHERE     (Description <> '') AND (Vendor <> '') AND (Vintage <> '')
GROUP BY Vendor, Description, Vintage
