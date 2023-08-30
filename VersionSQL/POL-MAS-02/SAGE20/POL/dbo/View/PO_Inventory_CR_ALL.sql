/****** Object:  View [dbo].[PO_Inventory_CR_ALL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PO_Inventory_CR_ALL]
AS
SELECT     ItemCode, SUM(QuantityOrdered) AS QtyOrdered, SUM(QuantityReceived) AS QtyReceived
FROM         dbo.PO_Inventory_CR
GROUP BY ItemCode
