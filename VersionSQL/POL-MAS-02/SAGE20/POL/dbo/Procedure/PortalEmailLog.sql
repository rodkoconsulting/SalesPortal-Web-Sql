/****** Object:  Procedure [dbo].[PortalEmailLog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalEmailLog]
	-- Add the parameters for the stored procedure her
	@Message varchar(100)
AS
BEGIN
EXEC msdb.dbo.sp_send_dbmail @profile_name='Error_Log',
@recipients='admin@polanerselections.com',
@subject='Sales Portal Error',
@body=@Message
END
