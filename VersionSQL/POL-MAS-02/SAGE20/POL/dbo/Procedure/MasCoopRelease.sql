/****** Object:  Procedure [dbo].[MasCoopRelease]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[MasCoopRelease]
	-- Add the parameters for the stored procedure here
	@Date datetime
AS
begin try
UPDATE SO_CoopRelease
SET OrderStatus = Case When [UDF_REVIEW_CREDIT] = 'N' OR [UDF_REVIEW_PO] = 'N' then 'H' else 'O' End,
	CancelReasonCode = Case When [UDF_REVIEW_CREDIT] = 'N' Then 'CRED'
							When  [UDF_REVIEW_PO] = 'N' Then 'PO'
							Else ''
							End,
	[UDF_REVIEW_COOP] = 'Y'
FROM SO_CoopRelease INNER JOIN
                      dbo.Web_Orders_Coops WITH ( NOLOCK ) ON SO_CoopRelease.UDF_NJ_COOP = dbo.Web_Orders_Coops.CoopNo AND 
                      SO_CoopRelease.ShipExpireDate = dbo.Web_Orders_Coops.SHIPDATE
WHERE     ShipExpireDate = @Date and (CAST(ROUND(dbo.Web_Orders_Coops.QUANTITYORDERED, 2) AS NUMERIC(12, 2)) 
                      >= 5)
return 0
end try
BEGIN CATCH
	DECLARE @ErrorMessage nvarchar(4000)
	DECLARE @ErrorSeverity int
	DECLARE @ErrorProcedure nvarchar(500)
	SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorSeverity=ERROR_SEVERITY(), @ErrorProcedure=ERROR_PROCEDURE()
	RAISERROR(@ErrorMessage,@ErrorSeverity,1) WITH LOG
	EXEC msdb.dbo.sp_send_dbmail
	@profile_name='Error_log',
	@recipients='admin@polanerselections.com',
	@subject='Coop Order Release error',
	@body=@ErrorProcedure
	ROLLBACK TRAN
	return 1
END CATCH
