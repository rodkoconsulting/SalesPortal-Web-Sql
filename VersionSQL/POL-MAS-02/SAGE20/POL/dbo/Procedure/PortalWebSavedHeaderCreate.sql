/****** Object:  Procedure [dbo].[PortalWebSavedHeaderCreate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PortalWebSavedHeaderCreate] 
	-- Add the parameters for the stored procedure here
	@UserName varchar(15),
	@CustomerNo char(9),
	@OrderType varchar(3),
	@DateDelivery char(6),
	@Notes varchar(150),
	@Coop varchar(8),
	@Po varchar(25),
	@ShipTo varchar(4)
AS
BEGIN
	DECLARE @OrderNo int;
	BEGIN TRY
		BEGIN TRAN
			INSERT INTO dbo.PortalWebSavedHeader(USERNAME,CUSTOMERNO,ORDERTYPE,DATE_SAVED,DATE_DELIVERY,NOTES,COOPNO,PONO,SHIPTO)
			VALUES(@UserName,@CustomerNo,@OrderType,GETDATE(),CONVERT(datetime, @DateDelivery, 12),@Notes,@Coop,@Po,@ShipTo)
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
