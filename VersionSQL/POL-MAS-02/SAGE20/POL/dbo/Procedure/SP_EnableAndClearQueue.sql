/****** Object:  Procedure [dbo].[SP_EnableAndClearQueue]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_EnableAndClearQueue]
AS
declare @OrderNo bigint	
begin try
	EXEC dbo.Web_Account_EnablePortalImport
	SET ROWCOUNT 0
	SELECT ORDERNO into #TEMP FROM dbo.Web_Account_OgHeader WHERE ORDERSTATUS = 'Q'
	SET ROWCOUNT 1
	Select @OrderNo = ORDERNO from #TEMP
	While @@ROWCOUNT <> 0
	begin
		EXECUTE dbo.Web_Account_OrderExport @OrderNo
		DELETE FROM #TEMP WHERE ORDERNO = @OrderNo
		SELECT @OrderNo = ORDERNO from #TEMP
	End
	Set ROWCOUNT 0
	DROP TABLE #TEMP
	SELECT ORDERNO into #TEMPIOS FROM PortalOrderTransmitHeader WHERE STATUS = 'Q'
	SET ROWCOUNT 1
	Select @OrderNo = ORDERNO from #TEMPIOS
	While @@ROWCOUNT <> 0
	begin
		EXECUTE dbo.PortalOrderExport @OrderNo
		DELETE FROM #TEMPIOS WHERE ORDERNO = @OrderNo
		SELECT @OrderNo = ORDERNO from #TEMPIOS
	End
	Set ROWCOUNT 0
	DROP TABLE #TEMPIOS
	SELECT ORDERNO into #TEMPSAMPLE FROM PortalSampleOrderTransmitHeader WHERE STATUS = 'Q'
	SET ROWCOUNT 1
	Select @OrderNo = ORDERNO from #TEMPSAMPLE
	While @@ROWCOUNT <> 0
	begin
		EXECUTE dbo.PortalSampleOrderExport @OrderNo
		DELETE FROM #TEMPSAMPLE WHERE ORDERNO = @OrderNo
		SELECT @OrderNo = ORDERNO from #TEMPSAMPLE
	End
	Set ROWCOUNT 0
	DROP TABLE #TEMPSAMPLE
end try
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
END CATCH
