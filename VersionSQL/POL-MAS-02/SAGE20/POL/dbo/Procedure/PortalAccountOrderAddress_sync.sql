/****** Object:  Procedure [dbo].[PortalAccountOrderAddress_sync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalAccountOrderAddress_sync]
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
SELECT @AccountType = AccountType FROM Web_UserMappings where UserName=@UserName;
WITH SHIPTOTALS AS
(
SELECT ARDivisionNo, CustomerNo
FROM  MAS_POL.dbo.SO_ShipToAddress a
WHERE UDF_INACTIVE <> 'Y'
GROUP BY ARDivisionNo, CustomerNo
HAVING COUNT(*) > 1
)
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(c.ARDivisionNo,2) as ARDivisionNo,
		   left(c.CustomerNo,20) as CustomerNo,
		   left(a.ShipToCode,4) as ShipToCode,
		   left(ShipToName,30) as ShipToName,
		   CASE WHEN len(ShipToAddress2)=0 then LEFT(ShipToAddress1 ,30) ELSE LEFT(ShipToAddress1 ,30) + ', ' + LEFT(ShipToAddress2 ,30) END as ShipToAddress
INTO #temp_PortalAccountAddresses_Current
FROM         MAS_POL.dbo.AR_Customer c INNER JOIN MAS_POL.dbo.SO_ShipToAddress a ON c.ARDivisionNo = a.ARDivisionNo and c.CustomerNo = a.CustomerNo
			INNER JOIN SHIPTOTALS st ON c.ARDivisionNo = st.ARDivisionNo and c.CustomerNo = st.CustomerNo
WHERE (a.UDF_INACTIVE <> 'Y') and (c.PriceLevel <> '') and ((c.ARDIVISIONNO = '00') or (c.ARDIVISIONNO = '02')) and ((@AccountType = 'REP' and c.SalespersonNo = @RepCode) or (@AccountType = 'OFF' and c.SalespersonNo not like 'XX%'))
SELECT @TimeSyncPrev = MAX(TimeSync) FROM PortalAccountAddresses_Previous where RepCode=@RepCode
IF(@TimeSyncPrev = @TimeSync)
BEGIN
	SELECT
	CONVERT(varchar, @CurrentDate , 121) as TimeSync,
	MIN(Operation) as Operation,
	RepCode,
	ARDivisionNo,
	CustomerNo,
	ShipToCode,
	CASE WHEN MIN(Operation)<>'D' THEN ShipToName ELSE '' END AS ShipToName,
	CASE WHEN MIN(Operation)<>'D' THEN ShipToAddress ELSE '' END AS ShipToAddress
FROM
(
  SELECT 'D' as Operation, RepCode, ARDivisionNo, CustomerNo, ShipToCode, ShipToName, ShipToAddress
  FROM dbo.PortalAccountAddresses_Previous
  WHERE RepCode = @RepCode
  UNION ALL
  SELECT 'I' as Operation, RepCode, ARDivisionNo, CustomerNo, ShipToCode, ShipToName, ShipToAddress
  FROM #temp_PortalAccountAddresses_Current
  WHERE RepCode = @RepCode
) tmp
 
GROUP BY RepCode, ARDivisionNo, CustomerNo, ShipToCode, ShipToName, ShipToAddress
   
HAVING COUNT(*) = 1
 
ORDER BY  RepCode, ARDivisionNo, CustomerNo, ShipToCode

END
ELSE
BEGIN
 SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
	'C' as Operation,
	RepCode, ARDivisionNo, CustomerNo, ShipToCode, ShipToName, ShipToAddress
  FROM #temp_PortalAccountAddresses_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalAccountAddresses_Previous where RepCode = @RepCode
INSERT PortalAccountAddresses_Previous(TimeSync, RepCode, ARDivisionNo, CustomerNo, ShipToCode, ShipToName, ShipToAddress)
SELECT
	TimeSync
	, RepCode
	, ARDivisionNo
	, CustomerNo
	, ShipToCode
	, ShipToName
	, Left(ShipToAddress,60)
FROM #temp_PortalAccountAddresses_Current
WHERE RepCode = @RepCode
END
END
