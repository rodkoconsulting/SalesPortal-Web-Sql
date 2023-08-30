/****** Object:  View [dbo].[Web_Inventory_PDF]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Inventory_PDF] AS
SELECT     MAS_POL.dbo.CI_ITEM.ITEMCODE as ItemCode,
		   MAS_POL.dbo.CI_ITEM.CATEGORY3 as 'Core',
		   MAS_POL.dbo.CI_ITEM.UDF_ORGANIC as 'Organic',
		   MAS_POL.dbo.CI_ITEM.UDF_BIODYNAMIC as 'Bio',
		   MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES +' '+ MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION+' '+MAS_POL.dbo.CI_ITEM.UDF_VINTAGE+' ('+REPLACE(MAS_POL.dbo.ci_item.SalesUnitOfMeasure,'C','')+'/'+(CASE WHEN CHARINDEX('ML',MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE)>0 THEN REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE,' ML','') ELSE REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE,' ','') END)+') '+MAS_POL.dbo.CI_ITEM.UDF_DAMAGED_NOTES AS ItemDescription,
		   MAS_POL.dbo.IM_PriceCode.CustomerPriceLevel as 'PriceLevel', MAS_POL.dbo.IM_PriceCode.ValidDate_234 as 'ValidDate',
		   MAS_POL.dbo.IM_PriceCode.ValidDateDescription_234 AS ContractDescription,
		   ROUND(MAS_POL.dbo.IM_ItemWarehouse.QuantityOnHand, 2) AS QtyOnHand,
		   MAS_POL.dbo.IM_ItemWarehouse.QuantityOnSalesOrder as 'QtyOnSalesOrder',
		   MAS_POL.dbo.IM_ItemWarehouse.QuantityOnBackOrder as 'QtyOnBackOrder',
		   IsNull(dbo.Web_Inventory_PO.OnPO,0) as OnPO,
		   IsNull(dbo.Web_Inventory_Po.PurchaseOrderNo,'') as PoNo,
		   IsNull(dbo.Web_Inventory_PO.RequiredDate,'1/1/1900') as PoETA,
		   MAS_POL.dbo.AP_VENDOR.UDF_MASTER_VENDOR as MasterVendor,
		   CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_OFFSALE='Y' AND LEN(ISNULL(MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_OFFSALE_NOTES,''))>0 THEN 'Offsale/'+MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_OFFSALE_NOTES+';'
		   WHEN  MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_OFFSALE='Y' THEN 'Offsale;' ELSE '' END +
		   CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_ALLOCATED='Y' THEN 'Alloc;' ELSE '' END +
		   CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_NORETAIL='Y' THEN 'On Prem;' ELSE '' END +
		   CASE WHEN LEN(MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_STATE)> 0 THEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_STATE+';' ELSE '' END +
		   CASE WHEN LEN(MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MANAGER)> 0 THEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MANAGER+' App;' ELSE '' END +
		   CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MAX > 0 THEN CAST(CAST(MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MAX AS INT) AS VARCHAR(5))+'c Max;' ELSE '' END +
		   CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_SAMPLES='Y' THEN 'NS;' ELSE '' END +
			CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_BO='Y' THEN 'No BOs;' ELSE '' END +
			CASE WHEN MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MO='Y' THEN 'No MOs;' ELSE '' END AS 'Restrictions'
FROM         MAS_POL.dbo.CI_Item INNER JOIN
                      MAS_POL.dbo.IM_ItemWarehouse ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.IM_ItemWarehouse.ItemCode INNER JOIN
                      MAS_POL.dbo.AP_Vendor ON MAS_POL.dbo.CI_Item.PrimaryAPDivisionNo = MAS_POL.dbo.AP_Vendor.APDivisionNo AND MAS_POL.dbo.CI_Item.PrimaryVendorNo = MAS_POL.dbo.AP_Vendor.VendorNo LEFT OUTER JOIN
                      dbo.Web_Inventory_PO ON MAS_POL.dbo.CI_Item.ItemCode = dbo.Web_Inventory_PO.ItemCode LEFT OUTER JOIN
                      MAS_POL.dbo.IM_PriceCode ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.IM_PriceCode.ItemCode
WHERE     (MAS_POL.dbo.CI_ITEM.ProductLine <> 'SAMP') AND (MAS_POL.dbo.CI_ITEM.ITEMTYPE = '1') AND (MAS_POL.dbo.CI_ITEM.CATEGORY1 = 'Y') AND (MAS_POL.dbo.IM_ItemWarehouse.WarehouseCode= '000') AND 
                      (MAS_POL.dbo.IM_ItemWarehouse.QuantityOnHand + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnPurchaseOrder +MAS_POL.dbo.IM_ItemWarehouse.QuantityOnSalesOrder + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnBackOrder
                       > 0.04) and CustomerPriceLevel IS NOT NULL
