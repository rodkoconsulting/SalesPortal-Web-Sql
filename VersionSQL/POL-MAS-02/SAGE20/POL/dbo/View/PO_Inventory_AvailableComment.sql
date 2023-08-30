/****** Object:  View [dbo].[PO_Inventory_AvailableComment]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PO_Inventory_AvailableComment]
AS
WITH Comment AS
(
SELECT ROW_NUMBER() OVER (PARTITION BY ItemCode ORDER BY ItemCode, PoDate) AS 'RN',
ItemCode, AvailableComment
FROM         dbo.PO_Inventory_CR
WHERE     AvailableComment != ''  and OrderType='S'and WarehouseCode='000'
)
SELECT     ItemCode, AvailableComment
FROM Comment
WHERE RN = 1
