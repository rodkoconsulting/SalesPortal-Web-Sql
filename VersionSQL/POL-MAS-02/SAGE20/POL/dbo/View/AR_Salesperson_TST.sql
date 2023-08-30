/****** Object:  View [dbo].[AR_Salesperson_TST]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_Salesperson_TST]
AS
SELECT     SalespersonDivisionNo, SalespersonNo, SalespersonName, EmailAddress, UDF_TERRITORY, UDF_STATE
FROM         MAS_TST.dbo.AR_Salesperson
