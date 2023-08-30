/****** Object:  Procedure [dbo].[Write_SP_AllNotes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Write_SP_AllNotes]
	-- Add the parameters for the stored procedure here
	@Notes varchar(2000)
AS
BEGIN
DECLARE @emailbody varchar(2000);
SET @emailbody = @Notes
EXEC msdb.dbo.sp_send_dbmail @profile_name='SP_Error_log',
@recipients='orders@polanerselections.com',
@subject='Sales Portal Notes',
@body=@emailbody
END
