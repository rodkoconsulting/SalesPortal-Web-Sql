/****** Object:  Procedure [dbo].[Email_SP_Import_MO]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Email_SP_Import_MO]
	-- Add the parameters for the stored procedure her
	@OrderNumber varchar(10)
AS
BEGIN
DECLARE @emailbody varchar(100);
SET @emailbody = 'Order Number: '+@OrderNumber+char(13)+'Warning: Rep submitted Master Order'
EXEC msdb.dbo.sp_send_dbmail @profile_name='SP_Error_Log',
@recipients='orders@polanerselections.com',
@subject='Sales Portal MO Warning',
@body=@emailbody
END
