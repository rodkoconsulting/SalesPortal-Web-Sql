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
			,h.UDF_AVAILABLE_COMMENT
			,h.WarehouseCode
	FROM MAS_POL.dbo.PO_PurchaseOrderHeader h
			INNER JOIN MAS_POL.dbo.PO_PurchaseOrderDetail d ON h.PurchaseOrderNo = d.PurchaseOrderNo
		    WHERE h.OrderStatus NOT in ('X') and h.OrderType in ('S','X') and h.WarehouseCode = '000' AND (d.QuantityOrdered - d.QuantityReceived > 0)
),
PoEta AS
(
	SELECT ItemCode, Min(RequiredExpireDate) As RequiredDate
	FROM Po
	WHERE OrderType = 'S' and RequiredExpireDate != '1/1/1753'
	GROUP BY ItemCode
),
Comment AS
(
SELECT ROW_NUMBER() OVER (PARTITION BY ItemCode ORDER BY ItemCode, PurchaseOrderDate) AS 'RN',
ItemCode, UDF_AVAILABLE_COMMENT
FROM         Po
WHERE     UDF_AVAILABLE_COMMENT != '' and OrderType='S'and WarehouseCode='000'
),
AvailableComment AS
(
SELECT     ItemCode, UDF_AVAILABLE_COMMENT
FROM Comment
WHERE RN = 1
),
ORDERS AS
( 
SELECT     DISTINCT 
		   h.InvoiceNo as OrderNo
		   ,'' as HoldCode
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
		   h.SalesOrderNo as OrderNo
		   ,CancelReasonCode as HoldCode
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
		   h.InvoiceNo as OrderNo
		   ,'' as HoldCode
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
	       po.PurchaseOrderNo as OrderNo
		   ,'' as HoldCode
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
	OrderNo as OrdNo
	,o.ItemCode as Item
	, CASE WHEN i.UDF_BRAND_NAMES = '' THEN o.ItemCodeDesc ELSE '' END AS 'Desc'
	, CONVERT(DECIMAL(9,4),(ROUND(Quantity,4))) AS Qty
	, CONVERT(DECIMAL(9,2),(ROUND(Price,2))) AS Pri
	, CONVERT(DECIMAL(9,2),(ROUND(Total,2))) AS Tot
	, LineComment as ItmCmt
	, CASE WHEN o.HoldCode = 'BO' and NOT eta.RequiredDate IS NULL then CONVERT(varchar,eta.RequiredDate,23) ELSE '' END AS BoEta
	, IsNull(CASE WHEN o.HoldCode = 'BO' and eta.RequiredDate is null THEN ac.UDF_AVAILABLE_COMMENT ELSE NULL END,'') AS AvailCmt
FROM ORDERS o
INNER JOIN MAS_POL.dbo.CI_Item AS i ON i.ItemCode = o.ItemCode
LEFT OUTER JOIN PoEta eta ON i.ItemCode = eta.ItemCode
LEFT OUTER JOIN AvailableComment ac On i.ItemCode = ac.ItemCode
WHERE o.ItemCode NOT IN ('/COBRA')
