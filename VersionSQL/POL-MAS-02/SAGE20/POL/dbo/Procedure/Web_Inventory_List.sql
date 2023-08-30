/****** Object:  Procedure [dbo].[Web_Inventory_List]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Inventory_List] @State char(1),
	@CurrentMonth bit
AS
BEGIN
	SET IMPLICIT_TRANSACTIONS OFF
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
	SELECT  ROW_NUMBER() OVER (PARTITION BY MAS_POL.dbo.CI_ITEM.ITEMCODE, dbo.Web_Inventory_PO.PurchaseOrderNo  ORDER BY  MAS_POL.dbo.IM_PriceCode.ValidDate_234 desc) AS 'RN',   
			MAS_POL.dbo.CI_Item.ITEMCODE as ItemCode,
			CASE WHEN MAS_POL.dbo.CI_Item.CATEGORY3='Y' THEN 'x' ELSE '' END AS 'Core',
			MAS_POL.dbo.CI_Item.UDF_ORGANIC as 'Organic',
			MAS_POL.dbo.CI_Item.UDF_BIODYNAMIC as 'Bio',
		    MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES+' '+ MAS_POL.dbo.CI_Item.UDF_DESCRIPTION+' '+MAS_POL.dbo.CI_Item.UDF_VINTAGE+' ('+REPLACE(MAS_POL.dbo.CI_Item.SalesUnitOfMeasure,'C','')+'/'+(CASE WHEN CHARINDEX('ML',MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE)>0 THEN REPLACE(IsNull(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE,''),' ML','') ELSE REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE,' ','') END)+') '+MAS_POL.dbo.CI_ITEM.UDF_DAMAGED_NOTES AS ItemDescription,
		   MAS_POL.dbo.IM_PriceCode.CustomerPriceLevel as 'PriceLevel', MAS_POL.dbo.IM_PriceCode.ValidDate_234 as 'ValidDate',
		   CASE WHEN CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 THEN ''
		   WHEN CHARINDEX('B',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 THEN LTRIM(REPLACE(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,LTRIM(RTRIM(STR(MAS_POL.dbo.IM_PriceCode.DiscountMarkup1,6,0)+',')),''))
		   ELSE LTRIM(REPLACE(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,SUBSTRING(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,0,CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)+1),'')) END AS ContractDescription,
		   CASE WHEN @State = 'P' THEN dbo.TryConvertPaPrice(CASE WHEN CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 THEN MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234 ELSE SUBSTRING(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,0,CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)) END)
		   ELSE MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 END AS PriceCase,
		   CASE WHEN @State = 'P' THEN dbo.TryConvertPaPrice(CASE WHEN CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 THEN MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234 ELSE SUBSTRING(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,0,CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)) END) / CAST(REPLACE(MAS_POL.dbo.CI_Item.SalesUnitOfMeasure,'C','') AS INT)
		   ELSE MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 / CAST(REPLACE(MAS_POL.dbo.CI_Item.SalesUnitOfMeasure,'C','') AS INT)  END as PriceBottle,
		   CASE WHEN @State = 'P' THEN dbo.TryConvertPaPrice(CASE WHEN CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 OR CHARINDEX('/',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 THEN MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234 ELSE SUBSTRING(REPLACE(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,' ',''),CHARINDEX(',',REPLACE(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,' ',''))+1,CHARINDEX('/',REPLACE(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,' ',''))-CHARINDEX(',',REPLACE(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,' ',''))-1)END) 
		   WHEN CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup1
		   ELSE CASE WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 AS DECIMAL(10,2))
		   ELSE CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 AS DECIMAL(10,2)) END
		   END AS DDCase,
		   CASE WHEN @State = 'P' THEN dbo.TryConvertPaPrice(CASE WHEN CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 OR CHARINDEX('/',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 THEN MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234 ELSE SUBSTRING(REPLACE(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,' ',''),CHARINDEX(',',REPLACE(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,' ',''))+1,CHARINDEX('/',REPLACE(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,' ',''))-CHARINDEX(',',REPLACE(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,' ',''))-1)END) / CAST(REPLACE(MAS_POL.dbo.CI_Item.SalesUnitOfMeasure,'C','') AS INT)
		   WHEN CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0 THEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 / CAST(REPLACE(MAS_POL.dbo.CI_Item.SalesUnitOfMeasure,'C','') AS INT)
		   ELSE CASE WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup5 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup4 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup3 AS DECIMAL(10,2))
		   WHEN MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 > 0 THEN CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup2 AS DECIMAL(10,2))
		   ELSE CAST(MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 AS DECIMAL(10,2)) END / CAST(REPLACE(ISNULL(MAS_POL.dbo.CI_Item.SalesUnitOfMeasure,'1'),'C','') AS DECIMAL)
		   END AS DDBottle,
		   CASE WHEN dbo.IM_InventoryAvailable.QuantityAvailable >0.01 THEN ROUND(dbo.IM_InventoryAvailable.QuantityAvailable, 2) ELSE 0 END AS QuantityAvailable,
		   ROUND(dbo.IM_InventoryAvailable.QtyOnHand, 2) AS QtyOnHand,
		   dbo.IM_InventoryAvailable.OnSO as OnSO,
		   dbo.IM_InventoryAvailable.OnMO as OnMO,
		   dbo.IM_InventoryAvailable.OnBO as OnBO,
		   IsNull(dbo.Web_Inventory_PO.OnPO,0) as OnPO,
		   IsNull(dbo.Web_Inventory_PO.PurchaseOrderNo,'') as PoNo,
		   dbo.Web_Inventory_PO.PoDate,
		   IsNull(dbo.Web_Inventory_PO.AvailableComment,'') as AvailableComment,
		   CASE WHEN YEAR(dbo.Web_Inventory_PO.RequiredDate)>1900 THEN dbo.Web_Inventory_PO.RequiredDate ELSE NULL END as PoETA,
		   MAS_POL.dbo.AP_VENDOR.UDF_MASTER_VENDOR as MasterVendor,
		   CASE WHEN MAS_POL.dbo.CI_Item.UDF_RESTRICT_OFFSALE='Y' THEN 'x' ELSE '' END AS 'OffSale',
		   CASE WHEN MAS_POL.dbo.CI_Item.UDF_RESTRICT_NORETAIL='Y' THEN 'x' ELSE '' END AS 'OnPremise',
		   MAS_POL.dbo.CI_Item.UDF_RESTRICT_OFFSALE_NOTES as 'OffSaleNotes',
		   CASE WHEN MAS_POL.dbo.CI_Item.UDF_RESTRICT_ALLOCATED='Y' THEN 'x' ELSE '' END AS 'Allocated',
		   MAS_POL.dbo.CI_Item.UDF_RESTRICT_MANAGER as 'Approval',
		   MAS_POL.dbo.CI_Item.UDF_RESTRICT_MAX as 'MaxCases',
		   MAS_POL.dbo.CI_Item.UDF_RESTRICT_STATE as 'State',
		   CASE WHEN MAS_POL.dbo.CI_Item.UDF_RESTRICT_SAMPLES='Y' THEN 'x' ELSE '' END AS 'NS',
		   CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_BO='Y' THEN 'x' ELSE '' END AS 'NoBo',
		   CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MO='Y' THEN 'x' ELSE '' END AS 'NoMo',
		   IsNull(CAST(CASE WHEN ISNUMERIC(REPLACE(MAS_POL.dbo.CI_Item.SalesUNITOFMEASURE,'C',''))=1 THEN REPLACE(MAS_POL.dbo.CI_Item.SalesUNITOFMEASURE,'C','') ELSE '1' END AS INT),12) AS UOM,
		   MAS_POL.dbo.CI_Item.UDF_WINE_COLOR as 'WineType',
		   IsNull(v.UDF_VARIETAL,'') as 'Varietal',
		   MAS_POL.dbo.CI_Item.UDF_CLOSURE as 'Closure',
		   MAS_POL.dbo.CI_Item.UDF_COUNTRY as 'Country',
		   IsNull(r.UDF_REGION,'') as 'Region',
		   IsNull(a.UDF_NAME,'') as 'Appellation',
		   MAS_POL.dbo.CI_Item.UDF_UPC_CODE AS UpcCode,
		   CASE WHEN len(MAS_POL.dbo.CI_Item.UDF_PARKER)>0 OR len(MAS_POL.dbo.CI_Item.UDF_SPECTATOR)>0 OR len(MAS_POL.dbo.CI_Item.UDF_TANZER)>0 OR len(MAS_POL.dbo.CI_Item.UDF_BURGHOUND)>0 OR len(MAS_POL.dbo.CI_Item.UDF_GALLONI_SCORE)>0 OR len(MAS_POL.dbo.CI_Item.UDF_VFC)>0 then 'x' Else '' END AS 'HasScore',
		   MAS_POL.dbo.CI_Item.UDF_PARKER AS ScoreWA,
		   MAS_POL.dbo.CI_Item.UDF_SPECTATOR AS ScoreWS,
		   MAS_POL.dbo.CI_Item.UDF_TANZER AS ScoreIWC,
		   MAS_POL.dbo.CI_Item.UDF_BURGHOUND as ScoreBH,
		   MAS_POL.dbo.CI_Item.UDF_GALLONI_SCORE as ScoreAG,
		   MAS_POL.dbo.CI_Item.UDF_VFC as ScoreOther,
		   MAS_POL.dbo.CI_Item.UDF_BOTTLE_SIZE as BottleSize,
		   MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES as 'Brand',
		   MAS_POL.dbo.CI_Item.UDF_DESCRIPTION as 'DescriptionShort',
		   MAS_POL.dbo.CI_Item.UDF_VINTAGE as 'Vintage',
		   CASE WHEN MAS_POL.dbo.CI_Item.UDF_SAMPLE_FOCUS='Y' THEN 'x' ELSE '' END AS 'SampleFocus',
		   CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_BM_FOCUS='Y' THEN 'x' ELSE '' END AS 'BmFocus',
		   dbo.Portal_PricingGroupsCountItems.PricingGroup as 'PricingGroup', dbo.Portal_PricingGroupsCountItems.GroupCount,
		   CASE WHEN YEAR(LastReceiptDate)>1900 THEN LastReceiptDate ELSE NULL END as ReceiptDate,
			CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_REGENERATIVE='Y' THEN 'x' ELSE '' END AS 'Regenerative',
			CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_NATURAL='Y' THEN 'x' ELSE '' END AS 'Natural',
			CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_VEGAN='Y' THEN 'x' ELSE '' END AS 'Vegan',
			CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_HAUTE_VALEUR='Y' THEN 'x' ELSE '' END AS 'HVE'
FROM         MAS_POL.dbo.CI_Item INNER JOIN
                      MAS_POL.dbo.IM_ItemWarehouse ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.IM_ItemWarehouse.ItemCode INNER JOIN
                      dbo.IM_InventoryAvailable ON MAS_POL.dbo.CI_Item.ItemCode = dbo.IM_InventoryAvailable.ITEMCODE INNER JOIN
                      MAS_POL.dbo.AP_Vendor ON MAS_POL.dbo.CI_Item.PrimaryAPDivisionNo = MAS_POL.dbo.AP_Vendor.APDivisionNo AND MAS_POL.dbo.CI_Item.PrimaryVendorNo = MAS_POL.dbo.AP_Vendor.VendorNo INNER JOIN
                      dbo.Portal_PricingGroupsCountItems ON MAS_POL.dbo.CI_Item.ItemCode = dbo.Portal_PricingGroupsCountItems.ITEMCODE LEFT OUTER JOIN
                      dbo.Web_Inventory_PO ON MAS_POL.dbo.CI_Item.ItemCode = dbo.Web_Inventory_PO.ItemCode LEFT OUTER JOIN
                      MAS_POL.dbo.IM_PriceCode ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.IM_PriceCode.ItemCode LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_VARIETALS AS v ON MAS_POL.dbo.CI_Item.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_Item.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON MAS_POL.dbo.CI_Item.UDF_SUBREGION_T = a.UDF_APPELLATION
WHERE     (MAS_POL.dbo.CI_ITEM.ProductLine <> 'SAMP') AND MAS_POL.dbo.IM_PriceCode.CustomerPriceLevel Is Not Null AND (MAS_POL.dbo.CI_Item.ITEMTYPE = '1') AND (MAS_POL.dbo.CI_Item.CATEGORY1 = 'Y') AND (MAS_POL.dbo.IM_ItemWarehouse.WarehouseCode = '000') AND 
                      (dbo.IM_InventoryAvailable.QtyOnHand + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnPurchaseOrder + dbo.IM_InventoryAvailable.OnSO + dbo.IM_InventoryAvailable.OnMO + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnBackOrder
                       > 0.04) and MAS_POL.dbo.IM_PriceCode.CustomerPriceLevel = @State and MAS_POL.dbo.IM_PriceCode.ValidDate_234<=@ValidDate
)
,
PREVIOUSPRICE AS
(
SELECT  ROW_NUMBER() OVER (PARTITION BY MAS_POL.dbo.CI_ITEM.ITEMCODE ORDER BY  MAS_POL.dbo.IM_PriceCode.ValidDate_234 DESC) AS 'RNP',   
			MAS_POL.dbo.CI_Item.ITEMCODE as 'ItemPrev',
		   CASE WHEN MAS_POL.dbo.IM_PriceCode.CustomerPriceLevel = 'P' THEN dbo.TryConvertPaPrice(CASE WHEN CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)=0  THEN MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234 ELSE SUBSTRING(MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234,0,CHARINDEX(',',MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234)) END)
		   ELSE MAS_POL.dbo.IM_PriceCode.DiscountMarkup1 end as PrevFL
			FROM         MAS_POL.dbo.CI_Item LEFT OUTER JOIN
                      MAS_POL.dbo.IM_PriceCode ON MAS_POL.dbo.CI_Item.ITEMCODE = MAS_POL.dbo.IM_PriceCode.ItemCode
                      WHERE MAS_POL.dbo.IM_PriceCode.CustomerPriceLevel = @State AND MAS_POL.dbo.IM_PriceCode.ValidDate_234<=@ValidDate
                 
)
SELECT RN,ItemCode,Core,Organic,Bio,ItemDescription,PriceLevel,ValidDate,ContractDescription,PriceCase,PriceBottle,DDCase,DDBottle,QuantityAvailable,QtyOnHand,OnSO,OnMO,OnBO,OnPO,PoNo,PoDate,PoETA,AvailableComment,MasterVendor,OffSale,OnPremise,OffSaleNotes,Allocated,Approval,MaxCases,[State],NS,NoBo,NoMo,UOM,WineType,Varietal,Closure,Country,Region,Appellation,UpcCode,HasScore,ScoreWA,ScoreWS,ScoreIWC,ScoreBH,ScoreAG,ScoreOther,BottleSize,
max(CASE WHEN PriceCase<PrevFL then 'x' else '' end) as 'Clearance',Brand,DescriptionShort,Vintage,SampleFocus,BmFocus,PricingGroup,GroupCount,ReceiptDate,Regenerative,Natural,Vegan,HVE
FROM CURRENTPRICE LEFT OUTER JOIN
PREVIOUSPRICE ON CURRENTPRICE.ItemCode = PREVIOUSPRICE.ItemPrev
WHERE RN = 1 AND (RNP between 1 and 2)
GROUP BY RN,ItemCode,Core,Organic,Bio,ItemDescription,PriceLevel,ValidDate,ContractDescription,PriceCase,PriceBottle,DDCase,DDBottle,QuantityAvailable,QtyOnHand,OnSO,OnMO,OnBO,OnPO,PoNo,PoDate,PoETA,AvailableComment,MasterVendor,OffSale,OnPremise,OffSaleNotes,Allocated,Approval,MaxCases,[State],NS,NoBo,NoMo,UOM,WineType,Varietal,Closure,Country,Region,Appellation,UpcCode,HasScore,ScoreWA,ScoreWS,ScoreIWC,ScoreBH,ScoreAG,ScoreOther,BottleSize,Brand,DescriptionShort,Vintage,SampleFocus,BmFocus,PricingGroup,GroupCount,ReceiptDate,Regenerative,Natural,Vegan,HVE
END
