/****** Object:  View [dbo].[Website_Export_Grouping_Description]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Website_Export_Grouping_Description]
AS
SELECT     MIN([Item Code]) AS [Item Code], Vendor, [Description], Vintage, [Bottle Size], [Bottle Size Priority]
FROM         dbo.Website_Export
GROUP BY Vendor, [Description], Vintage, [Bottle Size Priority], [Bottle Size]
