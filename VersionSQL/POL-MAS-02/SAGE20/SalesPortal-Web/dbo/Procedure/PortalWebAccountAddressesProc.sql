/****** Object:  Procedure [dbo].[PortalWebAccountAddressesProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebAccountAddressesProc]
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
SELECT @RepCode = RepCode FROM Web_ActiveUsers where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_ActiveUsers where UserName=@UserName;   
WITH SHIPTOTALS AS
(
SELECT ARDivisionNo, CustomerNo
FROM  MAS_POL.dbo.SO_ShipToAddress a
WHERE UDF_INACTIVE <> 'Y'
GROUP BY ARDivisionNo, CustomerNo
HAVING COUNT(*) > 1
)
SELECT     c.ARDivisionNo + c.CustomerNo as AcctNo
			,c.PrimaryShipToCode as Def
			,ShipToCode as Code
			,ShipToName as Name
			,CASE WHEN len(ShipToAddress2)=0 then LEFT(ShipToAddress1 ,30) ELSE LEFT(ShipToAddress1 ,30) + ', ' + LEFT(ShipToAddress2 ,30) END as Addr
FROM         MAS_POL.dbo.AR_Customer c INNER JOIN MAS_POL.dbo.SO_ShipToAddress Addr ON c.ARDivisionNo = Addr.ARDivisionNo and c.CustomerNo = Addr.CustomerNo
			INNER JOIN SHIPTOTALS st ON c.ARDivisionNo = st.ARDivisionNo and c.CustomerNo = st.CustomerNo
WHERE (Addr.UDF_INACTIVE <> 'Y') and (c.PriceLevel <> '') and ((c.ARDIVISIONNO = '00') or (c.ARDIVISIONNO = '02')) and ((@AccountType = 'REP' and c.SalespersonNo = @RepCode) or (@AccountType = 'OFF' and c.SalespersonNo not like 'XX%'))
FOR JSON AUTO
END
