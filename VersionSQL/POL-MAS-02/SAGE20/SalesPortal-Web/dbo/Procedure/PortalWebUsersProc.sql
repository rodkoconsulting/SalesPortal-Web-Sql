﻿/****** Object:  Procedure [dbo].[PortalWebUsersProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE PortalWebUsersProc
AS
BEGIN
SELECT     DISTINCT u.UserName, u.AccountType, u.RepCode,IsNull(s.UDF_STATE,'NY') 
                      AS State
FROM         POL.dbo.Web_UserMappings u LEFT OUTER JOIN
                      MAS_POL.dbo.AR_Salesperson s ON u.RepCode = s.SalespersonNo
WHERE s.SalespersonDivisionNo IS NULL OR s.SalespersonDivisionNo = '00'
FOR JSON PATH
END
