/****** Object:  View [dbo].[PortalPoAddress]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalPoAddress]
AS
SELECT		MIN(dbo.Users.UserName) AS UserName, dbo.Users.FullName, UDF_REP_CODE AS Rep, ShipToCode, 
                      CASE WHEN ShipToAddress1 LIKE '%PICK%FDL%' THEN 'PICK UP' WHEN ShipToAddress1 LIKE '%PICK%CLYDE%' THEN 'DNTCLY' WHEN ShipToAddress1 LIKE '%PICK%DNT%'
                       THEN 'DNT' ELSE 'FDL' END AS ShipVia, MAS_POL.dbo.PO_ShipToAddress.UDF_INACTIVE, CASE WHEN MAS_POL.dbo.AR_Salesperson.UDF_TERRITORY = 'NY Metro' then 'NYM'
				 WHEN MAS_POL.dbo.AR_Salesperson.UDF_TERRITORY = 'NY Long Island' then 'NYL'
				 WHEN MAS_POL.dbo.AR_Salesperson.UDF_TERRITORY = 'NY Upstate' then 'NYU'
				 WHEN MAS_POL.dbo.AR_Salesperson.UDF_TERRITORY = 'NY Westchester / Hudson' then 'NYW'
				 WHEN MAS_POL.dbo.AR_Salesperson.UDF_TERRITORY = 'NJ' then 'NJ'
				 WHEN MAS_POL.dbo.AR_Salesperson.UDF_TERRITORY = 'PA' then 'PA'
				 ELSE 'MAN'
				 END AS Region
				 ,Replace(ShipToName,'''','') as AcctName
FROM         MAS_POL.dbo.PO_ShipToAddress INNER JOIN dbo.Users ON  MAS_POL.dbo.PO_ShipToAddress.UDF_REP_CODE = dbo.Users.RepCode
			INNER JOIN MAS_POL.dbo.AR_Salesperson on MAS_POL.dbo.PO_ShipToAddress.UDF_REP_CODE = MAS_POL.dbo.AR_Salesperson.SalespersonNo
WHERE     (UDF_REP_CODE <> '') AND (UDF_REP_CODE <> 'NONE') and (MAS_POL.dbo.PO_ShipToAddress.UDF_INACTIVE<>'Y') and
			MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo = '00'
GROUP BY dbo.Users.FullName, UDF_REP_CODE, ShipToCode, ShipToAddress1, MAS_POL.dbo.PO_ShipToAddress.UDF_INACTIVE, MAS_POL.dbo.AR_Salesperson.UDF_TERRITORY, ShipToName
