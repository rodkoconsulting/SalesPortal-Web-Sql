/****** Object:  Procedure [dbo].[MasPaRelease]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[MasPaRelease]
	-- Add the parameters for the stored procedure here
	@OrderNo varchar(7)
AS
begin try
declare @cmd varchar(500)
declare @arg varchar(25)
declare @cmdline varchar(525)
declare @result int
set @arg=@OrderNo
set @cmd = 'E:\BoiCode\2020\PaRelease2020.exe '
set @cmdline=@cmd+@arg
exec @result = xp_cmdshell @cmdline
return @result
end try
BEGIN CATCH
	DECLARE @ErrorMessage nvarchar(4000)
	DECLARE @ErrorSeverity int
	DECLARE @ErrorProcedure nvarchar(500)
	SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorSeverity=ERROR_SEVERITY(), @ErrorProcedure=ERROR_PROCEDURE()
	RAISERROR(@ErrorMessage,@ErrorSeverity,1) WITH LOG
	EXEC msdb.dbo.sp_send_dbmail
	@profile_name='Error_log',
	@recipients='admin@polanerselections.com',
	@subject='PA Order Release error',
	@body=@ErrorProcedure
	ROLLBACK TRAN
END CATCH
