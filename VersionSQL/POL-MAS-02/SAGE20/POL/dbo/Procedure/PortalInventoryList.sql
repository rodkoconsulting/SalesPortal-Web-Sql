/****** Object:  Procedure [dbo].[PortalInventoryList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalInventoryList] @State char(1),
	@CurrentMonth bit
AS
BEGIN
	SET NOCOUNT ON
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
	SELECT  ROW_NUMBER() OVER (PARTITION BY MAS_POL.dbo.CI_ITEM.ITEMCODE ORDER BY  MAS_POL.dbo.IM_PriceCode.ValidDate_234 desc) AS 'RN',   
			MAS_POL.dbo.CI_Item.ItemCode, 
                      MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES + ' ' + MAS_POL.dbo.CI_Item.UDF_DESCRIPTION + ' ' + MAS_POL.dbo.CI_Item.UDF_VINTAGE + ' (' + REPLACE(MAS_POL.dbo.CI_Item.SalesUnitOfMeasure,
                       'C', '') + '/' + (CASE WHEN CHARINDEX('ML', MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE) > 0 THEN REPLACE(IsNull(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ''), 
                      ' ML', '') ELSE REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ', '') END) + ') ' + MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES AS ItemDescription, 
                      CASE WHEN CHARINDEX(',', MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234) = 0 THEN ''
                      WHEN CHARINDEX('B', MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234) = 0 THEN LTRIM(REPLACE(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234, LTRIM(RTRIM(STR(MAS_POL.dbo.IM_PriceCode.DiscountMarkup1, 6, 0) + ',')), '')) 
                      ELSE LTRIM(REPLACE(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234, SUBSTRING(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234, 0, 
                      CHARINDEX(',', MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234) + 1), '')) END AS ContractDescription, 
                      MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 AS PriceCase, 
                      MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 / CAST(REPLACE(MAS_POL.dbo.CI_Item.SalesUnitOfMeasure, 'C', '') AS INT) AS PriceBottle, 
                      CASE WHEN CHARINDEX(',', MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234) 
                      = 0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 ELSE CASE WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 > 0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup5
                      WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 > 0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup4
                      WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 > 0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup3
                      WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 > 0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup2
                      ELSE MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 END END AS DDCase, CASE WHEN CHARINDEX(',', 
                      MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234) 
                      = 0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 / CAST(REPLACE(MAS_POL.dbo.CI_Item.SalesUnitOfMeasure, 'C', '') AS INT) 
                      ELSE CASE WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 > 0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 
                      WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 > 0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup4
                      WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 > 0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup3
                      WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 > 0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup2
                      ELSE MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 END / CAST(REPLACE(ISNULL(MAS_POL.dbo.CI_Item.SalesUnitOfMeasure, '1'), 'C', '') 
                      AS FLOAT) END AS DDBottle, CASE WHEN dbo.IM_InventoryAvailable.QuantityAvailable > 0.01 THEN ROUND(dbo.IM_InventoryAvailable.QuantityAvailable, 2) 
                      ELSE 0 END AS QuantityAvailable, ROUND(MAS_POL.dbo.IM_ItemWarehouse.QuantityOnHand, 2) AS QtyOnHand, dbo.IM_InventoryAvailable.OnSO, 
                      dbo.IM_InventoryAvailable.OnMO, dbo.IM_InventoryAvailable.OnBO, dbo.IM_InventoryAvailable.QtyOnPurchaseOrder as OnPO
FROM         MAS_POL.dbo.CI_Item INNER JOIN
                      MAS_POL.dbo.IM_ItemWarehouse ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.IM_ItemWarehouse.ItemCode INNER JOIN
                      dbo.IM_InventoryAvailable ON MAS_POL.dbo.CI_Item.ItemCode = dbo.IM_InventoryAvailable.ITEMCODE LEFT OUTER JOIN
                      MAS_POL.dbo.IM_PriceCode ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.IM_PriceCode.ItemCode
WHERE     (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND (MAS_POL.dbo.IM_PriceCode.CustomerPriceLevel IS NOT NULL) AND (MAS_POL.dbo.CI_Item.ItemType = '1') AND (MAS_POL.dbo.CI_Item.Category1 = 'Y') AND 
                      (MAS_POL.dbo.IM_ItemWarehouse.WarehouseCode = '000') AND 
                      (MAS_POL.dbo.IM_ItemWarehouse.QuantityOnHand + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnPurchaseOrder + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnSalesOrder
                       + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnBackOrder > 0.04) AND (MAS_POL.dbo.IM_PriceCode.CustomerPriceLevel = @State) AND 
                      (MAS_POL.dbo.IM_PriceCode.ValidDate_234 <= @ValidDate)
)
SELECT 
	ItemCode,ItemDescription,
	ContractDescription,
	CAST(ROUND(PriceCase,2) AS FLOAT) AS PriceCase,
	CAST(ROUND(PriceBottle,2) AS FLOAT) AS PriceBottle,
	CAST(ROUND(DDCase,2) AS FLOAT) AS DDCase,
	CAST(ROUND(DDBottle,2) AS FLOAT) AS DDBottle,
	CAST(ROUND(QuantityAvailable,2) AS FLOAT) AS QuantityAvailable,
	CAST(ROUND(QtyOnHand,2) AS FLOAT) AS QtyOnHand,
	CAST(ROUND(OnSO,2) AS FLOAT) AS OnSO,
	CAST(ROUND(OnMO,2) AS FLOAT) AS OnMO,
	CAST(ROUND(OnBO,2) AS FLOAT) AS OnBO,
	CAST(ROUND(OnPO,2) AS FLOAT) AS OnPO
FROM CURRENTPRICE 
WHERE RN = 1
GROUP BY ItemCode,ItemDescription,ContractDescription,PriceCase,PriceBottle,DDCase,DDBottle,QuantityAvailable,QtyOnHand,OnSO,OnMO,OnBO,OnPO
END
