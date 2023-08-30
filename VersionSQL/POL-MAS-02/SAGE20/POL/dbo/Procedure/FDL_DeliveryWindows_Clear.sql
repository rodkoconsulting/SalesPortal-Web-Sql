/****** Object:  Procedure [dbo].[FDL_DeliveryWindows_Clear]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[FDL_DeliveryWindows_Clear]
WITH EXECUTE AS owner	
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON;
TRUNCATE TABLE [dbo].[FDL_DeliveryWindows_Previous]
INSERT INTO [dbo].[FDL_DeliveryWindows_Previous]
SELECT * FROM [dbo].[FDL_DeliveryWindows_Current]
TRUNCATE TABLE [dbo].[FDL_DeliveryWindows_Current]
END
