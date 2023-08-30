/****** Object:  View [dbo].[IM_OversoldItems_Base]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_OversoldItems_Base]
AS
SELECT     MAS_POL.dbo.IM_ItemWarehouse.ItemCode as 'Item Number', 
		 CONVERT(Numeric(10,2),((-1)*(MAS_POL.dbo.IM_ItemWarehouse.QuantityOnHand - (Isnull(SO_InventoryHeld.QuantityHeld,0)) - (Isnull(SO_InventoryHeld.QuantityHeldBh,0)) - (Isnull(MO_InventoryHeld.QuantityHeld,0)) - (ISNULL(dbo.PO_InventoryHeld.POQuantityHeld,0)) - (ISNULL(dbo.RG_InventoryHeld.RGQuantityHeld,0))))) as 'Amount Oversold'
FROM         MAS_POL.dbo.IM_ItemWarehouse LEFT OUTER JOIN
                      dbo.SO_InventoryHeld ON MAS_POL.dbo.IM_ItemWarehouse.ItemCode = dbo.SO_InventoryHeld.ITEMCODE LEFT OUTER JOIN
                      dbo.RG_InventoryHeld ON MAS_POL.dbo.IM_ItemWarehouse.ItemCode = dbo.RG_InventoryHeld.ItemCode LEFT OUTER JOIN
                      dbo.PO_InventoryHeld ON MAS_POL.dbo.IM_ItemWarehouse.ItemCode = dbo.PO_InventoryHeld.ItemCode LEFT OUTER JOIN
                      dbo.MO_InventoryHeld ON MAS_POL.dbo.IM_ItemWarehouse.ItemCode = dbo.MO_InventoryHeld.ItemCode
WHERE     MAS_POL.dbo.IM_ItemWarehouse.WarehouseCode = '000'
