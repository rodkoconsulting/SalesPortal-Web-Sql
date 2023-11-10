/****** Object:  Procedure [dbo].[PortalSamplesSync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalSamplesSync]
	@UserName varchar(25),
	@SyncTime varchar(50)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CurrentDate Datetime;
	DECLARE @TimeSyncHeaderPrev DateTime;
	DECLARE @TimeSyncDetailsPrev DateTime;
	DECLARE @TimeSyncAddressPrev DateTime;
	DECLARE @TimeSyncItemsPrev DateTime;
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
	DECLARE @TimeSyncHeader Datetime;
	DECLARE @TimeSyncDetails Datetime;
	DECLARE @TimeSyncAddress Datetime;
	DECLARE @TimeSyncItems Datetime;
	DECLARE @TimeSyncHeaderDay varchar(25);
	DECLARE @TimeSyncHeaderTime varchar(25);
	DECLARE @TimeSyncDetailsDay varchar(25);
	DECLARE @TimeSyncDetailsTime varchar(25);
	DECLARE @TimeSyncAddressDay varchar(25);
	DECLARE @TimeSyncAddressTime varchar(25);
	DECLARE @TimeSyncItemsDay varchar(25);
	DECLARE @TimeSyncItemsTime varchar(25);
	DECLARE @TimeSyncTemp varchar(50);
    Set @CurrentDate=GETDATE();
SELECT @RepCode = RepCode FROM Web_ActiveUsers where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_ActiveUsers where UserName=@UserName  
SET @TimeSyncTemp = @SyncTime
SET @TimeSyncHeaderDay = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncHeaderDay + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncHeaderTime = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncHeaderTime + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncDetailsDay = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncDetailsDay + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncDetailsTime = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncDetailsTime + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncAddressDay = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncAddressDay + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncAddressTime = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncAddressTime + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncItemsDay = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncItemsDay + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncItemsTime =@TimeSyncTemp
SET @TimeSyncHeader = TRY_CONVERT(DATETIME, @TimeSyncHeaderDay + ' ' + @TimeSyncHeaderTime, 121)
SET @TimeSyncDetails = TRY_CONVERT(DATETIME, @TimeSyncDetailsDay + ' ' + @TimeSyncDetailsTime, 121)
SET @TimeSyncAddress = TRY_CONVERT(DATETIME, @TimeSyncAddressDay + ' ' + @TimeSyncAddressTime, 121)
SELECT     distinct @CurrentDate as TimeSync
			, @RepCode as RepCode
			, left(ARDivisionNo,2) as ARDivisionNo
			, left(CustomerNo,20) as CustomerNo
			, left(InvoiceNo,7) as SalesOrderNo
			, CASE WHEN YEAR(OrderDate)<2000 THEN ShipDate ELSE OrderDate END as 'OrderDate'
			, ShipDate as ShipExpireDate
			, NULL AS ArrivalDate
			, CASE WHEN OrderType = '1' THEN 'I' ELSE left(OrderStatus,1) END as OrderStatus
			, '' as HoldCode
			, left(UDF_NJ_COOP,10) as CoopNo
			, Comment
			, left(Replace(ShipToName,'''',''),30) as ShipTo
INTO #temp_PortalOrderHeader_Current
FROM         MAS_POL.dbo.SO_InvoiceHeader
WHERE    ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%'))
UNION ALL
SELECT     distinct @CurrentDate as TimeSync
			, @RepCode as RepCode
			, left(ARDivisionNo,2) as ARDivisionNo
			, left(CustomerNo,20) as CustomerNo
			, left(h.SalesOrderNo,7) as SalesOrderNo
			, OrderDate
			, ShipExpireDate
			, CASE WHEN CANCELREASONCODE = 'IN' THEN UDF_ARRIVAL_DATE ELSE NULL END AS ArrivalDate
			, left(OrderStatus,1) as OrderStatus
			, CASE WHEN CancelReasonCode='MO' and UDF_REVIEW_RESTRICTIONS='N' then 'MOAPP' ELSE left(CancelReasonCode,5) END as HoldCode
			, left(UDF_NJ_COOP,10) as CoopNo
			, Comment
			, left(Replace(ShipToName,'''',''),30) as ShipTo
FROM         MAS_POL.dbo.SO_SalesOrderDetail d INNER JOIN
                      MAS_POL.dbo.SO_SalesOrderHeader h ON d.SalesOrderNo = h.SalesOrderNo
WHERE    ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%')) and (ROUND(QuantityOrdered,2) > 0 or ROUND(ExtensionAmt,2) > 0) AND h.CurrentInvoiceNo = ''
UNION ALL
SELECT     distinct @CurrentDate as TimeSync
			, @RepCode as RepCode
			, left(ARDivisionNo,2) as ARDivisionNo
			, left(CustomerNo,20) as CustomerNo
			, left(InvoiceNo,7) as SalesOrderNo
			, InvoiceDate as 'OrderDate'
			, InvoiceDate as ShipDate
			, NULL AS ArrivalDate
			, 'I' as OrderStatus
			, '' as HoldCode
			, left(IsNull(UDF_NJ_COOP,''),10) as CoopNo
			, Comment
			, left(Replace(ShipToName,'''',''),30) as ShipTo
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader
WHERE    CustomerNo not like 'ZZCO%' and InvoiceDate > GETDATE() and InvoiceDate < DateAdd(YEAR, 1, GETDATE()) and ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%'))
UNION ALL
SELECT  @CurrentDate as TimeSync
		, @RepCode as RepCode
		, '00' as ARDivisionNo
		, left(h.ShipToCode,4) as CustomerNo
		, left(h.PurchaseOrderNo,7) as SalesOrderNo
		, PurchaseOrderDate as OrderDate
		, RequiredExpireDate as ShipExpireDate
		, NULL AS ArrivalDate
		, CASE WHEN OnHold='Y' THEN 'H' ELSE 'O' END as OrderStatus
		,'SM' as HoldCode
		, '' as CoopNo
		, Comment
		, left(AcctName,30) as ShipTo
FROM PO_PurchaseOrderHeader h
INNER JOIN PortalPoAddress a ON h.ShipToCode = a.ShipToCode
WHERE h.OrderType = 'X' AND h.OrderStatus <> 'X' AND h.RequiredExpireDate > GETDATE() AND ((@AccountType = 'REP' and a.Rep = @RepCode) or @AccountType = 'OFF')

SELECT @TimeSyncHeaderPrev = MAX(TimeSync) FROM PortalOrderHeader_Previous where RepCode=@RepCode
SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
	'C' as
	 Operation
	 ,[SalesOrderNo]
	 ,[ARDivisionNo]
	 ,[CustomerNo]
	 ,CONVERT(varchar, [OrderDate], 12) as 'OrderDate'
	 ,CONVERT(varchar, [ShipExpireDate], 12) as 'ShipExpireDate'
	 ,IsNull(CONVERT(varchar, [ArrivalDate], 12),'') as 'ArrivalDate'
	 ,[OrderStatus]
	 ,[HoldCode]
	 ,[CoopNo]
	 ,[Comment]
	 ,ShipTo
  INTO #temp_PortalOrderHeader
  FROM #temp_PortalOrderHeader_Current
  WHERE 1=2
IF(@TimeSyncHeaderPrev = @TimeSyncHeader)
BEGIN
INSERT INTO #temp_PortalOrderHeader
	SELECT
		CONVERT(varchar, @CurrentDate , 121) as TimeSync,
		MIN(Operation) as Operation,
		[SalesOrderNo],
		CASE WHEN MIN(Operation)<>'D' THEN [ARDivisionNo] ELSE '' END AS ARDivisionNo,
		CASE WHEN MIN(Operation)<>'D' THEN [CustomerNo] ELSE '' END AS CustomerNo,
		CASE WHEN MIN(Operation)<>'D' THEN CONVERT(varchar, [OrderDate], 12) ELSE '' END AS OrderDate,
		CASE WHEN MIN(Operation)<>'D' THEN CONVERT(varchar, [ShipExpireDate], 12) ELSE '' END AS ShipExpireDate,
		CASE WHEN MIN(Operation)<>'D' THEN IsNull(CONVERT(varchar, [ArrivalDate], 12),'') ELSE '' END AS ArrivalDate,
		CASE WHEN MIN(Operation)<>'D' THEN [OrderStatus] ELSE '' END AS OrderStatus,
		CASE WHEN MIN(Operation)<>'D' THEN [HoldCode] ELSE '' END AS HoldCode,
		CASE WHEN MIN(Operation)<>'D' THEN [CoopNo] ELSE '' END AS CoopNo,
		CASE WHEN MIN(Operation)<>'D' THEN [Comment] ELSE '' END AS Comment,
		CASE WHEN MIN(Operation)<>'D' THEN [ShipTo] ELSE '' END AS ShipTo
FROM
(
  SELECT 'D' as Operation, [SalesOrderNo],[ARDivisionNo],[CustomerNo],[OrderDate],[ShipExpireDate],[ArrivalDate],[OrderStatus],[HoldCode],[CoopNo],[Comment],ShipTo
  FROM dbo.PortalOrderHeader_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [SalesOrderNo],[ARDivisionNo],[CustomerNo],[OrderDate],[ShipExpireDate],[ArrivalDate],[OrderStatus],[HoldCode],[CoopNo],[Comment],ShipTo
  FROM #temp_PortalOrderHeader_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [SalesOrderNo],[ARDivisionNo],[CustomerNo],[OrderDate],[ShipExpireDate],[ArrivalDate],[OrderStatus],[HoldCode],[CoopNo],[Comment],ShipTo
   
HAVING COUNT(*) = 1
 
ORDER BY  [SalesOrderNo]

END
ELSE
BEGIN 
INSERT INTO #temp_PortalOrderHeader
 SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
	'C' as
	 Operation
	 ,[SalesOrderNo]
	 ,[ARDivisionNo]
	 ,[CustomerNo]
	 ,CONVERT(varchar, [OrderDate], 12) as 'OrderDate'
	 ,CONVERT(varchar, [ShipExpireDate], 12) as 'ShipExpireDate'
	 ,IsNull(CONVERT(varchar, [ArrivalDate], 12),'') as 'ArrivalDate'
	 ,[OrderStatus]
	 ,[HoldCode]conver
	 ,[CoopNo]
	 ,[Comment]
	 ,ShipTo
  FROM #temp_PortalOrderHeader_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalOrderHeader_Previous where RepCode = @RepCode
INSERT PortalOrderHeader_Previous(TimeSync, RepCode,[SalesOrderNo],[ARDivisionNo],[CustomerNo],[OrderDate],[ShipExpireDate],[ArrivalDate],[OrderStatus],[HoldCode],[CoopNo],[Comment],ShipTo)
SELECT
	TimeSync,
	RepCode,
	[SalesOrderNo],[ARDivisionNo],[CustomerNo],[OrderDate],[ShipExpireDate],[ArrivalDate],[OrderStatus],[HoldCode],[CoopNo],[Comment],ShipTo
FROM #temp_PortalOrderHeader_Current
WHERE RepCode = @RepCode
END

SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(h.InvoiceNo,7) as SalesOrderNo,
		   right(LineKey,3) as LineKey,
		   left(ItemCode,30) as ItemCode,
		   CONVERT(numeric(6,2),ROUND(QuantityOrdered,2)) as Quantity,
		   CONVERT(numeric(7,2),UnitPrice) as Price,
		   CONVERT(numeric(7,2),ExtensionAmt) as Total,
		   left(CommentText,2048) as Comment
INTO #temp_PortalOrderDetail_Current
FROM         MAS_POL.dbo.SO_InvoiceDetail d INNER JOIN
                      MAS_POL.dbo.SO_InvoiceHeader h ON d.InvoiceNo = h.InvoiceNo
WHERE    ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%'))
UNION ALL
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(h.SalesOrderNo,7) as SalesOrderNo,
		   right(LineKey,3) as LineKey,
		   left(ItemCode,30) as ItemCode,
		   CONVERT(numeric(6,2),ROUND(QuantityOrdered,2)) as Quantity,
		   CONVERT(numeric(7,2),UnitPrice) as Price,
		   CONVERT(numeric(7,2),ExtensionAmt) as Total,
		   left(CommentText,2048) as Comment
FROM         MAS_POL.dbo.SO_SalesOrderDetail d INNER JOIN
                      MAS_POL.dbo.SO_SalesOrderHeader h ON d.SalesOrderNo = h.SalesOrderNo
WHERE    ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%')) and ROUND(QuantityOrdered,2) > 0 AND h.CurrentInvoiceNo = ''
UNION ALL
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(h.InvoiceNo,7) as SalesOrderNo,
		   right(DetailSeqNo,3) as LineKey,
		   left(ItemCode,30) as ItemCode,
		   CONVERT(numeric(6,2),ROUND(QuantityShipped,2)) as Quantity,
		   CONVERT(numeric(7,2),UnitPrice) as Price,
		   CONVERT(numeric(7,2),ExtensionAmt) as Total,
		   left(CommentText,2048) as Comment
FROM         MAS_POL.dbo.AR_InvoiceHistoryDetail d INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryHeader h ON d.InvoiceNo = h.InvoiceNo and
					  h.HeaderSeqNo = d.HeaderSeqNo
WHERE    InvoiceDate > GETDATE() and ItemCode != '/COBRA' and ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%'))
UNION ALL
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(h.PurchaseOrderNo,7) as SalesOrderNo,
		   right(LineKey,3) as LineKey,
		   left(ItemCode,30) as ItemCode,
		   CONVERT(numeric(6,2),QuantityOrdered) as Quantity,
		   0.0 as Price,
		   0.0 as Total,
		   left(CommentText,2048) as Comment                   
FROM         dbo.PO_PurchaseOrderDetail d INNER JOIN
                      dbo.PO_PurchaseOrderHeader h ON d.PurchaseOrderNo = h.PurchaseOrderNo INNER JOIN
                      dbo.PO_ShipToAddress a ON h.ShipToCode = a.ShipToCode
WHERE h.OrderType = 'X' AND h.OrderStatus <> 'X' AND ((@AccountType = 'REP' and a.UDF_REP_CODE = @RepCode) or @AccountType = 'OFF')

SELECT @TimeSyncDetailsPrev = MAX(TimeSync) FROM PortalOrderDetail_Previous where RepCode=@RepCode

SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
	'C' as Operation,
	[SalesOrderNo],[LineKey],[ItemCode],[Quantity],[Price],[Total],[Comment]
  INTO #temp_PortalOrderDetail
  FROM #temp_PortalOrderDetail_Current
  WHERE 1=2
IF(@TimeSyncDetailsPrev = @TimeSyncDetails)
BEGIN
	INSERT INTO #temp_PortalOrderDetail
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
 INSERT INTO #temp_PortalOrderDetail
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


SELECT H = ISNULL(JSON_QUERY((SELECT TOP(1) TimeSync
	, Op = CASE WHEN NOT EXISTS(SELECT SalesOrderNo FROM #temp_PortalOrderHeader) THEN 'E' WHEN Operation = 'C' THEN 'C' ELSE 'U' END
	, D = ISNULL((SELECT SalesOrderNo as OrderNo FROM #temp_PortalOrderHeader WHERE Operation = 'D' FOR JSON PATH),'[]')
	, A = ISNULL((SELECT SalesOrderNo as OrderNo
			, ARDivisionNo as Div
			, CustomerNo as CustNo
			, OrderDate as OrderDate
			, ShipExpireDate as ShipDate
			, ArrivalDate as ArrDate
			, OrderStatus as Status
			, HoldCode as Hold
			, CoopNo as Coop
			, Replace(Comment,'''', '''''') as Comment
			, ShipTo as ShipTo
		FROM #temp_PortalOrderHeader WHERE Operation !='D' FOR JSON PATH),'[]')
	FROM #temp_PortalOrderHeader
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)), '{"Op": "E"}')
	, D = ISNULL(JSON_QUERY((SELECT TOP(1) TimeSync
	, Op = CASE WHEN NOT EXISTS(SELECT SalesOrderNo FROM #temp_PortalOrderDetail) THEN 'E' WHEN Operation = 'C' THEN 'C' ELSE 'U' END
	, D = ISNULL((SELECT SalesOrderNo as OrderNo, LineKey as Line FROM #temp_PortalOrderDetail WHERE Operation = 'D' FOR JSON PATH),'[]')
	, A = ISNULL((SELECT SalesOrderNo as OrderNo
			, LineKey as Line
			, ItemCode as Item
			, Quantity as Qty
			, Price as Price
			, Total as Total
			, Replace(Comment,'''', '''''') as Cmt
		FROM #temp_PortalOrderDetail WHERE Operation !='D' FOR JSON PATH),'[]')
	FROM #temp_PortalOrderDetail
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)), '{"Op": "E"}')
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER

END
