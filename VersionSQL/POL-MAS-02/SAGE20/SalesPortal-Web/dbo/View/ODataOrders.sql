/****** Object:  View [dbo].[ODataOrders]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[ODataOrders]
AS
WITH ORDERS AS
( 
SELECT     h.SalespersonNo as Rep
           ,h.SalespersonDivisionNo as RepDiv
		   ,ARDivisionNo
		   ,CustomerNo
		   ,h.InvoiceNo as OrderNo
		   ,CASE WHEN YEAR(OrderDate)<2000 THEN ShipDate ELSE OrderDate END as OrderDate
		   ,ShipDate
		   ,NULL AS ArrivalDate
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
		   ,ROUND(QuantityOrdered,2) as Quantity
		   ,ROUND(UnitPrice,2) as Price
		   ,ROUND(ExtensionAmt,2) as Total
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
		   --,CASE WHEN CANCELREASONCODE = 'IN' THEN CONVERT(varchar,UDF_ARRIVAL_DATE,12) ELSE '' END AS ArrivalDate
		   ,CASE WHEN CANCELREASONCODE = 'IN' THEN UDF_ARRIVAL_DATE ELSE NULL END AS ArrivalDate
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
		   ,ROUND(QuantityOrdered,2) as Quantity
		   ,ROUND(UnitPrice,2) as Price
		   ,ROUND(ExtensionAmt,2) as Total
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
		   ,ROUND(QuantityShipped,2) as Quantity
		   ,ROUND(UnitPrice,2) as Price
		   ,ROUND(ExtensionAmt,2) as Total
		   ,CommentText as LineComment
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN
                       MAS_POL.dbo.AR_InvoiceHistoryDetail d ON h.InvoiceNo = d.InvoiceNo and
					   h.HeaderSeqNo = d.HeaderSeqNo
WHERE    InvoiceDate > GETDATE() and InvoiceDate < DateAdd(YEAR, 1, GETDATE()) --AND ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%')or (@AccountType = 'EXT'))
UNION ALL
SELECT	   a.Rep
           ,'00' as RepDiv
		   ,'' as ARDivisionNo
		   ,'Samples - ' + a.AcctName as CustomerNo
		   ,h.PurchaseOrderNo as OrderNo
		   ,PurchaseOrderDate as OrderDate
		   ,RequiredExpireDate as ShipDate
		   ,'' AS ArrivalDate
		   ,'SM' as OrderType
		   ,'SM' as HoldCode
		   ,'' as CoopNo
		   ,Comment
		   ,'' AS Invoiced
		   ,ItemCode
		   ,d.ItemCodeDesc
		   ,ROUND(QuantityOrdered,2) as Quantity
		   ,0.0 as Price
		   ,0.0 as Total
		   ,CommentText as LineComment
FROM PO_PurchaseOrderHeader h
			INNER JOIN PortalPoAddress a ON h.ShipToCode = a.ShipToCode
			INNER JOIN PO_PurchaseOrderDetail d ON h.PurchaseOrderNo = d.PurchaseOrderNo
		    WHERE h.OrderType = 'X' AND h.OrderStatus <> 'X' AND h.RequiredExpireDate > GETDATE()
)
SELECT
	Rep
	,OrderNo as OrdNo
	,OrderType as Typ
	,HoldCode as Hold
	--,CONVERT(varchar,OrderDate,12) as OrdDate
	,OrderDate as OrdDate
	--,CASE WHEN HoldCode NOT IN ('MO','IN','BH') THEN CONVERT(varchar,ShipDate,12) ELSE '' END AS ShpDate
	,CASE WHEN HoldCode NOT IN ('MO','IN','BH') THEN ShipDate ELSE NULL END AS ShpDate
	--,CASE WHEN HoldCode IN ('MO','IN','BH') THEN CONVERT(varchar,ShipDate,12) ELSE '' END AS ExpDate
	,CASE WHEN HoldCode IN ('MO','IN','BH') THEN ShipDate ELSE NULL END AS ExpDate
	,ArrivalDate as ArrDate
	--,CASE WHEN o.HoldCode = 'BO' THEN IsNull(CONVERT(varchar, eta.RequiredDate, 12),'') ELSE '' END AS BoEta
	,CASE WHEN o.HoldCode = 'BO' THEN eta.RequiredDate ELSE NULL END AS BoEta
	,IsNull(c.CustomerName,o.CustomerNo) as Acct
	,Comment as Cmt
	,IsNull(c.UDF_AFFILIATIONS,'') as Aff
	,CASE WHEN SUBSTRING(IsNull(c.CUSTOMERTYPE,''),3,2)='ON' THEN 'On' ELSE 'Off' END AS Prem
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
	, CASE WHEN NOT i.UDF_BRAND_NAMES ='' THEN i.UDF_BRAND_NAMES +' '+ i.UDF_DESCRIPTION +' '+i.UDF_VINTAGE+' ('+REPLACE(i.SalesUnitOfMeasure,'C','')+'/'+(CASE WHEN CHARINDEX('ML',i.UDF_BOTTLE_SIZE)>0 THEN REPLACE(i.UDF_BOTTLE_SIZE,' ML','') ELSE REPLACE(i.UDF_BOTTLE_SIZE,' ','') END)+') '+i.UDF_DAMAGED_NOTES ELSE ItemCodeDesc END AS 'Desc'
	, Quantity as Qty
	, Price as Pri
	, Total as Tot
	, LineComment as ItmCmt
FROM ORDERS o
INNER JOIN AR_Salesperson s ON o.Rep = s.SalespersonNo and o.RepDiv = s.SalespersonDivisionNo
LEFT OUTER JOIN CI_Item i ON o.ItemCode = i.ItemCode
LEFT OUTER JOIN dbo.PO_Inventory_ETA eta ON o.ItemCode = eta.ItemCode
LEFT OUTER jOIN AR_Customer c on o.ARDivisionNo = c.ARDivisionNo and o.CustomerNo = c.CustomerNo
