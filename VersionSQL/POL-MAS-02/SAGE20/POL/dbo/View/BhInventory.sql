/****** Object:  View [dbo].[BhInventory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[BhInventory]
AS
SELECT        d.ItemCode
			, ROUND(SUM(CAST(ROUND(d.QuantityOrdered * REPLACE(d.UnitOfMeasure, 'C', ''), 0) AS INT)) / CAST(REPLACE(d.UnitOfMeasure, 'C', '') AS DECIMAL), 5, 1) AS Cases
			, MAX(q.QuantityOnHand) as OnHand
FROM            dbo.SO_SalesOrderHeader AS h INNER JOIN
                         dbo.SO_SalesOrderDetail AS d ON h.SalesOrderNo = d.SalesOrderNo LEFT OUTER JOIN
                         dbo.IM_ItemWarehouse_000 AS q ON d.ItemCode = q.ItemCode
WHERE        (d.UnitPrice = 0) AND (d.ItemType = '1') AND (h.CurrentInvoiceNo = '') AND (d.QuantityOrdered > 0)
GROUP BY d.ItemCode, d.UnitOfMeasure
