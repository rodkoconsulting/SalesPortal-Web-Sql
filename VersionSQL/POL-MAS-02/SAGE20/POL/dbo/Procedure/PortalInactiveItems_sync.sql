/****** Object:  Procedure [dbo].[PortalInactiveItems_sync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalInactiveItems_sync]
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
CREATE TABLE #temp_PortalInactiveItems_Current(  
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ItemCode] [varchar](30) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[Brand] [varchar](50) NOT NULL,
	[MasterVendor] [varchar](40) NOT NULL,
	[Vintage] [varchar](4) NOT NULL,
	[Uom] [varchar](4) NOT NULL,
	[BottleSize] [varchar](10) NOT NULL,
	[DamagedNotes] [varchar](30) NOT NULL,
	[Closure] [varchar](20) NOT NULL,
	[WineType] [varchar](40) NOT NULL,
	[Varietal] [varchar](40) NOT NULL,
	[Organic] [varchar](10) NOT NULL,
	[Biodynamic] [varchar](10) NOT NULL,
	[SampleFocus] [varchar](1) NOT NULL,
	[Country] [varchar](20) NOT NULL,
	[Region] [varchar](40) NOT NULL,
	[Appellation] [varchar](50) NOT NULL,
	[RestrictOffSale] [varchar](1) NOT NULL,
	[RestrictOffSaleNotes] [varchar](30) NOT NULL,
	[RestrictOnPremise] [varchar](1) NOT NULL,
	[RestrictAllocated] [varchar](1) NOT NULL,
	[RestrictApproval] [varchar](20) NOT NULL,
	[RestrictMaxCases] [varchar](5) NOT NULL,
	[RestrictState] [varchar](20) NOT NULL,
	[RestrictSamples] [varchar](1) NOT NULL,
	[RestrictBo] [varchar](1) NOT NULL,
	[Upc] [varchar](13) NOT NULL,
	[ScoreWA] [varchar](20) NOT NULL,
	[ScoreWS] [varchar](20) NOT NULL,
	[ScoreIWC] [varchar](20) NOT NULL,
	[ScoreBH] [varchar](20) NOT NULL,
	[ScoreVM] [varchar](20) NOT NULL,
	[ScoreOther] [varchar](20) NOT NULL,
	[RestrictMo] [varchar](1) NOT NULL,
	[ReceiptDate] [datetime] NULL,
	[Regen] [varchar](1) NOT NULL,
	[Natural] [varchar](1) NOT NULL,
	[Vegan] [varchar](1) NOT NULL,
	[HVE] [varchar](1) NOT NULL)
IF(@AccountType = 'REP')
BEGIN
INSERT INTO #temp_PortalInactiveItems_Current(TimeSync, RepCode, ItemCode, Brand, [Description], Vintage, Uom, BottleSize, DamagedNotes, MasterVendor, RestrictOffSale,
									RestrictOnPremise, RestrictOffSaleNotes, RestrictAllocated, RestrictApproval, RestrictMaxCases, RestrictState, 
									RestrictSamples, WineType, Varietal, Closure, Country, Region, Appellation, Organic, Biodynamic, SampleFocus, RestrictBo,RestrictMo,
									Upc, ScoreWA, ScoreWS, ScoreIWC, ScoreBH, ScoreVM, ScoreOther, ReceiptDate, Regen, [Natural], Vegan, HVE)
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(MAS_POL.dbo.CI_Item.ItemCode,30) as ItemCode,
		   left(MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES,50) as Brand,
		   left(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION,200) as 'Description',
		   left(MAS_POL.dbo.CI_ITEM.UDF_VINTAGE,4) as Vintage, 
		   left(MAS_POL.dbo.CI_ITEM.SalesUnitOfMeasure,4) as Uom,
		   left(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE,10) as BottleSize,
		   left(MAS_POL.dbo.CI_ITEM.UDF_DAMAGED_NOTES,30) as DamagedNotes,
		   left(MAS_POL.dbo.CI_Item.UDF_MASTER_VENDOR,40) as MasterVendor,
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_OFFSALE as RestrictOffSale,
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_NORETAIL as RestrictOnPremise,
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_OFFSALE_NOTES as RestrictOffSaleNotes,
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_ALLOCATED as RestrictAllocated,
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MANAGER as RestrictApproval,
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MAX as RestrictMaxCases,
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_STATE as RestrictState,
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_SAMPLES as RestrictSamples,
		   left(MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR,40) as WineType,
		   left(IsNull(v.UDF_VARIETAL,''),40) as Varietal,
		   left(MAS_POL.dbo.CI_ITEM.UDF_CLOSURE,20) as Closure,
		   left(MAS_POL.dbo.CI_ITEM.UDF_COUNTRY,20) as Country,
		   left(IsNull(r.UDF_REGION,''),40) as Region,
		   left(IsNull(a.UDF_NAME,''),50) as Appellation,
		   left(MAS_POL.dbo.CI_ITEM.UDF_ORGANIC,10) as Organic,
		   left(MAS_POL.dbo.CI_ITEM.UDF_BIODYNAMIC,10) as Biodynamic,
		   MAS_POL.dbo.CI_ITEM.UDF_SAMPLE_FOCUS as SampleFocus,
		   IsNull(MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_BO,'') as RestrictBo,
		   IsNull(MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MO,'') as RestrictMo,
		   left(MAS_POL.dbo.CI_ITEM.UDF_UPC_CODE,13) as Upc,
		   left(MAS_POL.dbo.CI_ITEM.UDF_PARKER,20) as ScoreWA,
		   left(MAS_POL.dbo.CI_ITEM.UDF_SPECTATOR,20) as ScoreWS,
		   left(MAS_POL.dbo.CI_ITEM.UDF_TANZER,20) as ScoreIWC,
		   left(MAS_POL.dbo.CI_ITEM.UDF_BURGHOUND,20) as ScoreBH,
		   left(MAS_POL.dbo.CI_ITEM.UDF_GALLONI_SCORE,20) as ScoreVM,
		   left(MAS_POL.dbo.CI_ITEM.UDF_VFC,20) as ScoreOther,
		   LastReceiptDate as ReceiptDate,
		   IsNull(left(MAS_POL.dbo.CI_ITEM.UDF_REGENERATIVE,1),'') as Regen,
		   IsNull(left(MAS_POL.dbo.CI_ITEM.UDF_NATURAL,1),'') as [Natural],
		   IsNull(left(MAS_POL.dbo.CI_ITEM.UDF_VEGAN,1),'') as Vegan,
		   IsNull(left(MAS_POL.dbo.CI_ITEM.UDF_HAUTE_VALEUR,1),'') as HVE
FROM       MAS_POL.dbo.CI_Item INNER JOIN
           dbo.PortalItemsInactiveByRep ON MAS_POL.dbo.CI_Item.ItemCode = dbo.PortalItemsInactiveByRep.ItemCode LEFT OUTER JOIN
		   MAS_POL.dbo.CI_UDT_VARIETALS AS v ON MAS_POL.dbo.CI_Item.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
		   MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_Item.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
		   MAS_POL.dbo.CI_UDT_APPELLATION as a ON MAS_POL.dbo.CI_Item.UDF_SUBREGION_T = a.UDF_APPELLATION
           WHERE dbo.PortalItemsInactiveByRep.SalespersonNo = @RepCode
END
ELSE
BEGIN
INSERT INTO #temp_PortalInactiveItems_Current(TimeSync, RepCode, ItemCode, Brand, [Description], Vintage, Uom, BottleSize, DamagedNotes, MasterVendor, RestrictOffSale,
									RestrictOnPremise, RestrictOffSaleNotes, RestrictAllocated, RestrictApproval, RestrictMaxCases, RestrictState, 
									RestrictSamples, WineType, Varietal, Closure, Country, Region, Appellation, Organic, Biodynamic, SampleFocus, RestrictBo,RestrictMo,
									Upc, ScoreWA, ScoreWS, ScoreIWC, ScoreBH, ScoreVM, ScoreOther, ReceiptDate, Regen, [Natural], Vegan, HVE)
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(MAS_POL.dbo.CI_Item.ItemCode,30) as ItemCode,
		   left(MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES,50) as Brand,
		   left(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION,200) as 'Description',
		   left(MAS_POL.dbo.CI_ITEM.UDF_VINTAGE,4) as Vintage, 
		   left(MAS_POL.dbo.CI_ITEM.SalesUnitOfMeasure,4) as Uom,
		   left(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE,10) as BottleSize,
		   left(MAS_POL.dbo.CI_ITEM.UDF_DAMAGED_NOTES,30) as DamagedNotes,
		   left(MAS_POL.dbo.CI_Item.UDF_MASTER_VENDOR,40) as MasterVendor,
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_OFFSALE as RestrictOffSale,
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_NORETAIL as RestrictOnPremise,
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_OFFSALE_NOTES as RestrictOffSaleNotes,
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_ALLOCATED as RestrictAllocated,
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MANAGER as RestrictApproval,
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MAX as RestrictMaxCases,
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_STATE as RestrictState,
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_SAMPLES as RestrictSamples,
		   left(MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR,40) as WineType,
		   left(IsNull(v.UDF_VARIETAL,''),40) as Varietal,
		   left(MAS_POL.dbo.CI_ITEM.UDF_CLOSURE,20) as Closure,
		   left(MAS_POL.dbo.CI_ITEM.UDF_COUNTRY,20) as Country,
		   left(IsNull(r.UDF_REGION,''),40) as Region,
		   left(IsNull(a.UDF_NAME,''),50) as Appellation,
		   left(MAS_POL.dbo.CI_ITEM.UDF_ORGANIC,10) as Organic,
		   left(MAS_POL.dbo.CI_ITEM.UDF_BIODYNAMIC,10) as Biodynamic,
		   MAS_POL.dbo.CI_ITEM.UDF_SAMPLE_FOCUS as SampleFocus,
		   IsNull(MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_BO,'') as RestrictBo,
		   IsNull(MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MO,'') as RestrictMo,
		   left(MAS_POL.dbo.CI_ITEM.UDF_UPC_CODE,13) as Upc,
		   left(MAS_POL.dbo.CI_ITEM.UDF_PARKER,20) as ScoreWA,
		   left(MAS_POL.dbo.CI_ITEM.UDF_SPECTATOR,20) as ScoreWS,
		   left(MAS_POL.dbo.CI_ITEM.UDF_TANZER,20) as ScoreIWC,
		   left(MAS_POL.dbo.CI_ITEM.UDF_BURGHOUND,20) as ScoreBH,
		   left(MAS_POL.dbo.CI_ITEM.UDF_GALLONI_SCORE,20) as ScoreVM,
		   left(MAS_POL.dbo.CI_ITEM.UDF_VFC,20) as ScoreOther,
		   LastReceiptDate as ReceiptDate,
		   IsNull(left(MAS_POL.dbo.CI_ITEM.UDF_REGENERATIVE,1),'') as Regen,
		   IsNull(left(MAS_POL.dbo.CI_ITEM.UDF_NATURAL,1),'') as [Natural],
		   IsNull(left(MAS_POL.dbo.CI_ITEM.UDF_VEGAN,1),'') as Vegan,
		   IsNull(left(MAS_POL.dbo.CI_ITEM.UDF_HAUTE_VALEUR,1),'') as HVE
FROM       MAS_POL.dbo.CI_Item INNER JOIN
           dbo.PortalItemsInactive ON MAS_POL.dbo.CI_Item.ItemCode = dbo.PortalItemsInactive.ItemCode LEFT OUTER JOIN
		   MAS_POL.dbo.CI_UDT_VARIETALS AS v ON MAS_POL.dbo.CI_Item.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
		   MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_Item.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
		   MAS_POL.dbo.CI_UDT_APPELLATION as a ON MAS_POL.dbo.CI_Item.UDF_SUBREGION_T = a.UDF_APPELLATION
END   

SELECT @TimeSyncPrev = MAX(TimeSync) FROM PortalInactiveItems_Previous where RepCode=@RepCode
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
	CASE WHEN MIN(Operation)<>'D' THEN [MasterVendor] ELSE '' END AS MasterVendor,
	CASE WHEN MIN(Operation)<>'D' THEN [RestrictOffSale] ELSE '' END AS RestrictOffSale,
	CASE WHEN MIN(Operation)<>'D' THEN [RestrictOnPremise] ELSE '' END AS RestrictOnPremise,
	CASE WHEN MIN(Operation)<>'D' THEN [RestrictOffSaleNotes] ELSE '' END AS RestrictOffSaleNotes,
	CASE WHEN MIN(Operation)<>'D' THEN [RestrictAllocated] ELSE '' END AS RestrictAllocated,
	CASE WHEN MIN(Operation)<>'D' THEN [RestrictApproval] ELSE '' END AS RestrictApproval,
	CASE WHEN MIN(Operation)<>'D' THEN CAST([RestrictMaxCases] as varchar) ELSE '' END AS RestrictMaxCases,
	CASE WHEN MIN(Operation)<>'D' THEN [RestrictState] ELSE '' END AS RestrictState,
	CASE WHEN MIN(Operation)<>'D' THEN [RestrictSamples] ELSE '' END AS RestrictSamples,
	CASE WHEN MIN(Operation)<>'D' THEN [WineType] ELSE '' END AS WineType,
	CASE WHEN MIN(Operation)<>'D' THEN [Varietal] ELSE '' END AS Varietal,
	CASE WHEN MIN(Operation)<>'D' THEN [Closure] ELSE '' END AS Closure,
	CASE WHEN MIN(Operation)<>'D' THEN [Country] ELSE '' END AS Country,
	CASE WHEN MIN(Operation)<>'D' THEN [Region] ELSE '' END AS Region,
	CASE WHEN MIN(Operation)<>'D' THEN [Appellation] ELSE '' END AS Appellation,
	CASE WHEN MIN(Operation)<>'D' THEN [Organic] ELSE '' END AS Organic,
	CASE WHEN MIN(Operation)<>'D' THEN [Biodynamic] ELSE '' END AS Biodynamic,
	CASE WHEN MIN(Operation)<>'D' THEN [SampleFocus] ELSE '' END AS SampleFocus,
	CASE WHEN MIN(Operation)<>'D' THEN [RestrictBo] ELSE '' END AS RestrictBo,
	CASE WHEN MIN(Operation)<>'D' THEN [RestrictMo] ELSE '' END AS RestrictMo,
	CASE WHEN MIN(Operation)<>'D' THEN [Upc] ELSE '' END AS Upc,
	CASE WHEN MIN(Operation)<>'D' THEN [ScoreWA] ELSE '' END AS ScoreWA,
	CASE WHEN MIN(Operation)<>'D' THEN [ScoreWS] ELSE '' END AS ScoreWS,
	CASE WHEN MIN(Operation)<>'D' THEN [ScoreIWC] ELSE '' END AS ScoreIWC,
	CASE WHEN MIN(Operation)<>'D' THEN [ScoreBH] ELSE '' END AS ScoreBH,
	CASE WHEN MIN(Operation)<>'D' THEN [ScoreVM] ELSE '' END AS ScoreVM,
	CASE WHEN MIN(Operation)<>'D' THEN [ScoreOther] ELSE '' END AS ScoreOther,
	CASE WHEN MIN(Operation)<>'D' THEN CONVERT(varchar, [ReceiptDate], 112) ELSE '' END AS ReceiptDate,
	CASE WHEN MIN(Operation)<>'D' THEN [Regen] ELSE '' END AS Regen,
	CASE WHEN MIN(Operation)<>'D' THEN [Natural] ELSE '' END AS [Natural],
	CASE WHEN MIN(Operation)<>'D' THEN [Vegan] ELSE '' END AS Vegan,
	CASE WHEN MIN(Operation)<>'D' THEN [HVE] ELSE '' END AS HVE
FROM
(
  SELECT 'D' as Operation, [RepCode],[ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[MasterVendor],[RestrictOffSale],
				[RestrictOnPremise],[RestrictOffSaleNotes],[RestrictAllocated],[RestrictApproval],[RestrictMaxCases],[RestrictState],[RestrictSamples],
				[WineType],[Varietal],[Closure],[Country],[Region],[Appellation],[Organic],[Biodynamic],[SampleFocus],[RestrictBo],[RestrictMo],[Upc],[ScoreWA],
				[ScoreWS],[ScoreIWC], [ScoreBH], [ScoreVM], [ScoreOther],[ReceiptDate],Regen, [Natural], Vegan, HVE
				 
  FROM dbo.PortalInactiveItems_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [RepCode],[ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[MasterVendor],[RestrictOffSale],
				[RestrictOnPremise],[RestrictOffSaleNotes],[RestrictAllocated],[RestrictApproval],[RestrictMaxCases],[RestrictState],[RestrictSamples],
				[WineType],[Varietal],[Closure],[Country],[Region],[Appellation],[Organic],[Biodynamic],[SampleFocus],[RestrictBo],[RestrictMo],[Upc],[ScoreWA],
				[ScoreWS],[ScoreIWC], [ScoreBH], [ScoreVM], [ScoreOther],[ReceiptDate],Regen, [Natural], Vegan, HVE
  FROM #temp_PortalInactiveItems_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[MasterVendor],[RestrictOffSale],
				[RestrictOnPremise],[RestrictOffSaleNotes],[RestrictAllocated],[RestrictApproval],[RestrictMaxCases],[RestrictState],[RestrictSamples],
				[WineType],[Varietal],[Closure],[Country],[Region],[Appellation],[Organic],[Biodynamic],[SampleFocus],[RestrictBo],[RestrictMo],[Upc],[ScoreWA],
				[ScoreWS],[ScoreIWC], [ScoreBH], [ScoreVM], [ScoreOther],[ReceiptDate],Regen, [Natural], Vegan, HVE
   
HAVING COUNT(*) = 1
 
ORDER BY  [ItemCode], Operation

END
ELSE
BEGIN
 SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
	'C' as Operation,
	[ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[MasterVendor],[RestrictOffSale],
				[RestrictOnPremise],[RestrictOffSaleNotes],[RestrictAllocated],[RestrictApproval],CAST([RestrictMaxCases] as varchar) as RestrictMaxCases,[RestrictState],[RestrictSamples],
				[WineType],[Varietal],[Closure],[Country],[Region],[Appellation],[Organic],[Biodynamic],[SampleFocus],[RestrictBo],[RestrictMo],[Upc],[ScoreWA],
				[ScoreWS],[ScoreIWC], [ScoreBH], [ScoreVM], [ScoreOther],CONVERT(varchar, [ReceiptDate], 112) AS ReceiptDate,Regen, [Natural], Vegan, HVE
  FROM #temp_PortalInactiveItems_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalInactiveItems_Previous where RepCode = @RepCode
INSERT PortalInactiveItems_Previous(TimeSync, RepCode, ItemCode, Brand,[Description], Vintage, Uom, BottleSize, DamagedNotes, MasterVendor, RestrictOffSale,
									RestrictOnPremise, RestrictOffSaleNotes, RestrictAllocated, RestrictApproval, RestrictMaxCases, RestrictState, 
									RestrictSamples, WineType, Varietal, Closure, Country, Region, Appellation, Organic, Biodynamic, SampleFocus, RestrictBo, RestrictMo,
									Upc, ScoreWA, ScoreWS, ScoreIWC, ScoreBH, ScoreVM, ScoreOther, ReceiptDate,Regen, [Natural], Vegan, HVE)
SELECT
	TimeSync,
	RepCode,
	[ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[MasterVendor],[RestrictOffSale],
				[RestrictOnPremise],[RestrictOffSaleNotes],[RestrictAllocated],[RestrictApproval],[RestrictMaxCases],[RestrictState],[RestrictSamples],
				[WineType],[Varietal],[Closure],[Country],[Region],[Appellation],[Organic],[Biodynamic],[SampleFocus],[RestrictBo],[RestrictMo],[Upc],[ScoreWA],
				[ScoreWS],[ScoreIWC], [ScoreBH], [ScoreVM], [ScoreOther],[ReceiptDate],Regen, [Natural], Vegan, HVE
FROM #temp_PortalInactiveItems_Current
WHERE RepCode = @RepCode
END
DROP TABLE #temp_PortalInactiveItems_Current
END
