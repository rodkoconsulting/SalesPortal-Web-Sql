/****** Object:  View [dbo].[VirtualFeed_Zachys_Query]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.VirtualFeed_Zachys_Query
AS
SELECT     i.ITEMCODE AS [Item #]
			, i.UDF_UPC_CODE AS UPC
			, i.UDF_DESCRIPTION + CASE WHEN i.UDF_DAMAGED_NOTES like 'CANS%' THEN ' CANS' ELSE '' END AS [Product Name]
			, CASE WHEN LEN(dbo.SuperTrimLeft(i.UDF_NOTES_VARIETAL)) > 0 AND LEN(dbo.SuperTrimLeft(i.UDF_NOTES_TASTING)) > 0 THEN i.UDF_NOTES_VARIETAL + '; ' + i.UDF_NOTES_TASTING 
                   WHEN LEN(dbo.SuperTrimLeft(i.UDF_NOTES_VARIETAL)) > 0 THEN i.UDF_NOTES_VARIETAL 
                   ELSE i.UDF_NOTES_TASTING END AS [Product Description]
			, i.UDF_BRAND_NAMES AS [Producer]
			, CASE WHEN i.UDF_WINE_COLOR = 'Sake' THEN 'Sake'
              WHEN i.UDF_WINE_COLOR IN ('Port', 'Sweet / Fortified', 'Sherry', 'Madeira') THEN 'Sweet'
			  WHEN (i.UDF_WINE_COLOR = 'Sparkling' OR i.UDF_VARIETALS_T IN ('PEAR', 'APPLE')) AND (UPPER(i.UDF_DESCRIPTION) LIKE '%ROSE%' OR UPPER(i.UDF_DESCRIPTION) LIKE '%ROSA[TD]O%' OR UPPER(i.UDF_DESCRIPTION) LIKE '%VIN GRIS%') THEN 'Sparkling Rose'
			  WHEN i.UDF_VARIETALS_T = 'LAMBRUSCO' THEN 'Sparkling Red'
              WHEN i.UDF_WINE_COLOR = 'Sparkling' OR i.UDF_VARIETALS_T IN ('PEAR', 'APPLE')  THEN 'Sparkling'
			  WHEN i.UDF_WINE_COLOR = 'Rose' THEN 'Rose'
			  WHEN i.UDF_WINE_COLOR = 'White' THEN 'White'
			  WHEN i.UDF_WINE_COLOR = 'Red' THEN 'Red' END AS [Product Class]
                      ,i.UDF_VINTAGE AS Vintage,
                      IsNull(var.UDF_VARIETAL,'') AS [Grapes & Raw Materials], 
                      i.UDF_COUNTRY AS Country, 
                      IsNull(reg.UDF_REGION,'') AS Region,
                      IsNull(app.UDF_NAME,'') AS Appellation, 
                      LEFT(i.UDF_BOTTLE_SIZE, CHARINDEX(' ', i.UDF_BOTTLE_SIZE, 1)) AS Size,
                      RIGHT(i.UDF_BOTTLE_SIZE, LEN(i.UDF_BOTTLE_SIZE) - CHARINDEX(' ',i.UDF_BOTTLE_SIZE, 1) + 1) AS [Size Unit], 
                      REPLACE(i.STANDARDUNITOFMEASURE, 'C', '') AS [Case size], 
                      CASE WHEN p.ValidDateDescription_234 LIKE '%, %' then p.ValidDateDescription_234 
							WHEN p.ValidDateDescription_234 like '%B%' then REPLACE(p.ValidDateDescription_234,',',', ')
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
							else p.ValidDateDescription_234 end AS Pricing
FROM         MAS_POL.dbo.CI_Item i INNER JOIN
                      dbo.IM_ItemWarehouse_000 w ON i.ItemCode = w.ItemCode INNER JOIN
                      MAS_POL.dbo.AP_Vendor ven ON i.PrimaryAPDivisionNo = ven.APDivisionNo AND i.PrimaryVendorNo = ven.VendorNo INNER JOIN
                      dbo.IM_PriceCode_TODAY p ON i.ItemCode = p.ItemCode LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_VARIETALS var ON i.UDF_VARIETALS_T = var.UDF_VARIETAL_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION reg ON i.UDF_REGION = reg.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION app ON i.UDF_SUBREGION_T = app.UDF_APPELLATION
WHERE		ven.UDF_VEND_INACTIVE <> 'Y' AND
			i.CATEGORY2 <> 'Y' AND 
			i.CATEGORY1 ='Y' AND
			i.StandardUnitCost > 0 AND
			i.ProductLine <> 'SAMP' AND
			i.UDF_WINE_COLOR <> 'Olive Oil' AND
			i.UDF_RESTRICT_MANAGER='' AND
			i.UDF_RESTRICT_ALLOCATED <> 'Y' AND
			p.PriceCodeRecord=3 AND
			p.CustomerPriceLevel = 'Y' AND
			w.QuantityOnHand+w.QuantityOnPurchaseOrder>0.04
