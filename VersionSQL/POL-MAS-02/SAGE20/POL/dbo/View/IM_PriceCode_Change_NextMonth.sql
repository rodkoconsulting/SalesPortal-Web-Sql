/****** Object:  View [dbo].[IM_PriceCode_Change_NextMonth]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_PriceCode_Change_NextMonth]
AS
WITH PriceToday AS
(
SELECT        p.ItemCode, p.CustomerPriceLevel, p.ValidDate, p.ValidDateDescription_234
FROM            dbo.CI_Item AS i INNER JOIN
                         dbo.IM_PriceCode_TODAY AS p ON i.ItemCode = p.ItemCode
WHERE        (i.InactiveItem = 'N')
)
SELECT	pt.ItemCode,
		pt.CustomerPriceLevel,
		pnm.ValidDateDescription_234 as Pricing,
		pnm.BreakQuantity1,
		pnm.BreakQuantity2,
		pnm.BreakQuantity3,
		pnm.BreakQuantity4,
		pnm.BreakQuantity5,
		pnm.DiscountMarkup1,
		pnm.DiscountMarkup2,
		pnm.DiscountMarkup3,
		pnm.DiscountMarkup4,
		pnm.DiscountMarkup5
FROM PriceToday pt INNER JOIN 
IM_PriceCode_NextMonth_Active pnm ON pt.ItemCode = pnm.ItemCode and pt.CustomerPriceLevel = pnm.CustomerPriceLevel
WHERE pt.ValidDateDescription_234 <> pnm.ValidDateDescription_234
