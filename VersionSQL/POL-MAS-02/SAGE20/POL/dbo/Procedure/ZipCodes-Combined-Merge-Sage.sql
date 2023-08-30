/****** Object:  Procedure [dbo].[ZipCodes-Combined-Merge-Sage]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ZipCodes-Combined-Merge-Sage]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
MERGE [dbo].[ZipCodes-Combined] As Target
USING [dbo].[ZipCodes-Sage] As Source
ON Source.ZipCode = Target.ZipCode
WHEN NOT MATCHED BY Target THEN
	INSERT (ZipCode,City,[Ship-Monday],[Ship-Tuesday],[Ship-Wednesday],[Ship-Thursday],[Ship-Friday],Territory,ShipVia,County,[FDL Route])
	VALUES (Source.ZipCode,Source.City,Source.[Ship-Monday],Source.[Ship-Tuesday],Source.[Ship-Wednesday],Source.[Ship-Thursday],Source.[Ship-Friday],Source.Territory,Source.ShipVia,Source.County,Source.[FDL Route])
WHEN MATCHED THEN UPDATE SET
	Target.City = Source.City,
	Target.Territory = Source.Territory,
	Target.County = Source.County;
END
