/****** Object:  Procedure [dbo].[PortalHolidaysSync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalHolidaysSync]
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
			, Holiday as [Date]
INTO #temp_PortalHolidays_Current
FROM        POL.dbo.Holidays

SELECT @TimeSyncPrev = MAX(TimeSync) FROM PortalHolidays_Previous where RepCode=@RepCode
SELECT
	TimeSync
	,'C' as Operation
	,[Date]
  INTO #temp_PortalHolidays
  FROM #temp_PortalHolidays_Current
  WHERE 1=2
IF(@TimeSyncPrev = @TimeSync)
BEGIN
INSERT INTO #temp_PortalHolidays
	SELECT
		@CurrentDate
		, MIN(Operation) as Operation
		, [Date]
FROM
(
  SELECT 'D' as Operation, [Date]
  FROM PortalHolidays_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [Date]
  FROM #temp_PortalHolidays_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [Date]
   
HAVING COUNT(*) = 1
 
ORDER BY  [Date]

END
ELSE
BEGIN 
INSERT INTO #temp_PortalHolidays
 SELECT
	TimeSync,
	'C' as
	 Operation
	 ,[Date]
  FROM #temp_PortalHolidays_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalHolidays_Previous where RepCode = @RepCode
INSERT PortalHolidays_Previous(TimeSync, RepCode,[Date])
SELECT
	TimeSync,
	RepCode,
	[Date]
FROM #temp_PortalHolidays_Current
WHERE RepCode = @RepCode
END

SELECT ISNULL(JSON_QUERY((SELECT TOP(1) CONVERT(varchar, TimeSync, 121) as TimeSync
   , Op = CASE WHEN NOT EXISTS(SELECT [Date] FROM #temp_PortalHolidays) THEN 'E' WHEN Operation = 'C' THEN 'C' ELSE 'U' END
   , D = ISNULL((SELECT [Date] AS Date FROM #temp_PortalHolidays WHERE Operation = 'D' FOR JSON PATH),'[]')
   , A = ISNULL((SELECT [Date] AS Date FROM #temp_PortalHolidays WHERE Operation !='D' FOR JSON PATH),'[]')
	FROM #temp_PortalHolidays
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
