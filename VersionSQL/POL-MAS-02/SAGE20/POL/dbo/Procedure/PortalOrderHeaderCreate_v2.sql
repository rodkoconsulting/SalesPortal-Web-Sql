/****** Object:  Procedure [dbo].[PortalOrderHeaderCreate_v2]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalOrderHeaderCreate_v2]
	-- Add the parameters for the stored procedure here
	@Customer varchar(9),
	@OrderType varchar(3),
	@DateString char(6),
	@Notes varchar(150),
	@Coop varchar(8),
	@Po varchar(25),
	@ShipTo varchar(4),
	@Id varchar(50),
	@UserCode varchar(25) = null
AS
BEGIN
	DECLARE @OrderNo int;
	DECLARE @IsActive bit;
	DECLARE @Date datetime;
	DECLARE @IdLog varchar(25);
	DECLARE @DateOriginal varchar(25);
	DECLARE @DateDuplicate varchar(25);
	DECLARE @DivisionNo char(2);
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
			IF LEN(@Customer) > 7 or left(@Customer,2)='00' or left(@Customer,2)='02'
				BEGIN
					SET @DivisionNo = LEFT(@Customer,2)
					SET @Customer = SUBSTRING(@Customer,3,LEN(@Customer)-2)
				END
			ELSE
				BEGIN
					SET @DivisionNo = '00'
				END
			INSERT INTO dbo.PortalOrderTransmitHeader(STATUS,ORDERTYPE,CUSTOMERNO,DIVISIONNO,DELIVERYDAY,NOTES,PONO,COOPNO,SHIPTO,USERCODE,OrderId)
			VALUES('N',@OrderType,@Customer,@DivisionNo, @Date,@Notes,@Po,@Coop,@ShipTo,@UserCode,@Id)
			SET @OrderNo = CAST(SCOPE_IDENTITY() AS INT)
			IF @Id <> ''
				BEGIN
					INSERT INTO dbo.PortalExportLog(Date, Id, Customer)
					VALUES(GETDATE(), @Id, @Customer)
				END
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
	EXEC msdb.dbo.sp_send_dbmail
	@profile_name='SP_Error_log',
	@recipients='admin@polanerselections.com',
	@subject='SQL Proc error',
	@body='Error to follow'
	DECLARE @ErrorMessage nvarchar(4000)
	DECLARE @ErrorSeverity int
	DECLARE @ErrorProcedure nvarchar(500)
	DECLARE @ErrorDetail nvarchar(4000)
	SET @ErrorDetail = 'Division: '+@DivisionNo+char(13)+'Customer: '+@Customer+char(13)+'Order Type: '+@OrderType+char(13)+'Date: '+@DateString+char(13)+'Notes: '
			+@Notes+char(13)+'Coop: '+@Coop+char(13)+'PO: '+@Po+char(13)+'ShipTo: '+ @ShipTo+char(13)+'ID: '+ @Id;
	SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorSeverity=ERROR_SEVERITY(), @ErrorProcedure=ERROR_PROCEDURE()
	RAISERROR(@ErrorMessage,@ErrorSeverity,1) WITH LOG
	EXEC msdb.dbo.sp_send_dbmail
	@profile_name='SP_Error_log',
	@recipients='admin@polanerselections.com',
	@subject='SQL Proc error: PortalOrderHeaderCreate_v2',
	@body=@ErrorDetail

	SELECT -1
	END CATCH
END
