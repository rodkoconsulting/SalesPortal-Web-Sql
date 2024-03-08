/****** Object:  View [dbo].[VirtualFeed_Zachys_InventoryQuery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.VirtualFeed_Zachys_InventoryQuery
AS
SELECT      i.ITEMCODE AS [Sku]
			, CAST(ROUND(av.QuantityAvailable * IsNull(dbo.TryConvertUom(Replace(i.STANDARDUNITOFMEASURE, 'C', '')), 12),0) as INT) as [Available to Sell]
FROM         MAS_POL.dbo.CI_Item i INNER JOIN
					  dbo.VirtualFeed_Zachys_Items z ON i.ItemCode = z.ItemCode INNER JOIN
                      dbo.IM_InventoryAvailable av ON i.ItemCode = av.ItemCode INNER JOIN
                      MAS_POL.dbo.AP_Vendor ven ON i.PrimaryAPDivisionNo = ven.APDivisionNo AND i.PrimaryVendorNo = ven.VendorNo
WHERE		ven.UDF_VEND_INACTIVE <> 'Y' AND
			i.CATEGORY1 ='Y' AND
			i.StandardUnitCost > 0
