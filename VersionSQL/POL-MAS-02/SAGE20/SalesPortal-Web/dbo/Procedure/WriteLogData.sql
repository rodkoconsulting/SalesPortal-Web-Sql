/****** Object:  Procedure [dbo].[WriteLogData]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[WriteLogData]
	-- Add the parameters for the stored procedure here
	@Message varchar(100)
AS
BEGIN
SET NOCOUNT ON
DECLARE @emailbody varchar(100);
SET @emailbody = @Message
DECLARE	@return_value int
EXEC @return_value = msdb.dbo.sp_send_dbmail @profile_name='Error_log',
@recipients='itadmin@polanerselections.com',
@subject='SQL Logs',
@body=@emailbody
SELECT	CONVERT(varchar(5), @return_value) as 'RESULT'
END
