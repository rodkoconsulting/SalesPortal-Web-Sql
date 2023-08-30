/****** Object:  View [dbo].[WebSiteExportData_Diff_DO_test]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[WebSiteExportData_Diff_DO_test]
AS
SELECT GETDATE() AS LastUpdated, MIN(Operation) as Operation, [Item Code],[Vendor],[Description],[Vintage],[Bottle Sizes],[Country],[Region],[Appellation],[Wine Type],[Varietals],[Varietal Notes],[Organic],[Biodynamic],[Ratings - Wine Advocate],[Ratings - Wine Spectator],[Ratings - IWC],[Ratings - Burghound],[Ratings - Antonio Galloni],[Ratings - Other],[Review - Wine Advocate],[Review - Wine Spectator],[Review - IWC],[Review - Burghound],[Review - Antonio Galloni],[Review - Other],[Notes - Vineyard],[Notes - Orientation],[Notes - Soil],[Notes - Viticulture],[Notes - Vinification],[Notes - Aging Process],[Notes - Production],[Notes - Tasting],ImageFile,Natural,Regen,Vegan,HauteValeur

 
FROM
 
(
 
  SELECT 'Delete' as Operation, [Item Code],[Vendor],[Description] COLLATE DATABASE_DEFAULT as Description,[Vintage],[Bottle Sizes],[Country],[Region],[Appellation],[Wine Type],[Varietals],[Varietal Notes],[Organic],[Biodynamic],[Ratings - Wine Advocate],[Ratings - Wine Spectator],[Ratings - IWC],[Ratings - Burghound],[Ratings - Antonio Galloni],[Ratings - Other],[Review - Wine Advocate],[Review - Wine Spectator],[Review - IWC],[Review - Burghound],[Review - Antonio Galloni],[Review - Other],[Notes - Vineyard],[Notes - Orientation],[Notes - Soil],[Notes - Viticulture],[Notes - Vinification],[Notes - Aging Process],[Notes - Production],[Notes - Tasting],ImageFile,Natural,Regen,Vegan,HauteValeur

  FROM dbo.WebSiteExportData_Previous_DO_test
 
  UNION ALL
 
  SELECT 'Insert' as Operation, [Item Code],[Vendor],[Description],[Vintage],[Bottle Sizes],[Country],[Region],[Appellation],[Wine Type],[Varietals],[Varietal Notes],[Organic],[Biodynamic],[Ratings - Wine Advocate],[Ratings - Wine Spectator],[Ratings - IWC],[Ratings - Burghound],[Ratings - Antonio Galloni],[Ratings - Other],[Review - Wine Advocate],[Review - Wine Spectator],[Review - IWC],[Review - Burghound],[Review - Antonio Galloni],[Review - Other],[Notes - Vineyard],[Notes - Orientation],[Notes - Soil],[Notes - Viticulture],[Notes - Vinification],[Notes - Aging Process],[Notes - Production],[Notes - Tasting],ImageFile,Natural,Regen,Vegan,HauteValeur

  FROM dbo.WebsiteExportData_Current
 
) tmp
 
GROUP BY [Item Code],[Vendor],[Description],[Vintage],[Bottle Sizes],[Country],[Region],[Appellation],[Wine Type],[Varietals],[Varietal Notes],[Organic],[Biodynamic],[Ratings - Wine Advocate],[Ratings - Wine Spectator],[Ratings - IWC],[Ratings - Burghound],[Ratings - Antonio Galloni],[Ratings - Other],[Review - Wine Advocate],[Review - Wine Spectator],[Review - IWC],[Review - Burghound],[Review - Antonio Galloni],[Review - Other],[Notes - Vineyard],[Notes - Orientation],[Notes - Soil],[Notes - Viticulture],[Notes - Vinification],[Notes - Aging Process],[Notes - Production],[Notes - Tasting],ImageFile,Natural,Regen,Vegan,HauteValeur
 
HAVING COUNT(*) = 1
