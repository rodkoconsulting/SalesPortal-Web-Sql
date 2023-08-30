/****** Object:  View [dbo].[Web_Account_SavedOrders]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Account_SavedOrders]
AS
SELECT     dbo.Web_Account_OgHeader.ORDERNO, dbo.Web_Account_OgHeader.ARDIVISIONNO, dbo.Web_Account_OgHeader.CUSTOMERNO, dbo.Web_Account_OgHeader.USERCODE, MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNAME, 
                      dbo.Web_Account_OgHeader.SAVEDDATE, dbo.Web_Account_OgHeader.DELIVERYDAY, dbo.Web_Account_OgHeader.TOTALCASES, 
                      dbo.Web_Account_OgHeader.TOTALBOTTLES, dbo.Web_Account_OgHeader.TOTALDOLLARS, 
                      dbo.Web_Account_OgHeader.ORDERTYPE
FROM         dbo.Web_Account_OgHeader INNER JOIN
                      MAS_POL.dbo.AR_CUSTOMER ON dbo.Web_Account_OgHeader.CUSTOMERNO = MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNO AND dbo.Web_Account_OgHeader.ARDIVISIONNO = MAS_POL.dbo.AR_CUSTOMER.ARDIVISIONNO
WHERE     (dbo.Web_Account_OgHeader.ORDERSTATUS = 'S')
