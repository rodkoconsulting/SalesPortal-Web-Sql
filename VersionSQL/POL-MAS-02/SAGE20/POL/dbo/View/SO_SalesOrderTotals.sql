/****** Object:  View [dbo].[SO_SalesOrderTotals]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[SO_SalesOrderTotals]
AS
SELECT     SalesOrderNo, Sum(QuantityOrdered) as QuantityTotal, Sum(ExtensionAmt) as AmtTotal
FROM         MAS_POL.dbo.SO_SalesOrderDetail
group by SalesOrderNo
