/****** Object:  Procedure [dbo].[PortalSampleOrderHeaderCreate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalSampleOrderHeaderCreate]
	-- Add the parameters for the stored procedure here
	@ShipTo varchar(4),
	@DateString char(6),
	@Notes varchar(150),
	@Id varchar(50)
AS
BEGIN
	DECLARE @OrderNo int;
	DECLARE @IsActive bit;
	DECLARE @Date datetime;
	DECLARE @IdLog varchar(25);
	BEGIN TRY
	SET @Date = convert(datetime, @DateString, 12)
	SET @IdLog = (SELECT ID FROM PortalExportLog where ID = @Id)
	IF NOT @IdLog IS NULL
		BEGIN
			--DECLARE @emailbody varchar(2000);
			--SET @emailbody = 'Customer: '+@ShipTo+char(13)+'Order Type: '+'Sample'+char(13)+'Date: '+@DateString+char(13)+'Notes: '+@Notes+char(13)+'Coop: '
			--EXEC msdb.dbo.sp_send_dbmail
			--@profile_name='SP_Error_log',
			--@recipients='admin@polanerselections.com',
			--@subject='Sales Portal Sample Duplicate Order Attempt',
			--@body=@emailbody
			SELECT 0
		END
	IF @IdLog IS NULL
		BEGIN
			INSERT INTO dbo.PortalSampleOrderTransmitHeader(STATUS,SHIPTO,DELIVERYDAY,NOTES)
			VALUES('N',@ShipTo,@Date,@Notes)
			SET @OrderNo = CAST(SCOPE_IDENTITY() AS INT)
			INSERT INTO dbo.PortalExportLog(Date, Id)
			VALUES(GETDATE(), @Id)
			INSERT INTO dbo.PortalDebugLog(Date, OrderNo, Account, LastMessage)
			VALUES(GETDATE(), @OrderNo,@ShipTo,'Added Header')
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
