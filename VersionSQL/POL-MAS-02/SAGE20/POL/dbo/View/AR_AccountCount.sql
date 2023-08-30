/****** Object:  View [dbo].[AR_AccountCount]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_AccountCount]
AS
SELECT     COUNT(DISTINCT CUSTOMERNO) AS CustomerCount, SALESPERSONNO, SalespersonDivisionNo
FROM         MAS_POL.dbo.AR_CUSTOMER
where SALESPERSONNO not like 'XX%' AND CUSTOMERNO NOT LIKE 'ZZ%'
GROUP BY SALESPERSONNO, SalespersonDivisionNo
