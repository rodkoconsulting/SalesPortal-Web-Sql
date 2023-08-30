/****** Object:  Procedure [dbo].[PortalEmailHeaderError]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalEmailHeaderError]
	@OrderNo bigint
AS
BEGIN
SET NOCOUNT ON
DECLARE @CustomerNo varchar(9);
DECLARE @OrderType varchar(3)
DECLARE @DeliveryDate datetime;
DECLARE @Notes varchar(150);
DECLARE @Coop varchar(8);
DECLARE @Po varchar(25);
DECLARE @ShipTo varchar(4);
DECLARE @UserCode varchar(25);
DECLARE @emailbody varchar(5000);
SELECT  @CustomerNo = CUSTOMERNO
	   ,@OrderType = ORDERTYPE
	   ,@DeliveryDate = DELIVERYDAY
	   ,@Notes = NOTES
	   ,@Coop = COOPNO
	   ,@Po = PONO
	   ,@ShipTo = SHIPTO
	   ,@UserCode = UserCode
FROM PortalOrderHeaderView WHERE ORDERNO=@OrderNo
SET @emailbody = 'Order Number: '+CAST(@OrderNo as varchar(max))+char(13)
	+'Customer: '+@CustomerNo+char(13)
	+'Order Type: '+@OrderType+char(13)
	+'Delivery Date: '+ CASE WHEN Year(@DeliveryDate) > 1900 THEN CONVERT (varchar, @DeliveryDate, 1) ELSE '' END +char(13)
	+'Notes: '+@Notes+char(13)
	+'Coop No: '+@Coop+char(13)
	+'PO No: '+@Po+char(13)
	+'Ship To: '+@ShipTo+char(13)
	+'User: '+@UserCode+char(13)
EXEC msdb.dbo.sp_send_dbmail @profile_name='SP_Error_log',
@recipients='orders@polanerselections.com',
@subject='Sales Portal data import error - Invalid Customer',
@body=@emailbody
END
