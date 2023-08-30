/****** Object:  Procedure [dbo].[COD_Orders_UpdateProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[COD_Orders_UpdateProc] 
AS
BEGIN
	UPDATE [POL].[dbo].[COD_Orders_UpdateView]
	SET ORDERSTATUS = [OrderStatusNew]
      ,[CancelReasonCode] = [CancelReasonCodeNew]
      ,[UDF_REVIEW_CREDIT] = [CreditReviewNew]
      ,[TermsCode] = [TermsCodeNew]
END
