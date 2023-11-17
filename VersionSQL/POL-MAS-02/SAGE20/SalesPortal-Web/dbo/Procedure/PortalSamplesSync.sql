/****** Object:  Procedure [dbo].[PortalSamplesSync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalSamplesSync]
	@UserName varchar(25),
	@SyncTime varchar(100)
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
	DECLARE @TimeSyncTemp varchar(100);
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
SET @TimeSyncItems = TRY_CONVERT(DATETIME, @TimeSyncItemsDay + ' ' + @TimeSyncItemsTime, 121)
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(PurchaseOrderNo,7) as PurchaseOrderNo,
		   left(Rep,4) as OrderRep,
		   LEFT(h.ShipToCode,4) as ShipToCode,
		   CASE WHEN h.OrderStatus = 'X' THEN CompletionDate ELSE RequiredExpireDate END as Date,
		   CASE WHEN h.OrderStatus = 'X' THEN 1 ELSE 0 END AS isPosted
INTO #temp_PortalSampleOrderHeader_Current
FROM         MAS_POL.dbo.PO_PurchaseOrderHeader h INNER JOIN dbo.PortalPoAddress a ON h.ShipToCode = a.ShipToCode
WHERE    (h.OrderType = 'X') and (h.CompletionDate >= DATEADD(year, - 1, GETDATE()) or h.OrderStatus != 'X') and ((@AccountType = 'REP' and Rep = @RepCode) or (@AccountType = 'OFF'))

SELECT @TimeSyncHeaderPrev = MAX(TimeSync) FROM PortalSampleOrderHeader_Previous where RepCode=@RepCode

SELECT
	TimeSync,
	'C' as Operation,
	[PurchaseOrderNo],[OrderRep],ShipToCode,Date,isPosted
  INTO #temp_PortalSampleOrderHeader
  FROM #temp_PortalSampleOrderHeader_Current
  WHERE 1=2

IF(@TimeSyncHeaderPrev = @TimeSyncHeader)
BEGIN
INSERT INTO #temp_PortalSampleOrderHeader
	SELECT
	@CurrentDate as TimeSync,
	MIN(Operation) as Operation,
	[PurchaseOrderNo],
	CASE WHEN MIN(Operation)<>'D' THEN OrderRep ELSE '' END AS OrderRep,
	CASE WHEN MIN(Operation)<>'D' THEN ShipToCode ELSE '' END AS ShipToCode,
	CASE WHEN MIN(Operation)<>'D' THEN Date ELSE '' END AS Date,
	CASE WHEN MIN(Operation)<>'D' THEN isPosted ELSE 0 END AS isPosted
FROM
(
  SELECT 'D' as Operation, [PurchaseOrderNo],[OrderRep],ShipToCode,[Date],isPosted
  FROM dbo.PortalSampleOrderHeader_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [PurchaseOrderNo],[OrderRep],ShipToCode,[Date],isPosted
  FROM #temp_PortalSampleOrderHeader_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [PurchaseOrderNo],[OrderRep],ShipToCode,[Date],isPosted
   
HAVING COUNT(*) = 1
 
ORDER BY  [PurchaseOrderNo]

END
ELSE
BEGIN 
INSERT INTO #temp_PortalSampleOrderHeader
 SELECT
	TimeSync,
	'C' as Operation,
	[PurchaseOrderNo],[OrderRep],ShipToCode,Date,isPosted
  FROM #temp_PortalSampleOrderHeader_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalSampleOrderHeader_Previous where RepCode = @RepCode
INSERT PortalSampleOrderHeader_Previous(TimeSync, RepCode,[PurchaseOrderNo],[OrderRep],ShipToCode,[Date],isPosted)
SELECT
	TimeSync,
	RepCode,
	[PurchaseOrderNo],[OrderRep],ShipToCode,[Date],isPosted
FROM #temp_PortalSampleOrderHeader_Current
WHERE RepCode = @RepCode
END

SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(h.PurchaseOrderNo,7) as PurchaseOrderNo,
		   right(LineKey,3) as LineKey,
		   left(ItemCode,30) as ItemCode,
		   QuantityOrdered as Quantity,  
		   LEFT(d.CommentText,2048) as Comment
INTO #temp_PortalSampleOrderDetail_Current
FROM         MAS_POL.dbo.PO_PurchaseOrderDetail d INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderHeader h ON d.PurchaseOrderNo = h.PurchaseOrderNo INNER JOIN
                      dbo.PortalPoAddress a ON h.ShipToCode = a.ShipToCode
WHERE    (h.OrderType = 'X') and (h.CompletionDate >= DATEADD(year, - 1, GETDATE()) or h.OrderStatus != 'X') and ((@AccountType = 'REP' and Rep = @RepCode) or (@AccountType = 'OFF')) and QuantityOrdered > 0.04


SELECT @TimeSyncDetailsPrev = MAX(TimeSync) FROM PortalSampleOrderDetail_Previous where RepCode=@RepCode

SELECT
	TimeSync,
	'C' as Operation,
	[PurchaseOrderNo],[LineKey],[ItemCode],[Quantity],[Comment]
  INTO #temp_PortalSampleOrderDetail
  FROM #temp_PortalSampleOrderDetail_Current
  WHERE 1=2
IF(@TimeSyncDetailsPrev = @TimeSyncDetails)
BEGIN
	INSERT INTO #temp_PortalSampleOrderDetail
	SELECT
	@CurrentDate as TimeSync,
	MIN(Operation) as Operation,
	[PurchaseOrderNo],
	[LineKey],
	CASE WHEN MIN(Operation)<>'D' THEN [ItemCode] ELSE '' END AS ItemCode,
	CASE WHEN MIN(Operation)<>'D' THEN [Quantity] ELSE 0 END AS Quantity,
	CASE WHEN MIN(Operation)<>'D' THEN [Comment] ELSE '' END AS Comment
FROM
(
  SELECT 'D' as Operation, [PurchaseOrderNo],[LineKey],[ItemCode],[Quantity],[Comment]
  FROM dbo.PortalSampleOrderDetail_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [PurchaseOrderNo],[LineKey],[ItemCode],[Quantity],[Comment]
  FROM #temp_PortalSampleOrderDetail_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [PurchaseOrderNo],[LineKey],[ItemCode],[Quantity],[Comment]
   
HAVING COUNT(*) = 1
 
ORDER BY  [PurchaseOrderNo],[LineKey],[ItemCode],[Quantity],[Comment]

END
ELSE
BEGIN
 INSERT INTO #temp_PortalSampleOrderDetail
 SELECT
	TimeSync,
	'C' as Operation,
	[PurchaseOrderNo],[LineKey],[ItemCode],[Quantity],[Comment]
  FROM #temp_PortalSampleOrderDetail_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalSampleOrderDetail_Previous where RepCode = @RepCode
INSERT PortalSampleOrderDetail_Previous(TimeSync, RepCode, PurchaseOrderNo, LineKey, ItemCode, Quantity,Comment)
SELECT
	TimeSync,
	RepCode,
	[PurchaseOrderNo],[LineKey],[ItemCode],[Quantity],[Comment]
FROM #temp_PortalSampleOrderDetail_Current
WHERE RepCode = @RepCode
END

SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(a.ShipToCode,4) as ShipToCode,
		   left(pa.Rep,4) as ShipToRep,
		   left(ShipToName,30) as ShipToName,
		   CASE WHEN len(ShipToAddress2)=0 then LEFT(ShipToAddress1 ,30) ELSE LEFT(ShipToAddress1 ,30) + ', ' + LEFT(ShipToAddress2 ,28) END as ShipToAddress,
		   left(pa.Region,3) as RepRegion,
		   CASE WHEN pa.Rep = @RepCode THEN 1 ELSE 0 END AS isUser,
		   CASE WHEN pa.UDF_INACTIVE = 'Y' THEN 0 ELSE 1 END AS isActive
INTO #temp_PortalSampleAddresses_Current
FROM         MAS_POL.dbo.PO_ShipToAddress a INNER JOIN dbo.PortalPoAddress pa ON a.ShipToCode = pa.ShipToCode
WHERE    ((@AccountType = 'REP' and pa.Rep = @RepCode) or (@AccountType = 'OFF'))

SELECT @TimeSyncAddressPrev = MAX(TimeSync) FROM PortalSampleAddresses_Previous where RepCode=@RepCode

SELECT
	TimeSync,
	'C' as Operation,
	[RepCode],[ShipToCode],ShipToRep,ShipToName,ShipToAddress,RepRegion,isUser,isActive
  INTO #temp_PortalSampleAddresses
  FROM #temp_PortalSampleAddresses_Current
  WHERE 1=2

IF(@TimeSyncAddressPrev = @TimeSyncAddress)
BEGIN
	INSERT INTO #temp_PortalSampleAddresses
	SELECT
	@CurrentDate as TimeSync,
	MIN(Operation) as Operation,
	[RepCode],
	[ShipToCode],
	CASE WHEN MIN(Operation)<>'D' THEN ShipToRep ELSE '' END AS ShipToRep,
	CASE WHEN MIN(Operation)<>'D' THEN ShipToName ELSE '' END AS ShipToName,
	CASE WHEN MIN(Operation)<>'D' THEN ShipToAddress ELSE '' END AS ShipToAddress,
	CASE WHEN MIN(Operation)<>'D' THEN RepRegion ELSE '' END AS RepRegion,
	CASE WHEN MIN(Operation)<>'D' THEN isUser ELSE 0 END AS isUser,
	CASE WHEN MIN(Operation)<>'D' THEN isActive ELSE 0 END AS isActive
FROM
(
  SELECT 'D' as Operation, [RepCode],[ShipToCode],ShipToRep,ShipToName,ShipToAddress,RepRegion,isUser,isActive
  FROM dbo.PortalSampleAddresses_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [RepCode],[ShipToCode],ShipToRep,ShipToName,ShipToAddress,RepRegion,isUser,isActive
  FROM #temp_PortalSampleAddresses_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [RepCode],[ShipToCode],ShipToRep,ShipToName,ShipToAddress,RepRegion,isUser,isActive
   
HAVING COUNT(*) = 1
 
ORDER BY  [RepCode],[ShipToCode]

END
ELSE
BEGIN
INSERT INTO #temp_PortalSampleAddresses
 SELECT
	TimeSync,
	'C' as Operation,
	[RepCode],[ShipToCode],ShipToRep,ShipToName,ShipToAddress,RepRegion,isUser,isActive
  FROM #temp_PortalSampleAddresses_Current
  WHERE RepCode = @RepCode
END

if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalSampleAddresses_Previous where RepCode = @RepCode
INSERT PortalSampleAddresses_Previous(TimeSync, RepCode, ShipToCode,ShipToRep,ShipToName,ShipToAddress,RepRegion,isUser,isActive)
SELECT
	TimeSync,
	RepCode,
	ShipToCode,ShipToRep,ShipToName,ShipToAddress,RepRegion,isUser,isActive
FROM #temp_PortalSampleAddresses_Current
WHERE RepCode = @RepCode
END

CREATE TABLE #temp_PortalInactiveSampleItems_Current(  
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ItemCode] [varchar](30) NOT NULL,
	[Brand] [varchar](50) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[Vintage] [varchar](4) NOT NULL,
	[Uom] [varchar](4) NOT NULL,
	[BottleSize] [varchar](10) NOT NULL,
	[DamagedNotes] [varchar](30) NOT NULL,
	[SampleFocus] [varchar](1) NOT NULL,
	[Region] [varchar](40) NOT NULL,
	[MasterVendor] [varchar](40) NOT NULL,
	[Country] [varchar](20) NOT NULL,
	[Appellation] [varchar](50) NOT NULL)
IF(@AccountType = 'REP')
BEGIN
INSERT INTO #temp_PortalInactiveSampleItems_Current(TimeSync, RepCode, ItemCode, Brand, [Description], Vintage, Uom, BottleSize, DamagedNotes, SampleFocus, Region,MasterVendor,
									Country, Appellation)
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(i.ItemCode,30) as ItemCode,
		   left(i.UDF_BRAND_NAMES,50) as Brand,
		   left(i.UDF_DESCRIPTION,200) as 'Description',
		   left(i.UDF_VINTAGE,4) as Vintage, 
		   left(i.SalesUnitOfMeasure,4) as Uom,
		   left(i.UDF_BOTTLE_SIZE,10) as BottleSize,
		   left(i.UDF_DAMAGED_NOTES,30) as DamagedNotes,
		   i.UDF_SAMPLE_FOCUS as SampleFocus,
		   left(IsNull(r.UDF_REGION,''),40) as Region,
		   left(i.UDF_MASTER_VENDOR,40) as MasterVendor,
		   left(i.UDF_COUNTRY,20) as Country,
		   left(IsNull(a.UDF_NAME,''),50) as Appellation
FROM       MAS_POL.dbo.CI_Item i INNER JOIN
           dbo.PortalSampleItemsInactiveByRep ir ON i.ItemCode = ir.ItemCode LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON i.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON i.UDF_SUBREGION_T = a.UDF_APPELLATION
WHERE ir.Rep = @RepCode
END
ELSE
BEGIN
INSERT INTO #temp_PortalInactiveSampleItems_Current(TimeSync, RepCode, ItemCode, Brand, [Description], Vintage, Uom, BottleSize, DamagedNotes, SampleFocus, Region,MasterVendor,
									Country, Appellation)
SELECT     DISTINCT @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(i.ItemCode,30) as ItemCode,
		   left(i.UDF_BRAND_NAMES,50) as Brand,
		   left(i.UDF_DESCRIPTION,200) as 'Description',
		   left(i.UDF_VINTAGE,4) as Vintage, 
		   left(i.SalesUnitOfMeasure,4) as Uom,
		   left(i.UDF_BOTTLE_SIZE,10) as BottleSize,
		   left(i.UDF_DAMAGED_NOTES,30) as DamagedNotes,
		   i.UDF_SAMPLE_FOCUS as SampleFocus,
		   left(IsNull(r.UDF_REGION,''),40) as Region,
		   left(i.UDF_MASTER_VENDOR,40) as MasterVendor,
		   left(i.UDF_COUNTRY,20) as Country,
		   left(IsNull(a.UDF_NAME,''),50) as Appellation
FROM       MAS_POL.dbo.CI_Item i INNER JOIN
           dbo.PortalSampleItemsInactiveByRep ir ON i.ItemCode = ir.ItemCode LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON i.UDF_REGION = r.UDF_PRIMARY_REGION_CODE  LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_APPELLATION as a ON i.UDF_SUBREGION_T = a.UDF_APPELLATION
END

SELECT @TimeSyncItemsPrev = MAX(TimeSync) FROM PortalInactiveSampleItems_Previous where RepCode=@RepCode

SELECT
	TimeSync,
	'C' as Operation,
	[ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[SampleFocus],Region, MasterVendor, Country, Appellation
  INTO #temp_PortalInactiveSampleItems
  FROM #temp_PortalInactiveSampleItems_Current
  WHERE 1=2

IF(@TimeSyncItemsPrev = @TimeSyncItems)
BEGIN
	INSERT INTO #temp_PortalInactiveSampleItems
	SELECT
	@CurrentDate as TimeSync,
	MIN(Operation) as Operation,
	[ItemCode],
	CASE WHEN MIN(Operation)<>'D' THEN [Brand] ELSE '' END AS Brand,
	CASE WHEN MIN(Operation)<>'D' THEN [Description] ELSE '' END AS Description,
	CASE WHEN MIN(Operation)<>'D' THEN [Vintage] ELSE '' END AS Vintage,
	CASE WHEN MIN(Operation)<>'D' THEN [Uom] ELSE '' END AS Uom,
	CASE WHEN MIN(Operation)<>'D' THEN [BottleSize] ELSE '' END AS BottleSize,
	CASE WHEN MIN(Operation)<>'D' THEN [DamagedNotes] ELSE '' END AS DamagedNotes,
	CASE WHEN MIN(Operation)<>'D' THEN [SampleFocus] ELSE '' END AS SampleFocus,
	CASE WHEN MIN(Operation)<>'D' THEN [Region] ELSE '' END AS Region,
	CASE WHEN MIN(Operation)<>'D' THEN [MasterVendor] ELSE '' END AS MasterVendor,
	CASE WHEN MIN(Operation)<>'D' THEN [Country] ELSE '' END AS Country,
	CASE WHEN MIN(Operation)<>'D' THEN [Appellation] ELSE '' END AS Appellation
FROM
(
  SELECT 'D' as Operation, [RepCode],[ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[SampleFocus],Region, MasterVendor, Country, Appellation
  FROM dbo.PortalInactiveSampleItems_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [RepCode],[ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[SampleFocus],Region, MasterVendor, Country, Appellation
  FROM #temp_PortalInactiveSampleItems_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[SampleFocus],Region, MasterVendor, Country, Appellation
HAVING COUNT(*) = 1
 
ORDER BY  [ItemCode], Operation

END
ELSE
BEGIN
 INSERT INTO #temp_PortalInactiveSampleItems
 SELECT
	TimeSync,
	'C' as Operation,
	[ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[SampleFocus],Region, MasterVendor, Country, Appellation
  FROM #temp_PortalInactiveSampleItems_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalInactiveSampleItems_Previous where RepCode = @RepCode
INSERT PortalInactiveSampleItems_Previous(TimeSync, RepCode, ItemCode, Brand,[Description], Vintage, Uom, BottleSize, DamagedNotes, SampleFocus, Region, MasterVendor, Country, Appellation)
SELECT
	TimeSync,
	RepCode,
	[ItemCode],[Brand],[Description],[Vintage],[Uom],[BottleSize],[DamagedNotes],[SampleFocus], Region, MasterVendor, Country, Appellation
FROM #temp_PortalInactiveSampleItems_Current
WHERE RepCode = @RepCode
END

SELECT H = ISNULL(JSON_QUERY((SELECT TOP(1) CONVERT(varchar, TimeSync, 121) as TimeSync
	, Op = CASE WHEN NOT EXISTS(SELECT PurchaseOrderNo FROM #temp_PortalSampleOrderHeader) THEN 'E' WHEN Operation = 'C' THEN 'C' ELSE 'U' END
	, D = ISNULL((SELECT PurchaseOrderNo as OrderNo FROM #temp_PortalSampleOrderHeader WHERE Operation = 'D' FOR JSON PATH),'[]')
	, A = ISNULL((SELECT PurchaseOrderNo as OrderNo
			, OrderRep as Rep
			, ShipToCode as ShipTo
			, CONVERT(varchar, [Date], 12) as Date
			, isPosted
		FROM #temp_PortalSampleOrderHeader WHERE Operation !='D' FOR JSON PATH),'[]')
	FROM #temp_PortalSampleOrderHeader
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)), '{"Op": "E"}')
	, D = ISNULL(JSON_QUERY((SELECT TOP(1) CONVERT(varchar, TimeSync, 121) as TimeSync
	, Op = CASE WHEN NOT EXISTS(SELECT PurchaseOrderNo FROM #temp_PortalSampleOrderDetail) THEN 'E' WHEN Operation = 'C' THEN 'C' ELSE 'U' END
	, D = ISNULL((SELECT PurchaseOrderNo as OrderNo, LineKey as Line FROM #temp_PortalSampleOrderDetail WHERE Operation = 'D' FOR JSON PATH),'[]')
	, A = ISNULL((SELECT PurchaseOrderNo as OrderNo
			, LineKey as Line
			, ItemCode as Item
			, CONVERT(decimal(6,2), ROUND(Quantity,2)) as Qty
			, Replace(Comment,'''', '''''') as Cmt
		FROM #temp_PortalSampleOrderDetail WHERE Operation !='D' FOR JSON PATH),'[]')
	FROM #temp_PortalSampleOrderDetail
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)), '{"Op": "E"}')
	, A = ISNULL(JSON_QUERY((SELECT TOP(1) CONVERT(varchar, TimeSync, 121) as TimeSync
	, Op = CASE WHEN NOT EXISTS(SELECT ShipToCode FROM #temp_PortalSampleAddresses) THEN 'E' WHEN Operation = 'C' THEN 'C' ELSE 'U' END
	, D = ISNULL((SELECT ShipToCode as Code FROM #temp_PortalSampleAddresses WHERE Operation = 'D' FOR JSON PATH),'[]')
	, A = ISNULL((SELECT ShipToCode as Code 
			, Replace(ShipToName,'''', '''''') as Name
			, Replace(ShipToAddress,'''', '''''') as Addr
			, ShipToRep as Rep
			, RepRegion as Reg
			, isUser as isRep
			, isActive as isAct
		FROM #temp_PortalSampleAddresses WHERE Operation !='D' FOR JSON PATH),'[]')
	FROM #temp_PortalSampleAddresses
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)), '{"Op": "E"}')
	, I = ISNULL(JSON_QUERY((SELECT TOP(1) CONVERT(varchar, TimeSync, 121) as TimeSync
	, Op = CASE WHEN NOT EXISTS(SELECT ItemCode FROM #temp_PortalInactiveSampleItems) THEN 'E' WHEN Operation = 'C' THEN 'C' ELSE 'U' END
	, D = ISNULL((SELECT ItemCode as Code FROM #temp_PortalInactiveSampleItems WHERE Operation = 'D' FOR JSON PATH),'[]')
	, A = ISNULL((SELECT ItemCode as Code 
			, Replace(Description,'''', '''''') as [Desc]
			, Replace(Brand,'''', '''''') as Brand
			, Replace(MasterVendor,'''', '''''') as MVendor
			, Vintage
			, Uom
			, BottleSize as Size
			, Replace(DamagedNotes,'''', '''''') as DamNotes
			, SampleFocus as Focus
			, Country
			, Replace(Region,'''', '''''') as Region
			, Trim(Replace(Appellation,'''', '''''')) as App
		FROM #temp_PortalInactiveSampleItems WHERE Operation !='D' FOR JSON PATH),'[]')
	FROM #temp_PortalInactiveSampleItems
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)), '{"Op": "E"}')
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER

END
