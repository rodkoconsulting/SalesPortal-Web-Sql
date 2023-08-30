/****** Object:  Procedure [dbo].[PortalAccountList_sync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalAccountList_sync]
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
		   left(dbo.AR_Customer.ARDivisionNo,2) as ARDivisionNo,
		   left(dbo.AR_Customer.CustomerNo,20) as CustomerNo,
		   left(dbo.AR_Customer.CustomerName,30) as CustomerName,
		   left(dbo.AR_Customer.PriceLevel,1) as PriceLevel,
		   left(dbo.PortalShipping.ShipDays,5) as ShipDays,
		   LEFT(dbo.AR_Customer.UDF_NJ_COOP, 20) as CoopList,
		   Left(dbo.AR_CUSTOMER.UDF_WINE_BUYER, 25) AS Buyer1,
           Left(dbo.AR_CUSTOMER.UDF_WINE_BUYER_2, 25) AS Buyer2,
           LEFT(dbo.AR_CUSTOMER.UDF_WINE_BUYER_3, 25) AS Buyer3,
           Left(dbo.AR_CUSTOMER.UDF_WINE_BUYER_PHONE,20) AS Buyer1Phone,
           Left(dbo.AR_CUSTOMER.UDF_WINE_BUYER_PHONE_2,20) AS Buyer2Phone,
           Left(dbo.AR_CUSTOMER.UDF_WINE_BUYER_PHONE_3,20) AS Buyer3Phone,
           Left(dbo.AR_CUSTOMER.UDF_WINE_BUYER_EMAIL,35) AS Buyer1Email,
           Left(dbo.AR_CUSTOMER.UDF_WINE_BUYER_2_EMAIL,35) AS Buyer2Email,
           Left(dbo.AR_CUSTOMER.UDF_WINE_BUYER_3_EMAIL,35) AS Buyer3Email,
           Left(dbo.AR_CUSTOMER.UDF_AFFILIATIONS, 25) AS Affil,
           Left(LTRIM(RTRIM(dbo.AR_CUSTOMER.UDF_PREMISIS_ADDRESS_LINE_1)),30) AS Addr1,
           Left(LTRIM(RTRIM(dbo.AR_CUSTOMER.UDF_PREMISIS_ADDRESS_LINE_2)),30) AS Addr2,
           Left(LTRIM(RTRIM(dbo.AR_CUSTOMER.UDF_PREMISIS_CITY)),20) AS City,
           Left(dbo.AR_CUSTOMER.UDF_PREMISIS_STATE,2) AS State,
           Left(LTRIM(RTRIM(dbo.AR_CUSTOMER.UDF_PREMISIS_ZIP)),10) AS Zip,
		   CASE WHEN dbo.AR_Customer.UDF_CUST_ACTIVE_STAT <> 'Y' THEN 'I'
				WHEN Year(dbo.AR_Customer.UDF_LIC_EXPIRATION)>1900 and dbo.AR_Customer.UDF_LIC_EXPIRATION < GETDATE() THEN 'E'
				WHEN dbo.AR_Customer.TERMSCODE = '00' THEN 'CS'
				WHEN dbo.AR_Customer.TERMSCODE = '05' THEN 'CI'
				WHEN dbo.AR_Customer.TERMSCODE = '10' THEN 'CP'
				WHEN dbo.AR_Customer.TERMSCODE = '95' THEN 'CP'
				WHEN (dbo.AR_Customer.AGINGCATEGORY1 + dbo.AR_Customer.AGINGCATEGORY2 + dbo.AR_Customer.AGINGCATEGORY3 + dbo.AR_Customer.AGINGCATEGORY4) > 0 THEN 'P'
				ELSE '' END AS Status,
			LEFT(dbo.AR_Customer.SalespersonNo,4) as Rep,
			CASE WHEN dbo.AR_Salesperson.UDF_TERRITORY = 'NY Metro' then 'NYM'
				 WHEN dbo.AR_Salesperson.UDF_TERRITORY = 'NY Long Island' then 'NYL'
				 WHEN dbo.AR_Salesperson.UDF_TERRITORY = 'NY Upstate' then 'NYU'
				 WHEN dbo.AR_Salesperson.UDF_TERRITORY = 'NY Westchester / Hudson' then 'NYW'
				 WHEN dbo.AR_Salesperson.UDF_TERRITORY = 'NJ' then 'NJ'
				 WHEN dbo.AR_Salesperson.UDF_TERRITORY = 'PA' then 'PA'
				 ELSE 'MAN'
				 END AS Region,
			--LEFT(dbo.PortalShipping.Region,3) as Region
			LEFT(dbo.AR_Customer.PrimaryShipToCode,4) as PrimaryShipTo,
			LEFT(dbo.AR_Customer.SHIPMETHOD,12) as ShipVia
INTO #temp_PortalAccountList_Current
FROM         dbo.AR_Customer INNER JOIN
             dbo.PortalShipping ON dbo.AR_Customer.CustomerNo = dbo.PortalShipping.CUSTOMERNO AND dbo.AR_Customer.ARDivisionNo = dbo.PortalShipping.ARDivisionNo INNER JOIN
             dbo.AR_SalesPerson ON dbo.AR_Customer.SalespersonNo = dbo.AR_Salesperson.SalespersonNo AND dbo.AR_Customer.ARDivisionNo = dbo.AR_Salesperson.SalespersonDivisionNo
WHERE (dbo.AR_CUSTOMER.PriceLevel <> '') and ((@AccountType = 'REP' and dbo.AR_Customer.SalespersonNo = @RepCode) or (@AccountType = 'OFF' and dbo.AR_Customer.SalespersonNo not like 'XX%'))
SELECT @TimeSyncPrev = MAX(TimeSync) FROM PortalAccountList_Previous where RepCode=@RepCode
IF(@TimeSyncPrev = @TimeSync)
BEGIN
	SELECT
	CONVERT(varchar, @CurrentDate , 121) as TimeSync,
	MIN(Operation) as Operation,
	[ARDivisionNo],
	[CustomerNo],
	CASE WHEN MIN(Operation)<>'D' THEN [CustomerName] ELSE '' END AS CustomerName,
	CASE WHEN MIN(Operation)<>'D' THEN [PriceLevel] ELSE '' END AS PriceLevel,
	CASE WHEN MIN(Operation)<>'D' THEN [ShipDays] ELSE '' END AS ShipDays,
	CASE WHEN MIN(Operation)<>'D' THEN [CoopList] ELSE '' END AS CoopList,
	CASE WHEN MIN(Operation)<>'D' THEN [Buyer1] ELSE '' END AS Buyer1,
	CASE WHEN MIN(Operation)<>'D' THEN [Buyer2] ELSE '' END AS Buyer2,
	CASE WHEN MIN(Operation)<>'D' THEN [Buyer3] ELSE '' END AS Buyer3,
	CASE WHEN MIN(Operation)<>'D' THEN [Buyer1Phone] ELSE '' END AS Buyer1Phone,
	CASE WHEN MIN(Operation)<>'D' THEN [Buyer2Phone] ELSE '' END AS Buyer2Phone,
	CASE WHEN MIN(Operation)<>'D' THEN [Buyer3Phone] ELSE '' END AS Buyer3Phone,
	CASE WHEN MIN(Operation)<>'D' THEN [Buyer1Email] ELSE '' END AS Buyer1Email,
	CASE WHEN MIN(Operation)<>'D' THEN [Buyer2Email] ELSE '' END AS Buyer2Email, 
	CASE WHEN MIN(Operation)<>'D' THEN [Buyer3Email] ELSE '' END AS Buyer3Email,
	CASE WHEN MIN(Operation)<>'D' THEN [Affil] ELSE '' END AS Affil,    
	CASE WHEN MIN(Operation)<>'D' THEN [Addr1] ELSE '' END AS Addr1,
	CASE WHEN MIN(Operation)<>'D' THEN [Addr2] ELSE '' END AS Addr2,
	CASE WHEN MIN(Operation)<>'D' THEN [City] ELSE '' END AS City,
	CASE WHEN MIN(Operation)<>'D' THEN [State] ELSE '' END AS State,
	CASE WHEN MIN(Operation)<>'D' THEN [Zip] ELSE '' END AS Zip,
	CASE WHEN MIN(Operation)<>'D' THEN [Status] ELSE '' END AS Status,
	CASE WHEN MIN(Operation)<>'D' THEN [Rep] ELSE '' END AS Rep,
	CASE WHEN MIN(Operation)<>'D' THEN [Region] ELSE '' END AS Region,
	CASE WHEN MIN(Operation)<>'D' THEN [PrimaryShipTo] ELSE '' END AS PrimaryShipTo,
	CASE WHEN MIN(Operation)<>'D' THEN [ShipVia] ELSE '' END AS ShipVia
FROM
(
  SELECT 'D' as Operation, [ARDivisionNo],[CustomerNo],[CustomerName] COLLATE SQL_Latin1_General_CP1_CI_AS AS CustomerName,[PriceLevel],[ShipDays],[CoopList],[Buyer1],[Buyer2],[Buyer3],[Buyer1Phone],[Buyer2Phone],[Buyer3Phone],[Buyer1Email],[Buyer2Email],[Buyer3Email],[Affil],[Addr1],[Addr2],[City],[State],[Zip],[Status],[Rep],[Region],PrimaryShipTo,ShipVia
  FROM dbo.PortalAccountList_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [ARDivisionNo],[CustomerNo],[CustomerName],[PriceLevel],[ShipDays],[CoopList],[Buyer1],[Buyer2],[Buyer3],[Buyer1Phone],[Buyer2Phone],[Buyer3Phone],[Buyer1Email],[Buyer2Email],[Buyer3Email],[Affil],[Addr1],[Addr2],[City],[State],[Zip],[Status],[Rep],[Region],PrimaryShipTo,ShipVia
  FROM #temp_PortalAccountList_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [ARDivisionNo],[CustomerNo],[CustomerName],[PriceLevel],[ShipDays],[CoopList],[Buyer1],[Buyer2],[Buyer3],[Buyer1Phone],[Buyer2Phone],[Buyer3Phone],[Buyer1Email],[Buyer2Email],[Buyer3Email],[Affil],[Addr1],[Addr2],[City],[State],[Zip],[Status],[Rep],[Region],PrimaryShipTo,ShipVia
   
HAVING COUNT(*) = 1
 
ORDER BY  [ARDivisionNo],[CustomerNo], Operation

END
ELSE
BEGIN
 SELECT
	CONVERT(varchar, TimeSync, 121) as TimeSync,
	'C' as Operation,
	[ARDivisionNo],[CustomerNo],[CustomerName],[PriceLevel],[ShipDays],[CoopList],[Buyer1],[Buyer2],[Buyer3],[Buyer1Phone],[Buyer2Phone],[Buyer3Phone],[Buyer1Email],[Buyer2Email],[Buyer3Email],[Affil],[Addr1],[Addr2],[City],[State],[Zip],[Status],[Rep],[Region],PrimaryShipTo,ShipVia
  FROM #temp_PortalAccountList_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalAccountList_Previous where RepCode = @RepCode
INSERT PortalAccountList_Previous(TimeSync, RepCode, [ARDivisionNo],[CustomerNo],[CustomerName],[PriceLevel],[ShipDays],[CoopList],[Buyer1],[Buyer2],[Buyer3],[Buyer1Phone],[Buyer2Phone],[Buyer3Phone],[Buyer1Email],[Buyer2Email],[Buyer3Email],[Affil],[Addr1],[Addr2],[City],[State],[Zip],[Status],[Rep],[Region],PrimaryShipTo,ShipVia)
SELECT
	TimeSync,
	RepCode,
	[ARDivisionNo],[CustomerNo],[CustomerName],[PriceLevel],[ShipDays],[CoopList],[Buyer1],[Buyer2],[Buyer3],[Buyer1Phone],[Buyer2Phone],[Buyer3Phone],[Buyer1Email],[Buyer2Email],[Buyer3Email],[Affil],[Addr1],[Addr2],[City],[State],[Zip],[Status],[Rep],[Region],PrimaryShipTo,ShipVia
FROM #temp_PortalAccountList_Current
WHERE RepCode = @RepCode
END
END
