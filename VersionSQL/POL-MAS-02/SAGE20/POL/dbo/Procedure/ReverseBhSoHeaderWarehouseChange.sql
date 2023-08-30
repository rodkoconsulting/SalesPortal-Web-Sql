/****** Object:  Procedure [dbo].[ReverseBhSoHeaderWarehouseChange]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[ReverseBhSoHeaderWarehouseChange] 
AS
BEGIN
	UPDATE [dbo].[BhHeader]
	SET WarehouseCodeHeader = '000'
END
