/****** Object:  View [dbo].[BevMedia_DataExport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[BevMedia_DataExport]
AS
SELECT     MAS_POL.dbo.CI_ITEM.ITEMCODE AS SKU, CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MAX > 0 OR
                      /*** MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_OFFSALE = 'Y' OR ***/
                      MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_STATE = 'NJ ONLY' OR
                      MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_ALLOCATED = 'Y' OR
                      LEN(MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MANAGER)>0 OR
                      MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_NORETAIL = 'Y' THEN 'Limited Availability' ELSE 'Available' END AS Status,
                      CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_MASTER_VENDOR ='Private Labels' then 'Polaner Domestic' else MAS_POL.dbo.CI_ITEM.UDF_MASTER_VENDOR end AS [Importer/Supplier], 
                      CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR = 'Sake' THEN 'Sake'
                      WHEN MAS_POL.dbo.CI_ITEM.UDF_VARIETALS_T = 'PEAR' OR MAS_POL.dbo.CI_ITEM.UDF_VARIETALS_T = 'APPLE' THEN 'Cider' ELSE 'Wine' END AS [Product Type],
                      CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR='Sherry' OR MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR='Port' OR MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR='Madeira' THEN 'Fortified' 
                      WHEN MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR = 'Sparkling' OR MAS_POL.dbo.CI_ITEM.UDF_VARIETALS_T = 'PEAR' OR MAS_POL.dbo.CI_ITEM.UDF_VARIETALS_T = 'APPLE' THEN 'Sparkling'
                      ELSE 'Still' END AS [Product Subtype],
                      CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR = 'White' THEN 'White' 
                      WHEN MAS_POL.dbo.CI_ITEM.UDF_VARIETALS_T = 'LAMBRUSCO' OR MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR = 'Red' THEN 'Red'
                      WHEN UPPER(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION) LIKE '% ROSE %' OR UPPER(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION) LIKE '% ROSE'
                      OR UPPER(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION) LIKE 'ROSE %' OR UPPER(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION) LIKE 'ROSE'
                      OR UPPER(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION) LIKE '% ROSA[TD]O %' OR UPPER(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION) LIKE '% ROSA[TD]O'
                      OR UPPER(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION) LIKE 'ROSA[TD]O %' OR UPPER(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION) LIKE 'ROSA[TD]O'
                      OR UPPER(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION) LIKE '% VIN GRIS %' OR UPPER(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION) LIKE '% VIN GRIS'
                      OR UPPER(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION) LIKE 'VIN GRIS %' OR UPPER(MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION) LIKE 'VIN GRIS' THEN 'Rose'
                      WHEN MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR <> 'Red' AND MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR <> 'White' 
                      AND LEFT(MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR, 3) <> 'Ros' THEN 'White' ELSE MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR END AS [Product Style], 
                      MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES AS [Producer Name], MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES + ' ' +MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION + CASE WHEN MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES like 'CANS%' THEN ' CANS' ELSE '' END AS [Product Name],
                      MAS_POL.dbo.CI_ITEM.UDF_VINTAGE AS Vintage,
                      IsNull(v.UDF_VARIETAL,'') AS [Grapes & Raw Materials], 
                      MAS_POL.dbo.CI_ITEM.UDF_COUNTRY AS Country, 
                      IsNull(r.UDF_REGION,'') AS Region,
                      IsNull(a.UDF_NAME,'') AS Appellation, 
                      CASE WHEN LEN(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_NOTES_VARIETAL)) > 0 AND LEN(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_NOTES_TASTING)) > 0
                      THEN MAS_POL.dbo.CI_ITEM.UDF_NOTES_VARIETAL + '; ' + MAS_POL.dbo.CI_ITEM.UDF_NOTES_TASTING 
                      WHEN LEN(dbo.SuperTrimLeft(MAS_POL.dbo.CI_ITEM.UDF_NOTES_VARIETAL)) > 0 THEN MAS_POL.dbo.CI_ITEM.UDF_NOTES_VARIETAL 
                      ELSE MAS_POL.dbo.CI_iTEM.UDF_NOTES_TASTING END AS Description, 
                      CASE WHEN len(MAS_POL.dbo.CI_ITEM.UDF_ORGANIC) > 0 AND LEN(MAS_POL.dbo.ci_item.udf_biodynamic) > 0 THEN 'Organic, Biodynamic'
                      WHEN len(MAS_POL.dbo.CI_ITEM.UDF_ORGANIC) > 0 THEN 'Organic' 
                      WHEN LEN(MAS_POL.dbo.ci_item.udf_biodynamic) > 0 THEN 'Biodynamic' END AS Features, 
                      MAS_POL.dbo.CI_ITEM.UDF_ALCOHOL_PCT AS [Alcohol by volume],
                      LEFT(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, CHARINDEX(' ', MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, 1)) AS Size,
                      RIGHT(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, LEN(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE) - CHARINDEX(' ',MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, 1) + 1) AS [Size Unit], 
                      CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_CLOSURE = 'TETRA PAK / BOX' THEN 'Bag In Box' ELSE 'Bottle' END AS [Container Type],
                      REPLACE(MAS_POL.dbo.CI_ITEM.STANDARDUNITOFMEASURE, 'C', '') AS [Case size], 
                      CASE WHEN p.ValidDateDescription_234 LIKE '%, %' and p.CustomerPriceLevel <> 'J' then p.ValidDateDescription_234 
							WHEN p.CustomerPriceLevel <> 'J' OR p.ValidDateDescription_234 like '%B%' then REPLACE(p.ValidDateDescription_234,',',', ')
							WHEN p.BreakQuantity1 > 4 then CONVERT(varchar, floor(p.DiscountMarkup1))
							WHEN p.BreakQuantity5 > 0 and p.BreakQuantity4 < 5 then
								CONVERT(varchar, floor(p.DiscountMarkup1)) + ', ' +
							    CONVERT(varchar, floor(p.DiscountMarkup2)) + '/' +
							    CONVERT(varchar, floor(p.BreakQuantity1)+1) + ', ' +
							    CONVERT(varchar, floor(p.DiscountMarkup3)) + '/' +
							    CONVERT(varchar, floor(p.BreakQuantity2)+1) + ', ' +
							    CONVERT(varchar, floor(p.DiscountMarkup4)) + '/' +
							    CONVERT(varchar, floor(p.BreakQuantity3)+1) + ', ' +
							    CONVERT(varchar, floor(p.DiscountMarkup5)) + '/' +
							    CONVERT(varchar, floor(p.BreakQuantity4)+1)
							WHEN p.BreakQuantity4 > 0 and p.BreakQuantity3 < 5 then
								CONVERT(varchar, floor(p.DiscountMarkup1)) + ', ' +
							    CONVERT(varchar, floor(p.DiscountMarkup2)) + '/' +
							    CONVERT(varchar, floor(p.BreakQuantity1)+1) + ', ' +
							    CONVERT(varchar, floor(p.DiscountMarkup3)) + '/' +
							    CONVERT(varchar, floor(p.BreakQuantity2)+1) + ', ' +
							    CONVERT(varchar, floor(p.DiscountMarkup4)) + '/' +
							    CONVERT(varchar, floor(p.BreakQuantity3)+1)
							WHEN p.BreakQuantity3 > 0 AND p.BreakQuantity2 < 5 then
								CONVERT(varchar, floor(p.DiscountMarkup1)) + ', ' +
							    CONVERT(varchar, floor(p.DiscountMarkup2)) + '/' +
							    CONVERT(varchar, floor(p.BreakQuantity1)+1) + ', ' +
							    CONVERT(varchar, floor(p.DiscountMarkup3)) + '/' +
							    CONVERT(varchar, floor(p.BreakQuantity2)+1)
							WHEN p.BreakQuantity2 > 0 AND p.BreakQuantity1 < 5 then
								CONVERT(varchar, floor(p.DiscountMarkup1)) + ', ' +
							    CONVERT(varchar, floor(p.DiscountMarkup2)) + '/' +
							    CONVERT(varchar, floor(p.BreakQuantity1)+1)
							else 'J' + p.ValidDateDescription_234 end AS Pricing, 
                      p.ValidDate_234 as 'ValidDate', 
                      MAS_POL.dbo.CI_ITEM.CATEGORY2 AS IsHidden, 
                      MAS_POL.dbo.CI_ITEM.IMAGEFILE AS 'ImageURL',
                      p.CustomerPriceLevel as 'State',
                      MAS_POL.dbo.CI_ITEM.UDF_TTB AS 'TTB',
					  MAS_POL.dbo.CI_ITEM.UDF_PA_ITEMCODE AS 'SkuPa'
