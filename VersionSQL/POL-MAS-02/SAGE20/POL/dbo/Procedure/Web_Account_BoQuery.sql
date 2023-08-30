/****** Object:  Procedure [dbo].[Web_Account_BoQuery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Web_Account_BoQuery]
    @ItemCode varchar(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT [QtyOnPurchaseOrder] - [OnBO] as QuantityAvailable
FROM         IM_InventoryAvailable
WHERE     (ITEMCODE = @ItemCode) 

END
