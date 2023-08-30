/****** Object:  Procedure [dbo].[Web_Account_NotesInsert]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_NotesInsert]
	-- Add the parameters for the stored procedure here
	@ARDivisionNo char(2)='00',
	@CustomerNo varchar(10),
	@Notes nvarchar(max)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
BEGIN TRY
BEGIN TRAN
	INSERT INTO dbo.Web_Accounts_RepNotes values (@CustomerNo,@Notes,@ARDivisionNo)
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
