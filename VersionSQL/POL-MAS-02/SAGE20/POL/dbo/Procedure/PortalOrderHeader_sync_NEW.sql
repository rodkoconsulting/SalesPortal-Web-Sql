/****** Object:  Procedure [dbo].[PortalOrderHeader_sync_NEW]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalOrderHeader_sync_NEW]
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
INSERT PortalOrderHeader_Current(TimeSync, RepCode, ARDivisionNo, CustomerNo, SalesOrderNo, OrderDate, ShipExpireDate, OrderStatus, HoldCode, CoopNo, Comment)
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(ARDivisionNo,2) as ARDivisionNo,
		   left(CustomerNo,20) as CustomerNo,
		   left(InvoiceNo,7) as SalesOrderNo,
		   CASE WHEN YEAR(OrderDate)<2000 THEN ShipDate ELSE OrderDate END as 'OrderDate',
		   ShipDate,
		   CASE WHEN OrderType = '1' THEN 'I' ELSE left(OrderStatus,1) END as OrderStatus,
		   '' as HoldCode,
		   left(UDF_NJ_COOP,10) as CoopNo,
		   Comment
FROM         MAS_POL.dbo.SO_InvoiceHeader
WHERE    SalesOrderNo = '' and ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%'))
UNION ALL
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(ARDivisionNo,2) as ARDivisionNo,
		   left(CustomerNo,20) as CustomerNo,
		   left(SalesOrderNo,7) as SalesOrderNo,
		   OrderDate,
		   ShipExpireDate,
		   left(OrderStatus,1) as OrderStatus,
		   CASE WHEN CancelReasonCode='MO' and UDF_REVIEW_RESTRICTIONS='N' then 'MOAPP' ELSE left(CancelReasonCode,5) END as HoldCode,
		   left(UDF_NJ_COOP,10) as CoopNo,
		   Comment
FROM         MAS_POL.dbo.SO_SalesOrderHeader
WHERE    (@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%')
UNION ALL
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(ARDivisionNo,2) as ARDivisionNo,
		   left(CustomerNo,20) as CustomerNo,
		   left(InvoiceNo,7) as SalesOrderNo,
		   InvoiceDate as 'OrderDate',
		   InvoiceDate as ShipDate,
		   'I' as OrderStatus,
		   '' as HoldCode,
		   left(UDF_NJ_COOP,10) as CoopNo,
		   Comment
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader
WHERE    InvoiceDate > GETDATE() and ((@AccountType = 'REP' and SalespersonNo = @RepCode) or (@AccountType = 'OFF' and SalespersonNo not like 'XX%'))
UNION ALL
SELECT  @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   '00' as ARDivisionNo,
left(PO_PurchaseOrderHeader.ShipToCode,4) as CustomerNo,
		   left(PO_PurchaseOrderHeader.PurchaseOrderNo,7) as SalesOrderNo,
		   PurchaseOrderDate as OrderDate,
		   RequiredExpireDate as ShipExpireDate,
		   CASE WHEN OnHold='Y' THEN 'H' ELSE 'O' END as OrderStatus,
		   'SM' as HoldCode,
		   '' as CoopNo,
		   Comment
FROM PO_PurchaseOrderHeader
INNER JOIN PortalPoAddress ON PO_PurchaseOrderHeader.ShipToCode = PortalPoAddress.ShipToCode
--INNER JOIN PO_ShipToAddress ON PO_PurchaseOrderHeader.ShipToCode = PO_ShipToAddress.ShipToCode
WHERE PO_PurchaseOrderHeader.OrderType = 'X' AND PO_PurchaseOrderHeader.RequiredExpireDate > GETDATE() AND ((@AccountType = 'REP' and PortalPoAddress.Rep = @RepCode) or @AccountType = 'OFF')
SELECT @TimeSyncPrev = MAX(TimeSync) FROM PortalOrderHeader_Previous where RepCode=@RepCode
IF(@TimeSyncPrev = @TimeSync)
BEGIN
	SELECT
	CONVERT(varchar, @CurrentDate , 121) as TimeSync,
	MIN(Operation) as Operation,
	[SalesOrderNo],
	CASE WHEN MIN(Operation)<>'D' THEN [ARDivisionNo] ELSE '' END AS ARDivisionNo,
	CASE WHEN MIN(Operation)<>'D' THEN [CustomerNo] ELSE '' END AS CustomerNo,
	CASE WHEN MIN(Operation)<>'D' THEN CONVERT(varchar, [OrderDate], 12) ELSE '' END AS OrderDate,
	CASE WHEN MIN(Operation)<>'D' THEN CONVERT(varchar, [ShipExpireDate], 12) ELSE '' END AS ShipExpireDate,
	CASE WHEN MIN(Operation)<>'D' THEN [OrderStatus] ELSE '' END AS OrderStatus,
	CASE WHEN MIN(Operation)<>'D' THEN [HoldCode] ELSE '' END AS HoldCode,
	CASE WHEN MIN(Operation)<>'D' THEN [CoopNo] ELSE '' END AS CoopNo,
	CASE WHEN MIN(Operation)<>'D' THEN [Comment] ELSE '' END AS Comment
FROM
(
  SELECT 'D' as Operation, [SalesOrderNo],[ARDivisionNo],[CustomerNo],[OrderDate],[ShipExpireDate],[OrderStatus],[HoldCode],[CoopNo],[Comment]
  FROM dbo.PortalOrderHeader_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [SalesOrderNo],[ARDivisionNo],[CustomerNo],[OrderDate],[ShipExpireDate],[OrderStatus],[HoldCode],[CoopNo],[Comment]
  FROM dbo.PortalOrderHeader_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [SalesOrderNo],[ARDivisionNo],[CustomerNo],[OrderDate],[ShipExpireDate],[OrderStatus],[HoldCode],[CoopNo],[Comment]
   
HAVING COUNT(*) = 1
 
ORDER BY  [SalesOrderNo]

END
ELSE
BEGIN
 SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
	'C' as Operation,
	[SalesOrderNo],[ARDivisionNo],[CustomerNo],CONVERT(varchar, [OrderDate], 12) as 'OrderDate',CONVERT(varchar, [ShipExpireDate], 12) as 'ShipExpireDate',[OrderStatus],[HoldCode],[CoopNo],[Comment]
  FROM PortalOrderHeader_Current
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalOrderHeader_Previous where RepCode = @RepCode
INSERT PortalOrderHeader_Previous(TimeSync, RepCode,[SalesOrderNo],[ARDivisionNo],[CustomerNo],[OrderDate],[ShipExpireDate],[OrderStatus],[HoldCode],[CoopNo],[Comment])
SELECT
	TimeSync,
	RepCode,
	[SalesOrderNo],[ARDivisionNo],[CustomerNo],[OrderDate],[ShipExpireDate],[OrderStatus],[HoldCode],[CoopNo],[Comment]
FROM PortalOrderHeader_Current
WHERE RepCode = @RepCode
END
DELETE FROM PortalOrderHeader_Current where RepCode = @RepCode
END
