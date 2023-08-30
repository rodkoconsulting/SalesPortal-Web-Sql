/****** Object:  Procedure [dbo].[Web_Account_OgInsert]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_OgInsert]
	-- Add the parameters for the stored procedure here
	@OrderNo bigint,
	@ItemCode varchar(15),
	@PriceCase decimal(16,6),
	@PriceBottle decimal(16,6),
	@DiscountCase decimal(16,6),
	@DiscountBottle decimal(16,6),
	@DiscountList varchar(30),
	@LastInvoiceDate datetime,
	@LastQuantityShipped decimal(16,6),
	@LastPrice decimal(16,6)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	BEGIN TRY
	BEGIN TRANSACTION

	INSERT INTO dbo.Web_Account_OgDetails(ORDERNO,ITEMCODE,PriceCase,PriceBottle,DiscountCase,DiscountBottle,DiscountList,LastInvoiceDate,LastQuantityShipped,LastPrice,Cases,Bottles,UnitPriceCase, UnitPriceBottle,Total,MoboTotal,IsOverride,IsMix)
	SELECT @OrderNo,@ItemCode,@PriceCase,@PriceBottle,@DiscountCase,@DiscountBottle,@DiscountList,@LastInvoiceDate,@LastQuantityShipped,@LastPrice,0,0,@PriceCase,@PriceBottle,0,0,0,0
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
	END CATCH
END
