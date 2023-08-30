/****** Object:  View [dbo].[BhHeader]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[BhHeader]
AS
SELECT        h.SalesOrderNo, h.WarehouseCodeHeader
FROM            dbo.SO_SalesOrderHeader AS h INNER JOIN
                         dbo.SO_SalesOrderDetail AS d ON h.SalesOrderNo = d.SalesOrderNo
WHERE        (d.UnitPrice = 0) AND (d.ItemType = '1') and (d.QuantityOrdered > 0) and (h.CurrentInvoiceNo = '')
