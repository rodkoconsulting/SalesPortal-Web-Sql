/****** Object:  Procedure [dbo].[PortalAccountSync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalAccountSync]
	@UserName varchar(25),
	@SyncTime varchar(100)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CurrentDate Datetime;
	DECLARE @TimeSyncHeaderPrev DateTime;
	DECLARE @TimeSyncDetailsPrev DateTime;
	DECLARE @TimeSyncAccountsPrev DateTime;
	DECLARE @TimeSyncItemsPrev DateTime;
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
	DECLARE @TimeSyncHeader Datetime;
	DECLARE @TimeSyncDetails Datetime;
	DECLARE @TimeSyncAccounts Datetime;
	DECLARE @TimeSyncItems Datetime;
	DECLARE @TimeSyncHeaderDay varchar(25);
	DECLARE @TimeSyncHeaderTime varchar(25);
	DECLARE @TimeSyncDetailsDay varchar(25);
	DECLARE @TimeSyncDetailsTime varchar(25);
	DECLARE @TimeSyncAccountsDay varchar(25);
	DECLARE @TimeSyncAccountsTime varchar(25);
	DECLARE @TimeSyncItemsDay varchar(25);
	DECLARE @TimeSyncItemsTime varchar(25);
	DECLARE @TimeSyncTemp varchar(100);
    Set @CurrentDate=GETDATE();
SELECT @RepCode = RepCode FROM Web_ActiveUsers where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_ActiveUsers where UserName=@UserName  
SET @TimeSyncTemp = @SyncTime
SET @TimeSyncAccountsDay = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncAccountsDay + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncAccountsTime = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncAccountsTime + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncHeaderDay = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncHeaderDay + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncHeaderTime = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncHeaderTime + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncDetailsDay = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncDetailsDay + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncDetailsTime = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncDetailsTime + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncItemsDay = SUBSTRING(@TimeSyncTemp, 0, PATINDEX('%/%',@TimeSyncTemp))
SET @TimeSyncTemp = SUBSTRING(@TimeSyncTemp, LEN(@TimeSyncItemsDay + '/') + 1, LEN(@TimeSyncTemp))
SET @TimeSyncItemsTime =@TimeSyncTemp
SET @TimeSyncHeader = TRY_CONVERT(DATETIME, @TimeSyncHeaderDay + ' ' + @TimeSyncHeaderTime, 121)
SET @TimeSyncDetails = TRY_CONVERT(DATETIME, @TimeSyncDetailsDay + ' ' + @TimeSyncDetailsTime, 121)
SET @TimeSyncAccounts = TRY_CONVERT(DATETIME, @TimeSyncAccountsDay + ' ' + @TimeSyncAccountsTime, 121)
SET @TimeSyncItems = TRY_CONVERT(DATETIME, @TimeSyncItemsDay + ' ' + @TimeSyncItemsTime, 121)
SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(c.ARDivisionNo,2) as ARDivisionNo,
		   left(c.CustomerNo,20) as CustomerNo,
		   left(c.CustomerName,30) as CustomerName,
		   left(c.PriceLevel,1) as PriceLevel,
		   left(ps.ShipDays,5) as ShipDays,
		   LEFT(c.UDF_NJ_COOP, 20) as CoopList,
		   Left(c.UDF_WINE_BUYER, 25) AS Buyer1,
           Left(c.UDF_WINE_BUYER_2, 25) AS Buyer2,
           LEFT(c.UDF_WINE_BUYER_3, 25) AS Buyer3,
           Left(c.UDF_WINE_BUYER_PHONE,20) AS Buyer1Phone,
           Left(c.UDF_WINE_BUYER_PHONE_2,20) AS Buyer2Phone,
           Left(c.UDF_WINE_BUYER_PHONE_3,20) AS Buyer3Phone,
           Left(c.UDF_WINE_BUYER_EMAIL,35) AS Buyer1Email,
           Left(c.UDF_WINE_BUYER_2_EMAIL,35) AS Buyer2Email,
           Left(c.UDF_WINE_BUYER_3_EMAIL,35) AS Buyer3Email,
           Left(c.UDF_AFFILIATIONS, 25) AS Affil,
           Left(TRIM(c.UDF_PREMISIS_ADDRESS_LINE_1),30) AS Addr1,
           Left(TRIM(c.UDF_PREMISIS_ADDRESS_LINE_2),30) AS Addr2,
           Left(TRIM(c.UDF_PREMISIS_CITY),20) AS City,
           Left(c.UDF_PREMISIS_STATE,2) AS State,
           Left(TRIM(c.UDF_PREMISIS_ZIP),10) AS Zip,
		   CASE WHEN c.UDF_CUST_ACTIVE_STAT <> 'Y' THEN 'I'
				WHEN Year(c.UDF_LIC_EXPIRATION)>1900 and c.UDF_LIC_EXPIRATION < @CurrentDate THEN 'E'
				WHEN c.TERMSCODE = '00' THEN 'CS'
				WHEN c.TERMSCODE = '05' THEN 'CI'
				WHEN c.TERMSCODE = '10' THEN 'CP'
				WHEN c.TERMSCODE = '95' THEN 'CP'
				WHEN (c.AGINGCATEGORY1 + c.AGINGCATEGORY2 + c.AGINGCATEGORY3 + c.AGINGCATEGORY4) > 0 THEN 'P'
				ELSE '' END AS Status,
			LEFT(c.SalespersonNo,4) as Rep,
			CASE WHEN s.UDF_TERRITORY = 'NY Metro' then 'NYM'
				 WHEN s.UDF_TERRITORY = 'NY Long Island' then 'NYL'
				 WHEN s.UDF_TERRITORY = 'NY Upstate' then 'NYU'
				 WHEN s.UDF_TERRITORY = 'NY Westchester / Hudson' then 'NYW'
				 WHEN s.UDF_TERRITORY = 'NJ' then 'NJ'
				 WHEN s.UDF_TERRITORY = 'PA' then 'PA'
				 ELSE 'MAN'
				 END AS Region,
			LEFT(c.PrimaryShipToCode,4) as PrimaryShipTo,
			LEFT(c.SHIPMETHOD,12) as ShipVia
INTO #temp_PortalAccountList_Current
FROM         dbo.AR_Customer c INNER JOIN
             dbo.PortalShipping ps ON c.CustomerNo = ps.CUSTOMERNO AND c.ARDivisionNo = ps.ARDivisionNo INNER JOIN
             dbo.AR_SalesPerson s ON c.SalespersonNo = s.SalespersonNo AND c.ARDivisionNo = s.SalespersonDivisionNo
WHERE (c.PriceLevel <> '') and ((@AccountType = 'REP' and c.SalespersonNo = @RepCode) or (@AccountType = 'OFF' and c.SalespersonNo not like 'XX%'))

SELECT @TimeSyncAccountsPrev = MAX(TimeSync) FROM PortalAccountList_Previous where RepCode=@RepCode

SELECT
	TimeSync,
	'C' as Operation,
	[ARDivisionNo],[CustomerNo],[CustomerName],[PriceLevel],[ShipDays],[CoopList],[Buyer1],[Buyer2],[Buyer3],[Buyer1Phone],[Buyer2Phone],[Buyer3Phone],[Buyer1Email],[Buyer2Email],[Buyer3Email],[Affil],[Addr1],[Addr2],[City],[State],[Zip],[Status],[Rep],[Region],PrimaryShipTo,ShipVia
  INTO #temp_PortalAccountList
  FROM #temp_PortalAccountList_Current
  WHERE 1=2

IF(@TimeSyncAccountsPrev = @TimeSyncAccounts)
BEGIN
	INSERT INTO #temp_PortalAccountList
	SELECT
	TimeSync,
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
  FROM PortalAccountList_Previous
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
 INSERT INTO #temp_PortalAccountList
 SELECT
	 TimeSync,
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

SELECT     @CurrentDate as TimeSync,
		   @RepCode as RepCode,
		   left(c.ARDivisionNo,2) as ARDivisionNo,
		   left(c.CustomerNo,20) as CustomerNo,
		   left(h.InvoiceNo,7) as InvoiceNo,
		   right(h.HeaderSeqNo,1) as HSeqNo,
		   left(h.InvoiceType,2) as InvoiceType,
		   h.InvoiceDate as InvoiceDate,
		   left(h.Comment,30) as Comment
INTO #temp_PortalInvoiceHistoryHeader_Current
FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader h INNER JOIN
                      MAS_POL.dbo.AR_Customer c ON h.ARDivisionNo = c.ARDivisionNo AND 
                      h.CustomerNo = c.CustomerNo
WHERE     (h.InvoiceDate >= DATEADD(YEAR, - 1, @CurrentDate)) AND (h.ModuleCode = 'S/O') 
and ((@AccountType = 'REP' and c.SalespersonNo = @RepCode) or (@AccountType = 'OFF' and c.SalespersonNo not like 'XX%'))

SELECT @TimeSyncHeaderPrev = MAX(TimeSync) FROM PortalInvoiceHistoryHeader_Previous where RepCode=@RepCode

SELECT
	TimeSync,
	'C' as Operation,
	[ARDivisionNo],[CustomerNo],[CustomerName],[PriceLevel],[ShipDays],[CoopList],[Buyer1],[Buyer2],[Buyer3],[Buyer1Phone],[Buyer2Phone],[Buyer3Phone],[Buyer1Email],[Buyer2Email],[Buyer3Email],[Affil],[Addr1],[Addr2],[City],[State],[Zip],[Status],[Rep],[Region],PrimaryShipTo,ShipVia
  INTO #temp_PortalInvoiceHistoryHeader
  FROM #temp_PortalInvoiceHistoryHeader_Current
  WHERE 1=2

IF(@TimeSyncHeaderPrev = @TimeSyncHeader)
BEGIN
	INSERT INTO #temp_PortalInvoiceHistoryHeader
	SELECT
	TimeSync,
	MIN(Operation) as Operation,
	[InvoiceNo],
	right(HSeqNo,1) as HSeqNo,
	CASE WHEN MIN(Operation)<>'D' THEN [ARDivisionNo] ELSE '' END AS ARDivisionNo,
	CASE WHEN MIN(Operation)<>'D' THEN [CustomerNo] ELSE '' END AS CustomerNo,
	CASE WHEN MIN(Operation)<>'D' THEN [InvoiceType] ELSE '' END AS InvoiceType,
	CASE WHEN MIN(Operation)<>'D' THEN [InvoiceDate] ELSE '' END AS InvoiceDate,
	CASE WHEN MIN(Operation)<>'D' THEN [Comment] ELSE '' END AS Comment
FROM
(
  SELECT 'D' as Operation, [InvoiceNo],[HSeqNo],[ARDivisionNo],[CustomerNo],[InvoiceType],[InvoiceDate],[Comment]
  FROM dbo.PortalInvoiceHistoryHeader_Previous
  WHERE [RepCode] = @RepCode
  UNION ALL
  SELECT 'I' as Operation, [InvoiceNo],[HSeqNo],[ARDivisionNo],[CustomerNo],[InvoiceType],[InvoiceDate],[Comment]
  FROM #temp_PortalInvoiceHistoryHeader_Current
  WHERE [RepCode] = @RepCode
) tmp
 
GROUP BY [InvoiceNo],[HSeqNo],[ARDivisionNo],[CustomerNo],[InvoiceType],[InvoiceDate],[Comment]
   
HAVING COUNT(*) = 1
 
ORDER BY  [InvoiceNo],[HSeqNo]

END
ELSE
BEGIN
 INSERT INTO #temp_PortalInvoiceHistoryHeader
 SELECT
	TimeSync,
	'C' as Operation,
	[InvoiceNo], [HSeqNo],[ARDivisionNo],[CustomerNo],[InvoiceType],[InvoiceDate],[Comment]
  FROM #temp_PortalInvoiceHistoryHeader_Current
  WHERE RepCode = @RepCode
END
if @@ROWCOUNT>0
BEGIN
DELETE FROM PortalInvoiceHistoryHeader_Previous where RepCode = @RepCode
INSERT PortalInvoiceHistoryHeader_Previous(TimeSync, RepCode,[InvoiceNo],[HSeqNo],[ARDivisionNo],[CustomerNo],[InvoiceType],[InvoiceDate],[Comment])
SELECT
	TimeSync,
	RepCode,
	[InvoiceNo], HSeqNo as HeaderSeqNo,[ARDivisionNo],[CustomerNo],[InvoiceType],[InvoiceDate],[Comment]
FROM #temp_PortalInvoiceHistoryHeader_Current
WHERE RepCode = @RepCode
END
END
