/****** Object:  View [dbo].[VirtualFeed_Zachys_ProductQuery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.VirtualFeed_Zachys_ProductQuery
AS
SELECT      CASE WHEN i.UDF_BRAND_NAMES ='Arnot-Roberts' THEN 'Arnot Roberts'
				WHEN i.UDF_BRAND_NAMES ='Red Car' THEN 'Red Car Wine Company'
				WHEN i.UDF_BRAND_NAMES ='Algueira' THEN 'Adega Algueira'
				WHEN i.UDF_BRAND_NAMES ='Ayres' THEN 'Ayres Vineyard'
				WHEN i.UDF_BRAND_NAMES ='Boisson' THEN 'Pierre Boisson'
				WHEN i.UDF_BRAND_NAMES ='Bourcier-Martinot' THEN 'Bourcier Martinot'
				WHEN i.UDF_BRAND_NAMES ='Camus-Bruchon' THEN 'Camus Bruchon'
				WHEN i.UDF_BRAND_NAMES ='Chateau la Canorgue' THEN 'Canorgue'
				WHEN i.UDF_BRAND_NAMES ='Chidaine' THEN 'Francois Chidaine'
				WHEN i.UDF_BRAND_NAMES ='Confuron-Cotetidot' THEN 'Confuron Cotetidot'
				WHEN i.UDF_BRAND_NAMES ='COS' THEN 'Cos'
				WHEN i.UDF_BRAND_NAMES ='De Montille' THEN 'Montille'
				WHEN i.UDF_BRAND_NAMES ='Dutraive, Famille' THEN 'Famille Dutraive'
				WHEN i.UDF_BRAND_NAMES ='Giuseppe Mascarello' THEN 'G Mascarello'
				WHEN i.UDF_BRAND_NAMES ='Isle Saint-Pierre' THEN 'Domaine Isle Saint-Pierre'
				WHEN i.UDF_BRAND_NAMES ='Julien Sunier' THEN 'Domaine Julien Sunier'
				WHEN i.UDF_BRAND_NAMES ='Kelley Fox' THEN 'Kelley Fox Wines'
				WHEN i.UDF_BRAND_NAMES ='Laherte Freres' THEN 'Freres'
				WHEN i.UDF_BRAND_NAMES ='Mayard' THEN 'Vignobles Mayard'
				WHEN i.UDF_BRAND_NAMES ='Pabiot' THEN 'Jonathan Didier Pabiot'
				WHEN i.UDF_BRAND_NAMES ='Pallus' THEN 'Domaine de Pallus'
				WHEN i.UDF_BRAND_NAMES ='Piaugier' THEN 'Domaine de Piaugier'
				WHEN i.UDF_BRAND_NAMES ='Pierre Moncuit' THEN 'Moncuit'
				ELSE i.UDF_BRAND_NAMES END AS [Producer]
			, Replace(Replace(i.UDF_BRAND_NAMES,' (Grand''Cour)',''),'Dutraive, Famille', 'Famille Dutraive')
				+ ' ' +
				Replace(Replace(Replace(Replace(Replace(i.UDF_DESCRIPTION, ' 1er Cru',''),' GC',''),' VdF',''),'Mtn','Mountain'),'VV','Vieilles Vignes')
				+ ' ' + i.UDF_VINTAGE + ' (' + Replace(i.UDF_BOTTLE_SIZE, ' ','') + ') ' AS [Product Name]
			, i.ITEMCODE AS [SKU]
			, CASE WHEN UDF_DESCRIPTION like '%Vermouth%' THEN 'VERMOUTH/APERITIF'
				WHEN i.UDF_WINE_COLOR IN ('Port') THEN Upper(i.UDF_WINE_COLOR)
				WHEN i.UDF_WINE_COLOR IN ('Sherry, Madeira') THEN 'SHERRY MADEIRA'
				WHEN i.UDF_WINE_COLOR IN ('Red', 'White') AND reg.UDF_REGION IN ('Bordeaux', 'Burgundy') THEN Upper(i.UDF_WINE_COLOR + ' ' + reg.UDF_REGION)
				WHEN reg.UDF_REGION IN ('Rhone','Alsace', 'Beaujolais', 'California', 'Champagne') THEN Upper(reg.UDF_REGION)
				WHEN reg.UDF_REGION IN ('Oregon', 'Loire') THEN reg.UDF_REGION
				WHEN reg.UDF_REGION IN ('Languedoc', 'Provence', 'Southwest') THEN 'Southern France'
				WHEN i.UDF_COUNTRY IN ('Australia', 'Italy', 'Spain') THEN Upper(i.UDF_COUNTRY)
				WHEN i.UDF_COUNTRY IN ('Germany','Austria', 'New Zealand') THEN i.UDF_COUNTRY
				WHEN i.UDF_COUNTRY = 'USA' THEN 'USA WINES'
				WHEN i.UDF_COUNTRY IN ('Chile','Argentina') THEN 'SOUTH AMERICA'
				ELSE 'MISC WINE' END AS [Department]
			, Replace(Replace(i.UDF_UPC_CODE,'n/a',''), char(9),'') AS [UPC Code]
			, Replace(i.UDF_BOTTLE_SIZE, ' ','') as [Size]
			, Replace(i.STANDARDUNITOFMEASURE, 'C', '') AS [Pack Size]
			, CASE WHEN CAST(ROUND(av.QuantityAvailable * IsNull(dbo.TryConvertUom(Replace(i.STANDARDUNITOFMEASURE, 'C', '')), 12),0) as INT) > 0 THEN CAST(ROUND(av.QuantityAvailable * IsNull(dbo.TryConvertUom(Replace(i.STANDARDUNITOFMEASURE, 'C', '')), 12),0) as INT) ELSE 1 END as [Qty in Bottles]
			, FORMAT(p.DiscountMarkup1 / IsNull(dbo.TryConvertUom(Replace(i.STANDARDUNITOFMEASURE, 'N', '')), 12), 'N', 'en-US') as [Frontline Price]
			, FORMAT(CASE WHEN Replace(p.ValidDateDescription_234, ' ','') NOT LIKE '%12B%' THEN p.DiscountMarkup1 / IsNull(dbo.TryConvertUom(Replace(i.STANDARDUNITOFMEASURE, 'C', '')), 12)
				ELSE SUBSTRING(Replace(p.ValidDateDescription_234, ' ',''), CHARINDEX('12B', Replace(p.ValidDateDescription_234, ' ','')) - 3,2) END, 'N', 'en-US') AS [One Case Price]
			, FORMAT(CASE WHEN p.BreakQuantity1 != 1 AND Replace(p.ValidDateDescription_234, ' ','') NOT LIKE '%12B%' THEN p.DiscountMarkup1 / IsNull(dbo.TryConvertUom(Replace(i.STANDARDUNITOFMEASURE, 'C', '')), 12)
				WHEN Replace(p.ValidDateDescription_234, ' ','') LIKE '%24B%' THEN SUBSTRING(Replace(p.ValidDateDescription_234, ' ',''), CHARINDEX('24B', Replace(p.ValidDateDescription_234, ' ','')) - 3,2)
				WHEN Replace(p.ValidDateDescription_234, ' ','') LIKE '%12B%' THEN SUBSTRING(Replace(p.ValidDateDescription_234, ' ',''), CHARINDEX('12B', Replace(p.ValidDateDescription_234, ' ','')) - 3,2)
				ELSE p.DiscountMarkup2 / IsNull(dbo.TryConvertUom(Replace(i.STANDARDUNITOFMEASURE, 'C', '')), 12) END, 'N', 'en-US') as [Two Case Price]
			, FORMAT(p.DiscountMarkup1 * 1.5 / IsNull(dbo.TryConvertUom(Replace(i.STANDARDUNITOFMEASURE, 'C', '')), 12), 'N', 'en-US') as [MSRP]
			, CASE WHEN UDF_DESCRIPTION like '%Vermouth%' THEN 'Liquor'
			  WHEN i.UDF_WINE_COLOR IN ('Port', 'Sweet / Fortified', 'Sherry', 'Madeira') THEN 'Sweet'
			  WHEN (i.UDF_WINE_COLOR = 'Sparkling' OR i.UDF_VARIETALS_T IN ('PEAR', 'APPLE')) AND (UPPER(i.UDF_DESCRIPTION) LIKE '%ROSE%' OR UPPER(i.UDF_DESCRIPTION) LIKE '%ROSA[TD]O%' OR UPPER(i.UDF_DESCRIPTION) LIKE '%VIN GRIS%') THEN 'Sparkling Rose'
			  WHEN i.UDF_VARIETALS_T = 'LAMBRUSCO' THEN 'Sparkling Red'
              WHEN i.UDF_WINE_COLOR = 'Sparkling' OR i.UDF_VARIETALS_T IN ('PEAR', 'APPLE')  THEN 'Sparkling'
			  WHEN i.UDF_WINE_COLOR IN ('Rose', 'White', 'Red', 'Sake') THEN i.UDF_WINE_COLOR
			  END AS [Class]
			, CASE WHEN UDF_DESCRIPTION like '%Vermouth%' THEN 'Vermouth'
				WHEN app.UDF_NAME LIKE 'Chianti%' AND var.UDF_VARIETAL LIKE '%Blend' THEN 'Chianti Blend'
				WHEN app.UDF_NAME = 'Champagne' AND var.UDF_VARIETAL = 'Blend' THEN 'Champagne Blend'
				WHEN i.UDF_WINE_COLOR IN ('Port') AND var.UDF_VARIETAL IN ('Red Blend','Blend') THEN 'Port Blend'
				WHEN i.UDF_COUNTRY = 'France' AND var.UDF_VARIETAL = 'Grenache (Garnacha)' THEN 'Grenache'
				WHEN i.UDF_COUNTRY = 'Spain' AND var.UDF_VARIETAL = 'Grenache (Garnacha)' THEN 'Garnacha'
				WHEN var.UDF_VARIETAL = 'Melon de Bourgogne' THEN 'Melon'
				WHEN var.UDF_VARIETAL LIKE 'Picpoul%' THEN 'Picpoul'
				WHEN i.UDF_COUNTRY = 'Australia' AND var.UDF_VARIETAL = 'Syrah (Shiraz)' THEN 'Shiraz'
				WHEN var.UDF_VARIETAL = 'Syrah (Shiraz)' THEN 'Syrah'
				WHEN var.UDF_VARIETAL LIKE '%Vermouth%' THEN 'Vermouth'
				ELSE IsNull(var.UDF_VARIETAL,'') END AS [Varietal]
			, i.UDF_COUNTRY AS [Country]
			, CASE WHEN Replace(Replace(IsNull(reg.UDF_REGION,''),char(13),''),char(10),'') = 'Gredos' THEN 'Vinos de Madrid'
				WHEN Replace(Replace(IsNull(reg.UDF_REGION,''),char(13),''),char(10),'') = 'Languedoc' THEN 'Languedoc-Roussillon'
				ELSE Replace(Replace(IsNull(reg.UDF_REGION,''),char(13),''),char(10),'') END AS [Region]
			, CASE WHEN app.UDF_NAME = 'Vinos de Madrid' THEN 'Sierra de Gredos'
				WHEN app.UDF_NAME = 'IGT Toscana' THEN 'Tuscany'
				WHEN app.UDF_NAME = 'Chateauneuf-du-Pape' THEN 'Chateauneuf du Pape'
				WHEN app.UDF_NAME = 'Cotes-du-Rhone' THEN 'Cotes du Rhone'
				WHEN app.UDF_NAME = 'Saint Joseph' THEN 'St. Joseph'
				WHEN app.UDF_NAME IN ('Terre Siciliane IGT','Sicilia') THEN 'Sicily'
				WHEN app.UDF_NAME = 'Muscadet-Sevre-et-Maine' THEN 'Muscadet Sevre-et-Maine'
				WHEN app.UDF_NAME = 'Corse' THEN 'Corsica'
				WHEN app.UDF_NAME = 'Contra Costa County' THEN 'Contra Costa'
				WHEN app.UDF_NAME = 'Brunello di Montalcino' THEN 'Montalcino'
				WHEN app.UDF_NAME = 'Pouilly-Fume' THEN 'Pouilly Fume'
				WHEN app.UDF_NAME = 'Amarone della Valpolicella' THEN 'Valpolicella'
				WHEN app.UDF_NAME = 'Crozes-Hermitage' THEN 'Crozes Hermitage'
				WHEN app.UDF_NAME = 'Soave Classico' THEN 'Soave'
				WHEN app.UDF_NAME = 'Bourgogne' THEN 'Burgundy'
				WHEN app.UDF_NAME = 'Beaujolais' THEN 'Beaujolais Villages'
				WHEN app.UDF_NAME = 'Cote de Brouilly' THEN 'Brouilly'
				WHEN app.UDF_NAME IN ('Maranges','Meursault','Santenay','Santenay 1er Cru','Savigny-les-Beaune','Savigny-Les-Beaune 1er Cru') THEN 'Cote de Beaune'
				WHEN app.UDF_NAME IN ('Nuits Saint Georges','Nuits Saint Georges 1er Cru','Vosne-Romanee','Vosne-Romanee 1er Cru') THEN 'Cote de Nuits'
				WHEN IsNull(app.UDF_NAME,'') != '' THEN IsNull(app.UDF_NAME,'')
				ELSE Replace(Replace(IsNull(reg.UDF_REGION,''),char(13),''),char(10),'') END AS [Appellation]
            , i.UDF_VINTAGE AS [Vintage]
			, Replace(Replace(IsNull(i.UDF_NOTES_TASTING,''),char(13),''),char(10),'') as [Description]
			, CASE WHEN len(i.UDF_PARKER_REVIEW) > 0 or len(i.UDF_PARKER) > 0 THEN 'Wine Advocate' ELSE '' END as [Critic Name 1]
			, i.UDF_PARKER as [Critic Score 1]
			, Replace(Replace(IsNull(i.UDF_PARKER_REVIEW ,''),char(13),''),char(10),'') as [Critic Notes 1]
			, CASE WHEN len(i.UDF_GALLONI_REVIEW) > 0 or len(i.UDF_GALLONI_SCORE) > 0 THEN 'Vinous Media' ELSE '' END as [Critic Name 2]
			, i.UDF_GALLONI_SCORE as [Critic Score 2]
			, Replace(Replace(IsNull(i.UDF_GALLONI_REVIEW,''),char(13),''),char(10),'')as [Critic Notes 2]
			, CASE WHEN len(i.ImageFile) > 0 THEN 'https://polaner-labels.s3.amazonaws.com/' + i.ImageFile ELSE '' END as [Bottle Image URL]
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
