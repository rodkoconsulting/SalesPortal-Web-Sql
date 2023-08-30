/****** Object:  View [dbo].[AR_BhTotals_old]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_BhTotals_old]
AS
SELECT     MAS_POL.dbo.SO_SalesOrderHeader.ARDivisionNo, MAS_POL.dbo.SO_SalesOrderHeader.CustomerNo, MAS_POL.dbo.SO_SalesOrderDetail.ItemCode, 
                      SUM(MAS_POL.dbo.SO_SalesOrderDetail.QuantityOrdered) AS QuantityOrdered
FROM         MAS_POL.dbo.SO_SalesOrderHeader INNER JOIN
                      MAS_POL.dbo.SO_SalesOrderDetail ON MAS_POL.dbo.SO_SalesOrderHeader.SalesOrderNo = MAS_POL.dbo.SO_SalesOrderDetail.SalesOrderNo INNER JOIN
                      MAS_POL.dbo.CI_Item ON MAS_POL.dbo.SO_SalesOrderDetail.ItemCode = MAS_POL.dbo.CI_Item.ItemCode
WHERE     (MAS_POL.dbo.SO_SalesOrderDetail.WarehouseCode = '001' or MAS_POL.dbo.SO_SalesOrderDetail.CostOfGoodsSoldAcctKey='00000008M') 
GROUP BY MAS_POL.dbo.SO_SalesOrderHeader.ARDivisionNo, MAS_POL.dbo.SO_SalesOrderHeader.CustomerNo, MAS_POL.dbo.SO_SalesOrderDetail.ItemCode
