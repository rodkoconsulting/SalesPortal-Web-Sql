/****** Object:  Procedure [dbo].[Email_Refresh_Message]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Email_Refresh_Message]
	-- Add the parameters for the stored procedure her
	@Message varchar(100)
AS
BEGIN
EXEC msdb.dbo.sp_send_dbmail @profile_name='Error_Log',
@recipients='admin@polanerselections.com',
@subject='Daily Refresh message',
@body=@Message
END
