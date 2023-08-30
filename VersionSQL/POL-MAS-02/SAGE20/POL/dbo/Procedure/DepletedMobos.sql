/****** Object:  Procedure [dbo].[DepletedMobos]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[DepletedMobos]
	-- Add the parameters for the stored procedure here
AS
BEGIN
SELECT SALESORDERNO FROM dbo.MOBO_DepletedOrders;
END
