/****** Object:  View [dbo].[VirtualFeed_Zachys_ProductQuery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.VirtualFeed_Zachys_ProductQuery
AS
SELECT      i.UDF_BRAND_NAMES AS [Producer]
			, i.UDF_BRAND_NAMES + ' ' + i.UDF_DESCRIPTION + ' ' + i.UDF_VINTAGE + ' (' + Replace(i.UDF_BOTTLE_SIZE, ' ','') + ') ' + i.UDF_DAMAGED_NOTES AS [Product Name]
			, i.ITEMCODE AS [SKU]
			, CASE WHEN UDF_DESCRIPTION like 'Vermouth' THEN 'Vermouth/Apertif'
				WHEN i.UDF_WINE_COLOR IN ('Port') THEN Upper(i.UDF_WINE_COLOR)
				WHEN i.UDF_WINE_COLOR IN ('Sherry') THEN 'Shery'
				WHEN i.UDF_WINE_COLOR IN ('Red', 'White') AND reg.UDF_REGION IN ('Bordeaux', 'Burgundy') THEN i.UDF_WINE_COLOR + ' ' + reg.UDF_REGION
				WHEN reg.UDF_REGION IN ('Alsace', 'Beaujolais', 'Loire') THEN Upper(reg.UDF_REGION)
				WHEN reg.UDF_REGION IN ('Alsace', 'Rhone', 'Beaujolais', 'California', 'Champagne', 'Loire', 'Oregon') THEN reg.UDF_REGION
				WHEN reg.UDF_REGION IN ('Languedoc', 'Provence', 'Southwest') THEN 'Southern France'
				WHEN i.UDF_COUNTRY IN ('Germany') THEN Upper(i.UDF_COUNTRY)
				WHEN i.UDF_COUNTRY IN ('Australia', 'Austria', 'Italy', 'New Zealand', 'Spain') THEN i.UDF_COUNTRY
				WHEN i.UDF_COUNTRY = 'USA' THEN 'USA WINES'
				WHEN i.UDF_COUNTRY IN ('Chile','Argentina') THEN 'South America'
				ELSE 'MISC Wine' END AS [Department]
			, Replace(Replace(i.UDF_UPC_CODE,'n/a',''), char(9),'') AS [UPC Code]
			, Replace(i.UDF_BOTTLE_SIZE, ' ','') as [Size]
			, Replace(i.STANDARDUNITOFMEASURE, 'C', '') AS [Pack Size]
			, CAST(ROUND(av.QuantityAvailable * IsNull(dbo.TryConvertUom(Replace(i.STANDARDUNITOFMEASURE, 'C', '')), 12),0) as INT) as [Qty in Bottles]
			, FORMAT(p.DiscountMarkup1 / IsNull(dbo.TryConvertUom(Replace(i.STANDARDUNITOFMEASURE, 'C', '')), 12), 'c', 'en-US') as [Frontline Price]
			, FORMAT(CASE WHEN Replace(p.ValidDateDescription_234, ' ','') NOT LIKE '%12B%' THEN p.DiscountMarkup1 / IsNull(dbo.TryConvertUom(Replace(i.STANDARDUNITOFMEASURE, 'C', '')), 12)
				ELSE SUBSTRING(Replace(p.ValidDateDescription_234, ' ',''), CHARINDEX('12B', Replace(p.ValidDateDescription_234, ' ','')) - 3,2) END, 'c', 'en-US') AS [One Case Price]
			, FORMAT(CASE WHEN p.BreakQuantity1 != 1 AND Replace(p.ValidDateDescription_234, ' ','') NOT LIKE '%12B%' THEN p.DiscountMarkup1 / IsNull(dbo.TryConvertUom(Replace(i.STANDARDUNITOFMEASURE, 'C', '')), 12)
				WHEN Replace(p.ValidDateDescription_234, ' ','') LIKE '%24B%' THEN SUBSTRING(Replace(p.ValidDateDescription_234, ' ',''), CHARINDEX('24B', Replace(p.ValidDateDescription_234, ' ','')) - 3,2)
				WHEN Replace(p.ValidDateDescription_234, ' ','') LIKE '%12B%' THEN SUBSTRING(Replace(p.ValidDateDescription_234, ' ',''), CHARINDEX('12B', Replace(p.ValidDateDescription_234, ' ','')) - 3,2)
				ELSE p.DiscountMarkup2 / IsNull(dbo.TryConvertUom(Replace(i.STANDARDUNITOFMEASURE, 'C', '')), 12) END, 'c', 'en-US') as [Two Case Price]
			, FORMAT(p.DiscountMarkup1 * 1.5 / IsNull(dbo.TryConvertUom(Replace(i.STANDARDUNITOFMEASURE, 'C', '')), 12), 'c', 'en-US') as [MSRP]
			, CASE WHEN i.UDF_WINE_COLOR IN ('Port', 'Sweet / Fortified', 'Sherry', 'Madeira') THEN 'Sweet'
			  WHEN (i.UDF_WINE_COLOR = 'Sparkling' OR i.UDF_VARIETALS_T IN ('PEAR', 'APPLE')) AND (UPPER(i.UDF_DESCRIPTION) LIKE '%ROSE%' OR UPPER(i.UDF_DESCRIPTION) LIKE '%ROSA[TD]O%' OR UPPER(i.UDF_DESCRIPTION) LIKE '%VIN GRIS%') THEN 'Sparkling Rose'
			  WHEN i.UDF_VARIETALS_T = 'LAMBRUSCO' THEN 'Sparkling Red'
              WHEN i.UDF_WINE_COLOR = 'Sparkling' OR i.UDF_VARIETALS_T IN ('PEAR', 'APPLE')  THEN 'Sparkling'
			  WHEN i.UDF_WINE_COLOR IN ('Rose', 'White', 'Red', 'Sake') THEN i.UDF_WINE_COLOR
			  END AS [Class]
			, IsNull(var.UDF_VARIETAL,'') AS [Varietal]
			, i.UDF_COUNTRY AS [Country]
			, Replace(Replace(IsNull(reg.UDF_REGION,''),char(13),''),char(10),'') AS [Region]
			, CASE WHEN IsNull(app.UDF_NAME,'') != '' THEN IsNull(app.UDF_NAME,'') ELSE Replace(Replace(IsNull(reg.UDF_REGION,''),char(13),''),char(10),'') END AS [Appellation]
            , i.UDF_VINTAGE AS [Vintage]
FROM         MAS_POL.dbo.CI_Item i INNER JOIN
					  dbo.VirtualFeed_Zachys_Items z ON i.ItemCode = z.ItemCode INNER JOIN
                      dbo.IM_ItemWarehouse_000 w ON i.ItemCode = w.ItemCode INNER JOIN
                      MAS_POL.dbo.AP_Vendor ven ON i.PrimaryAPDivisionNo = ven.APDivisionNo AND i.PrimaryVendorNo = ven.VendorNo INNER JOIN
					  dbo.IM_InventoryAvailable av ON i.ItemCode = av.ItemCode INNER JOIN
                      dbo.IM_PriceCode_TODAY p ON i.ItemCode = p.ItemCode LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_VARIETALS var ON i.UDF_VARIETALS_T = var.UDF_VARIETAL_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION reg ON i.UDF_REGION = reg.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION app ON i.UDF_SUBREGION_T = app.UDF_APPELLATION
WHERE		ven.UDF_VEND_INACTIVE <> 'Y' AND
			i.CATEGORY1 ='Y' AND
			i.StandardUnitCost > 0 AND
			p.PriceCodeRecord=3 AND
			p.CustomerPriceLevel = 'Y'
