/****** Object:  Procedure [dbo].[EmpireWines_Create]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[EmpireWines_Create]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ValidDate Datetime;
	DECLARE @NextMonthDate Datetime;
	DECLARE @NextMonthMonth int;
	DECLARE @NextMonthYear int;
	SET @NextMonthDate = DATEADD(month, 1, GETDATE());
	SET @NextMonthMonth=MONTH(@NextMonthDate);
	SET @NextMonthYear=Year(@NextMonthDate);
	SET @ValidDate = CAST(CAST(@NextMonthMonth AS varchar(5))+'/1/'+CAST(@NextMonthYear As varchar(5)) as Datetime);
INSERT INTO [dbo].[EmpireWines_Snapshot]
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
      --,Replace(Replace([Region],char(10),''),char(13),'') as [Region]
	  ,[Region]
      ,[Appellation]
      --,replace(replace(replace(Replace(Replace([Description],char(13),' '),char(10),' '),' ','<>'),'><',''),'<>',' ') as [Description]
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
   FROM [dbo].[EmpireWines_Query] dupe
 where ValidDate in (SELECT MAX(VALIDDATE) FROM [dbo].[EmpireWines_Query] WHERE SKU=dupe.SKU AND VALIDDATE<=@ValidDate)
END
