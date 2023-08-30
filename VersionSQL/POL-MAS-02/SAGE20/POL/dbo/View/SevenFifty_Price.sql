/****** Object:  View [dbo].[SevenFifty_Price]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[SevenFifty_Price]
AS
WITH Pricing AS
(
SELECT     dbo.PortalWebPriceCurrent.ItemCode, dbo.PortalWebPriceCurrent.[Level], dbo.PortalWebPriceCurrent.Date,
                      dbo.PortalWebPriceCurrent.Price, dbo.PortalWebPriceCurrent.DiscountMarkup1, dbo.PortalWebPriceCurrent.DiscountMarkup2, dbo.PortalWebPriceCurrent.BreakQuantity1
           
FROM         dbo.PortalWebPriceCurrent LEFT OUTER JOIN
                      dbo.PortalWebPricePrevious ON dbo.PortalWebPriceCurrent.ITEMCODE = dbo.PortalWebPricePrevious.ITEMCODE AND 
                      dbo.PortalWebPriceCurrent.[Level] = dbo.PortalWebPricePrevious.[Level]
UNION
SELECT     dbo.PortalWebPriceFuture.ItemCode, dbo.PortalWebPriceFuture.[Level], dbo.PortalWebPriceFuture.Date,
                      dbo.PortalWebPriceFuture.Price, dbo.PortalWebPriceFuture.DiscountMarkup1, dbo.PortalWebPriceFuture.DiscountMarkup2, dbo.PortalWebPriceFuture.BreakQuantity1
           
FROM         dbo.PortalWebPriceFuture LEFT OUTER JOIN
                      dbo.PortalWebPriceCurrent ON dbo.PortalWebPriceFuture.ITEMCODE = dbo.PortalWebPriceCurrent.ITEMCODE AND 
                      dbo.PortalWebPriceFuture.[Level] = dbo.PortalWebPriceCurrent.[Level]
)
SELECT i.ItemCode, [Level], CONVERT(varchar, p.[Date], 12) as 'Date', 
	CASE WHEN p.Price NOT LIKE '%,%,%' or p.[Level] <> 'J' or p.Price like '%B%' then p.Price
		 ELSE CONVERT(varchar, floor(p.DiscountMarkup1)) + ', ' +
							    CONVERT(varchar, floor(p.DiscountMarkup2)) + '/' +
							    CONVERT(varchar, floor(p.BreakQuantity1)+1)
		  end AS Price
FROM Pricing p INNER JOIN
	  MAS_POL.dbo.CI_Item i ON p.ItemCode = i.ItemCode INNER JOIN
      dbo.IM_ItemWarehouse_000 q ON i.ItemCode = q.ItemCode INNER JOIN
      MAS_POL.dbo.AP_Vendor v ON i.PrimaryAPDivisionNo = v.APDivisionNo AND i.PrimaryVendorNo = v.VendorNo INNER JOIN
	  dbo.IM_InventoryAvailable ia ON i.ItemCode = ia.ITEMCODE
WHERE    v.UDF_VEND_INACTIVE <> 'Y' AND
		  i.CATEGORY2 <> 'Y' AND 
          i.CATEGORY1 ='Y' AND
		  i.StandardUnitCost > 0 AND
		  i.ProductLine <> 'SAMP' AND 
          i.UDF_RESTRICT_MANAGER='' AND
		  i.UDF_RESTRICT_ALLOCATED <> 'Y' AND
		   q.QuantityOnHand+q.QuantityOnPurchaseOrder>0.04 and
		   Level in ('Y','J')
