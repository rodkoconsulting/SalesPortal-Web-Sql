/****** Object:  View [dbo].[Website_Export_Grouping_BottleSize]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Website_Export_Grouping_BottleSize]
AS
SELECT     MIN([Item Code]) AS [Item Code], Vendor, [Description], Vintage, REPLACE(REPLACE(REPLACE((SELECT [BOTTLE SIZE] as A FROM dbo.Website_Export_Grouping_Description  where (Vendor = dupe.Vendor and [Description]=dupe.[Description] and Vintage=dupe.Vintage) FOR XML PATH ('')), '</A><A>', ', '),'<A>',''),'</A>','') AS BottleSizeList
FROM         dbo.Website_Export_Grouping_Description dupe
GROUP BY Vendor, [Description], Vintage
