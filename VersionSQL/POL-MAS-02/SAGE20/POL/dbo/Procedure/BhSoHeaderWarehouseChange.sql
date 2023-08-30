/****** Object:  Procedure [dbo].[BhSoHeaderWarehouseChange]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[BhSoHeaderWarehouseChange] 
AS
BEGIN
	UPDATE [dbo].[BhHeader]
	SET WarehouseCodeHeader = '001'
END
