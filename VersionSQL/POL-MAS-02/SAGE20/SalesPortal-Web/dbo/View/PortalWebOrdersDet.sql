/****** Object:  View [dbo].[PortalWebOrdersDet]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebOrdersDet]
AS
WITH Po AS
(
	SELECT h.PurchaseOrderNo
			,h.PurchaseOrderDate
			,h.RequiredExpireDate
			,h.Comment
			,h.ShipToCode
			,h.OrderType
			,d.ItemCode
			,d.ItemCodeDesc
			,d.QuantityOrdered
			,d.CommentText
	FROM MAS_POL.dbo.PO_PurchaseOrderHeader h
			INNER JOIN MAS_POL.dbo.PO_PurchaseOrderDetail d ON h.PurchaseOrderNo = d.PurchaseOrderNo
		    WHERE h.OrderStatus NOT in ('X') and h.OrderType in ('S','X') and h.WarehouseCode = '000' AND (d.QuantityOrdered - d.QuantityReceived > 0)
),
ORDERS AS
( 
SELECT     DISTINCT 
		   h.SalespersonNo as Rep
		   ,ItemCode
		   ,d.ItemCodeDesc
		   ,QuantityOrdered as Quantity
		   ,UnitPrice as Price
		   ,ExtensionAmt as Total
		   ,d.CommentText as LineComment
FROM         MAS_POL.dbo.SO_InvoiceHeader h INNER JOIN MAS_POL.dbo.SO_InvoiceDetail d
				ON h.InvoiceNo = d.InvoiceNo
UNION ALL
SELECT     DISTINCT 
		   h.SalespersonNo as Rep
		   ,ItemCode
		   ,d.ItemCodeDesc
		   ,QuantityOrdered as Quantity
		   ,UnitPrice as Price
		   ,ExtensionAmt as Total
		   ,CommentText as LineComment
FROM         MAS_POL.dbo.SO_SalesOrderHeader h INNER JOIN
                       MAS_POL.dbo.SO_SalesOrderDetail d ON h.SalesOrderNo = d.SalesOrderNo
WHERE    CurrentInvoiceNo = '' AND (ROUND(QuantityOrdered,2) > 0 or ROUND(ExtensionAmt,2) > 0)
UNION ALL
SELECT     DISTINCT 
		   h.SalespersonNo as Rep
		   ,ItemCode
		   ,d.ItemCodeDesc
		   ,QuantityShipped as Quantity
		   ,UnitPrice as Price
		   ,ExtensionAmt as Total
		   ,CommentText as LineComment
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN
                       MAS_POL.dbo.AR_InvoiceHistoryDetail d ON h.InvoiceNo = d.InvoiceNo and
					   h.HeaderSeqNo = d.HeaderSeqNo
WHERE    InvoiceDate > GETDATE() and InvoiceDate < DateAdd(YEAR, 1, GETDATE())
UNION ALL
SELECT	   DISTINCT
	       a.UDF_REP_CODE as Rep
		   ,ItemCode
		   ,ItemCodeDesc
		   ,QuantityOrdered as Quantity
		   ,0.0 as Price
		   ,0.0 as Total
		   ,CommentText as LineComment
FROM po
	INNER JOIN MAS_POL.dbo.PO_ShipToAddress a ON po.ShipToCode = a.ShipToCode
	WHERE po.OrderType = 'X' AND po.RequiredExpireDate > GETDATE()
)
SELECT DISTINCT
	Rep
	,o.ItemCode as Item
	, CASE WHEN i.UDF_BRAND_NAMES = '' THEN o.ItemCodeDesc ELSE '' END AS 'Desc'
	, CAST(ROUND(Quantity,2) AS FLOAT) AS Qty
	, CAST(ROUND(Price,2) AS FLOAT) AS Pri
	, CAST(ROUND(Total,2) AS FLOAT) AS Tot
	, LineComment as ItmCmt
FROM ORDERS o
INNER JOIN MAS_POL.dbo.CI_Item AS i ON i.ItemCode = o.ItemCode
WHERE o.ItemCode NOT IN ('/COBRA')
