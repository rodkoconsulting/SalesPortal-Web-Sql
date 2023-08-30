/****** Object:  View [dbo].[IM_YtdGp]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[IM_YtdGp]
AS
SELECT     ItemCode, WarehouseCode, FiscalCalYear, SUM(DollarsSold) AS YtdDollarsSold, SUM(CostOfGoodsSold) AS YtdCostOfGoodsSold
FROM         MAS_POL.dbo.IM_ItemWhseHistoryByPeriod
GROUP BY ItemCode, WarehouseCode, FiscalCalYear
