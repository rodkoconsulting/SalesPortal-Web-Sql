﻿/****** Object:  View [dbo].[Web_ActiveUsers]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_ActiveUsers]
AS
SELECT DISTINCT UserName
		, AccountType
		, RepCode
		, IsNull(s.UDF_STATE,'NY') AS State
		, s.SalespersonDivisionNo
FROM         dbo.Users u LEFT OUTER JOIN
                      MAS_POL.dbo.AR_Salesperson s ON u.RepCode = s.SalespersonNo
WHERE s.SalespersonDivisionNo IS NULL OR s.SalespersonDivisionNo = '00'
