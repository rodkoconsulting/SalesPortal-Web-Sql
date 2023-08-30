/****** Object:  Procedure [dbo].[PortalWebOrders]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebOrders]
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
SELECT @RepCode = RepCode FROM Web_UserMappings where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_UserMappings where UserName=@UserName;

WITH ORDERS AS
(     
SELECT     h.SalespersonNo as Rep
		   ,ARDivisionNo + CustomerNo as AcctNo
		   ,SalesOrderNo as OrderNo
		   ,CONVERT(varchar,CASE WHEN YEAR(OrderDate)<2000 THEN ShipDate ELSE OrderDate END,12) as OrderDate
		   ,CONVERT(varchar, ShipDate, 12) as ShipDate
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
		   ,CAST(ROUND(QuantityOrdered,2) AS FLOAT) as Quantity
		   ,CAST(ROUND(UnitPrice,2) AS FLOAT) as Price
		   ,CAST(ROUND(ExtensionAmt,2) AS FLOAT) as Total
		   ,d.CommentText as LineComment
		   ,h.CustomerPONo as UserName
		   ,IsNull(h.UDF_ORDER_ID,'') as Id
FROM         MAS_POL.dbo.SO_InvoiceHeader h INNER JOIN MAS_POL.dbo.SO_InvoiceDetail d
				ON h.InvoiceNo = d.InvoiceNo
WHERE    SalesOrderNo = '' and ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%') or (@AccountType = 'EXT'))
UNION ALL
SELECT     h.SalespersonNo as Rep
		   ,ARDivisionNo + CustomerNo as AcctNo
		   ,h.SalesOrderNo as OrderNo
		   ,CONVERT(varchar, OrderDate, 12) as OrderDate
		   ,CONVERT(varchar, ShipExpireDate, 12) as ShipDate
		   ,CASE WHEN CANCELREASONCODE = 'IN' THEN CONVERT(varchar, UDF_ARRIVAL_DATE, 12) ELSE '' END AS ArrivalDate
		   ,CASE WHEN d.ExtensionAmt = 0 AND Comment NOT LIKE '%B&H HOLD%' AND CancelReasonCode IN ('NSQTY','NOTE','PO','') THEN 'BHS'
				 WHEN d.ExtensionAmt = 0 AND CancelReasonCode IN ('NSQTY','APP','NOTE','CRED','BH') THEN 'BHH'
				 WHEN CancelReasonCode IN ('IN') THEN 'BO'
				 WHEN CancelReasonCode IN ('MO','BO') THEN CancelReasonCode
				 ELSE 'S'
		   END as OrderType
		   ,CASE WHEN @UserName = 'SevenFifty' AND CancelReasonCode IN ('COOP') THEN ''
				 ELSE CancelReasonCode
			END as HoldCode
		   ,UDF_NJ_COOP as CoopNo
		   ,Comment
		   ,'' AS Invoiced
		   ,ItemCode
		   ,CAST(ROUND(QuantityOrdered,2) AS FLOAT) as Quantity
		   ,CAST(ROUND(UnitPrice,2) AS FLOAT) as Price
		   ,CAST(ROUND(ExtensionAmt,2) AS FLOAT) as Total
		   ,CommentText as LineComment
		   ,h.CustomerPONo as UserName
		   ,IsNull(h.UDF_ORDER_ID,'') as Id
FROM         MAS_POL.dbo.SO_SalesOrderHeader h INNER JOIN
                       MAS_POL.dbo.SO_SalesOrderDetail d ON h.SalesOrderNo = d.SalesOrderNo
WHERE    ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%') or (@AccountType = 'EXT')) and (CAST(ROUND(QuantityOrdered,2) AS FLOAT) > 0 or ROUND(ExtensionAmt,2) > 0)
UNION ALL
SELECT     h.SalespersonNo as Rep
		   ,ARDivisionNo + CustomerNo as AcctNo
		   ,h.InvoiceNo as OrderNo
		   ,CONVERT(varchar, CASE WHEN Year(OrderDate) > 1900 THEN OrderDate ELSE InvoiceDate END, 12) as OrderDate
		   ,CONVERT(varchar, InvoiceDate, 12) as ShipDate
		   ,'' AS ArrivalDate
		   ,'I' as OrderType
		   ,'' as HoldCode
		   ,UDF_NJ_COOP as CoopNo
		   ,Comment
		   ,'Y' AS Invoiced
		   ,ItemCode
		   ,CAST(ROUND(QuantityShipped,2) AS FLOAT) as Quantity
		   ,CAST(ROUND(UnitPrice,2) AS FLOAT) as Price
		   ,CAST(ROUND(ExtensionAmt,2) AS FLOAT) as Total
		   ,CommentText as LineComment
		   ,h.CustomerPONo as UserName
		   ,IsNull(h.UDF_ORDER_ID,'') as Id
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN
                       MAS_POL.dbo.AR_InvoiceHistoryDetail d ON h.InvoiceNo = d.InvoiceNo and
					   h.HeaderSeqNo = d.HeaderSeqNo
WHERE    InvoiceDate > GETDATE() and InvoiceDate < DateAdd(YEAR, 1, GETDATE()) AND ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%')or (@AccountType = 'EXT'))
UNION ALL
SELECT	   a.Rep
		   ,'00' + a.ShipToCode as AcctNo
		   ,h.PurchaseOrderNo as OrderNo
		   ,CONVERT(varchar, PurchaseOrderDate, 12) as OrderDate
		   ,CONVERT(varchar, RequiredExpireDate, 12) as ShipDate
		   ,'' AS ArrivalDate
		   ,'SM' as OrderType
		   ,'SM' as HoldCode
		   ,'' as CoopNo
		   ,Comment
		   ,'' AS Invoiced
		   ,ItemCode
		   ,CAST(ROUND(QuantityOrdered,2) AS FLOAT) as Quantity
		   ,0.0 as Price
		   ,0.0 as Total
		   ,CommentText as LineComment
		   ,'' as UserName
		   ,'' as Id     
FROM PO_PurchaseOrderHeader h
			INNER JOIN PortalPoAddress a ON h.ShipToCode = a.ShipToCode
			INNER JOIN PO_PurchaseOrderDetail d ON h.PurchaseOrderNo = d.PurchaseOrderNo
		    WHERE h.OrderType = 'X' AND h.OrderStatus <> 'X' AND h.RequiredExpireDate > GETDATE() AND ((@AccountType = 'REP' and a.Rep = @RepCode) or @AccountType = 'OFF')
)
SELECT CASE WHEN @AccountType = 'REP' THEN '' ELSE o.Rep END AS Rep
		, o.AcctNo
		, o.OrderNo
		, o.OrderDate
		, o.ShipDate
		, o.ArrivalDate
		, o.OrderType
		, o.HoldCode
		, o.CoopNo
		, o.Comment
		, o.Invoiced
		, o.ItemCode
		, o.Quantity
		, o.Price
		, o.Total
		, o.LineComment
		, CASE WHEN @UserName <> 'SevenFifty' THEN '' ELSE o.Id END AS Id
		,CASE WHEN UDF_TERRITORY = 'NY Metro' then 'NYM'
				 WHEN UDF_TERRITORY = 'NY Long Island' then 'NYL'
				 WHEN UDF_TERRITORY = 'NY Upstate' then 'NYU'
				 WHEN UDF_TERRITORY = 'NY Westchester / Hudson' then 'NYW'
				 WHEN UDF_TERRITORY = 'NJ' then 'NJ'
				 WHEN UDF_TERRITORY = 'Pennsylvania' then 'PA'
				 ELSE 'MAN'
				 END AS Region
		,CASE WHEN o.HoldCode = 'BO' THEN IsNull(CONVERT(varchar, eta.RequiredDate, 12),'') ELSE '' END AS BOETA
FROM ORDERS o
		INNER JOIN AR_Salesperson s ON o.Rep = s.SalespersonNo
		LEFT OUTER JOIN dbo.PO_Inventory_ETA eta ON o.ItemCode = eta.ItemCode
WHERE s.SalespersonDivisionNo = '00' and (@UserName <> 'SevenFifty' or (@UserName = 'SevenFifty' and o.UserName = 'SevenFifty'))
END
