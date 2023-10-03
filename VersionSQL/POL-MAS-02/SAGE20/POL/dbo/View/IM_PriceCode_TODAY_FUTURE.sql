/****** Object:  View [dbo].[IM_PriceCode_TODAY_FUTURE]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_PriceCode_TODAY_FUTURE]
AS
WITH MAXDATE AS (SELECT     ItemCode, CustomerPriceLevel, MAX(ValidDate_234) AS ValidDate_234
                                            FROM         MAS_POL.dbo.IM_PriceCode
                                            WHERE     (ValidDate_234 <= GETDATE())
                                            GROUP BY ItemCode, CustomerPriceLevel)
    SELECT     TOP (100) PERCENT MAXDATE_1.ItemCode, MAXDATE_1.CustomerPriceLevel, MAXDATE_1.ValidDate_234, IM_PriceCode_1.ValidDateDescription_234, IM_PriceCode_1.DiscountMarkup1,IM_PriceCode_1.DiscountMarkup2,IM_PriceCode_1.DiscountMarkup3,IM_PriceCode_1.DiscountMarkup4,IM_PriceCode_1.DiscountMarkup5,
		IM_PriceCode_1.BreakQuantity1,IM_PriceCode_1.BreakQuantity2,IM_PriceCode_1.BreakQuantity3,IM_PriceCode_1.BreakQuantity4,IM_PriceCode_1.BreakQuantity5, IM_PriceCode_1.PriceCodeRecord
     FROM         MAXDATE AS MAXDATE_1 INNER JOIN
                            dbo.IM_PriceCode AS IM_PriceCode_1 ON MAXDATE_1.ItemCode = IM_PriceCode_1.ItemCode AND 
                            MAXDATE_1.CustomerPriceLevel = IM_PriceCode_1.CustomerPriceLevel AND MAXDATE_1.ValidDate_234 = IM_PriceCode_1.ValidDate_234
UNION ALL
SELECT     ItemCode, CustomerPriceLevel, ValidDate_234, ValidDateDescription_234, DiscountMarkup1, DiscountMarkup2,DiscountMarkup3,DiscountMarkup4,DiscountMarkup5,BreakQuantity1, BreakQuantity2, BreakQuantity3,BreakQuantity4,BreakQuantity5,PriceCodeRecord
FROM         MAS_POL.dbo.IM_PriceCode
WHERE     (ValidDate_234 > GETDATE())
GROUP BY ItemCode, CustomerPriceLevel, ValidDate_234, ValidDateDescription_234, DiscountMarkup1, DiscountMarkup2,DiscountMarkup3,DiscountMarkup4,DiscountMarkup5,BreakQuantity1, BreakQuantity2, BreakQuantity3,BreakQuantity4,BreakQuantity5,PriceCodeRecord
