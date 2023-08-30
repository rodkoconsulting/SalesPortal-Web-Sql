/****** Object:  View [dbo].[SevenFifty_API]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[SevenFifty_API]
AS
SELECT     i.ITEMCODE AS SKU
		   , CASE WHEN i.UDF_RESTRICT_MAX > 0
					OR i.UDF_RESTRICT_STATE = 'NJ ONLY'
					OR i.UDF_RESTRICT_ALLOCATED = 'Y'
					OR i.UDF_RESTRICT_MANAGER <> ''
					OR i.UDF_RESTRICT_NORETAIL = 'Y'
					THEN 'Limited Availability'
				  ELSE 'Available' END AS Status
		   , CASE WHEN i.UDF_MASTER_VENDOR ='Private Labels'
					THEN 'Polaner Domestic'
				  ELSE i.UDF_MASTER_VENDOR END AS Importer
		   , CASE WHEN i.UDF_WINE_COLOR = 'Sake' THEN 'Sake'
                  WHEN i.UDF_VARIETALS_T IN ('PEAR','APPLE')
					THEN 'Cider'
				  ELSE 'Wine' END AS Type
		   , CASE WHEN i.UDF_WINE_COLOR IN ('Sherry','Port','Madeira')
					THEN 'Fortified' 
                  WHEN i.UDF_WINE_COLOR = 'Sparkling'
				    OR i.UDF_VARIETALS_T IN ('PEAR','APPLE')
					THEN 'Sparkling' 
                  ELSE 'Still' END AS SubType
		   , CASE WHEN i.UDF_WINE_COLOR = 'White'
					THEN 'White' 
			       WHEN i.UDF_VARIETALS_T = 'LAMBRUSCO'
				    OR i.UDF_WINE_COLOR = 'Red' THEN 'Red'
                   WHEN UPPER(i.UDF_DESCRIPTION) LIKE '% ROSE %'
				     OR UPPER(i.UDF_DESCRIPTION) LIKE '% ROSE'
                     OR UPPER(i.UDF_DESCRIPTION) LIKE 'ROSE %'
					 OR UPPER(i.UDF_DESCRIPTION) LIKE 'ROSE'
                     OR UPPER(i.UDF_DESCRIPTION) LIKE '% ROSA[TD]O %'
					 OR UPPER(i.UDF_DESCRIPTION) LIKE '% ROSA[TD]O'
                     OR UPPER(i.UDF_DESCRIPTION) LIKE 'ROSA[TD]O %'
					 OR UPPER(i.UDF_DESCRIPTION) LIKE 'ROSA[TD]O'
                     OR UPPER(i.UDF_DESCRIPTION) LIKE '% VIN GRIS %'
					 OR UPPER(i.UDF_DESCRIPTION) LIKE '% VIN GRIS'
                     OR UPPER(i.UDF_DESCRIPTION) LIKE 'VIN GRIS %'
					 OR UPPER(i.UDF_DESCRIPTION) LIKE 'VIN GRIS'
					THEN 'Rose'
                   WHEN i.UDF_WINE_COLOR NOT IN ('Red', 'White')
				    AND LEFT(i.UDF_WINE_COLOR, 3) <> 'Ros'
					THEN 'White' 
				   ELSE i.UDF_WINE_COLOR END AS Style
		    , i.UDF_BRAND_NAMES AS Producer
			, i.UDF_BRAND_NAMES + ' ' + i.UDF_DESCRIPTION + CASE WHEN i.UDF_DAMAGED_NOTES like 'CANS%' THEN ' CANS' ELSE '' END AS Name
            , i.UDF_VINTAGE AS Vintage
			, IsNull(va.UDF_VARIETAL,'') AS Grapes
			, i.UDF_COUNTRY AS Country 
            , IsNull(r.UDF_REGION,'') AS Region
			, IsNull(a.UDF_NAME,'') AS Appellation
			, CASE WHEN dbo.SuperTrimLeft(i.UDF_NOTES_VARIETAL) <> '' AND dbo.SuperTrimLeft(i.UDF_NOTES_TASTING) <> ''
					THEN i.UDF_NOTES_VARIETAL + '; ' + i.UDF_NOTES_TASTING 
                   WHEN dbo.SuperTrimLeft(i.UDF_NOTES_VARIETAL) <> ''
					THEN i.UDF_NOTES_VARIETAL 
                   ELSE i.UDF_NOTES_TASTING END AS Description
			, CASE WHEN i.UDF_ORGANIC <> '' AND i.UDF_BIODYNAMIC <> '' 
					THEN 'Organic, Biodynamic'
                   WHEN i.UDF_ORGANIC <> '' 
					THEN 'Organic' 
                   WHEN i.UDF_BIODYNAMIC <> ''
					THEN 'Biodynamic'
				   ELSE '' END AS Features
			, CAST(i.UDF_ALCOHOL_PCT AS FLOAT) AS Alc
			, CAST(LEFT(i.UDF_BOTTLE_SIZE, CHARINDEX(' ', i.UDF_BOTTLE_SIZE, 1)-1) AS FLOAT) AS Size
			, RIGHT(i.UDF_BOTTLE_SIZE, LEN(i.UDF_BOTTLE_SIZE) - CHARINDEX(' ', i.UDF_BOTTLE_SIZE, 1)) AS Unit
			, CASE WHEN i.UDF_CLOSURE = 'TETRA PAK / BOX' 
					THEN 'Bag In Box'
				   ELSE 'Bottle' END AS ConType
			, CAST(REPLACE(i.STANDARDUNITOFMEASURE, 'C', '') AS FLOAT) AS CaseSize
            , i.IMAGEFILE AS 'Image'
			, i.UDF_TTB AS 'TTB'
			, i.UDF_PA_ITEMCODE AS 'SkuPa'
			, CASE WHEN ia.QuantityAvailable > 0.01 THEN CAST(ROUND(ia.QuantityAvailable, 2) AS FLOAT) ELSE 0 END AS 'QtyA'
FROM         MAS_POL.dbo.CI_Item i INNER JOIN
                      dbo.IM_ItemWarehouse_000 q ON i.ItemCode = q.ItemCode INNER JOIN
                      MAS_POL.dbo.AP_Vendor v ON i.PrimaryAPDivisionNo = v.APDivisionNo AND i.PrimaryVendorNo = v.VendorNo INNER JOIN
					  dbo.IM_InventoryAvailable ia ON i.ItemCode = ia.ITEMCODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_VARIETALS AS va ON i.UDF_VARIETALS_T = va.UDF_VARIETAL_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON i.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON i.UDF_SUBREGION_T = a.UDF_APPELLATION
WHERE     i.ProductLine <> 'OOIL' AND
          i.UDF_WINE_COLOR <> 'Olive Oil' AND
		  i.ProductLine <> 'SAMP' AND
		  v.UDF_VEND_INACTIVE <> 'Y' AND
		  i.CATEGORY2 <> 'Y' AND 
          i.CATEGORY1 ='Y' AND
		  i.StandardUnitCost > 0 AND
          i.UDF_RESTRICT_MANAGER='' AND
		  i.UDF_RESTRICT_ALLOCATED <> 'Y' AND
		   q.QuantityOnHand+q.QuantityOnPurchaseOrder>0.04
