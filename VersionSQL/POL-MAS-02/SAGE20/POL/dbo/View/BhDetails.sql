/****** Object:  View [dbo].[BhDetails]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[BhDetails]
AS
SELECT        h.SalesOrderNo, d.ItemCode, d.WarehouseCode, CostOfGoodsSoldAcctKey, h.WarehouseCodeHeader,  h.CustomerNo, d.QuantityOrdered
FROM            dbo.SO_SalesOrderHeader AS h INNER JOIN
                         dbo.SO_SalesOrderDetail AS d ON h.SalesOrderNo = d.SalesOrderNo
WHERE        (d.UnitPrice = 0) AND (d.ItemType = '1') and (d.QuantityOrdered > 0) and (h.CurrentInvoiceNo = '')
