/****** Object:  View [dbo].[PolanerDB_PoItemTotals_test]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PolanerDB_PoItemTotals_test]
AS
SELECT     dbo.PolanerDb_PoHeader_test.PurchaseOrderNo, dbo.PolanerDb_PoDetails_test.ItemCode, SUM(dbo.PolanerDb_PoDetails_test.Qty) AS Qty
FROM         dbo.PolanerDb_PoHeader_test INNER JOIN
                      dbo.PolanerDb_PoDetails_test ON dbo.PolanerDb_PoHeader_test.PurchaseOrderNo = dbo.PolanerDb_PoDetails_test.PurchaseOrderNo
GROUP BY dbo.PolanerDb_PoHeader_test.PurchaseOrderNo, dbo.PolanerDb_PoDetails_test.ItemCode
