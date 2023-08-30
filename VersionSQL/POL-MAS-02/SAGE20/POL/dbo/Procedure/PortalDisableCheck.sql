/****** Object:  Procedure [dbo].[PortalDisableCheck]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalDisableCheck]
AS
begin try
declare @disableDate datetime
declare @currentDate datetime
declare @ismasactive bit
declare @disabledTime int
set nocount on
SET @ismasactive = (select IsMasActive from dbo.Web_MasFlags where ID = 1)
SET @disableDate = (select DisableTime from dbo.Web_MasFlags where ID = 1)
SET @currentDate = GETDATE()
if @ismasactive = 0 and DATEDIFF(MINUTE,@disableDate,@currentDate) >= 15
	BEGIN
		EXEC msdb.dbo.sp_start_job N'SalesPortal_RevertDisable';
	END
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
	@subject='Sales Portal PortalDisableCheck procedure error',
	@body=@ErrorProcedure
	ROLLBACK TRAN
END CATCH
