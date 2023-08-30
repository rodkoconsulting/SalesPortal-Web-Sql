/****** Object:  View [dbo].[PortalWebPriceCurrent]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebPriceCurrent]
AS
WITH Price AS
(
SELECT  ROW_NUMBER() OVER (PARTITION BY MAS_POL.dbo.IM_PriceCode.ITEMCODE, CustomerPriceLevel ORDER BY ValidDate_234 DESC) AS 'RN',
	 ITEMCODE,
	 CustomerPriceLevel as 'Level', 
	 ValidDate_234 as 'Date',
	 CASE WHEN CustomerPriceLevel = 'P' THEN dbo.TryConvertPaPrice(CASE WHEN CHARINDEX(',',ValidDateDescription_234)=0  THEN ValidDateDescription_234 ELSE SUBSTRING(ValidDateDescription_234,0,CHARINDEX(',',ValidDateDescription_234)) END)
		    else DiscountMarkup1 END as FrontLinePrice,
	 Replace(ValidDateDescription_234,' ','') as Price,
	 DiscountMarkup1,
	 DiscountMarkup2,
	 DiscountMarkup3,
	 DiscountMarkup4,
	 DiscountMarkup5,
	 BreakQuantity1,
	 BreakQuantity2,
	 BreakQuantity3,
	 BreakQuantity4,
	 BreakQuantity5
			FROM       MAS_POL.dbo.IM_PriceCode
WHERE     MAS_POL.dbo.IM_PriceCode.ValidDate_234<=GETDATE()
)
SELECT ITEMCODE, [Level], [Date], FrontLinePrice, Price,
	 DiscountMarkup1,
	 DiscountMarkup2,
	 DiscountMarkup3,
	 DiscountMarkup4,
	 DiscountMarkup5,
	 BreakQuantity1,
	 BreakQuantity2,
	 BreakQuantity3,
	 BreakQuantity4,
	 BreakQuantity5
FROM Price
WHERE RN = 1
