/****** Object:  Procedure [dbo].[ReverseBhSoWarehouseChange]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[ReverseBhSoWarehouseChange] 
AS
BEGIN
	UPDATE [dbo].[BhDetails]
	SET WarehouseCode = '000', CostOfGoodsSoldAcctKey = '00000008M'
END
