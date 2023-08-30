/****** Object:  Procedure [dbo].[PortalOrderDetail_sync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalOrderDetail_sync]
	@UserName varchar(25),
	@TimeSync datetime
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CurrentDate Datetime;
	DECLARE @TimeSyncPrev DateTime;
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
    Set @CurrentDate=GETDATE();
SELECT @RepCode = RepCode FROM Web_UserMappings where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_UserMappings where UserName=@UserName      
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(h.InvoiceNo,7) as SalesOrderNo,
		   right(LineKey,3) as LineKey,
		   left(ItemCode,30) as ItemCode,
		   CAST(ROUND(QuantityOrdered,2) AS FLOAT) as Quantity,
		   CAST(ROUND(UnitPrice,2) AS FLOAT) as Price,
		   CAST(ROUND(ExtensionAmt,2) AS FLOAT) as Total,
		   left(CommentText,2048) as Comment
INTO #temp_PortalOrderDetail_Current
FROM         MAS_POL.dbo.SO_InvoiceDetail d INNER JOIN
                      MAS_POL.dbo.SO_InvoiceHeader h ON d.InvoiceNo = h.InvoiceNo
WHERE    ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%'))
UNION ALL
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(MAS_POL.dbo.SO_SalesOrderDetail.SalesOrderNo,7) as SalesOrderNo,
		   right(LineKey,3) as LineKey,
		   left(ItemCode,30) as ItemCode,
		   CAST(ROUND(QuantityOrdered,2) AS FLOAT) as Quantity,
		   CAST(ROUND(UnitPrice,2) AS FLOAT) as Price,
		   CAST(ROUND(ExtensionAmt,2) AS FLOAT) as Total,
		   left(CommentText,2048) as Comment
FROM         MAS_POL.dbo.SO_SalesOrderDetail INNER JOIN
                      MAS_POL.dbo.SO_SalesOrderHeader ON MAS_POL.dbo.SO_SalesOrderDetail.SalesOrderNo = MAS_POL.dbo.SO_SalesOrderHeader.SalesOrderNo
WHERE    ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%')) and CAST(ROUND(QuantityOrdered,2) AS FLOAT) > 0 AND MAS_POL.dbo.SO_SalesOrderHeader.CurrentInvoiceNo = ''
UNION ALL
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(h.InvoiceNo,7) as SalesOrderNo,
		   right(DetailSeqNo,3) as LineKey,
		   left(ItemCode,30) as ItemCode,
		   CAST(ROUND(QuantityShipped,2) AS FLOAT) as Quantity,
		   CAST(ROUND(UnitPrice,2) AS FLOAT) as Price,
		   CAST(ROUND(ExtensionAmt,2) AS FLOAT) as Total,
		   left(CommentText,2048) as Comment
FROM         MAS_POL.dbo.AR_InvoiceHistoryDetail INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryHeader h ON MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo = h.InvoiceNo and
					  h.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo
WHERE    InvoiceDate > GETDATE() and ItemCode != '/COBRA' and ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%'))
UNION ALL
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(dbo.PO_PurchaseOrderHeader.PurchaseOrderNo,7) as SalesOrderNo,
		   right(LineKey,3) as LineKey,
		   left(ItemCode,30) as ItemCode,
		   CAST(ROUND(QuantityOrdered,2) AS FLOAT) as Quantity,
		   0.0 as Price,
		   0.0 as Total,
		   left(CommentText,2048) as Comment                   
FROM         dbo.PO_PurchaseOrderDetail INNER JOIN
                      dbo.PO_PurchaseOrderHeader ON dbo.PO_PurchaseOrderDetail.PurchaseOrderNo = dbo.PO_PurchaseOrderHeader.PurchaseOrderNo INNER JOIN
                      PO_ShipToAddress ON PO_PurchaseOrderHeader.ShipToCode = PO_ShipToAddress.ShipToCode
WHERE PO_PurchaseOrderHeader.OrderType = 'X' AND PO_PurchaseOrderHeader.OrderStatus <> 'X' AND ((@AccountType = 'REP' and PO_ShipToAddress.UDF_REP_CODE = @RepCode) or @AccountType = 'OFF')
SELECT @TimeSyncPrev = MAX(TimeSync) FROM PortalOrderDetail_Previous where RepCode=@RepCode
IF(@TimeSyncPrev = @TimeSync)
BEGIN
	SELECT
	CONVERT(varchar, @CurrentDate , 121) as TimeSync,
	MIN(Operation) as Operation,
	[SalesOrderNo],
	[LineKey],
	CASE WHEN MIN(Operation)<>'D' THEN [ItemCode] ELSE '' END AS ItemCode,
	CASE WHEN MIN(Operation)<>'D' THEN [Quantity] ELSE 0 END AS Quantity,
	CASE WHEN MIN(Operation)<>'D' THEN [Price] ELSE 0 END AS Price,
	CASE WHEN MIN(Operation)<>'D' THEN [Total] ELSE 0 END AS Total,
	CASE WHEN MIN(Operation)<>'D' THEN [Comment] ELSE '' END AS Comment
FROM
(
  SELECT 'D' as Operation, [SalesOrderNo],[LineKey],[ItemCode],[Quantity],[Price],[Total],[Comment]
  FROM dbo.PortalOrderDetail_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [SalesOrderNo],[LineKey],[ItemCode],[Quantity],[Price],[Total],[Comment]
  FROM #temp_PortalOrderDetail_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [SalesOrderNo],[LineKey],[ItemCode],[Quantity],[Price],[Total],[Comment]
   
HAVING COUNT(*) = 1
 
ORDER BY  [SalesOrderNo],[LineKey]

END
ELSE
BEGIN
 SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
	'C' as Operation,
	[SalesOrderNo],[LineKey],[ItemCode],[Quantity],[Price],[Total],[Comment]
  FROM #temp_PortalOrderDetail_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalOrderDetail_Previous where RepCode = @RepCode
INSERT PortalOrderDetail_Previous(TimeSync, RepCode, SalesOrderNo, LineKey, ItemCode, Quantity, Price, Total, Comment)
SELECT
	TimeSync,
	RepCode,
	[SalesOrderNo],[LineKey],[ItemCode],[Quantity],[Price],[Total],[Comment]
FROM #temp_PortalOrderDetail_Current
WHERE RepCode = @RepCode
END

END
