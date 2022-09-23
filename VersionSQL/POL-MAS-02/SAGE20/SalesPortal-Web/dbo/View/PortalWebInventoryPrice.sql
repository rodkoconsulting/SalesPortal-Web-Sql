/****** Object:  View [dbo].[PortalWebInventoryPrice]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebInventoryPrice]
AS
WITH Price AS
(
SELECT  ROW_NUMBER() OVER (PARTITION BY p.ITEMCODE, CustomerPriceLevel ORDER BY ValidDate_234 DESC) AS 'RN'
		, ITEMCODE
		, CustomerPriceLevel
		, ValidDate_234
		, ValidDateDescription_234
		, DiscountMarkup1
		, DiscountMarkup2
		, DiscountMarkup3
		, DiscountMarkup4
		, DiscountMarkup5
		, BreakQuantity1
		, BreakQuantity2
		, BreakQuantity3
		, BreakQuantity4
		, BreakQuantity5
			FROM       MAS_POL.dbo.IM_PriceCode p
WHERE     p.ValidDate_234<=GETDATE()
),
PriceCurrent AS
(
SELECT ItemCode
		, CustomerPriceLevel
		, ValidDate_234
		, ValidDateDescription_234
		, DiscountMarkup1
		, DiscountMarkup2
		, DiscountMarkup3
		, DiscountMarkup4
		, DiscountMarkup5
		, BreakQuantity1
		, BreakQuantity2
		, BreakQuantity3
		, BreakQuantity4
		, BreakQuantity5
FROM Price
WHERE RN = 1
),
PricePrevious AS
(
SELECT	ItemCode
		, CustomerPriceLevel
		, ValidDate_234
		, ValidDateDescription_234
		, DiscountMarkup1
FROM Price
WHERE RN = 2
),
PriceFutureFilter AS
(
SELECT   ROW_NUMBER() OVER (PARTITION BY p.ITEMCODE, CustomerPriceLevel ORDER BY ValidDate_234) AS 'RN'
		, ITEMCODE
		, CustomerPriceLevel
		, ValidDate_234
		, ValidDateDescription_234
		, DiscountMarkup1
		, DiscountMarkup2
		, DiscountMarkup3
		, DiscountMarkup4
		, DiscountMarkup5
		, BreakQuantity1
		, BreakQuantity2
		, BreakQuantity3
		, BreakQuantity4
		, BreakQuantity5
			FROM       MAS_POL.dbo.IM_PriceCode p
WHERE     p.ValidDate_234>GETDATE()
),
PriceFuture AS
(
	SELECT	ITEMCODE
			, CustomerPriceLevel
			, ValidDate_234
			, ValidDateDescription_234
			, DiscountMarkup1
			, DiscountMarkup2
			, DiscountMarkup3
			, DiscountMarkup4
			, DiscountMarkup5
			, BreakQuantity1
			, BreakQuantity2
			, BreakQuantity3
			, BreakQuantity4
			, BreakQuantity5
	FROM PriceFutureFilter p
	WHERE RN = 1
),
PriceFutureReduced AS
(
	SELECT	pf.ItemCode
			, pf.CustomerPriceLevel
			, pf.ValidDate_234
			, pf.ValidDateDescription_234
			, CASE	WHEN pf.CustomerPriceLevel != 'P' AND pf.DiscountMarkup1 < pc.DiscountMarkup1 THEN 'Y'
					WHEN pf.CustomerPriceLevel = 'P' AND 
					dbo.TryConvertPaPrice(CASE WHEN CHARINDEX(',', pf.ValidDateDescription_234)=0 THEN pf.ValidDateDescription_234 ELSE SUBSTRING(pf.ValidDateDescription_234,0,CHARINDEX(',',pf.ValidDateDescription_234)) END)
					< dbo.TryConvertPaPrice(CASE WHEN CHARINDEX(',', pc.ValidDateDescription_234)=0 THEN pc.ValidDateDescription_234 ELSE SUBSTRING(pc.ValidDateDescription_234,0,CHARINDEX(',',pc.ValidDateDescription_234)) END)
				THEN 'Y'
				ELSE ''
			 END  AS Reduced
	FROM	MAS_POL.dbo.CI_Item i INNER JOIN
			PriceFuture pf ON i.ItemCode = pf.ItemCode INNER JOIN
			MAS_POL.dbo.IM_ItemWarehouse w ON i.ItemCode = w.ItemCode LEFT OUTER JOIN
			PriceCurrent pc ON pf.ItemCode = pc.ItemCode AND pf.CustomerPriceLevel = pc.CustomerPriceLevel
			WHERE i.Category1 = 'Y' AND i.ProductLine != 'SAMP' AND i.ItemType = '1' AND w.WarehouseCode = '000' AND (w.QuantityOnHand + w.QuantityOnPurchaseOrder + w.QuantityOnSalesOrder + w.QuantityOnBackOrder > 0.04) 
),
PriceUnion AS
(
SELECT	pc.ItemCode
		, pc.CustomerPriceLevel
		, pc.ValidDate_234
		, pc.ValidDateDescription_234
		, CASE	WHEN pc.CustomerPriceLevel != 'P' AND pc.DiscountMarkup1 < pp.DiscountMarkup1 THEN 'Y'
				WHEN pc.CustomerPriceLevel = 'P' AND 
					dbo.TryConvertPaPrice(CASE WHEN CHARINDEX(',', pc.ValidDateDescription_234)=0 THEN pc.ValidDateDescription_234 ELSE SUBSTRING(pc.ValidDateDescription_234,0,CHARINDEX(',',pc.ValidDateDescription_234)) END)
					< dbo.TryConvertPaPrice(CASE WHEN CHARINDEX(',', pp.ValidDateDescription_234)=0 THEN pp.ValidDateDescription_234 ELSE SUBSTRING(pp.ValidDateDescription_234,0,CHARINDEX(',',pp.ValidDateDescription_234)) END)
				THEN 'Y'
				ELSE ''
			 END  AS Reduced
FROM	MAS_POL.dbo.CI_Item i INNER JOIN
		PriceCurrent pc ON i.ItemCode = pc.ItemCode INNER JOIN
		MAS_POL.dbo.IM_ItemWarehouse w ON i.ItemCode = w.ItemCode LEFT OUTER JOIN
		PricePrevious pp ON pc.ItemCode = pp.ItemCode AND pc.CustomerPriceLevel = pp.CustomerPriceLevel
WHERE i.Category1 = 'Y' AND i.ProductLine != 'SAMP' AND i.ItemType = '1' AND w.WarehouseCode = '000' AND (w.QuantityOnHand + w.QuantityOnPurchaseOrder + w.QuantityOnSalesOrder + w.QuantityOnBackOrder > 0.04) 
UNION ALL
SELECT *
FROM PriceFutureReduced
)
SELECT	ItemCode
		, CustomerPriceLevel as 'Level'
		, CONVERT(varchar, ValidDate_234, 12) as 'Date'
		, Replace(ValidDateDescription_234,' ','') as Price
		, Reduced
FROM PriceUnion
