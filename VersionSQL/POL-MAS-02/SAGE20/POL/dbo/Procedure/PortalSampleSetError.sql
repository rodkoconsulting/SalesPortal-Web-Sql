/****** Object:  Procedure [dbo].[PortalSampleSetError]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalSampleSetError]
	-- Add the parameters for the stored procedure here
	@OrderNumber bigint
AS
BEGIN
UPDATE PortalSampleOrderTransmitHeader
SET STATUS = 'E'
WHERE ORDERNO = @OrderNumber
END
