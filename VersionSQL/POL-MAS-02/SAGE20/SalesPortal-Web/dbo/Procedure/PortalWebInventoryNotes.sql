/****** Object:  Procedure [dbo].[PortalWebInventoryNotes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PortalWebInventoryNotes] 
	-- Add the parameters for the stored procedure here
	@ItemCode varchar(15)
AS
BEGIN
	SELECT
	UDF_NOTES_TASTING as NotesTast, 
    UDF_NOTES_VINEYARD as NotesVine, 
    UDF_NOTES_VINIFICATION as NotesVinif, 
    UDF_NOTES_VARIETAL as NotesVar,
    UDF_NOTES_PRODUCTION as NotesProd,
    UDF_NOTES_AGING as NotesAge,
    UDF_NOTES_ALTITUDE as NotesSoil,
    UDF_NOTES_ORIENTATION as NotesOrien,
    UDF_NOTES_SOIL as NotesViti
	FROM [MAS_POL].dbo.CI_Item
	WHERE ItemCode = @ItemCode
END
