/****** Object:  View [dbo].[PortalWebOrdersMain]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebOrdersMain]
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
SELECT     h.SalespersonNo as Rep
           ,h.SalespersonDivisionNo as RepDiv 
		   ,ARDivisionNo
		   ,CustomerNo
		   ,h.InvoiceNo as OrderNo
		   ,CASE WHEN YEAR(OrderDate)<2000 THEN ShipDate ELSE OrderDate END as OrderDate
		   ,ShipDate
		   ,'' AS ArrivalDate
		   ,CASE WHEN Comment LIKE '%BILL & HOLD INVOICE%' THEN 'BHI'
				WHEN Comment LIKE '%BILL & HOLD%' AND d.ExtensionAmt > 0 and OrderType = '1' THEN 'BHI'
				WHEN Comment LIKE '%BILL & HOLD TRANSFER%' THEN 'BHT'
				WHEN d.ExtensionAmt = 0 THEN 'BHS'
				ELSE 'I'
		   END as OrderType
		   ,'' as HoldCode
		   ,left(UDF_NJ_COOP,10) as CoopNo
		   ,Comment
		   ,'Y' AS Invoiced
		   ,ItemCode
		   ,d.ItemCodeDesc
		   ,QuantityOrdered as Quantity
		   ,UnitPrice as Price
		   ,ExtensionAmt as Total
		   ,d.CommentText as LineComment
FROM         MAS_POL.dbo.SO_InvoiceHeader h INNER JOIN MAS_POL.dbo.SO_InvoiceDetail d
				ON h.InvoiceNo = d.InvoiceNo
UNION ALL
SELECT     h.SalespersonNo as Rep
		   ,h.SalespersonDivisionNo as RepDiv
		   ,ARDivisionNo
		   ,CustomerNo
		   ,h.SalesOrderNo as OrderNo
		   ,OrderDate
		   ,ShipExpireDate as ShipDate
		   ,CASE WHEN CANCELREASONCODE = 'IN' THEN UDF_ARRIVAL_DATE ELSE '' END AS ArrivalDate
		   ,CASE WHEN d.ExtensionAmt = 0 AND Comment NOT LIKE '%B&H HOLD%' AND CancelReasonCode IN ('NSQTY','NOTE','PO','') THEN 'BHS'
				 WHEN d.ExtensionAmt = 0 AND CancelReasonCode IN ('NSQTY','APP','NOTE','CRED','BH') THEN 'BHH'
				 WHEN CancelReasonCode IN ('IN') THEN 'BO'
				 WHEN CancelReasonCode IN ('MO','BO') THEN CancelReasonCode
				 ELSE 'S'
		   END as OrderType
		   ,CancelReasonCode as HoldCode
		   ,UDF_NJ_COOP as CoopNo
		   ,Comment
		   ,'' AS Invoiced
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
SELECT     h.SalespersonNo as Rep
		   ,h.SalespersonDivisionNo as RepDiv
		   ,ARDivisionNo
		   ,CustomerNo
		   ,h.InvoiceNo as OrderNo
		   ,CASE WHEN Year(OrderDate) > 1900 THEN OrderDate ELSE InvoiceDate END AS OrderDate
		   ,InvoiceDate as ShipDate
		   ,'' AS ArrivalDate
		   ,'I' as OrderType
		   ,'' as HoldCode
		   ,UDF_NJ_COOP as CoopNo
		   ,Comment
		   ,'Y' AS Invoiced
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
SELECT	   a.UDF_REP_CODE as Rep
           ,'00' as RepDiv
		   ,'' as ARDivisionNo
		   ,'Samples - ' + Replace(a.ShipToName,'''','') as CustomerNo
		   ,po.PurchaseOrderNo as OrderNo
		   ,PurchaseOrderDate as OrderDate
		   ,RequiredExpireDate as ShipDate
		   , '' AS ArrivalDate
		   ,'SM' as OrderType
		   ,'SM' as HoldCode
		   ,'' as CoopNo
		   ,Comment
		   ,'' AS Invoiced
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
SELECT
	Rep
	,o.ARDivisionNo + o.CustomerNo AS AcctNo 
	,OrderNo as OrdNo
	,OrderType as Typ
	,HoldCode as Hold
	,CONVERT(varchar,OrderDate,23) as OrdDate
	,CASE WHEN HoldCode NOT IN ('MO','IN','BH') THEN CONVERT(varchar,ShipDate,23) ELSE '' END AS ShpDate
	,CASE WHEN HoldCode IN ('MO','IN','BH') THEN CONVERT(varchar,ShipDate,23) ELSE '' END AS ExpDate
	,CASE WHEN ArrivalDate !='' THEN CONVERT(varchar,ArrivalDate,23) ELSE '' END as ArrDate
	,o.Comment as Cmt
	,CoopNo as Coop
	,CASE WHEN UDF_TERRITORY = 'NY Metro' then 'NYM'
				 WHEN UDF_TERRITORY = 'NY Long Island' then 'NYL'
				 WHEN UDF_TERRITORY = 'NY Upstate' then 'NYU'
				 WHEN UDF_TERRITORY = 'NY Westchester / Hudson' then 'NYW'
				 WHEN UDF_TERRITORY = 'NJ' then 'NJ'
				 WHEN UDF_TERRITORY = 'PA' then 'PA'
				 ELSE 'MAN'
				 END AS Ter
	,o.ItemCode as Item
	,o.ItemCodeDesc as [Desc]
	, CAST(ROUND(Quantity,2) AS FLOAT) AS Qty
	, CAST(ROUND(Price,2) AS FLOAT) AS Pri
	, CAST(ROUND(Total,2) AS FLOAT) AS Tot
	, LineComment as ItmCmt
FROM ORDERS o
INNER JOIN MAS_POL.dbo.AR_Salesperson s ON o.Rep = s.SalespersonNo and o.RepDiv = s.SalespersonDivisionNo
WHERE o.ItemCode NOT IN ('/COBRA')
