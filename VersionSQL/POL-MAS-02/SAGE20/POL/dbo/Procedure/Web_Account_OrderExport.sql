/****** Object:  Procedure [dbo].[Web_Account_OrderExport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_OrderExport]
	-- Add the parameters for the stored procedure here
	@OrderNo bigint
	--with exec as 'POLANER\portalproxy'
AS

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	begin try
declare @cmd varchar(500)
declare @scmd varchar(100)
declare @arg varchar(25)
--declare @paren varchar(1)
declare @cmdline varchar(525)
--declare @obj int
--BEGIN TRY
set @arg=CONVERT(varchar(25),@OrderNo)
set @cmd = 'E:\BoiCode\2020\salesportalexport2020-handoff.vbs '
set @scmd = 'c:\windows\system32\cscript.exe '+@cmd

set @cmdline=@scmd+@arg
UPDATE dbo.Web_Account_OgHeader set ORDERSTATUS='I' WHERE ORDERNO=@OrderNo
exec xp_cmdshell @cmdline, 'no_output'
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
