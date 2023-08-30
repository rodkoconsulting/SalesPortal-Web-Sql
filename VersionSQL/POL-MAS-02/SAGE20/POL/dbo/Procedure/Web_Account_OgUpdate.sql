/****** Object:  Procedure [dbo].[Web_Account_OgUpdate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_OgUpdate]
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
	@LastPrice decimal(16,6),
	@Cases int,
	@Bottles int,
	@UnitPriceCase decimal(16,6),
	@UnitPriceBottle decimal(16,6),
	@Total decimal(16,2),
	@MoboList varchar(40),
	@MoboTotal int,
	@IsOverride bit,
	@IsMix bit
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	BEGIN TRY
	BEGIN TRANSACTION

	UPDATE dbo.Web_Account_OgDetails set PriceCase=@PriceCase,PriceBottle=@PriceBottle,DiscountCase=@DiscountCase,DiscountBottle=@DiscountBottle,DiscountList=@DiscountList,LastInvoiceDate=@LastInvoiceDate,LastQuantityShipped=@LastQuantityShipped,LastPrice=@LastPrice,Cases=@Cases,Bottles=@Bottles,MoboList=@MoboList,UnitPriceCase=@UnitPriceCase,UnitPriceBottle=@UnitPriceBottle,Total=@Total,MoboTotal=@MoboTotal,IsOverride=@IsOverride,IsMix=@IsMix
	WHERE ORDERNO=@OrderNo AND ITEMCODE=@ItemCode
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
