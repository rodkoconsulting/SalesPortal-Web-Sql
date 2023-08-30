/****** Object:  Procedure [dbo].[PortalSampleEmailError]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalSampleEmailError]
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
SET @emailbody = 'Sample Order Number: '+@OrderNumber+char(13)+'Item Number: '+@ItemNumber+char(13)+'Quantity Ordered: '+@QuantityOrdered+char(13)+'Error: '+@errordescription
EXEC msdb.dbo.sp_send_dbmail @profile_name='SP_Error_log',
@recipients='orders@polanerselections.com',
@subject='Sales Portal Sample import error',
@body=@emailbody
END
