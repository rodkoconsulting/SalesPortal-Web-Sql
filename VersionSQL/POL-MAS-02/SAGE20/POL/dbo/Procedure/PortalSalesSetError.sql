/****** Object:  Procedure [dbo].[PortalSalesSetError]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalSalesSetError]
	-- Add the parameters for the stored procedure here
	@OrderNumber bigint
AS
BEGIN
UPDATE PortalOrderTransmitHeader
SET STATUS = 'E'
WHERE ORDERNO = @OrderNumber
END
