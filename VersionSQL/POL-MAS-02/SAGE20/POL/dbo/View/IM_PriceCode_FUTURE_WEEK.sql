/****** Object:  View [dbo].[IM_PriceCode_FUTURE_WEEK]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_PriceCode_FUTURE_WEEK]
AS
WITH MAXDATE AS (SELECT     ItemCode, CustomerPriceLevel, MAX(ValidDate_234) AS ValidDate
                                            FROM         MAS_POL.dbo.IM_PriceCode
                                            WHERE     (ValidDate_234 <= DATEADD(day, 7, GETDATE()))
                                            GROUP BY ItemCode, CustomerPriceLevel)
    SELECT     TOP (100) PERCENT MAXDATE_1.ItemCode, MAXDATE_1.CustomerPriceLevel, MAXDATE_1.ValidDate, IM_PriceCode_1.ValidDateDescription_234
	,PriceCodeRecord
	,ValidDate_234
	,BreakQuantity1
	,BreakQuantity2
	,BreakQuantity3
	,BreakQuantity4
	,BreakQuantity5
	,DiscountMarkup1
	,DiscountMarkup2
	,DiscountMarkup3
	,DiscountMarkup4
	,DiscountMarkup5
     FROM         MAXDATE AS MAXDATE_1 INNER JOIN
                            dbo.IM_PriceCode AS IM_PriceCode_1 ON MAXDATE_1.ItemCode = IM_PriceCode_1.ItemCode AND 
                            MAXDATE_1.CustomerPriceLevel = IM_PriceCode_1.CustomerPriceLevel AND MAXDATE_1.ValidDate = IM_PriceCode_1.ValidDate_234
     ORDER BY MAXDATE_1.ItemCode
