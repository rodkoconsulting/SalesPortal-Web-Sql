/****** Object:  Procedure [dbo].[PortalWebSampleSavedHeaderUpdate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.PortalWebSampleSavedHeaderUpdate 
	-- Add the parameters for the stored procedure here
	@OrderNo bigint,
	@DateDelivery char(6),
	@Notes varchar(150),
	@ShipTo varchar(4)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	BEGIN TRY
		BEGIN TRAN
			UPDATE dbo.PortalWebSampleSavedHeader
				SET
					DATE_SAVED = GETDATE(),
					DATE_DELIVERY = CONVERT(datetime, @DateDelivery, 12),
					NOTES = @Notes,
					SHIPTO = @ShipTo
				where OrderNo = @OrderNo
			DELETE [dbo].[PortalWebSampleSavedDetails] WHERE OrderNo = @OrderNo;
	IF @@ERROR<>0
		BEGIN
			ROLLBACK TRAN
			SELECT -1
		END
	ELSE
		BEGIN
			COMMIT TRAN
			SELECT @OrderNo AS OrderNo
		END
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
	SELECT -1
	END CATCH
END
