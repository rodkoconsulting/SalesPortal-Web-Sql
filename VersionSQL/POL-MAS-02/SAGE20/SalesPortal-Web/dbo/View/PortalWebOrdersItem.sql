/****** Object:  View [dbo].[PortalWebOrdersItem]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebOrdersItem]
AS
WITH Po AS
(
	SELECT 
			h.RequiredExpireDate
			,h.ShipToCode
			,h.OrderType
			,d.ItemCode
	FROM MAS_POL.dbo.PO_PurchaseOrderHeader h
			INNER JOIN MAS_POL.dbo.PO_PurchaseOrderDetail d ON h.PurchaseOrderNo = d.PurchaseOrderNo
		    WHERE h.OrderStatus NOT in ('X') and h.OrderType in ('S','X') and h.WarehouseCode = '000' AND (d.QuantityOrdered - d.QuantityReceived > 0)
),
ORDERS AS
( 
SELECT     DISTINCT
			h.SalespersonNo as Rep 
		   ,ItemCode
FROM         MAS_POL.dbo.SO_InvoiceHeader h INNER JOIN MAS_POL.dbo.SO_InvoiceDetail d
				ON h.InvoiceNo = d.InvoiceNo
UNION ALL
SELECT     DISTINCT
			h.SalespersonNo as Rep
		   ,ItemCode
FROM         MAS_POL.dbo.SO_SalesOrderHeader h INNER JOIN
                       MAS_POL.dbo.SO_SalesOrderDetail d ON h.SalesOrderNo = d.SalesOrderNo
WHERE    CurrentInvoiceNo = '' AND (ROUND(QuantityOrdered,2) > 0 or ROUND(ExtensionAmt,2) > 0)
UNION ALL
SELECT     DISTINCT
			h.SalespersonNo as Rep
		   ,ItemCode
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN
                       MAS_POL.dbo.AR_InvoiceHistoryDetail d ON h.InvoiceNo = d.InvoiceNo and
					   h.HeaderSeqNo = d.HeaderSeqNo
WHERE    InvoiceDate > GETDATE() and InvoiceDate < DateAdd(YEAR, 1, GETDATE())
UNION ALL
SELECT	   DISTINCT
			a.UDF_REP_CODE as Rep
		   ,ItemCode
FROM po
	INNER JOIN MAS_POL.dbo.PO_ShipToAddress a ON po.ShipToCode = a.ShipToCode
	WHERE po.OrderType = 'X' AND po.RequiredExpireDate > GETDATE()
)
SELECT
	DISTINCT
	Rep
	,o.ItemCode as Code
	, CASE WHEN NOT i.UDF_BRAND_NAMES ='' THEN i.UDF_BRAND_NAMES +' '+ i.UDF_DESCRIPTION +' '+i.UDF_VINTAGE+' ('+REPLACE(i.SalesUnitOfMeasure,'C','')+'/'+(CASE WHEN CHARINDEX('ML',i.UDF_BOTTLE_SIZE)>0 THEN REPLACE(i.UDF_BOTTLE_SIZE,' ML','') ELSE REPLACE(i.UDF_BOTTLE_SIZE,' ','') END)+') '+i.UDF_DAMAGED_NOTES ELSE '' END AS 'Desc'
	, CASE WHEN i.UDF_RESTRICT_ALLOCATED = 'Y' THEN 'Y' ELSE '' END as Allo
FROM ORDERS o
INNER JOIN MAS_POL.dbo.CI_Item i ON o.ItemCode = i.ItemCode
WHERE o.ItemCode NOT LIKE ('%/%')
