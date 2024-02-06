/****** Object:  Procedure [dbo].[PortalWebSampleSavedHeaderCreate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.PortalWebSampleSavedHeaderCreate 
	-- Add the parameters for the stored procedure here
	@UserName varchar(15),
	@ShipTo varchar(4),
	@DateDelivery char(6),
	@Notes varchar(150)
AS
BEGIN
	DECLARE @OrderNo int;
	BEGIN TRY
		BEGIN TRAN
			INSERT INTO dbo.PortalWebSampleSavedHeader(USERNAME,DATE_SAVED,DATE_DELIVERY,NOTES,SHIPTO)
			VALUES(@UserName,GETDATE(),CONVERT(datetime, @DateDelivery, 12),@Notes,@ShipTo)
			SET @OrderNo = CAST(SCOPE_IDENTITY() AS INT)
			IF @@ERROR<>0
				BEGIN
					ROLLBACK TRAN
					SELECT -1
				END
			ELSE
				BEGIN
					COMMIT TRAN
					SELECT @OrderNo AS NewOrderNo
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
