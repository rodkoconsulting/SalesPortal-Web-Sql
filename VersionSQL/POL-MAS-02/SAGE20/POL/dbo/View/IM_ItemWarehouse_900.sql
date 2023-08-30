/****** Object:  View [dbo].[IM_ItemWarehouse_900]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_ItemWarehouse_900]
AS
SELECT     ItemCode, QuantityOnHand as OnPO, Null as PoDate, Null as RequiredDate, '900' as PurchaseOrderNo
FROM         MAS_POL.dbo.IM_ItemWarehouse
WHERE     (WarehouseCode = '900' and QuantityOnHand > 0) 
