/****** Object:  View [dbo].[AR_Customer_NJ_Lic]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_Customer_NJ_Lic]
AS
SELECT     
ARDivisionNo,
CustomerNo,
CustomerName,
Left(RTRIM(UDF_LICENSE_NUM),11) as UDF_LICENSE_NUM,
PriceLevel,
UDF_CUST_ACTIVE_STAT,
UDF_NJ_COOP
FROM         MAS_POL.dbo.AR_Customer
