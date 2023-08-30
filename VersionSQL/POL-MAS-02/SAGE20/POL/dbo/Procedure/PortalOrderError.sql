/****** Object:  Procedure [dbo].[PortalOrderError]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalOrderError]
	@OrderNumber varchar(7),
	@ItemNumber varchar(10),
	@QuantityOrdered varchar(1000),
	@ErrorNumber int,
	@EmailSubject varchar(50)
AS
BEGIN
DECLARE @errordescription varchar(50);
DECLARE @emailbody varchar(2000);
SELECT @errordescription=ErrorDescription FROM SP_ERRORLOG_INFO WHERE ErrorCode=@ErrorNumber;
SET @emailbody = 'Order Number: '+@OrderNumber+char(13)+'Item Number: '+@ItemNumber+char(13)+'Quantity Ordered: '+@QuantityOrdered+char(13)+'Error: '+@errordescription
EXEC msdb.dbo.sp_send_dbmail @profile_name='SP_Error_log',
@recipients='orders@polanerselections.com',
@subject=@EmailSubject,
@body=@emailbody
END
