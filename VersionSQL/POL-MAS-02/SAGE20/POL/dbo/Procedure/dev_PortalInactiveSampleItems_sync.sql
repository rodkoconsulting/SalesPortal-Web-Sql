/****** Object:  Procedure [dbo].[dev_PortalInactiveSampleItems_sync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[dev_PortalInactiveSampleItems_sync]
	@UserName varchar(25),
	@TimeSync datetime
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CurrentDate Datetime;
	DECLARE @TimeSyncPrev DateTime;
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
    Set @CurrentDate=GETDATE();
SELECT @RepCode = RepCode FROM Web_UserMappings where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_UserMappings where UserName=@UserName
CREATE TABLE #temp_dev_PortalInactiveSampleItems_Current(  
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ItemCode] [varchar](30) NOT NULL,
	[Brand] [varchar](50) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[Vintage] [varchar](4) NOT NULL,
	[Uom] [varchar](4) NOT NULL,
	[BottleSize] [varchar](10) NOT NULL,
	[DamagedNotes] [varchar](30) NOT NULL,
	[SampleFocus] [varchar](1) NOT NULL,
	[Region] [varchar](40) NOT NULL,
	[MasterVendor] [varchar](40) NOT NULL,
	[Country] [varchar](20) NOT NULL,
	[Appellation] [varchar](50) NOT NULL)
IF(@AccountType = 'REP')
BEGIN
INSERT INTO #temp_dev_PortalInactiveSampleItems_Current(TimeSync, RepCode, ItemCode, Brand, [Description], Vintage, Uom, BottleSize, DamagedNotes, SampleFocus, Region,MasterVendor,
									Country, Appellation)
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(MAS_POL.dbo.CI_Item.ItemCode,30) as ItemCode,
		   left(MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES,50) as Brand,
		   left(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION,200) as 'Description',
		   left(MAS_POL.dbo.CI_ITEM.UDF_VINTAGE,4) as Vintage, 
		   left(MAS_POL.dbo.CI_ITEM.SalesUnitOfMeasure,4) as Uom,
		   left(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE,10) as BottleSize,
		   left(MAS_POL.dbo.CI_ITEM.UDF_DAMAGED_NOTES,30) as DamagedNotes,
		   MAS_POL.dbo.CI_ITEM.UDF_SAMPLE_FOCUS as SampleFocus,
		   left(IsNull(r.UDF_REGION,''),40) as Region,
		   left(MAS_POL.dbo.CI_ITEM.UDF_MASTER_VENDOR,40) as MasterVendor,
		   left(MAS_POL.dbo.CI_ITEM.UDF_COUNTRY,20) as Country,
		   left(IsNull(a.UDF_NAME,''),50) as Appellation
FROM       MAS_POL.dbo.CI_Item INNER JOIN
           dbo.PortalSampleItemsInactiveByRep ON MAS_POL.dbo.CI_Item.ItemCode = dbo.PortalSampleItemsInactiveByRep.ItemCode LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_Item.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON MAS_POL.dbo.CI_Item.UDF_SUBREGION_T = a.UDF_APPELLATION
WHERE dbo.PortalSampleItemsInactiveByRep.Rep = @RepCode
END
ELSE
BEGIN
INSERT INTO #temp_dev_PortalInactiveSampleItems_Current(TimeSync, RepCode, ItemCode, Brand, [Description], Vintage, Uom, BottleSize, DamagedNotes, SampleFocus, Region,MasterVendor,
									Country, Appellation)
SELECT     DISTINCT @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(MAS_POL.dbo.CI_Item.ItemCode,30) as ItemCode,
		   left(MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES,50) as Brand,
		   left(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION,200) as 'Description',
		   left(MAS_POL.dbo.CI_ITEM.UDF_VINTAGE,4) as Vintage, 
		   left(MAS_POL.dbo.CI_ITEM.SalesUnitOfMeasure,4) as Uom,
		   left(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE,10) as BottleSize,
		   left(MAS_POL.dbo.CI_ITEM.UDF_DAMAGED_NOTES,30) as DamagedNotes,
		   MAS_POL.dbo.CI_ITEM.UDF_SAMPLE_FOCUS as SampleFocus,
		   left(IsNull(r.UDF_REGION,''),40) as Region,
		   left(MAS_POL.dbo.CI_ITEM.UDF_MASTER_VENDOR,40) as MasterVendor,
		   left(MAS_POL.dbo.CI_ITEM.UDF_COUNTRY,20) as Country,
		   left(IsNull(a.UDF_NAME,''),50) as Appellation
FROM       MAS_POL.dbo.CI_Item INNER JOIN
           dbo.PortalSampleItemsInactiveByRep ON MAS_POL.dbo.CI_Item.ItemCode = dbo.PortalSampleItemsInactiveByRep.ItemCode LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_Item.UDF_REGION = r.UDF_PRIMARY_REGION_CODE  LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON MAS_POL.dbo.CI_Item.UDF_SUBREGION_T = a.UDF_APPELLATION
END   

SELECT @TimeSyncPrev = MAX(TimeSync) FROM dev_PortalInactiveSampleItems_Previous where RepCode=@RepCode
IF(@TimeSyncPrev = @TimeSync)
BEGIN
	SELECT
	CONVERT(varchar, @CurrentDate , 121) as TimeSync,
	MIN(Operation) as Operation,
	[ItemCode],
	CASE WHEN MIN(Operation)<>'D' THEN [Brand] ELSE '' END AS Brand,
	CASE WHEN MIN(Operation)<>'D' THEN [Description] ELSE '' END AS Description,
	CASE WHEN MIN(Operation)<>'D' THEN [Vintage] ELSE '' END AS Vintage,
	CASE WHEN MIN(Operation)<>'D' THEN [Uom] ELSE '' END AS Uom,
	CASE WHEN MIN(Operation)<>'D' THEN [BottleSize] ELSE '' END AS BottleSize,
	CASE WHEN MIN(Operation)<>'D' THEN [DamagedNotes] ELSE '' END AS DamagedNotes,
	CASE WHEN MIN(Operation)<>'D' THEN [SampleFocus] ELSE '' END AS SampleFocus,
	CASE WHEN MIN(Operation)<>'D' THEN [Region] ELSE '' END AS Region,
	CASE WHEN MIN(Operation)<>'D' THEN [MasterVendor] ELSE '' END AS MasterVendor,
	CASE WHEN MIN(Operation)<>'D' THEN [Country] ELSE '' END AS Country,
	CASE WHEN MIN(Operation)<>'D' THEN [Appellation] ELSE '' END AS Appellation
FROM
(
  SELECT 'D' as Operation, [RepCode],[ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[SampleFocus],Region, MasterVendor, Country, Appellation
  FROM dbo.PortalInactiveSampleItems_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [RepCode],[ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[SampleFocus],Region, MasterVendor, Country, Appellation
  FROM #temp_dev_PortalInactiveSampleItems_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[SampleFocus],Region, MasterVendor, Country, Appellation
HAVING COUNT(*) = 1
 
ORDER BY  [ItemCode], Operation

END
ELSE
BEGIN
 SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
	'C' as Operation,
	[ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[SampleFocus],Region, MasterVendor, Country, Appellation
  FROM #temp_dev_PortalInactiveSampleItems_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM dev_PortalInactiveSampleItems_Previous where RepCode = @RepCode
INSERT dev_PortalInactiveSampleItems_Previous(TimeSync, RepCode, ItemCode, Brand,[Description], Vintage, Uom, BottleSize, DamagedNotes, SampleFocus, Region, MasterVendor, Country, Appellation)
SELECT
	TimeSync,
	RepCode,
	[ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[SampleFocus], Region, MasterVendor, Country, Appellation
FROM #temp_dev_PortalInactiveSampleItems_Current
WHERE RepCode = @RepCode
END

END
