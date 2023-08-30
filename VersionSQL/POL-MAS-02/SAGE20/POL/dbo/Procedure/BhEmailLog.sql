/****** Object:  Procedure [dbo].[BhEmailLog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[BhEmailLog]
	-- Add the parameters for the stored procedure her
	@Message varchar(100)
AS
BEGIN
EXEC msdb.dbo.sp_send_dbmail @profile_name='Error_Log',
@recipients='admin@polanerselections.com',
@subject='BH Transaction error',
@body=@Message
END
