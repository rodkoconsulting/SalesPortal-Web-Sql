/****** Object:  Procedure [dbo].[PortalWebSampleAccounts]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebSampleAccounts]
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
SELECT @RepCode = RepCode FROM Web_UserMappings where UserName=@UserName
SELECT @AccountType = AccountType FROM Web_UserMappings where UserName=@UserName      
SELECT DISTINCT '00' + a.ShipToCode as AcctNo
, 'SAMPLES - ' + a.FullName as AcctName	   
FROM PO_PurchaseOrderHeader h
			INNER JOIN PortalPoAddress a ON h.ShipToCode = a.ShipToCode
			INNER JOIN PO_PurchaseOrderDetail d ON h.PurchaseOrderNo = d.PurchaseOrderNo
		    WHERE h.OrderType = 'X' AND h.OrderStatus <> 'X' AND h.RequiredExpireDate > GETDATE() and ((@AccountType = 'REP' and a.Rep = @RepCode) or (@AccountType = 'OFF'))
END
