/****** Object:  Procedure [dbo].[PortalWebSavedDetailsCreate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.PortalWebSavedDetailsCreate
	-- Add the parameters for the stored procedure here
	@OrderNo bigint,
	@ItemCode varchar(15),
	@MoboList varchar(40),
	@Bottles decimal(9,5),
	@MoboTotal decimal(9,5)
AS
BEGIN
	BEGIN TRY
    BEGIN TRAN
	INSERT INTO dbo.PortalWebSavedDetails(ORDERNO,ITEMCODE,MoboList,Quantity,MoboTotal)
	VALUES(@OrderNo,@ItemCode,@MoboList,@Bottles,@MoboTotal)
	COMMIT TRAN
	SELECT 1
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
	SELECT -1
	END CATCH
END
