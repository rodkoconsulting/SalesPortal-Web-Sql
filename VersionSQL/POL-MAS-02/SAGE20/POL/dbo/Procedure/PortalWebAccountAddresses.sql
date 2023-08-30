/****** Object:  Procedure [dbo].[PortalWebAccountAddresses]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebAccountAddresses]
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
SELECT @RepCode = RepCode FROM Web_UserMappings where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_UserMappings where UserName=@UserName;      
WITH SHIPTOTALS AS
(
SELECT ARDivisionNo, CustomerNo
FROM  MAS_POL.dbo.SO_ShipToAddress a
WHERE UDF_INACTIVE <> 'Y'
GROUP BY ARDivisionNo, CustomerNo
HAVING COUNT(*) > 1
)
SELECT     c.ARDivisionNo + c.CustomerNo as AcctNo
			,ShipToCode as Code
			,ShipToName as Name
			,CASE WHEN len(ShipToAddress2)=0 then LEFT(ShipToAddress1 ,30) ELSE LEFT(ShipToAddress1 ,30) + ', ' + LEFT(ShipToAddress2 ,30) END as Addr
			,PrimaryShipToCode as Def
FROM         MAS_POL.dbo.AR_Customer c INNER JOIN MAS_POL.dbo.SO_ShipToAddress a ON c.ARDivisionNo = a.ARDivisionNo and c.CustomerNo = a.CustomerNo
			INNER JOIN SHIPTOTALS st ON c.ARDivisionNo = st.ARDivisionNo and c.CustomerNo = st.CustomerNo
WHERE (a.UDF_INACTIVE <> 'Y') and (c.PriceLevel <> '') and ((c.ARDIVISIONNO = '00') or (c.ARDIVISIONNO = '02')) and ((@AccountType = 'REP' and c.SalespersonNo = @RepCode) or (@AccountType = 'OFF' and c.SalespersonNo not like 'XX%'))
END
