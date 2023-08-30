/****** Object:  View [dbo].[IM_PriceCode_NextMonth_Active]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_PriceCode_NextMonth_Active]
AS
WITH MAXDATE AS (SELECT     ItemCode, CustomerPriceLevel, MAX(ValidDate_234) AS ValidDate
                                            FROM         MAS_POL.dbo.IM_PriceCode
                                            WHERE     (ValidDate_234 <= DATEADD(MONTH, 1, GETDATE()))
                                            GROUP BY ItemCode, CustomerPriceLevel)
    SELECT     TOP (100) PERCENT pnm.ItemCode, pnm.CustomerPriceLevel, IM_PriceCode_1.ValidDateDescription_234
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
     FROM         MAXDATE AS pnm INNER JOIN
                            dbo.IM_PriceCode AS IM_PriceCode_1 ON pnm.ItemCode = IM_PriceCode_1.ItemCode AND 
                            pnm.CustomerPriceLevel = IM_PriceCode_1.CustomerPriceLevel AND pnm.ValidDate = IM_PriceCode_1.ValidDate_234
							INNER JOIN dbo.CI_Item AS i ON i.ItemCode = pnm.ItemCode
	 WHERE i.InactiveItem='N'
     ORDER BY pnm.ItemCode
