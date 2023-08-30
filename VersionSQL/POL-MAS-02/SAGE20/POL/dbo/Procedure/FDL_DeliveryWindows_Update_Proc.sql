/****** Object:  Procedure [dbo].[FDL_DeliveryWindows_Update_Proc]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FDL_DeliveryWindows_Update_Proc] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
UPDATE [POL].[dbo].[FDL_DeliveryWindows_Update]
   SET [UDF_DELIVERY_WINDOW_1_START] = UDF_DELIVERY_WINDOW_1_START_NEW
      ,[UDF_DELIVERY_WINDOW_1_END] = UDF_DELIVERY_WINDOW_1_END_NEW
      ,[UDF_DELIVERY_WINDOW_2_END] = UDF_DELIVERY_WINDOW_2_END_NEW
      ,[UDF_DELIVERY_WINDOW_2_START] = UDF_DELIVERY_WINDOW_2_START_NEW
      ,[UDF_INSTRUCTIONS] = UDF_INSTRUCTIONS_NEW
END
