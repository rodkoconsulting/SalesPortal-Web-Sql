/****** Object:  View [dbo].[IM_InventoryAvailable_800]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_InventoryAvailable_800] AS
SELECT     MAS_POL.dbo.CI_ITEM.ITEMCODE,
			CASE WHEN MAS_POL.dbo.CI_ITEM.INACTIVEITEM = 'Y' THEN 0 ELSE CONVERT(Numeric(10, 5), ISNULL(dbo.IM_ItemWarehouse_800.QuantityOnHand, 0) - ISNULL(dbo.SO_InventoryHeld_800.QuantityHeld, 0) - ISNULL(dbo.SO_InventoryHeld_800.QuantityHeldBh, 0) 
                      - ISNULL(dbo.MO_InventoryHeld_800.QuantityHeld,0) - ISNULL(dbo.PO_InventoryHeld_800.POQuantityHeld, 0) - ISNULL(dbo.RG_InventoryHeld_800.RGQuantityHeld, 0)) END AS QuantityAvailable,
            CONVERT(Numeric(10, 5), ISNULL(dbo.SO_InventoryHeld_800.QuantityHeld, 0) + ISNULL(dbo.PO_InventoryHeld_800.POQuantityHeld, 0) + ISNULL(dbo.RG_InventoryHeld_800.RGQuantityHeld, 0) + ISNULL(dbo.MO_InventoryHeld_800.QuantityHeld,0)) 
                      AS QuantityHeld,
            CONVERT(Numeric(10,5), ISNULL(dbo.MO_InventoryHeld_800.QuantityHeld,0)) as OnMO,
            CONVERT(Numeric(10,5), (ISNULL(dbo.SO_InventoryHeld_800.QuantityHeld, 0))) as OnSO,
            CONVERT(Numeric(10,5), ISNULL(dbo.BO_InventoryHeld_800.QuantityHeld,0)) as OnBO,
                      MAS_POL.dbo.CI_ITEM.STANDARDUNITOFMEASURE,
                      CONVERT(Numeric(10,5), (ISNULL(dbo.IM_ItemWarehouse_800.QuantityOnHand, 0) - ISNULL(dbo.SO_InventoryHeld_800.QuantityHeldBh, 0))) AS QtyOnHand,
                      ISNULL(dbo.IM_ItemWarehouse_800.QuantityOnPurchaseOrder, 0) AS QtyOnPurchaseOrder
FROM         dbo.PO_InventoryHeld_800 RIGHT OUTER JOIN
                      dbo.MO_InventoryHeld_800 RIGHT OUTER JOIN
                      dbo.BO_InventoryHeld_800 RIGHT OUTER JOIN
                      dbo.IM_ItemWarehouse_800 ON dbo.BO_InventoryHeld_800.ITEMCODE = dbo.IM_ItemWarehouse_800.ItemCode ON 
                      dbo.MO_InventoryHeld_800.ITEMCODE = dbo.IM_ItemWarehouse_800.ItemCode RIGHT OUTER JOIN
                      MAS_POL.dbo.CI_ITEM ON dbo.IM_ItemWarehouse_800.ItemCode = MAS_POL.dbo.CI_ITEM.ITEMCODE ON 
                      dbo.PO_InventoryHeld_800.ItemCode = dbo.IM_ItemWarehouse_800.ItemCode LEFT OUTER JOIN
                      dbo.RG_InventoryHeld_800 ON dbo.IM_ItemWarehouse_800.ItemCode = dbo.RG_InventoryHeld_800.ItemCode LEFT OUTER JOIN
                      dbo.SO_InventoryHeld_800 ON dbo.IM_ItemWarehouse_800.ItemCode = dbo.SO_InventoryHeld_800.ITEMCODE
WHERE     (MAS_POL.dbo.CI_ITEM.ITEMTYPE = '1')
