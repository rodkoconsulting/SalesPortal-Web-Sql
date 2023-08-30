/****** Object:  Procedure [dbo].[Web_Account_OgRevertChanges]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_OgRevertChanges]
	-- Add the parameters for the stored procedure here
	@OrderNo bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	BEGIN TRY
	BEGIN TRAN
	MERGE INTO dbo.Web_Account_OgHeader
	USING (
			SELECT ORDERNO
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
           FROM dbo.Web_Account_OgHeader_temp
           WHERE ORDERNO = @OrderNo
           ) AS source
           ON dbo.Web_Account_OgHeader.ORDERNO = source.ORDERNO
    WHEN MATCHED THEN
    UPDATE
    SET
		dbo.Web_Account_OgHeader.[ORDERTYPE] = source.[ORDERTYPE],
		dbo.Web_Account_OgHeader.[SAVEDDATE] = source.[SAVEDDATE],
		dbo.Web_Account_OgHeader.[DELIVERYDAY] = source.[DELIVERYDAY],
		dbo.Web_Account_OgHeader.[NOTES] = source.[NOTES],
		dbo.Web_Account_OgHeader.[COOPCASES] = source.[COOPCASES],
		dbo.Web_Account_OgHeader.[TOTALCASES] = source.[TOTALCASES],
		dbo.Web_Account_OgHeader.[TOTALBOTTLES] = source.[TOTALBOTTLES],
		dbo.Web_Account_OgHeader.[TOTALQUANTITY] = source.[TOTALQUANTITY],
		dbo.Web_Account_OgHeader.[TOTALDOLLARS] = source.[TOTALDOLLARS],
		dbo.Web_Account_OgHeader.[COOPNO] = source.[COOPNO],
		dbo.Web_Account_OgHeader.[PONO] = source.[PONO];
		
    
	DELETE FROM dbo.Web_Account_OgDetails WHERE ORDERNO=@OrderNo
	INSERT INTO dbo.Web_Account_OgDetails (
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
     FROM dbo.Web_Account_OgDetails_temp where ORDERNO=@OrderNo
    DELETE FROM dbo.Web_Account_OgHeader_temp WHERE ORDERNO=@OrderNo
	DELETE FROM dbo.Web_Account_OgDetails_temp WHERE ORDERNO=@OrderNo
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
