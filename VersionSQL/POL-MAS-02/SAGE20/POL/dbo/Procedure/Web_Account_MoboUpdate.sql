﻿/****** Object:  Procedure [dbo].[Web_Account_MoboUpdate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_MoboUpdate]
	-- Add the parameters for the stored procedure here
	@OrderNo bigint,
	@ItemCode varchar(15),
	@SalesOrderNo char(7),
	@Cases int,
	@Bottles int
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
BEGIN TRY	
BEGIN TRAN
	UPDATE dbo.Web_Account_MoboDetails set Cases=@Cases,Bottles=@Bottles
	WHERE ORDERNO=@OrderNo AND ITEMCODE=@ItemCode AND SALESORDERNO=@SalesOrderNo
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
