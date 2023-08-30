/****** Object:  View [dbo].[Web_Inventory_Notes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Inventory_Notes]
AS
SELECT     MAS_POL.dbo.CI_ITEM.ITEMCODE as ItemCode,
		   MAS_POL.dbo.CI_ITEM.UDF_NOTES_TASTING as NotesTasting, 
           MAS_POL.dbo.CI_ITEM.UDF_NOTES_VINEYARD as NotesVineyard, 
           MAS_POL.dbo.CI_ITEM.UDF_NOTES_VINIFICATION as NotesVinification, 
           MAS_POL.dbo.CI_ITEM.UDF_NOTES_VARIETAL as NotesVarietal,
           MAS_POL.dbo.CI_ITEM.UDF_NOTES_PRODUCTION as NotesProduction,
           MAS_POL.dbo.CI_ITEM.UDF_NOTES_AGING as NotesAging,
           MAS_POL.dbo.CI_ITEM.UDF_NOTES_ALTITUDE as NotesSoil,
           MAS_POL.dbo.CI_ITEM.UDF_NOTES_ORIENTATION as NotesOrientation,
           MAS_POL.dbo.CI_ITEM.UDF_NOTES_SOIL as NotesViticulture
FROM         MAS_POL.dbo.CI_ITEM 
