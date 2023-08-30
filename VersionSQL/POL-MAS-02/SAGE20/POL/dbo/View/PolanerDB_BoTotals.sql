/****** Object:  View [dbo].[PolanerDB_BoTotals]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PolanerDB_BoTotals]
AS
SELECT     dbo.SO_SalesOrderHeader.SalesOrderNo, dbo.SO_SalesOrderDetail.ItemCode
FROM         dbo.SO_SalesOrderHeader INNER JOIN
                      dbo.SO_SalesOrderDetail ON dbo.SO_SalesOrderHeader.SalesOrderNo = dbo.SO_SalesOrderDetail.SalesOrderNo
WHERE     (dbo.SO_SalesOrderHeader.CancelReasonCode = 'BO')
