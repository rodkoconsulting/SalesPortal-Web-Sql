/****** Object:  Procedure [dbo].[EmpireWines_QuerySnapshot]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[EmpireWines_QuerySnapshot]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [SKU]
      ,[Status]
      ,[Importer/Supplier]
      ,[Product Type]
      ,[Product Subtype]
      ,[Product Style]
      ,[Producer Name]
      ,[Product Name]
      ,[Vintage]
      ,[Grapes & Raw Materials]
      ,[Country]
	  ,[Region]
      ,[Appellation]
	  ,[Description]
      ,[Features]
      ,[Alcohol by volume]
      ,[Size]
      ,[Size Unit]
      ,[Container Type]
      ,[Case size]
      ,[Pricing]
      ,[ImageURL]
      ,[TTB]
   FROM [dbo].[EmpireWines_Snapshot]
END
