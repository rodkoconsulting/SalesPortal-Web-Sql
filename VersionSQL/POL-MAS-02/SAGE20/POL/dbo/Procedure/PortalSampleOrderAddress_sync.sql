/****** Object:  Procedure [dbo].[PortalSampleOrderAddress_sync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalSampleOrderAddress_sync]
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
		   left(MAS_POL.dbo.PO_ShipToAddress.ShipToCode,4) as ShipToCode,
		   left(dbo.PortalPoAddress.Rep,4) as ShipToRep,
		   left(ShipToName,30) as ShipToName,
		   CASE WHEN len(ShipToAddress2)=0 then LEFT(ShipToAddress1 ,30) ELSE LEFT(ShipToAddress1 ,30) + ', ' + LEFT(ShipToAddress2 ,28) END as ShipToAddress,
		   left(dbo.PortalPoAddress.Region,3) as RepRegion,
		   CASE WHEN dbo.PortalPoAddress.Rep = @RepCode THEN 1 ELSE 0 END AS isUser,
		   CASE WHEN dbo.PortalPoAddress.UDF_INACTIVE = 'Y' THEN 0 ELSE 1 END AS isActive
INTO #temp_PortalSampleAddresses_Current
FROM         MAS_POL.dbo.PO_ShipToAddress INNER JOIN dbo.PortalPoAddress ON MAS_POL.dbo.PO_ShipToAddress.ShipToCode = dbo.PortalPoAddress.ShipToCode
WHERE    ((@AccountType = 'REP' and dbo.PortalPoAddress.Rep = @RepCode) or (@AccountType = 'OFF'))
SELECT @TimeSyncPrev = MAX(TimeSync) FROM PortalSampleAddresses_Previous where RepCode=@RepCode
IF(@TimeSyncPrev = @TimeSync)
BEGIN
	SELECT
	CONVERT(varchar, @CurrentDate , 121) as TimeSync,
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
 SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
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

END