FROM         MAS_POL.dbo.CI_Item INNER JOIN
                      dbo.IM_ItemWarehouse_000 ON MAS_POL.dbo.CI_Item.ItemCode = dbo.IM_ItemWarehouse_000.ItemCode INNER JOIN
                      MAS_POL.dbo.AP_Vendor ON MAS_POL.dbo.CI_Item.PrimaryAPDivisionNo = MAS_POL.dbo.AP_Vendor.APDivisionNo AND 
                      MAS_POL.dbo.CI_Item.PrimaryVendorNo = MAS_POL.dbo.AP_Vendor.VendorNo INNER JOIN
                      dbo.IM_PriceCode_FUTURE_WEEK p ON MAS_POL.dbo.CI_Item.ItemCode = p.ItemCode LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_VARIETALS AS v ON MAS_POL.dbo.CI_Item.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_Item.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON MAS_POL.dbo.CI_Item.UDF_SUBREGION_T = a.UDF_APPELLATION
WHERE     (MAS_POL.dbo.AP_VENDOR.UDF_VEND_INACTIVE <> 'Y') AND (MAS_POL.dbo.CI_ITEM.CATEGORY2 <> 'Y') AND 
          (MAS_POL.dbo.CI_ITEM.CATEGORY1 ='Y') AND (MAS_POL.dbo.CI_ITEM.StandardUnitCost > 0) AND (MAS_POL.dbo.CI_ITEM.ProductLine <> 'SAMP') AND 
          (MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MANAGER='')
          and (MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_ALLOCATED <> 'Y') AND p.PriceCodeRecord=3 and dbo.IM_ItemWarehouse_000.QuantityOnHand+dbo.IM_ItemWarehouse_000.QuantityOnPurchaseOrder>0.04
          --and (MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_OFFSALE <> 'Y')
