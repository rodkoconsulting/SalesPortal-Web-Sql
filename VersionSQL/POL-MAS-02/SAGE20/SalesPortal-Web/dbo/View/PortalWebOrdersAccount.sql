/****** Object:  View [dbo].[PortalWebOrdersAccount]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebOrdersAccount]
AS
WITH 
Po AS
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
		   SalespersonNo as Rep
		   ,ARDivisionNo
		   ,CustomerNo
FROM         MAS_POL.dbo.SO_InvoiceHeader
UNION ALL
SELECT		DISTINCT
			SalespersonNo as Rep
			,ARDivisionNo
		    ,CustomerNo
FROM         MAS_POL.dbo.SO_SalesOrderHeader h INNER JOIN
                       MAS_POL.dbo.SO_SalesOrderDetail d ON h.SalesOrderNo = d.SalesOrderNo
WHERE    CurrentInvoiceNo = '' AND (ROUND(QuantityOrdered,2) > 0 or ROUND(ExtensionAmt,2) > 0)
UNION ALL
SELECT     DISTINCT
			SalespersonNo as Rep
			,ARDivisionNo
		   ,CustomerNo
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader
WHERE    InvoiceDate > GETDATE() and InvoiceDate < DateAdd(YEAR, 1, GETDATE())
UNION ALL
SELECT	   DISTINCT
			a.UDF_REP_CODE as Rep
		   ,'' as ARDivisionNo
		   ,'Samples - ' + Replace(a.ShipToName,'''','') as CustomerNo
FROM po
	INNER JOIN MAS_POL.dbo.PO_ShipToAddress a ON po.ShipToCode = a.ShipToCode
	WHERE po.OrderType = 'X' AND po.RequiredExpireDate > GETDATE()
)
SELECT DISTINCT
	Rep
	,o.ARDivisionNo + o.CustomerNo AS AcctNo 
	,IsNull(c.CustomerName,o.CustomerNo) as Acct
	,IsNull(c.UDF_AFFILIATIONS,'') as Aff
	,CASE WHEN SUBSTRING(IsNull(c.CUSTOMERTYPE,''),3,2)='ON' THEN 'On' ELSE 'Off' END AS Prem
FROM ORDERS o
LEFT OUTER JOIN MAS_POL.dbo.AR_Customer c on o.ARDivisionNo = c.ARDivisionNo and o.CustomerNo = c.CustomerNo
