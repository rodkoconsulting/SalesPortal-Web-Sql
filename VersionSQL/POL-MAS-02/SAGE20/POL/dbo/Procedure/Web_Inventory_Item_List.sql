/****** Object:  Procedure [dbo].[Web_Inventory_Item_List]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Inventory_Item_List]
	@CurrentMonth bit,
	@ItemCode varchar(15),
	@ARDivisionNo char(2)='00',
	@Customer varchar(7)
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
	SELECT  ROW_NUMBER() OVER (PARTITION BY MAS_POL.dbo.CI_ITEM.ITEMCODE ORDER BY dbo.Portal_Account_ItemHistory.INVOICEDATE desc, MAS_POL.dbo.IM_PriceCode.ValidDate_234 desc) AS 'RN',   
			MAS_POL.dbo.CI_ITEM.ITEMCODE as ItemCode,
			CASE WHEN MAS_POL.dbo.CI_ITEM.CATEGORY3='Y' THEN 'x' ELSE '' END AS 'Core',
			MAS_POL.dbo.CI_ITEM.UDF_ORGANIC as 'Organic',
			MAS_POL.dbo.CI_ITEM.UDF_BIODYNAMIC as 'Bio',
		   MAS_POL.dbo.CI_Item.UDF_BRAND_NAMEs +' '+ MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION+' '+MAS_POL.dbo.CI_ITEM.UDF_VINTAGE+' ('+
				REPLACE(MAS_POL.dbo.ci_item.SalesUNITOFMEASURE,'C','')+'/'+(CASE WHEN CHARINDEX('ML',MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE)>0 THEN REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE,' ML','') ELSE
				REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE,' ','') END)+') '+MAS_POL.dbo.CI_ITEM.UDF_DAMAGED_NOTES AS ItemDescription,
		   MAS_POL.dbo.IM_PriceCode.CustomerPriceLevel as 'PriceLevel',
		   MAS_POL.dbo.IM_PriceCode.ValidDate_234 as 'ValidDate',
		   CASE WHEN CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 THEN ''
		   WHEN CHARINDEX('B',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 THEN
		   LTRIM(REPLACE(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,LTRIM(RTRIM(STR(MAS_POL.dbo.IM_PriceCode.DiscountMarkup1,6,0)+',')),'')) ELSE
		   LTRIM(REPLACE(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,SUBSTRING(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,0,
		   CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)+1),'')) END AS ContractDescription,
		   MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 AS PriceCase,
		   MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 / CAST(REPLACE(MAS_POL.dbo.CI_ITEM.SalesUnitOfMeasure,'C','') AS INT)  as PriceBottle,
		   CASE WHEN CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup1
		   ELSE CASE WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 AS DECIMAL(10,2))
		   ELSE CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 AS DECIMAL(10,2)) END
		   END AS DDCase,
		   CASE WHEN CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 THEN
		   MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 / CAST(REPLACE(MAS_POL.dbo.CI_ITEM.SalesUNITOFMEASURE,'C','') AS INT)
		   ELSE CASE WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 AS DECIMAL(10,2))
		   ELSE CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 AS DECIMAL(10,2)) END / CAST(REPLACE(MAS_POL.dbo.CI_ITEM.SalesUNITOFMEASURE,'C','') AS DECIMAL)
		   END AS DDBottle,
		   CASE WHEN dbo.IM_InventoryAvailable.QuantityAvailable >0.01 THEN ROUND(dbo.IM_InventoryAvailable.QuantityAvailable, 2) ELSE 0 END AS QuantityAvailable,
		   ROUND(dbo.IM_InventoryAvailable.QtyOnHand, 2) AS QtyOnHand,
		   dbo.IM_InventoryAvailable.OnSO,
		   dbo.IM_InventoryAvailable.OnMO,
		   dbo.IM_InventoryAvailable.OnBO,
		   dbo.IM_InventoryAvailable.QtyOnPurchaseOrder as OnPO,
		   MAS_POL.dbo.AP_VENDOR.UDF_MASTER_VENDOR as MasterVendor,
		   CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_OFFSALE='Y' THEN 'x' ELSE '' END AS 'OffSale',
		   CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_NORETAIL='Y' THEN 'x' ELSE '' END AS 'OnPremise',
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_OFFSALE_NOTES as 'OffSaleNotes',
		   CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_ALLOCATED='Y' THEN 'x' ELSE '' END AS 'Allocated',
		   CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MO  ='Y' THEN 'x' ELSE '' END AS 'NoMo',
		   CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_BO  ='Y' THEN 'x' ELSE '' END AS 'NoBo',
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MANAGER as 'Approval',
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MAX as 'MaxCases',
		   MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_STATE as 'State',
		   CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_SAMPLES='Y' THEN 'x' ELSE '' END AS 'NS',
		   IsNull(CAST(CASE WHEN ISNUMERIC(REPLACE(MAS_POL.dbo.CI_ITEM.SalesUNITOFMEASURE,'C',''))=1 THEN
		   REPLACE(MAS_POL.dbo.CI_ITEM.SalesUNITOFMEASURE,'C','') ELSE '1' END AS INT),12) AS UOM,
		   MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR as 'WineType',
		   IsNull(v.UDF_VARIETAL,'') as 'Varietal',
		   MAS_POL.dbo.CI_ITEM.UDF_CLOSURE as 'Closure',
		   MAS_POL.dbo.CI_ITEM.UDF_COUNTRY as 'Country',
		   IsNull(r.UDF_REGION,'') as 'Region',
		   IsNull(a.UDF_NAME,'') as 'Appellation',
		   MAS_POL.dbo.CI_ITEM.UDF_UPC_CODE AS UpcCode,
		   CASE WHEN len(MAS_POL.dbo.CI_ITEM.UDF_PARKER)>0 OR len(MAS_POL.dbo.CI_ITEM.UDF_SPECTATOR)>0 OR len(MAS_POL.dbo.CI_ITEM.UDF_TANZER)>0 OR len(MAS_POL.dbo.CI_ITEM.UDF_BURGHOUND)>0 OR
		   len(MAS_POL.dbo.CI_ITEM.UDF_GALLONI_SCORE)>0 OR len(MAS_POL.dbo.CI_ITEM.UDF_VFC)>0 then 'x' Else '' END AS 'HasScore',
		   MAS_POL.dbo.CI_ITEM.UDF_PARKER AS ScoreWA,
		   MAS_POL.dbo.CI_ITEM.UDF_SPECTATOR AS ScoreWS,
		   MAS_POL.dbo.CI_ITEM.UDF_TANZER AS ScoreIWC,
		   MAS_POL.dbo.CI_ITEM.UDF_BURGHOUND as ScoreBH,
		   MAS_POL.dbo.CI_ITEM.UDF_GALLONI_SCORE as ScoreAG,
		   MAS_POL.dbo.CI_ITEM.UDF_VFC as ScoreOther,
		   MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE as BottleSize,
		   MAS_POL.dbo.CI_Item.UDF_BRAND_NAMEs as 'Brand',
			MAS_POL.dbo.ci_item.UDF_DESCRIPTION as 'DescriptionShort',
			MAS_POL.dbo.CI_ITEM.UDF_VINTAGE as 'Vintage',
			CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_SAMPLE_FOCUS='Y' THEN 'x' ELSE '' END AS 'SampleFocus',
			dbo.Portal_PricingGroupsCountItems.PricingGroup,
			dbo.Portal_PricingGroupsCountItems.GroupCount,
			dbo.Portal_Account_ItemHistory.INVOICEDATE AS LastInvoiceDate,
			dbo.Portal_Account_ItemHistory.QUANTITYSHIPPED AS LastQuantityShipped,
			dbo.Portal_Account_ItemHistory.UNITPRICE AS LastPrice
FROM         MAS_POL.dbo.CI_Item INNER JOIN
                      MAS_POL.dbo.IM_ItemWarehouse ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.IM_ItemWarehouse.ItemCode INNER JOIN
                      dbo.IM_InventoryAvailable ON MAS_POL.dbo.CI_Item.ItemCode = dbo.IM_InventoryAvailable.ITEMCODE INNER JOIN
                      MAS_POL.dbo.AP_Vendor ON MAS_POL.dbo.CI_Item.PrimaryAPDivisionNo = MAS_POL.dbo.AP_Vendor.APDivisionNo AND MAS_POL.dbo.CI_Item.PrimaryVendorNo = MAS_POL.dbo.AP_Vendor.VendorNo INNER JOIN
                      dbo.Portal_PricingGroupsCountItems ON MAS_POL.dbo.CI_Item.ItemCode = dbo.Portal_PricingGroupsCountItems.ITEMCODE INNER JOIN
                      MAS_POL.dbo.IM_PriceCode ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.IM_PriceCode.ItemCode INNER JOIN
                      MAS_POL.dbo.AR_Customer ON MAS_POL.dbo.IM_PriceCode.CustomerPriceLevel = MAS_POL.dbo.AR_Customer.PriceLevel LEFT OUTER JOIN
                      dbo.Portal_Account_ItemHistory ON MAS_POL.dbo.AR_Customer.CustomerNo = dbo.Portal_Account_ItemHistory.CUSTOMERNO AND 
                      MAS_POL.dbo.CI_Item.ItemCode = dbo.Portal_Account_ItemHistory.ITEMCODE LEFT OUTER JOIN
                      dbo.Web_Inventory_PO ON MAS_POL.dbo.CI_Item.ItemCode = dbo.Web_Inventory_PO.ItemCode LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_VARIETALS AS v ON MAS_POL.dbo.CI_Item.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_Item.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON MAS_POL.dbo.CI_Item.UDF_SUBREGION_T = a.UDF_APPELLATION
WHERE     (MAS_POL.dbo.CI_ITEM.ITEMCODE = @ItemCode) AND (MAS_POL.dbo.IM_ItemWarehouse.WarehouseCode = '000') AND 
                      ValidDate_234<=@ValidDate and AR_CUSTOMER.CUSTOMERNO=@Customer AND AR_CUSTOMER.ARDIVISIONNO=@ARDivisionNo
                     
)
SELECT * FROM CURRENTPRICE
WHERE RN = 1
END
