/****** Object:  View [dbo].[Web_Inventory_Reviews]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Inventory_Reviews]
AS
SELECT     MAS_POL.dbo.CI_ITEM.ITEMCODE as ItemCode,
		   MAS_POL.dbo.CI_ITEM.UDF_PARKER as RatingWA, 
           MAS_POL.dbo.CI_ITEM.UDF_SPECTATOR as RatingWS, 
           MAS_POL.dbo.CI_ITEM.UDF_TANZER as RatingIWC, 
           MAS_POL.dbo.CI_ITEM.UDF_BURGHOUND as RatingBH,
           MAS_POL.dbo.CI_ITEM.UDF_GALLONI_SCORE as RatingAG,
           MAS_POL.dbo.CI_ITEM.UDF_VFC as RatingOther,
           MAS_POL.dbo.CI_ITEM.UDF_PARKER_REVIEW as ReviewWA,
           MAS_POL.dbo.CI_ITEM.UDF_SPECTATOR_REVIEW as ReviewWS,
           MAS_POL.dbo.CI_ITEM.UDF_TANZER_REVIEW as ReviewIWC,
           MAS_POL.dbo.CI_ITEM.UDF_BURGHOUND_REVIEW as ReviewBH,
           MAS_POL.dbo.CI_ITEM.UDF_GALLONI_REVIEW as ReviewAG,
           MAS_POL.dbo.CI_ITEM.UDF_VIEW_REVIEW as ReviewOther
FROM         MAS_POL.dbo.CI_ITEM
