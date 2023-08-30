/****** Object:  Procedure [dbo].[Web_Account_OgEditSaved]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_OgEditSaved]
	-- Add the parameters for the stored procedure here
	@OrderNo bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	BEGIN TRY
    BEGIN TRAN
	DELETE FROM dbo.Web_Account_OgHeader_temp WHERE ORDERNO=@OrderNo
	DELETE FROM dbo.Web_Account_OgDetails_temp WHERE ORDERNO=@OrderNo
	INSERT INTO dbo.Web_Account_OgHeader_temp
			([ORDERNO]
		   ,[ORDERTYPE]
           ,[ORDERSTATUS]
           ,[USERCODE]
           ,[CUSTOMERNO]
           ,[SAVEDDATE]
           ,[DELIVERYDAY]
           ,[NOTES]
           ,[COOPCASES]
           ,[TOTALCASES]
           ,[TOTALBOTTLES]
           ,[TOTALQUANTITY]
           ,[TOTALDOLLARS]
           ,[COOPNO]
           ,[PONO])
	SELECT [ORDERNO]
		   ,[ORDERTYPE]
           ,[ORDERSTATUS]
           ,[USERCODE]
           ,[CUSTOMERNO]
           ,[SAVEDDATE]
           ,[DELIVERYDAY]
           ,[NOTES]
           ,[COOPCASES]
           ,[TOTALCASES]
           ,[TOTALBOTTLES]
           ,[TOTALQUANTITY]
           ,[TOTALDOLLARS]
           ,[COOPNO]
           ,[PONO]
    FROM dbo.Web_Account_OgHeader where ORDERNO=@OrderNo
	INSERT INTO dbo.Web_Account_OgDetails_temp (
			[ORDERNO]
		   ,[ITEMCODE]
           ,[PriceCase]
           ,[PriceBottle]
           ,[DiscountCase]
           ,[DiscountBottle]
           ,[DiscountList]
           ,[MoboList]
           ,[LastInvoiceDate]
           ,[LastQuantityShipped]
           ,[LastPrice]
           ,[Cases]
           ,[Bottles]
           ,[UnitPriceCase]
           ,[UnitPriceBottle]
           ,[Total]
           ,[MoboTotal]
           ,[IsOverride]
           ,[IsMix])
	SELECT  [ORDERNO]
		   ,[ITEMCODE]
           ,[PriceCase]
           ,[PriceBottle]
           ,[DiscountCase]
           ,[DiscountBottle]
           ,[DiscountList]
           ,[MoboList]
           ,[LastInvoiceDate]
           ,[LastQuantityShipped]
           ,[LastPrice]
           ,[Cases]
           ,[Bottles]
           ,[UnitPriceCase]
           ,[UnitPriceBottle]
           ,[Total]
           ,[MoboTotal]
           ,[IsOverride]
           ,[IsMix]
     FROM dbo.Web_Account_OgDetails where ORDERNO=@OrderNo
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
