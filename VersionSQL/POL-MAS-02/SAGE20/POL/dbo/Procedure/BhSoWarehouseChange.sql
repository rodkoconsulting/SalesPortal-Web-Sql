/****** Object:  Procedure [dbo].[BhSoWarehouseChange]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[BhSoWarehouseChange] 
AS
BEGIN
	UPDATE [dbo].[BhDetails]
	SET WarehouseCode = '001', CostOfGoodsSoldAcctKey = '00000000Z'
END
