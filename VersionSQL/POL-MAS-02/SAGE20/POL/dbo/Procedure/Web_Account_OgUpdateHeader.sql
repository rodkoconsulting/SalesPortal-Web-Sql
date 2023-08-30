/****** Object:  Procedure [dbo].[Web_Account_OgUpdateHeader]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_OgUpdateHeader]
	-- Add the parameters for the stored procedure here
	@OrderNo bigint,
	@ARDivisionNo char(2)='00',
	@CustomerNo varchar(9),
	@OrderType varchar(20),
	@OrderStatus char(1),
	@SavedDate datetime,
	@DeliveryDay datetime,
	@Notes varchar(150),
	@CoopNo varchar(8),
	@CoopCases smallint,
	@TotalCases smallint,
	@TotalBottles smallint,
	@TotalQuantity decimal (16,8),
	@TotalDollars decimal(18,2),
	@PoNo varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
BEGIN TRY	
BEGIN TRAN
	UPDATE dbo.Web_Account_OgHeader set ORDERTYPE=@OrderType, ORDERSTATUS=@OrderStatus, SAVEDDATE=@SavedDate, DELIVERYDAY=@DeliveryDay, NOTES=@Notes, COOPNO=@CoopNo, COOPCASES=@CoopCases, TOTALCASES=@TotalCases, TOTALBOTTLES=@TotalBottles, TOTALQUANTITY=@TotalQuantity, TOTALDOLLARS=@TotalDollars, PONO=@PoNo
	WHERE ORDERNO=@OrderNo AND CUSTOMERNO=@CustomerNo and ARDIVISIONNO = @ARDivisionNo
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
