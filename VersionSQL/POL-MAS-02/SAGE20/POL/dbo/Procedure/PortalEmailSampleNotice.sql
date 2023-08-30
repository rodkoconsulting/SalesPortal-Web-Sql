/****** Object:  Procedure [dbo].[PortalEmailSampleNotice]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalEmailSampleNotice]
	-- Add the parameters for the stored procedure her
	@OrderNumber varchar(10)
AS
BEGIN
DECLARE @emailbody varchar(100);
SET @emailbody = 'Order Number: '+@OrderNumber+char(13)+'Rep submitted Sample Order'
EXEC msdb.dbo.sp_send_dbmail @profile_name='SP_Error_Log',
@recipients='orders@polanerselections.com',
@subject='Sales Portal Sample Order Submitted',
@body=@emailbody
END
