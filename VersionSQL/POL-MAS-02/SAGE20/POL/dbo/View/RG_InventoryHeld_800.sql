/****** Object:  View [dbo].[RG_InventoryHeld_800]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[RG_InventoryHeld_800]
AS
SELECT      MAS_POL.dbo.PO_ReturnDetail.ItemCode, Sum(MAS_POL.dbo.PO_ReturnDetail.QuantityOrdered) as RGQuantityHeld
FROM        MAS_POL.dbo.PO_ReturnHeader INNER JOIN
                      MAS_POL.dbo.PO_ReturnDetail ON MAS_POL.dbo.PO_ReturnHeader.ReturnNo = MAS_POL.dbo.PO_ReturnDetail.ReturnNo  
WHERE  MAS_POL.dbo.PO_ReturnDetail.ItemType = '1' and MAS_POL.dbo.PO_ReturnHeader.ShipToCode like 'TAS%' AND MAS_POL.dbo.PO_ReturnDetail.WarehouseCode='800'
GROUP BY MAS_POL.dbo.PO_ReturnDetail.ItemCode
