﻿/****** Object:  Procedure [dbo].[PortalWebSampleSavedDelete]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.PortalWebSampleSavedDelete
	-- Add the parameters for the stored procedure here
	@OrderNo bigint
AS

BEGIN
BEGIN TRY
BEGIN TRANSACTION
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    DELETE FROM dbo.PortalWebSampleSavedHeader WHERE ORDERNO=@OrderNo
    DELETE FROM dbo.PortalWebSampleSavedDetails WHERE ORDERNO=@OrderNo
	SELECT 1
COMMIT TRANSACTION
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
	SELECT 0
END CATCH
END
