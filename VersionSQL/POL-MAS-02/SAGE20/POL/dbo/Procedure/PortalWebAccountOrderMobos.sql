/****** Object:  Procedure [dbo].[PortalWebAccountOrderMobos]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebAccountOrderMobos]
	-- Add the parameters for the stored procedure here
	@UserName varchar(25),
	@AcctNo varchar(9)
AS
BEGIN
	DECLARE @UserCode varchar(4);
	DECLARE @MasterUser varchar(7);
	DECLARE @MasterAcct varchar(7);
	DECLARE @AccountType char(3);
	DECLARE @DivisionNo char(2);
	DECLARE @CustomerNo varchar(10);
SELECT @DivisionNo = LEFT(@AcctNo,2)
SELECT @CustomerNo = SUBSTRING(@AcctNo,3,len(@AcctNo)-2)
SELECT @AccountType = AccountType FROM Web_UserMappings where UserName=@UserName 
SELECT @UserCode = RepCode FROM Web_UserMappings where UserName=@UserName
SELECT @MasterUser = 'ZZA' + @UserCode
SET NOCOUNT ON;
SELECT
h.SalesOrderNo as OrderNo,     
h.ARDivisionNo + h.CustomerNo as AcctNo,
CONVERT(varchar, ShipExpireDate, 12) as ShipExpireDate,
CASE WHEN CancelReasonCode='IN' THEN 'BO' ELSE CancelReasonCode END as Type,
ItemCode,
CAST(ROUND(QuantityOrdered,2) AS FLOAT) as Quantity
FROM         MAS_POL.dbo.SO_SalesOrderHeader h INNER JOIN
                      MAS_POL.dbo.SO_SalesOrderDetail d ON h.SalesOrderNo = d.SalesOrderNo
where ((h.CustomerNo = @MasterUser) or (h.ARDivisionNo = @DivisionNo and h.CustomerNo = @CustomerNo) or (@AccountType = 'OFF' and h.CustomerNo like 'ZZA%') )
 and (CancelReasonCode = 'IN' or CancelReasonCode = 'MO' or CancelReasonCode = 'BH') and (QuantityOrdered > 0)
ORDER BY h.CustomerNo, h.SalesOrderNo
	End;
