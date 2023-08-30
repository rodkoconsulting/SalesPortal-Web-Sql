/****** Object:  Procedure [dbo].[PortalSalesSetOrderError]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalSalesSetOrderError]
	-- Add the parameters for the stored procedure here
	@OrderNumber bigint
AS
BEGIN
UPDATE PortalOrderTransmitHeader
SET STATUS = 'E'
WHERE ORDERNO = @OrderNumber
END
