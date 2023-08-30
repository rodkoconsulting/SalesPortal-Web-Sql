/****** Object:  Procedure [dbo].[Update_WebSiteExportData_Diff_NEW]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Update_WebSiteExportData_Diff_NEW]
WITH EXECUTE AS owner
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

INSERT dbo.WebSiteExportData_Diff
(LastUpdated, Operation, [Item Code],[Vendor],[Description],[Vintage],[Bottle Sizes],[Country],[Region],[Appellation],[Wine Type],[Varietals],[Varietal Notes],[Organic],[Biodynamic],[Ratings - Wine Advocate],[Ratings - Wine Spectator],[Ratings - IWC],[Ratings - Burghound],[Ratings - Antonio Galloni],[Ratings - Other],[Review - Wine Advocate],[Review - Wine Spectator],[Review - IWC],[Review - Burghound],[Review - Antonio Galloni],[Review - Other],[Notes - Vineyard],[Notes - Orientation],[Notes - Soil],[Notes - Viticulture],[Notes - Vinification],[Notes - Aging Process],[Notes - Production],[Notes - Tasting],ImageFile)


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
 
ORDER BY LastUpdated, [Item Code], Operation

END
