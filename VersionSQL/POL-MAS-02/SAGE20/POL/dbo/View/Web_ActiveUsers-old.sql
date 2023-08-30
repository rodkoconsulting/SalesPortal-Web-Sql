/****** Object:  View [dbo].[Web_ActiveUsers-old]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_ActiveUsers-old]
AS
SELECT     DISTINCT dbo.Web_UserMappings.UserName, dbo.Web_UserMappings.AccountType, dbo.Web_UserMappings.RepCode,IsNull(MAS_POL.dbo.AR_Salesperson.UDF_STATE,'NY') 
                      AS State, dbo.Web_UserMappings.ZoomPercent, MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo
FROM         dbo.Web_UserMappings LEFT OUTER JOIN
                      MAS_POL.dbo.AR_Salesperson ON dbo.Web_UserMappings.RepCode = MAS_POL.dbo.AR_Salesperson.SalespersonNo
WHERE MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo IS NULL OR MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo = '00'
