/****** Object:  Procedure [dbo].[Web_Account_MoboPop]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_MoboPop]
	-- Add the parameters for the stored procedure here
	@OrderNo bigint,
	@MasterNoUser varchar(7),
	@MasterNoRep varchar(7),
	@ARDivisionNo char(2)='00',
	@CustomerNo varchar(9)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	BEGIN TRY
	BEGIN TRAN
	DELETE FROM dbo.Web_Account_MoboDetails WHERE ORDERNO=@OrderNo
	INSERT INTO dbo.Web_Account_MoboDetails(ORDERNO,ITEMCODE,SALESORDERNO,Cases,Bottles)
	SELECT DISTINCT @OrderNo,MAS_POL.dbo.SO_SALESORDERDETAIL.ITEMCODE,MAS_POL.dbo.SO_SALESORDERHEADER.SALESORDERNO,0,0
	FROM         MAS_POL.dbo.SO_SALESORDERHEADER INNER JOIN
                      MAS_POL.dbo.SO_SALESORDERDETAIL ON MAS_POL.dbo.SO_SALESORDERHEADER.SALESORDERNO = MAS_POL.dbo.SO_SALESORDERDETAIL.SALESORDERNO
	WHERE     (MAS_POL.dbo.SO_SALESORDERDETAIL.ITEMTYPE = 1) AND
			  (MAS_POL.dbo.SO_SALESORDERDETAIL.QUANTITYORDERED > 0) AND 
              (MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'IN' OR MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'MO' OR MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'BH') AND
              (MAS_POL.dbo.SO_SALESORDERHEADER.ARDIVISIONNO = '00') AND
              (MAS_POL.dbo.SO_SALESORDERHEADER.UDF_REVIEW_RESTRICTIONS = 'Y')  AND
              ((MAS_POL.dbo.SO_SALESORDERHEADER.CUSTOMERNO = @CustomerNo and MAS_POL.dbo.SO_SALESORDERHEADER.ARDivisionNo = @ARDivisionNo) OR MAS_POL.dbo.SO_SALESORDERHEADER.CUSTOMERNO = @MasterNoUser or MAS_POL.dbo.SO_SALESORDERHEADER.CUSTOMERNO = @MasterNoRep)
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
