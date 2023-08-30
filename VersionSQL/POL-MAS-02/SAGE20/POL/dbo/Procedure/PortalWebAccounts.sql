/****** Object:  Procedure [dbo].[PortalWebAccounts]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebAccounts]
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
SELECT @RepCode = RepCode FROM Web_UserMappings where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_UserMappings where UserName=@UserName      
SELECT     AR_Customer.ARDivisionNo+AR_Customer.CustomerNo as CustomerNo,
		   CustomerName,
		   PriceLevel,
		   SO_SHIPTOADDRESS.UDF_DELIVERY_MON +
		   SO_SHIPTOADDRESS.UDF_DELIVERY_TUES + 
		   SO_SHIPTOADDRESS.UDF_DELIVERY_WED + 
		   SO_SHIPTOADDRESS.UDF_DELIVERY_THURS +
		   SO_SHIPTOADDRESS.UDF_DELIVERY_FRI AS ShipDays,
		   UDF_NJ_COOP as CoopList,
		   UDF_WINE_BUYER as Buyer1,
           UDF_WINE_BUYER_2 as Buyer2,
           UDF_WINE_BUYER_3 as Buyer3,
		   UDF_WINE_BUYER_PHONE as Buyer1Phone,
           UDF_WINE_BUYER_PHONE_2 as Buyer2Phone,
           UDF_WINE_BUYER_PHONE_3 as Buyer3Phone,
           UDF_WINE_BUYER_EMAIL as Buyer1Email,
           UDF_WINE_BUYER_2_EMAIL as Buyer2Email,
           UDF_WINE_BUYER_3_EMAIL as Buyer3Email,
           UDF_AFFILIATIONS as Affil,
           UDF_ACCOUNT_TYPE AS Type, 
           UDF_GROWTH_POTENTIAL AS Growth, 
           UDF_STORE_REST_FOCUS AS Focus,
           UDF_OTHER_KEY_SUPPLIERS AS Suppliers,
           RTRIM(LTRIM(SHIPTOADDRESS1+CASE WHEN LEN(LTRIM(SHIPTOADDRESS2))>0 THEN CHAR(13)+ CHAR(10)+ SHIPTOADDRESS2 ELSE '' END)) as 'Address',
		   SHIPTOCITY as City,
		   SHIPTOSTATE as State,
		   SHIPTOZIPCODE as Zip,
		   CASE WHEN UDF_CUST_ACTIVE_STAT <> 'Y' THEN 'I'
				WHEN Year(UDF_LIC_EXPIRATION)>1900 and UDF_LIC_EXPIRATION < GETDATE() THEN 'E'
				WHEN TERMSCODE = '00' THEN 'CS'
				WHEN TERMSCODE = '05' THEN 'CI'
				WHEN TERMSCODE = '10' THEN 'CP'
				WHEN TERMSCODE = '95' THEN 'CP'
				WHEN (AGINGCATEGORY1 + AGINGCATEGORY2 + AGINGCATEGORY3 + AGINGCATEGORY4) > 0 THEN 'P'
				ELSE '' END AS Status,
			CASE WHEN @AccountType <> 'REP' THEN AR_Customer.SalespersonNo ELSE '' END as Rep,
			CASE WHEN UDF_TERRITORY = 'NY Metro' then 'NYM'
				 WHEN UDF_TERRITORY = 'NY Long Island' then 'NYL'
				 WHEN UDF_TERRITORY = 'NY Upstate' then 'NYU'
				 WHEN UDF_TERRITORY = 'NY Westchester / Hudson' then 'NYW'
				 WHEN UDF_TERRITORY = 'NJ' then 'NJ'
				 WHEN UDF_TERRITORY = 'Pennsylvania' then 'PA'
				 ELSE 'MAN'
				 END AS Region,
			CAST(ROUND(IsNull(CURRENTBALANCE+AGINGCATEGORY1+AGINGCATEGORY2+AGINGCATEGORY3+AGINGCATEGORY4,0),2) AS FLOAT) AS Balance,
            CAST(ROUND(CASE WHEN (AGINGCATEGORY1+AGINGCATEGORY2+AGINGCATEGORY3+AGINGCATEGORY4)<=0 THEN 0
                ELSE(AGINGCATEGORY1+AGINGCATEGORY2+AGINGCATEGORY3+AGINGCATEGORY4) END,2) AS FLOAT) AS PastDue,
            IsNull(UDF_INSTRUCTIONS,'') AS DeliveryNotes,
            CASE WHEN UDF_PO_REQUIRED = 'Y' THEN 'Y' ELSE '' END AS PoRequired,
            CASE WHEN SUBSTRING(CUSTOMERTYPE,3,2)='ON' THEN 'Y' ELSE '' END AS Premise,
            UDF_LICENSE_NUM as License,
            SO_SHIPTOADDRESS.UDF_COUNTY as County,
            IsNull(CONVERT(varchar, LastOrdered, 12),'') as LastOrdered,
            IsNull(Notes,'') as Notes,
			UDF_REP_EMAIL_ADDRESS as RepEmail,
			MAS_POL.dbo.AR_Customer.ShipMethod as ShipVia       
FROM         MAS_POL.dbo.AR_Customer INNER JOIN
             MAS_POL.dbo.SO_SHIPTOADDRESS ON MAS_POL.dbo.AR_CUSTOMER.ARDIVISIONNO = MAS_POL.dbo.SO_SHIPTOADDRESS.ARDIVISIONNO AND 
                      MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNO =MAS_POL.dbo.SO_SHIPTOADDRESS.CUSTOMERNO AND 
                      MAS_POL.dbo.AR_CUSTOMER.PRIMARYSHIPTOCODE = MAS_POL.dbo.SO_SHIPTOADDRESS.SHIPTOCODE INNER JOIN
             MAS_POL.dbo.AR_UDT_SHIPPING ON MAS_POL.dbo.SO_SHIPTOADDRESS.UDF_REGION_CODE = MAS_POL.dbo.AR_UDT_SHIPPING.UDF_REGION_CODE LEFT OUTER JOIN
             dbo.PortalWebAccountNotes ON MAS_POL.dbo.AR_CUSTOMER.ARDIVISIONNO = dbo.PortalWebAccountNotes.ARDIVISIONNO AND 
                      MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNO = dbo.PortalWebAccountNotes.CUSTOMERNO LEFT OUTER JOIN
             dbo.PortalWebAccountLastOrdered ON MAS_POL.dbo.AR_CUSTOMER.ARDIVISIONNO = dbo.PortalWebAccountLastOrdered.ARDIVISIONNO AND 
                      MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNO = dbo.PortalWebAccountLastOrdered.CUSTOMERNO
WHERE (PriceLevel <> '') and ((AR_CUSTOMER.ARDIVISIONNO = '00') or (AR_CUSTOMER.ARDIVISIONNO = '02')) and ((@AccountType = 'REP' and AR_Customer.SalespersonNo = @RepCode) or ((@AccountType = 'OFF' or @AccountType = 'EXT') and AR_Customer.SalespersonNo not like 'XX%'))
END
