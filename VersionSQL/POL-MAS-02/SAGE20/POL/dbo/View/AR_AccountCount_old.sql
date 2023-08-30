/****** Object:  View [dbo].[AR_AccountCount_old]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_AccountCount_old]
AS
SELECT     COUNT(DISTINCT CUSTOMERNO) AS CustomerCount, SALESPERSONNO
FROM         MAS_POL.dbo.AR_CUSTOMER
where SALESPERSONNO not like 'XX%' AND CUSTOMERNO NOT LIKE 'ZZ%'
GROUP BY SALESPERSONNO
