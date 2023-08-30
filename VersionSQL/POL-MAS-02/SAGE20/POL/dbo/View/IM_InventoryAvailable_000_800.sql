/****** Object:  View [dbo].[IM_InventoryAvailable_000_800]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_InventoryAvailable_000_800] AS
SELECT    Wh000.ITEMCODE
			, Wh000.QuantityAvailable + IsNull(Wh800.QuantityAvailable,0) as QuantityAvailable
			, Wh000.QuantityHeld + IsNull(Wh800.QuantityHeld,0) as QuantityHeld
			, Wh000.OnMO + IsNull(Wh800.OnMO,0) as OnMO
			, Wh000.OnSO + IsNull(Wh800.OnSO,0) as OnSO
			, Wh000.OnBO + IsNull(Wh800.OnBO,0) as OnBO
			, Wh000.STANDARDUNITOFMEASURE
			, Wh000.QtyOnHand + IsNull(Wh800.QtyOnHand,0) as QtyOnHand
			, Wh000.QtyOnPurchaseOrder + IsNull(Wh800.QtyOnPurchaseOrder,0) as QtyOnPurchaseOrder
FROM  [dbo].[IM_InventoryAvailable] AS Wh000 LEFT OUTER JOIN [dbo].[IM_InventoryAvailable_800] AS Wh800 on Wh000.ITEMCODE = Wh800.ItemCode
