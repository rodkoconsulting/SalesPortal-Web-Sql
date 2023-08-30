/****** Object:  Procedure [dbo].[Web_Account_OgCreate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_OgCreate]
	-- Add the parameters for the stored procedure here
	@ARDivisionNo char(2)='00',
	@Customer varchar(9),
	@UserCode char(4)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @OrderNo int;
	BEGIN TRY
    BEGIN TRAN
	INSERT INTO dbo.Web_Account_OgHeader(ORDERTYPE,ORDERSTATUS,ARDIVISIONNO,CUSTOMERNO,USERCODE,SAVEDDATE,DELIVERYDAY,PONO,COOPNO,COOPCASES,TOTALCASES,TOTALBOTTLES,TOTALQUANTITY,TOTALDOLLARS)
	VALUES('Standard','N',@ARDivisionNo,@Customer,@UserCode,GETDATE(),GETDATE(),NULL,NULL,0,0,0,0,0)
	SET @OrderNo = CAST(SCOPE_IDENTITY() AS INT)
	SELECT @OrderNo AS NewOrderNo
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
	SELECT -1
	END CATCH
END
