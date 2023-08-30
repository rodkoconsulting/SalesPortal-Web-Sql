/****** Object:  View [dbo].[PortalWebInventory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebInventory]
AS
SELECT     CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_SAMPLE_FOCUS = 'Y' THEN 'Y' ELSE '' END AS Focus
			, MAS_POL.dbo.CI_Item.ItemCode
			, MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES AS Brand
			, MAS_POL.dbo.CI_Item.UDF_DESCRIPTION AS 'Description'
			, MAS_POL.dbo.CI_Item.UDF_VINTAGE AS Vintage
			, CAST(REPLACE(MAS_POL.dbo.CI_Item.SalesUnitOfMeasure, 'C', '') AS INT) AS Uom
			, MAS_POL.dbo.CI_Item.UDF_BOTTLE_SIZE AS BottleSize
			, MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES AS DamagedNotes
			, CASE WHEN dbo.IM_InventoryAvailable.QuantityAvailable > 0.01 THEN CAST(ROUND(dbo.IM_InventoryAvailable.QuantityAvailable, 2) AS FLOAT) ELSE 0 END AS QtyAvailable
			, CAST(ROUND(dbo.IM_InventoryAvailable.QtyOnHand, 2) AS FLOAT) AS QtyOnHand
			, CAST(ROUND(dbo.IM_InventoryAvailable.OnSO,2) AS FLOAT) AS OnSO
			, CAST(ROUND(dbo.IM_InventoryAvailable.OnMO,2) AS FLOAT) AS OnMO
			, CAST(ROUND(dbo.IM_InventoryAvailable.OnBO,2) AS FLOAT) AS OnBO
			, CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_OFFSALE = 'Y' THEN 'Y' ELSE '' END AS RestrictOffSale
			, CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_NORETAIL = 'Y' THEN 'Y' ELSE '' END AS RestrictOnPremise
			, MAS_POL.dbo.CI_Item.UDF_RESTRICT_OFFSALE_NOTES AS RestrictOffSaleNotes
			, CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_ALLOCATED = 'Y' THEN 'Y' ELSE '' END AS RestrictAllocated
			, MAS_POL.dbo.CI_Item.UDF_RESTRICT_MANAGER AS RestrictApproval
			, CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MAX > 0 THEN CONVERT(VARCHAR(3), CONVERT(INT, MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MAX)) ELSE '' END AS RestrictMaxCases
			, MAS_POL.dbo.CI_Item.UDF_RESTRICT_STATE AS RestrictState
			, CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_SAMPLES = 'Y' THEN 'Y' ELSE '' END AS RestrictSamples
			, CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_BO = 'Y' THEN 'Y' ELSE '' END AS RestrictBo
			, CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MO = 'Y' THEN 'Y' ELSE '' END AS RestrictMo
			, CASE WHEN MAS_POL.dbo.CI_Item.CATEGORY3 = 'Y' THEN 'Y' ELSE '' END AS 'Core'
			, MAS_POL.dbo.CI_Item.UDF_WINE_COLOR AS Type
			, IsNull(v.UDF_VARIETAL,'') AS Varietal
			, LEFT(MAS_POL.dbo.CI_Item.UDF_ORGANIC, 1) AS Organic
			, LEFT(MAS_POL.dbo.CI_Item.UDF_BIODYNAMIC, 1) AS Biodynamic
			, MAS_POL.dbo.CI_Item.UDF_COUNTRY AS Country
			, IsNull(r.UDF_REGION,'') AS Region
			, IsNull(a.UDF_NAME,'') AS Appellation
			, MAS_POL.dbo.CI_Item.UDF_MASTER_VENDOR AS MasterVendor
			, MAS_POL.dbo.CI_Item.UDF_CLOSURE AS Closure
			, MAS_POL.dbo.CI_Item.UDF_UPC_CODE AS Upc, MAS_POL.dbo.CI_Item.UDF_PARKER AS ScoreWA, 
                      MAS_POL.dbo.CI_Item.UDF_SPECTATOR AS ScoreWS, MAS_POL.dbo.CI_Item.UDF_TANZER AS ScoreIWC, MAS_POL.dbo.CI_Item.UDF_BURGHOUND AS ScoreBH, 
                      MAS_POL.dbo.CI_Item.UDF_GALLONI_SCORE AS ScoreVM, MAS_POL.dbo.CI_Item.UDF_VFC AS ScoreOther,
                      CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_BM_FOCUS = 'Y' THEN 'Y' ELSE '' END AS FocusBm
FROM         MAS_POL.dbo.CI_Item INNER JOIN
                      MAS_POL.dbo.IM_ItemWarehouse ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.IM_ItemWarehouse.ItemCode INNER JOIN
                      dbo.IM_InventoryAvailable ON MAS_POL.dbo.CI_Item.ItemCode = dbo.IM_InventoryAvailable.ITEMCODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_VARIETALS AS v ON MAS_POL.dbo.CI_Item.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_Item.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON MAS_POL.dbo.CI_Item.UDF_SUBREGION_T = a.UDF_APPELLATION
WHERE     (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND (MAS_POL.dbo.CI_Item.ItemType = '1') AND (MAS_POL.dbo.CI_Item.Category1 = 'Y') AND 
                      (MAS_POL.dbo.IM_ItemWarehouse.WarehouseCode = '000') AND 
          (MAS_POL.dbo.IM_ItemWarehouse.QuantityOnHand + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnPurchaseOrder + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnSalesOrder
          + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnBackOrder > 0.04)
