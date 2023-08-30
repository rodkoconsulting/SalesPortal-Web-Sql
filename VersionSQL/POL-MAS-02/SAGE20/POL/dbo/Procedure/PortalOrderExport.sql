/****** Object:  Procedure [dbo].[PortalOrderExport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalOrderExport]
	@OrderNo bigint
AS
begin try
begin transaction
declare @cmd varchar(500)
declare @scmd varchar(100)
declare @arg varchar(25)
declare @cmdline varchar(525)
declare @ismasactive bit
set nocount on
set @arg=CONVERT(varchar(25),@OrderNo)
set @cmd = 'E:\BoiCode\2020\portalorderexport2020-handoff.vbs '
set @scmd = 'c:\windows\system32\cscript.exe '+@cmd
set @cmdline=@scmd+@arg
SET @ismasactive = (select IsMasActive from dbo.Web_MasFlags where ID = 1)
if @ismasactive = 1
	BEGIN
		UPDATE dbo.PortalOrderTransmitHeader set STATUS='I' WHERE ORDERNO=@OrderNo
		exec xp_cmdshell @cmdline, 'no_output'
	END
else
	BEGIN
		UPDATE dbo.PortalOrderTransmitHeader set STATUS='Q' WHERE ORDERNO=@OrderNo
	END
SELECT 1
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
