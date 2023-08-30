/****** Object:  View [dbo].[WebSiteExportData_Diff]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[WebSiteExportData_Diff]
AS
SELECT GETDATE() AS LastUpdated, MIN(Operation) as Operation, [Item Code],[Vendor],[Description],[Vintage],[Bottle Sizes],[Country],[Region],[Appellation],[Wine Type],[Varietals],[Varietal Notes],[Organic],[Biodynamic],[Ratings - Wine Advocate],[Ratings - Wine Spectator],[Ratings - IWC],[Ratings - Burghound],[Ratings - Antonio Galloni],[Ratings - Other],[Review - Wine Advocate],[Review - Wine Spectator],[Review - IWC],[Review - Burghound],[Review - Antonio Galloni],[Review - Other],[Notes - Vineyard],[Notes - Orientation],[Notes - Soil],[Notes - Viticulture],[Notes - Vinification],[Notes - Aging Process],[Notes - Production],[Notes - Tasting],ImageFile

 
FROM
 
(
 
  SELECT 'Delete' as Operation, [Item Code],[Vendor],[Description] COLLATE DATABASE_DEFAULT as Description,[Vintage],[Bottle Sizes],[Country],[Region],[Appellation],[Wine Type],[Varietals],[Varietal Notes],[Organic],[Biodynamic],[Ratings - Wine Advocate],[Ratings - Wine Spectator],[Ratings - IWC],[Ratings - Burghound],[Ratings - Antonio Galloni],[Ratings - Other],[Review - Wine Advocate],[Review - Wine Spectator],[Review - IWC],[Review - Burghound],[Review - Antonio Galloni],[Review - Other],[Notes - Vineyard],[Notes - Orientation],[Notes - Soil],[Notes - Viticulture],[Notes - Vinification],[Notes - Aging Process],[Notes - Production],[Notes - Tasting],ImageFile

  FROM dbo.WebSiteExportData_Previous
 
  UNION ALL
 
  SELECT 'Insert' as Operation, [Item Code],[Vendor],[Description],[Vintage],[Bottle Sizes],[Country],[Region],[Appellation],[Wine Type],[Varietals],[Varietal Notes],[Organic],[Biodynamic],[Ratings - Wine Advocate],[Ratings - Wine Spectator],[Ratings - IWC],[Ratings - Burghound],[Ratings - Antonio Galloni],[Ratings - Other],[Review - Wine Advocate],[Review - Wine Spectator],[Review - IWC],[Review - Burghound],[Review - Antonio Galloni],[Review - Other],[Notes - Vineyard],[Notes - Orientation],[Notes - Soil],[Notes - Viticulture],[Notes - Vinification],[Notes - Aging Process],[Notes - Production],[Notes - Tasting],ImageFile

  FROM dbo.WebsiteExportData_Current
 
) tmp
 
GROUP BY [Item Code],[Vendor],[Description],[Vintage],[Bottle Sizes],[Country],[Region],[Appellation],[Wine Type],[Varietals],[Varietal Notes],[Organic],[Biodynamic],[Ratings - Wine Advocate],[Ratings - Wine Spectator],[Ratings - IWC],[Ratings - Burghound],[Ratings - Antonio Galloni],[Ratings - Other],[Review - Wine Advocate],[Review - Wine Spectator],[Review - IWC],[Review - Burghound],[Review - Antonio Galloni],[Review - Other],[Notes - Vineyard],[Notes - Orientation],[Notes - Soil],[Notes - Viticulture],[Notes - Vinification],[Notes - Aging Process],[Notes - Production],[Notes - Tasting],ImageFile
 
HAVING COUNT(*) = 1
