/****** Object:  Procedure [dbo].[WebsiteExportDataDiff_Lambda]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.WebsiteExportDataDiff_Lambda 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
			[Operation],
			[Item Code], [Vendor],
			[Description],
			[Vintage], [Bottle Sizes],
			[Country], [Region],
			[Appellation], [Wine Type],
			[Varietals], [Varietal Notes],
			[Organic], [Biodynamic],
			[Ratings - Wine Advocate], [Ratings - Wine Spectator], [Ratings - IWC], [Ratings - Burghound], [Ratings - Antonio Galloni], [Ratings - Other],
                        [Review - Wine Advocate], [Review - Wine Spectator], [Review - IWC], [Review - Burghound], [Review - Antonio Galloni], [Review - Other],
                        [Notes - Vineyard], [Notes - Orientation], [Notes - Soil], [Notes - Viticulture], [Notes - Vinification],
                        [Notes - Aging Process], [Notes - Production], [Notes - Tasting],
                        [ImageFile],
                        [Natural],
                        [Regen],
                        [Vegan],
                        [HauteValeur]
			
			FROM [dbo].[WebSiteExportData_Diff_Lambda] ORDER BY LastUpdated ASC, [Item Code] ASC, Operation ASC
END
