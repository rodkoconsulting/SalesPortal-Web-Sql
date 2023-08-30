/****** Object:  Procedure [dbo].[WspEnable]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[WspEnable]
AS
begin try
begin transaction
declare @cmd varchar(500)
declare @scmd varchar(100)
set nocount on
set @cmd = 'E:\BoiCode\WspEnable.vbs '
set @scmd = 'c:\windows\system32\cscript.exe '+@cmd
exec xp_cmdshell @scmd, 'no_output'
commit transaction
end try
BEGIN CATCH
	DECLARE @ErrorMessage nvarchar(4000)
	DECLARE @ErrorSeverity int
	DECLARE @ErrorProcedure nvarchar(500)
	SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorSeverity=ERROR_SEVERITY(), @ErrorProcedure=ERROR_PROCEDURE()
	RAISERROR(@ErrorMessage,@ErrorSeverity,1) WITH LOG
	EXEC msdb.dbo.sp_send_dbmail
	@profile_name='SP_Error_log',
	@recipients='admin@polanerselections.com',
	@subject='Sales Portal SQL Proc error',
	@body=@ErrorProcedure
	ROLLBACK TRAN
END CATCH
