/****** Object:  Procedure [dbo].[FDL_DeliveryWindows_Create]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[FDL_DeliveryWindows_Create]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON;
INSERT INTO [dbo].[FDL_DeliveryWindows_Current]
	SELECT [Ship to ID]
      ,[Name]
      ,[Address]
      ,[City]
      ,[State]
      ,[Zip]
      ,[Delivery Instruction]
      ,[Delivery Window # 1 - Open]
      ,[Delivery Window # 1 - Close]
      ,[Delivery Window # 2 - Open]
      ,[Delivery Window # 2 - Close]
  FROM [POL].[dbo].[FDL_DeliveryWindows]
END
