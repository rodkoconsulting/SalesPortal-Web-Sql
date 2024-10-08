﻿/****** Object:  Procedure [dbo].[SevenFifty_Create]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SevenFifty_Create]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ValidDate Datetime;
    DECLARE @CurrentMonth int;
    DECLARE @CurrentYear int;
	DECLARE @NextMonthDate Datetime;
	DECLARE @NextMonthMonth int;
	DECLARE @NextMonthYear int;
	SET @NextMonthDate = DATEADD(month, 1, GETDATE());
    SET @CurrentMonth=MONTH(DATEADD(day, 7, GETDATE()));
	SET @CurrentYear=YEAR(DATEADD(day, 7, GETDATE()));
	SET @NextMonthMonth=MONTH(@NextMonthDate);
	SET @NextMonthYear=Year(@NextMonthDate);
	--SET @ValidDate = CAST(CAST(@CurrentMonth AS varchar(5))+'/1/'+CAST(@CurrentYear As varchar(5)) as Datetime);
	SET @ValidDate = CAST(CAST(@NextMonthMonth AS varchar(5))+'/1/'+CAST(@NextMonthYear As varchar(5)) as Datetime);
INSERT INTO [dbo].[SevenFifty_Current]
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
      ,[IsHidden]
      ,[ImageURL]
      ,[State]
      ,[TTB]
	  ,[SkuPa]
   FROM [dbo].[SevenFifty_DataExport] dupe
 where ValidDate in (SELECT MAX(VALIDDATE) FROM [dbo].[SevenFifty_DataExport] WHERE SKU=dupe.SKU and [State]=dupe.[State] AND VALIDDATE<=@ValidDate)
END
