/****** Object:  View [dbo].[Web_Account_OgDetailsView]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Account_OgDetailsView]
AS
SELECT  dbo.Web_Account_OgDetails.ITEMCODE,
		CASE WHEN MAS_POL.dbo.CI_ITEM.CATEGORY3 = 'Y' THEN 'x' ELSE '' END AS Core, 
        MAS_POL.dbo.CI_ITEM.UDF_ORGANIC AS Organic,
        MAS_POL.dbo.CI_ITEM.UDF_BIODYNAMIC AS Bio, 
        MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES+' '+ MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION+' '+MAS_POL.dbo.CI_ITEM.UDF_VINTAGE+ ' (' +
			REPLACE(MAS_POL.dbo.CI_ITEM.SalesUnitOfMeasure, 'C', '') + '/' + (CASE WHEN CHARINDEX('ML', MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE) > 0
			THEN REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ML', '') ELSE
			REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ', '') END)+ ') ' + MAS_POL.dbo.CI_ITEM.UDF_DAMAGED_NOTES AS ItemDescription,
        CASE WHEN dbo.IM_InventoryAvailable.QuantityAvailable >0 THEN
			ROUND(dbo.IM_InventoryAvailable.QuantityAvailable, 2) ELSE 0 END AS QuantityAvailable, 
        dbo.IM_InventoryAvailable.OnSO,
        dbo.IM_InventoryAvailable.OnMO,
        dbo.IM_InventoryAvailable.QtyOnPurchaseOrder AS OnPO,
        dbo.IM_InventoryAvailable.OnBO,
        ROUND(dbo.IM_InventoryAvailable.QtyOnHand, 2) AS QtyOnHand,
        MAS_POL.dbo.AP_VENDOR.UDF_MASTER_VENDOR AS MasterVendor, 
        CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_OFFSALE = 'Y' THEN 'x' ELSE '' END AS OffSale, 
        CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_NORETAIL = 'Y' THEN 'x' ELSE '' END AS OnPremise,
        MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_OFFSALE_NOTES AS OffSaleNotes, 
        CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_ALLOCATED = 'Y' THEN 'x' ELSE '' END AS Allocated,
        MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MANAGER AS Approval, 
        CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MAX > 0 THEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MAX ELSE NULL END AS MaxCases,
        MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_STATE AS State, 
        CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_SAMPLES = 'Y' THEN 'x' ELSE '' END AS NS,
        CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_BO = 'Y' THEN 'x' ELSE '' END AS NoBo,
        CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MO = 'Y' THEN 'x' ELSE '' END AS NoMo,
        IsNull(CAST(CASE WHEN ISNUMERIC(REPLACE(MAS_POL.dbo.CI_ITEM.SalesUNITOFMEASURE, 'C', '')) = 1 THEN
			REPLACE(MAS_POL.dbo.CI_ITEM.SalesUNITOFMEASURE, 'C', '') ELSE '1' END AS INT),12) AS UOM, 
        MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR AS WineType,
        IsNull(v.UDF_VARIETAL,'') AS Varietal, 
        MAS_POL.dbo.CI_ITEM.UDF_CLOSURE AS Closure,
        MAS_POL.dbo.CI_ITEM.UDF_COUNTRY AS Country, 
        IsNull(r.UDF_REGION,'') AS Region,
        IsNull(a.UDF_NAME,'') AS Appellation, 
        MAS_POL.dbo.CI_ITEM.UDF_UPC_CODE AS UpcCode,
        CASE WHEN len(MAS_POL.dbo.CI_ITEM.UDF_PARKER)>0 OR
                  len(MAS_POL.dbo.CI_ITEM.UDF_SPECTATOR)>0 OR
                  len(MAS_POL.dbo.CI_ITEM.UDF_TANZER)>0 OR
                  LEN(MAS_POL.dbo.CI_ITEM.UDF_BURGHOUND)>0 OR
                  LEN(MAS_POL.dbo.CI_ITEM.UDF_GALLONI_SCORE)>0 OR
                  LEN(MAS_POL.dbo.CI_ITEM.UDF_VFC)>0 THEN 'x' ELSE '' END AS HasScore,
        MAS_POL.dbo.CI_ITEM.UDF_PARKER AS ScoreWA,
        MAS_POL.dbo.CI_ITEM.UDF_SPECTATOR AS ScoreWS,
        MAS_POL.dbo.CI_ITEM.UDF_TANZER AS ScoreIWC,
        MAS_POL.dbo.CI_ITEM.UDF_BURGHOUND AS ScoreBH,
        MAS_POL.dbo.CI_ITEM.UDF_GALLONI_SCORE AS ScoreAG,
        MAS_POL.dbo.CI_ITEM.UDF_VFC AS ScoreOther,
        MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE AS BottleSize,
        MAS_POL.dbo.CI_item.UDF_BRAND_NAMES AS Brand, 
        MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION AS DescriptionShort,
        MAS_POL.dbo.CI_ITEM.UDF_VINTAGE AS Vintage,
        MAS_POL.dbo.CI_ITEM.InactiveItem AS IsInactive,
        dbo.Web_Account_OgDetails.ORDERNO, 
        CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_SAMPLE_FOCUS = 'Y' THEN 'x' ELSE '' END AS SampleFocus,
        dbo.Web_Account_OgDetails.PriceCase as PriceCase, 
        dbo.Web_Account_OgDetails.PriceBottle as PriceBottle,
        dbo.Web_Account_OgDetails.DiscountCase as DiscountCase,
        dbo.Web_Account_OgDetails.DiscountBottle as DiscountBottle, 
        dbo.Web_Account_OgDetails.DiscountList,
        dbo.Web_Account_OgDetails.MoboList,
        dbo.Web_Account_OgDetails.LastInvoiceDate, 
        dbo.Web_Account_OgDetails.LastQuantityShipped,
        dbo.Web_Account_OgDetails.LastPrice,
        dbo.Web_Account_OgDetails.Cases,
        dbo.Web_Account_OgDetails.Bottles, 
        dbo.Web_Account_OgDetails.UnitPriceCase,
        dbo.Web_Account_OgDetails.UnitPriceBottle,
        dbo.Web_Account_OgDetails.Total,
        dbo.Web_Account_OgDetails.MoboTotal,
        dbo.Web_Account_OgDetails.IsOverride,
        dbo.Web_Account_OgDetails.IsMix,
        dbo.Portal_PricingGroupsCountItems.PricingGroup,
        dbo.Portal_PricingGroupsCountItems.GroupCount
FROM         dbo.Web_Account_OgDetails INNER JOIN
                      dbo.IM_InventoryAvailable ON dbo.Web_Account_OgDetails.ITEMCODE = dbo.IM_InventoryAvailable.ITEMCODE INNER JOIN
                      MAS_POL.dbo.CI_Item ON dbo.Web_Account_OgDetails.ITEMCODE = MAS_POL.dbo.CI_Item.ItemCode INNER JOIN
                      MAS_POL.dbo.AP_Vendor ON MAS_POL.dbo.CI_Item.PrimaryAPDivisionNo = MAS_POL.dbo.AP_Vendor.APDivisionNo AND MAS_POL.dbo.CI_Item.PrimaryVendorNo = MAS_POL.dbo.AP_Vendor.VendorNo INNER JOIN
                      dbo.Portal_PricingGroupsCountItems ON dbo.Web_Account_OgDetails.ITEMCODE = dbo.Portal_PricingGroupsCountItems.ITEMCODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_VARIETALS AS v ON MAS_POL.dbo.CI_Item.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_Item.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON MAS_POL.dbo.CI_Item.UDF_SUBREGION_T = a.UDF_APPELLATION
WHERE MAS_POL.dbo.CI_ITEM.VALUATION <>5
