/****** Object:  Procedure [dbo].[PortalBrandsPriceMixingSync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalBrandsPriceMixingSync]
	@UserName varchar(25),
	@TimeSync varchar(50)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CurrentDate Datetime;
	DECLARE @TimeSyncPrev DateTime;
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
    Set @CurrentDate=GETDATE();
SELECT @RepCode = RepCode FROM Web_ActiveUsers where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_ActiveUsers where UserName=@UserName  
SELECT     @CurrentDate as TimeSync
			, @RepCode as RepCode
			, UDF_BRAND_NAME as [Brand]
INTO #temp_PortalBrandsPriceMixing_Current
FROM        MAS_POL.dbo.CI_UDT_BRANDS
WHERE UDF_BRAND_MIXING = 'Y'
SELECT @TimeSyncPrev = MAX(TimeSync) FROM PortalBrandsPriceMixing_Previous where RepCode=@RepCode
SELECT
	TimeSync
	,'C' as Operation
	,[Brand]
  INTO #temp_PortalBrandsPriceMixing
  FROM #temp_PortalBrandsPriceMixing_Current
  WHERE 1=2
IF(@TimeSyncPrev = @TimeSync)
BEGIN
INSERT INTO #temp_PortalBrandsPriceMixing
	SELECT
		@CurrentDate
		, MIN(Operation) as Operation
		, [Brand]
FROM
(
  SELECT 'D' as Operation, [Brand]
  FROM PortalBrandsPriceMixing_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [Brand]
  FROM #temp_PortalBrandsPriceMixing_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [Brand]
   
HAVING COUNT(*) = 1
 
ORDER BY  [Brand]

END
ELSE
BEGIN 
INSERT INTO #temp_PortalBrandsPriceMixing
 SELECT
	TimeSync,
	'C' as
	 Operation
	 ,[Brand]
  FROM #temp_PortalBrandsPriceMixing_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalBrandsPriceMixing_Previous where RepCode = @RepCode
INSERT PortalBrandsPriceMixing_Previous(TimeSync, RepCode,[Brand])
SELECT
	TimeSync,
	RepCode,
	[Brand]
FROM #temp_PortalBrandsPriceMixing_Current
WHERE RepCode = @RepCode
END

SELECT ISNULL(JSON_QUERY((SELECT TOP(1) CONVERT(varchar, TimeSync, 121) as Time
   , Op = CASE WHEN NOT EXISTS(SELECT [Brand] FROM #temp_PortalBrandsPriceMixing) THEN 'E' WHEN Operation = 'C' THEN 'C' ELSE 'U' END
   , D = ISNULL((SELECT [Brand] FROM #temp_PortalBrandsPriceMixing WHERE Operation = 'D' FOR JSON PATH),'[]')
   , A = ISNULL((SELECT [Brand] FROM #temp_PortalBrandsPriceMixing WHERE Operation !='D' FOR JSON PATH),'[]')
	FROM #temp_PortalBrandsPriceMixing
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)), '{"Op": "E"}')


/****** SELECT ISNULL(JSON_QUERY((SELECT TOP(1) CONVERT(varchar, TimeSync, 121) as TimeSync
	, Op = CASE WHEN NOT EXISTS(SELECT [Date] FROM #temp_PortalHolidays) THEN 'E' WHEN Operation = 'C' THEN 'C' ELSE 'U' END
	, D = ISNULL((SELECT [Date] AS Date FROM #temp_PortalHolidays WHERE Operation = 'D' FOR JSON PATH),'[]')
	, A = ISNULL((SELECT [Date] AS Date
		FROM #temp_PortalHolidays WHERE Operation !='D' FOR JSON PATH),'[]')
	FROM #temp_PortalHolidays
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)), '{"Op": "E"}')
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER ******/

END
