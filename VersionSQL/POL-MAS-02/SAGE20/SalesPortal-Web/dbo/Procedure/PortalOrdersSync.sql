/****** Object:  Procedure [dbo].[PortalOrdersSync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalOrdersSync]
	@UserName varchar(25),
	@TimeSync varchar(50)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CurrentDate Datetime;
	DECLARE @TimeSyncPrev DateTime;
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
	DECLARE @TimeSyncHeaderDay varchar(25);
	DECLARE @TimeSyncHeaderTime varchar(25);
	DECLARE @TimeSyncDetailsDay varchar(25);
	DECLARE @TimeSyncDetailsTime varchar(25);
	DECLARE @TimeSyncTemp varchar(50);
    Set @CurrentDate=GETDATE();
SELECT @RepCode = RepCode FROM Web_ActiveUsers where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_ActiveUsers where UserName=@UserName  
SET @TimeSyncTemp = @TimeSync
SET @TimeSyncHeaderDay = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncHeaderDay + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncHeaderTime = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncHeaderTime + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncDetailsDay = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncDetailsDay + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncDetailsTime = @TimeSyncTemp  
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
WHERE    ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%')) and (CAST(ROUND(QuantityOrdered,2) AS FLOAT) > 0 or ROUND(ExtensionAmt,2) > 0) AND h.CurrentInvoiceNo = ''
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

END
