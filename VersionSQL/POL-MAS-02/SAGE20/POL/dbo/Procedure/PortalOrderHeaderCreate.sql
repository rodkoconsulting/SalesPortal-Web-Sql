/****** Object:  Procedure [dbo].[PortalOrderHeaderCreate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalOrderHeaderCreate]
	-- Add the parameters for the stored procedure here
	@Customer varchar(7),
	@OrderType varchar(3),
	@DateString char(6),
	@Notes varchar(150),
	@Coop varchar(8),
	@Po varchar(25),
	@Id varchar(50)
AS
BEGIN
	DECLARE @OrderNo int;
	DECLARE @IsActive bit;
	DECLARE @Date datetime;
	DECLARE @IdLog varchar(25);
	DECLARE @DateOriginal varchar(25);
	DECLARE @DateDuplicate varchar(25);
	BEGIN TRY
	SET @Date = convert(datetime, @DateString, 12)
	SET @IdLog = (SELECT ID FROM PortalExportLog where ID = @Id)
		IF NOT @IdLog IS NULL
		BEGIN
			DECLARE @emailbody varchar(2000);
			SET @DateOriginal = CONVERT (varchar, (Select DATE FROM PortalExportLog where ID = @Id), 121);
			SET @DateDuplicate = CONVERT (varchar, GETDATE(), 121);
			SET @emailbody = 'Customer: '+@Customer+char(13)+'Order Type: '+@OrderType+char(13)+'Date: '+@DateString+char(13)+'Notes: '
			+@Notes+char(13)+'Coop: '+@Coop+char(13)+'PO: '+@Po+char(13)+'Original Date: '+ @DateOriginal + char(13) + 'Duplicate Date: '+ @DateDuplicate;
			EXEC msdb.dbo.sp_send_dbmail
			@profile_name='SP_Error_log',
			@recipients='admin@polanerselections.com',
			@subject='Sales Portal Duplicate Order Attempt',
			@body=@emailbody
			SELECT 0
		END
	IF @IdLog IS NULL
		BEGIN
	--		BEGIN TRAN
			INSERT INTO dbo.PortalOrderTransmitHeader(STATUS,ORDERTYPE,CUSTOMERNO,DELIVERYDAY,NOTES,PONO,COOPNO)
			VALUES('N',@OrderType,@Customer,@Date,@Notes,@Po,@Coop)
			SET @OrderNo = CAST(SCOPE_IDENTITY() AS INT)
			INSERT INTO dbo.PortalExportLog(Date, Id, Customer)
			VALUES(GETDATE(), @Id, @Customer)
			SELECT @OrderNo AS NewOrderNo
	--		COMMIT TRAN
		END

	--SET @IsActive = (select IsMasActive from dbo.Web_MasFlags where ID = 1)
	--DECLARE @Status char(1) =
    --    CASE
    --    WHEN @IsActive = 1 THEN 'N'
    --    ELSE 'Q'
    --    END
    
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
