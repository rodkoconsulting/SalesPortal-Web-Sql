/****** Object:  View [dbo].[WebsiteExportData_Current]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[WebsiteExportData_Current]
AS
SELECT     dbo.Website_Export_BaseItemCode.[Base Item Code] AS [Item Code], dbo.Website_Export_Grouping_BottleSize.Vendor, dbo.Website_Export_Grouping_BottleSize.Description, 
                      dbo.Website_Export_Grouping_BottleSize.Vintage, dbo.Website_Export_Grouping_BottleSize.BottleSizeList AS [Bottle Sizes], 
                      MAS_POL.dbo.CI_ITEM.UDF_COUNTRY AS Country, IsNull(r.UDF_REGION,'') AS Region, 
                      IsNull(a.UDF_NAME,'') AS Appellation, MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR AS [Wine Type], 
                      IsNull(v.UDF_VARIETAL,'') AS Varietals,
					  IsNull(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_NOTES_VARIETAL),'') AS [Varietal Notes], 
                      MAS_POL.dbo.CI_ITEM.UDF_ORGANIC AS Organic, MAS_POL.dbo.CI_ITEM.UDF_BIODYNAMIC AS Biodynamic, 
                      MAS_POL.dbo.CI_ITEM.UDF_PARKER AS [Ratings - Wine Advocate], MAS_POL.dbo.CI_ITEM.UDF_SPECTATOR AS [Ratings - Wine Spectator], 
                      MAS_POL.dbo.CI_ITEM.UDF_TANZER AS [Ratings - IWC], MAS_POL.dbo.CI_ITEM.UDF_BURGHOUND AS [Ratings - Burghound],
                      MAS_POL.dbo.CI_ITEM.UDF_GALLONI_SCORE AS [Ratings - Antonio Galloni],
                      MAS_POL.dbo.CI_ITEM.UDF_VFC AS [Ratings - Other],
                      IsNull(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_PARKER_REVIEW),'') AS [Review - Wine Advocate], 
                      IsNull(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_SPECTATOR_REVIEW),'') AS [Review - Wine Spectator],
                      IsNull(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_TANZER_REVIEW),'') AS [Review - IWC], 
                      IsNull(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_BURGHOUND_REVIEW),'') AS [Review - Burghound],
                      IsNull(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_GALLONI_REVIEW),'') AS [Review - Antonio Galloni],
                      IsNull(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_VIEW_REVIEW),'') AS [Review - Other], 
                      IsNull(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_NOTES_VINEYARD),'') AS [Notes - Vineyard],
                      IsNull(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_NOTES_ORIENTATION),'') AS [Notes - Orientation], 
                      IsNull(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_NOTES_ALTITUDE),'') AS [Notes - Soil],
                      IsNull(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_NOTES_SOIL),'') AS [Notes - Viticulture], 
                      IsNull(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_NOTES_VINIFICATION),'') AS [Notes - Vinification],
                      IsNull(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_NOTES_AGING),'') AS [Notes - Aging Process], 
                      IsNull(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_NOTES_PRODUCTION),'') AS [Notes - Production],
                      IsNull(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_NOTES_TASTING),'') AS [Notes - Tasting],
                      MAS_POL.dbo.CI_ITEM.IMAGEFILE as ImageFile,
					  IsNull(MAS_POL.dbo.CI_ITEM.UDF_NATURAL,'N') as Natural,
					  IsNull(MAS_POL.dbo.CI_ITEM.UDF_REGENERATIVE,'N') as Regen,
					  IsNull(MAS_POL.dbo.CI_ITEM.UDF_VEGAN,'N') as Vegan,
					  IsNull(MAS_POL.dbo.CI_ITEM.UDF_HAUTE_VALEUR,'N') as HauteValeur
FROM         dbo.Website_Export_Grouping_BottleSize INNER JOIN
                      MAS_POL.dbo.CI_ITEM ON dbo.Website_Export_Grouping_BottleSize.[Item Code] = MAS_POL.dbo.CI_ITEM.ITEMCODE INNER JOIN
                      dbo.Website_Export_BaseItemCode ON dbo.Website_Export_Grouping_BottleSize.Vendor = dbo.Website_Export_BaseItemCode.Vendor AND 
                      dbo.Website_Export_Grouping_BottleSize.Vintage = dbo.Website_Export_BaseItemCode.Vintage AND 
                      dbo.Website_Export_Grouping_BottleSize.Description = dbo.Website_Export_BaseItemCode.Description LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_VARIETALS AS v ON MAS_POL.dbo.CI_ITEM.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_ITEM.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON MAS_POL.dbo.CI_ITEM.UDF_SUBREGION_T = a.UDF_APPELLATION
