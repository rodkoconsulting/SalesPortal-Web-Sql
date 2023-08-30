/****** Object:  Procedure [dbo].[dev_PortalInventoryDesc_sync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[dev_PortalInventoryDesc_sync]
	@UserName varchar(25),
	@TimeSync datetime
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CurrentDate Datetime;
	DECLARE @TimeSyncPrev DateTime;
	DECLARE @RepCode varchar(4);
    Set @CurrentDate=GETDATE();
SELECT @RepCode = RepCode FROM Web_UserMappings where UserName=@UserName
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
		   IsNull(left(MAS_POL.dbo.CI_ITEM.UDF_NATURAL,1),'') as Natural,
		   IsNull(left(MAS_POL.dbo.CI_ITEM.UDF_VEGAN,1),'') as Vegan,
		   IsNull(left(MAS_POL.dbo.CI_ITEM.UDF_HAUTE_VALEUR,1),'') as HVE
INTO #temp_dev_PortalInventoryDesc_Current
FROM       MAS_POL.dbo.CI_Item INNER JOIN
           MAS_POL.dbo.IM_ItemWarehouse ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.IM_ItemWarehouse.ItemCode INNER JOIN
           dbo.IM_InventoryAvailable ON MAS_POL.dbo.CI_Item.ItemCode = dbo.IM_InventoryAvailable.ITEMCODE LEFT OUTER JOIN
		   MAS_POL.dbo.CI_UDT_VARIETALS AS v ON MAS_POL.dbo.CI_Item.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
		   MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_Item.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
		   MAS_POL.dbo.CI_UDT_APPELLATION as a ON MAS_POL.dbo.CI_Item.UDF_SUBREGION_T = a.UDF_APPELLATION LEFT OUTER JOIN
		   POL.dbo.IM_ItemWarehouse_001 as bh ON MAS_POL.dbo.CI_Item.ItemCode = bh.ItemCode
WHERE     (MAS_POL.dbo.CI_Item.ProcurementType <> 'SAMP') AND (MAS_POL.dbo.CI_Item.ItemType = '1') AND (MAS_POL.dbo.CI_Item.Category1 = 'Y') AND (MAS_POL.dbo.IM_ItemWarehouse.WarehouseCode = '000') AND 
          (MAS_POL.dbo.IM_ItemWarehouse.QuantityOnHand + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnPurchaseOrder + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnSalesOrder
          + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnBackOrder + IsNull(bh.QuantityOnSalesOrder,0) > 0.04)
SELECT @TimeSyncPrev = MAX(TimeSync) FROM dev_PortalInventoryDesc_Previous where RepCode=@RepCode
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
	CASE WHEN MIN(Operation)<>'D' THEN [Natural] ELSE '' END AS Natural,
	CASE WHEN MIN(Operation)<>'D' THEN [Vegan] ELSE '' END AS Vegan,
	CASE WHEN MIN(Operation)<>'D' THEN [HVE] ELSE '' END AS HVE
FROM
(
  SELECT 'D' as Operation, [RepCode],[ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[MasterVendor],[RestrictOffSale],
				[RestrictOnPremise],[RestrictOffSaleNotes],[RestrictAllocated],[RestrictApproval],[RestrictMaxCases],[RestrictState],[RestrictSamples],
				[WineType],[Varietal],[Closure],[Country],[Region],[Appellation],[Organic],[Biodynamic],[SampleFocus],[RestrictBo],[RestrictMo],[Upc],[ScoreWA],
				[ScoreWS],[ScoreIWC], [ScoreBH], [ScoreVM], [ScoreOther], [ReceiptDate],[Regen],[Natural],[Vegan],[HVE]
  FROM dbo.dev_PortalInventoryDesc_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [RepCode],[ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[MasterVendor],[RestrictOffSale],
				[RestrictOnPremise],[RestrictOffSaleNotes],[RestrictAllocated],[RestrictApproval],[RestrictMaxCases],[RestrictState],[RestrictSamples],
				[WineType],[Varietal],[Closure],[Country],[Region],[Appellation],[Organic],[Biodynamic],[SampleFocus],[RestrictBo],[RestrictMo],[Upc],[ScoreWA],
				[ScoreWS],[ScoreIWC], [ScoreBH], [ScoreVM], [ScoreOther],[ReceiptDate],[Regen],[Natural],[Vegan],[HVE]
  FROM #temp_dev_PortalInventoryDesc_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[MasterVendor],[RestrictOffSale],
				[RestrictOnPremise],[RestrictOffSaleNotes],[RestrictAllocated],[RestrictApproval],[RestrictMaxCases],[RestrictState],[RestrictSamples],
				[WineType],[Varietal],[Closure],[Country],[Region],[Appellation],[Organic],[Biodynamic],[SampleFocus],[RestrictBo],[RestrictMo],[Upc],[ScoreWA],
				[ScoreWS],[ScoreIWC], [ScoreBH], [ScoreVM], [ScoreOther], [ReceiptDate],[Regen],[Natural],[Vegan],[HVE]
   
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
				[ScoreWS],[ScoreIWC], [ScoreBH], [ScoreVM], [ScoreOther]
				,CONVERT(varchar, [ReceiptDate], 112) AS ReceiptDate,[Regen],[Natural],[Vegan],[HVE]
  FROM #temp_dev_PortalInventoryDesc_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM dev_PortalInventoryDesc_Previous where RepCode = @RepCode
INSERT dev_PortalInventoryDesc_Previous(TimeSync, RepCode, ItemCode, Brand,[Description], Vintage, Uom, BottleSize, DamagedNotes, MasterVendor, RestrictOffSale,
									RestrictOnPremise, RestrictOffSaleNotes, RestrictAllocated, RestrictApproval, RestrictMaxCases, RestrictState, 
									RestrictSamples, WineType, Varietal, Closure, Country, Region, Appellation, Organic, Biodynamic, SampleFocus, RestrictBo, RestrictMo,
									Upc, ScoreWA, ScoreWS, ScoreIWC, ScoreBH, ScoreVM, ScoreOther, ReceiptDate,[Regen],[Natural],[Vegan],[HVE])
SELECT
	TimeSync,
	RepCode,
	[ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[MasterVendor],[RestrictOffSale],
				[RestrictOnPremise],[RestrictOffSaleNotes],[RestrictAllocated],[RestrictApproval],[RestrictMaxCases],[RestrictState],[RestrictSamples],
				[WineType],[Varietal],[Closure],[Country],[Region],[Appellation],[Organic],[Biodynamic],[SampleFocus],[RestrictBo],[RestrictMo],[Upc],[ScoreWA],
				[ScoreWS],[ScoreIWC], [ScoreBH], [ScoreVM], [ScoreOther], [ReceiptDate],[Regen],[Natural],[Vegan],[HVE]
FROM #temp_dev_PortalInventoryDesc_Current
WHERE RepCode = @RepCode
END

END
