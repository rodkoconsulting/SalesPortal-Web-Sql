/****** Object:  View [dbo].[PO_Inventory_ETA]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PO_Inventory_ETA]
AS
SELECT     ItemCode, MIN(RequiredDate) AS RequiredDate
FROM         dbo.PO_Inventory_CR 
WHERE     RequiredDate > '1/1/2012' and OrderType='S'and WarehouseCode='000'
GROUP BY ItemCode
