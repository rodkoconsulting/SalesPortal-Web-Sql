/****** Object:  Procedure [dbo].[Web_Account_PriceQuery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_PriceQuery]
    @State char(2),
	@CurrentMonth bit,
	@ItemCode varchar(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @ValidDate Datetime;
    DECLARE @NextMonth int;
    DECLARE @NextYear int;
    DECLARE @CurrentDay int;
    SET @CurrentDay=DAY(GETDATE());
    IF @CurrentMonth=1 OR @CurrentDay=1
		BEGIN
			SET @ValidDate=GETDATE();
		END
	ELSE
		BEGIN
			SET @NextMonth=MONTH(GETDATE())+1;
			SET @NextYear=YEAR(GETDATE());
			IF @NextMonth=13
				BEGIN
					SET @NextMonth=1;
					SET @NextYear=@NextYear+1;
				END
			SET @ValidDate = CAST(CAST(@NextMonth AS varchar(5))+'/1/'+CAST(@NextYear As varchar(5)) as Datetime);
		END;
	WITH CURRENTPRICE AS
	(
	SELECT  ROW_NUMBER() OVER (PARTITION BY MAS_POL.dbo.CI_ITEM.ITEMCODE  ORDER BY  MAS_POL.dbo.IM_PriceCode.ValidDate_234 desc) AS 'RN',   
			MAS_POL.dbo.CI_ITEM.ITEMCODE AS ItemCode, 
                      CASE WHEN LTRIM(RTRIM(STR(MAS_POL.dbo.IM_PriceCode.DiscountMarkup1, 6, 0))) = LTRIM(RTRIM(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)) 
                      THEN '' ELSE LTRIM(REPLACE(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234, LTRIM(RTRIM(STR(MAS_POL.dbo.IM_PriceCode.DiscountMarkup1, 6, 0) + ',')), '')) 
                      END AS ContractDescription, MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 AS PriceCase, 
                      MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 / CAST(REPLACE(MAS_POL.dbo.CI_ITEM.SalesUNITOFMEASURE, 'C', '') AS INT) AS PriceBottle,
           CASE WHEN CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup1
		   ELSE CASE WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 AS DECIMAL(10,2))
		   ELSE CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 AS DECIMAL(10,2)) END
		   END AS DDCase,
		   CASE WHEN CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 / CAST(REPLACE(MAS_POL.dbo.CI_ITEM.SalesUNITOFMEASURE,'C','') AS INT)
		   ELSE CASE WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 AS DECIMAL(10,2))
		   ELSE CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 AS DECIMAL(10,2)) END / CAST(REPLACE(MAS_POL.dbo.CI_ITEM.SalesUNITOFMEASURE,'C','') AS DECIMAL)
		   END AS DDBottle
FROM         MAS_POL.dbo.CI_ITEM LEFT OUTER JOIN
                      MAS_POL.dbo.IM_PriceCode ON MAS_POL.dbo.CI_ITEM.ITEMCODE = MAS_POL.dbo.IM_PriceCode.ItemCode
WHERE     (MAS_POL.dbo.CI_ITEM.ITEMCODE = @ItemCode) AND (MAS_POL.dbo.IM_PriceCode.CustomerPriceLevel = SUBSTRING(@State,2,1)) AND 
                      (MAS_POL.dbo.IM_PriceCode.ValidDate_234 <= @ValidDate)
)
SELECT ItemCode, ContractDescription, PriceCase, PriceBottle, DDCase, DDBottle FROM CURRENTPRICE
WHERE RN = 1
END
