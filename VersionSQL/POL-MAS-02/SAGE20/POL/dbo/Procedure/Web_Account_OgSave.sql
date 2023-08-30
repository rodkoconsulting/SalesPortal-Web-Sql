/****** Object:  Procedure [dbo].[Web_Account_OgSave]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_OgSave]
	-- Add the parameters for the stored procedure here
	@ARDivisionNo char(2)='00',
	@Customer varchar(9),
	@OrderNo bigint
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
BEGIN TRY
BEGIN TRAN
	DELETE Web_Account_OgSaved WHERE CUSTOMERNO = @Customer and ARDIVISIONNO = @ARDivisionNo
	INSERT INTO Web_Account_OgSaved(ARDIVISIONNO, CUSTOMERNO,ITEMCODE)
	SELECT @ARDivisionNo, @Customer,ITEMCODE
	FROM Web_Account_OgDetails
	WHERE ORDERNO = @OrderNo
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
