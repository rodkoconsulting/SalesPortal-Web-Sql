/****** Object:  Procedure [dbo].[PortalEmailError]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalEmailError]
	-- Add the parameters for the stored procedure here
	@OrderNumber varchar(10),
	@ItemNumber varchar(10),
	--@QuantityOrdered varchar(10),
	@QuantityOrdered varchar(1000),
	@ErrorNumber int
AS
BEGIN
DECLARE @errordescription varchar(50);
--DECLARE @emailbody varchar(100);
DECLARE @emailbody varchar(2000);
SELECT @errordescription=ErrorDescription FROM SP_ERRORLOG_INFO WHERE ErrorCode=@ErrorNumber;
SET @emailbody = 'Order Number: '+@OrderNumber+char(13)+'Item Number: '+@ItemNumber+char(13)+'Quantity Ordered: '+@QuantityOrdered+char(13)+'Error: '+@errordescription
EXEC msdb.dbo.sp_send_dbmail @profile_name='SP_Error_log',
@recipients='orders@polanerselections.com',
@subject='Sales Portal data import error',
@body=@emailbody
END
