/****** Object:  View [dbo].[PortalWebPricePrevious]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebPricePrevious]
AS
WITH Price AS
(
SELECT  ROW_NUMBER() OVER (PARTITION BY MAS_POL.dbo.IM_PriceCode.ITEMCODE, CustomerPriceLevel ORDER BY ValidDate_234 DESC) AS 'RN',
	 ITEMCODE,
	 CustomerPriceLevel as 'Level', 
	 ValidDate_234 as 'Date',
	 CASE WHEN CustomerPriceLevel = 'P' THEN dbo.TryConvertPaPrice(CASE WHEN CHARINDEX(',',ValidDateDescription_234)=0  THEN ValidDateDescription_234 ELSE SUBSTRING(ValidDateDescription_234,0,CHARINDEX(',',ValidDateDescription_234)) END)
		    else DiscountMarkup1 END as FrontLinePrice,
	 Replace(ValidDateDescription_234,' ','') as Price
			FROM       MAS_POL.dbo.IM_PriceCode
WHERE     MAS_POL.dbo.IM_PriceCode.ValidDate_234<=GETDATE()
)
SELECT ITEMCODE, [Level], [Date], FrontLinePrice, Price
FROM Price
WHERE RN = 2
