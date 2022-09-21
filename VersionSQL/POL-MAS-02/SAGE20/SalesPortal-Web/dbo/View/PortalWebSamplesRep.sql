/****** Object:  View [dbo].[PortalWebSamplesRep]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebSamplesRep] AS
SELECT			DISTINCT s.SalespersonNo as RepNo
				, CASE WHEN s.UDF_TERRITORY = 'NY Metro' THEN 'NYM' WHEN UDF_TERRITORY = 'NY Long Island' THEN 'NYLI' WHEN UDF_TERRITORY = 'NY Upstate' THEN 'NYU' WHEN UDF_TERRITORY = 'NY Westchester / Hudson' THEN
                          'NYW' WHEN UDF_TERRITORY = 'NJ' THEN 'NJ' WHEN UDF_TERRITORY = 'Pennsylvania' THEN 'PA' ELSE 'Manager' END AS Ter
				,s.SALESPERSONNAME AS RepName
FROM        MAS_POL.dbo.AR_Salesperson s
WHERE     s.SalesPersonDivisionNo = '00'
