/****** Object:  Procedure [dbo].[SageLabelSet]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SageLabelSet]
	-- Add the parameters for the stored procedure here
	@ItemCode varchar(30),
	@FileName varchar(40)
AS
begin try
UPDATE MAS_POL.dbo.CI_Item
SET ImageFile = @FileName
WHERE ItemCode = @ItemCode
return 0
end try
BEGIN CATCH
	DECLARE @ErrorMessage nvarchar(4000)
	DECLARE @ErrorSeverity int
	DECLARE @ErrorProcedure nvarchar(500)
	DECLARE @emailbody nvarchar(1000)
	SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorSeverity=ERROR_SEVERITY(), @ErrorProcedure=ERROR_PROCEDURE()
	RAISERROR(@ErrorMessage,@ErrorSeverity,1) WITH LOG
	SET @emailbody = 'Unable to set label for item ' + @ItemCode + ': ' + @ErrorProcedure 
	EXEC msdb.dbo.sp_send_dbmail
	@profile_name='Error_log',
	@recipients='admin@polanerselections.com',
	@subject='Sage Label Set error',
	@body=@emailbody
	ROLLBACK TRAN
	return 1
END CATCH
