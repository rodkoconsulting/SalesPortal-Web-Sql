/****** Object:  Procedure [dbo].[Web_Account_OgClearTemp]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_OgClearTemp]
	-- Add the parameters for the stored procedure here
	@OrderNo bigint
AS

BEGIN
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	BEGIN TRAN
    DELETE FROM dbo.Web_Account_OgHeader_temp WHERE ORDERNO=@OrderNo
	DELETE FROM dbo.Web_Account_OgDetails_temp WHERE ORDERNO=@OrderNo
COMMIT TRAN
END TRY
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
END
