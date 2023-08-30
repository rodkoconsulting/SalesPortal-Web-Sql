/****** Object:  View [dbo].[PortalWebPrice]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebPrice]
AS
WITH Pricing AS
(
SELECT     dbo.PortalWebPriceCurrent.ItemCode, dbo.PortalWebPriceCurrent.[Level], dbo.PortalWebPriceCurrent.Date,
                      dbo.PortalWebPriceCurrent.Price,
           CASE WHEN dbo.PortalWebPriceCurrent.FrontLinePrice < dbo.PortalWebPricePrevious.FrontLinePrice  THEN 'Y' ELSE '' END AS Reduced
           
FROM         dbo.PortalWebPriceCurrent LEFT OUTER JOIN
                      dbo.PortalWebPricePrevious ON dbo.PortalWebPriceCurrent.ITEMCODE = dbo.PortalWebPricePrevious.ITEMCODE AND 
                      dbo.PortalWebPriceCurrent.[Level] = dbo.PortalWebPricePrevious.[Level]
UNION
SELECT     dbo.PortalWebPriceFuture.ItemCode, dbo.PortalWebPriceFuture.[Level], dbo.PortalWebPriceFuture.Date,
                      dbo.PortalWebPriceFuture.Price,
           CASE WHEN dbo.PortalWebPriceFuture.FrontLinePrice < dbo.PortalWebPriceCurrent.FrontLinePrice  THEN 'Y' ELSE '' END AS Reduced
           
FROM         dbo.PortalWebPriceFuture LEFT OUTER JOIN
                      dbo.PortalWebPriceCurrent ON dbo.PortalWebPriceFuture.ITEMCODE = dbo.PortalWebPriceCurrent.ITEMCODE AND 
                      dbo.PortalWebPriceFuture.[Level] = dbo.PortalWebPriceCurrent.[Level]
)
SELECT Pricing.ItemCode, [Level], CONVERT(varchar, [Date], 12) as 'Date', Price, Reduced
FROM Pricing INNER JOIN
	  MAS_POL.dbo.CI_Item ON Pricing.ItemCode = MAS_POL.dbo.CI_Item.ItemCode INNER JOIN
           MAS_POL.dbo.IM_ItemWarehouse ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.IM_ItemWarehouse.ItemCode INNER JOIN
           dbo.IM_InventoryAvailable ON MAS_POL.dbo.CI_Item.ItemCode = dbo.IM_InventoryAvailable.ITEMCODE
WHERE     (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND (MAS_POL.dbo.CI_Item.ItemType = '1') AND (MAS_POL.dbo.CI_Item.Category1 = 'Y') and (MAS_POL.dbo.IM_ItemWarehouse.WarehouseCode = '000') AND 
          (MAS_POL.dbo.IM_ItemWarehouse.QuantityOnHand + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnPurchaseOrder + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnSalesOrder
          + MAS_POL.dbo.IM_ItemWarehouse.QuantityOnBackOrder > 0.04)   
