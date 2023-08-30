/****** Object:  Procedure [dbo].[Resend_SP_ExceptionLog_Data]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Resend_SP_ExceptionLog_Data]
	-- Add the parameters for the stored procedure here
	@OrderNumber varchar(10),
	@InnerException varchar(5000)
AS
BEGIN
--DECLARE @emailbody varchar(100);
DECLARE @emailbody varchar(5100);
DECLARE @OrderNumberInt bigint;
SET @OrderNumberInt = CONVERT(bigint, @OrderNumber);
SET @emailbody = 'SQL Order Number: '+@OrderNumber+char(13)+'Error: '+@InnerException;
EXEC msdb.dbo.sp_send_dbmail @profile_name='SP_Error_log',
@recipients='admin@polanerselections.com',
@subject='Sales Portal data import error',
@body=@emailbody
EXEC [POL].[dbo].[Web_Account_OrderExport] @OrderNumberInt
END
