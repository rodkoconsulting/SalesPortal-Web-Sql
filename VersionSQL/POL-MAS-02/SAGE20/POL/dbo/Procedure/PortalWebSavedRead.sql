/****** Object:  Procedure [dbo].[PortalWebSavedRead]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PortalWebSavedRead] 
	-- Add the parameters for the stored procedure here
	@UserName varchar(15)
AS
BEGIN
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
	SELECT @RepCode = RepCode FROM Web_UserMappings where UserName=@UserName
	SELECT @AccountType = AccountType FROM Web_UserMappings where UserName=@UserName;
	WITH ACCOUNT_INFO AS
	(
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
            IsNull(Notes,'') as Notes          
FROM         MAS_POL.dbo.AR_Customer INNER JOIN
             MAS_POL.dbo.SO_SHIPTOADDRESS ON MAS_POL.dbo.AR_CUSTOMER.ARDIVISIONNO = MAS_POL.dbo.SO_SHIPTOADDRESS.ARDIVISIONNO AND 
                      MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNO =MAS_POL.dbo.SO_SHIPTOADDRESS.CUSTOMERNO AND 
                      MAS_POL.dbo.AR_CUSTOMER.PRIMARYSHIPTOCODE = MAS_POL.dbo.SO_SHIPTOADDRESS.SHIPTOCODE INNER JOIN
             MAS_POL.dbo.AR_UDT_SHIPPING ON MAS_POL.dbo.SO_SHIPTOADDRESS.UDF_REGION_CODE = MAS_POL.dbo.AR_UDT_SHIPPING.UDF_REGION_CODE LEFT OUTER JOIN
             dbo.PortalWebAccountNotes ON MAS_POL.dbo.AR_CUSTOMER.ARDIVISIONNO = dbo.PortalWebAccountNotes.ARDIVISIONNO AND 
                      MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNO = dbo.PortalWebAccountNotes.CUSTOMERNO LEFT OUTER JOIN
             dbo.PortalWebAccountLastOrdered ON MAS_POL.dbo.AR_CUSTOMER.ARDIVISIONNO = dbo.PortalWebAccountLastOrdered.ARDIVISIONNO AND 
                      MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNO = dbo.PortalWebAccountLastOrdered.CUSTOMERNO
WHERE (PriceLevel <> '') and ((AR_CUSTOMER.ARDIVISIONNO = '00') or (AR_CUSTOMER.ARDIVISIONNO = '02')) and ((@AccountType = 'REP' and AR_Customer.SalespersonNo = @RepCode) or (@AccountType = 'OFF' and AR_Customer.SalespersonNo not like 'XX%'))
)
	SELECT
		h.OrderNo
		,h.CustomerNo as 'AcctNo'
		,OrderType as 'Type'
		,CONVERT(varchar, Date_Saved, 20) as DateSaved
		,CONVERT(varchar, Date_Delivery, 12) as DateDelivery
		,h.Notes as 'Note'
		,CoopNo as 'Coop'
		,PoNo as 'Po'
		,ShipTo
		,d.ItemCode
		,CASE WHEN TRY_CAST(REPLACE(i.SalesUnitOfMeasure,'C','') AS INT) IS NULL OR TRY_CAST(REPLACE(i.SalesUnitOfMeasure,'C','') AS INT) <=0 THEN 12 ELSE TRY_CAST(REPLACE(i.SalesUnitOfMeasure,'C','') AS INT) END AS 'Uom'
		,i.UDF_BRAND_NAMES + ' ' + i.UDF_DESCRIPTION + ' ' + i.UDF_VINTAGE + ' (' + REPLACE(i.SalesUnitOfMeasure,
                       'C', '') + '/' + (CASE WHEN CHARINDEX('ML', i.UDF_BOTTLE_SIZE) > 0 THEN REPLACE(IsNull(i.UDF_BOTTLE_SIZE, ''), 
                      ' ML', '') ELSE REPLACE(i.UDF_BOTTLE_SIZE, ' ', '') END) + ') ' + i.UDF_DAMAGED_NOTES AS Description
		,CAST(Quantity AS FLOAT) AS Quantity
		,CAST(MoboTotal AS FLOAT) AS 'MoboQty'
		,MoboList
		,ISNULL(d.Comment,'') AS Comment
		,a.PoRequired as 'AcctPo'
		,a.Balance as 'AcctBal'
		,a.License as 'AcctLic'
		,a.Rep as 'AcctRep'
		,a.Suppliers as 'AcctSup'
		,a.Buyer1 as 'AcctWb1'
		,a.Buyer2 as 'AcctWb2'
		,a.Buyer3 as 'AcctWb3'
		,a.City as 'AcctCity'
		,a.CoopList as 'AcctCoop'
		,a.ShipDays as 'AcctDays'
		,a.LastOrdered as 'AcctLast'
		,a.Premise as 'AcctPrem'
		,a.Type as 'AcctType'
		,a.Affil as 'AcctAffil'
		,a.Focus as 'AcctFocus'
		,a.PriceLevel as 'AcctLevel'
		,a.State as 'AcctState'
		,a.County as 'AcctCounty'
		,a.Growth as 'AcctGrowth'
		,a.Region as 'AcctRegion'
		,a.Status as 'AcctStatus'
		,a.Address as 'AcctAddress'
		,a.DeliveryNotes as 'AcctDelNote'
		,a.CustomerName as 'AcctName'
		,a.Notes as 'AcctNote'
		,a.Buyer1Email as 'AcctWb1Email'
		,a.Buyer1Phone as 'AcctWb1Phone'
		,a.Buyer2Email as 'AcctWb2Email'
		,a.Buyer2Phone as 'AcctWb2Phone'
		,a.Buyer3Email as 'AcctWb3Email'
		,a.Buyer3Phone as 'AcctWb3Phone'
	FROM dbo.PortalWebSavedHeader h INNER JOIN dbo.PortalWebSavedDetails d ON h.OrderNo = d.OrderNo
		INNER JOIN ACCOUNT_INFO a ON h.CUSTOMERNO = a.CustomerNo
		INNER JOIN CI_Item i ON d.ITEMCODE = i.ItemCode
	WHERE h.UserName = @UserName
END
