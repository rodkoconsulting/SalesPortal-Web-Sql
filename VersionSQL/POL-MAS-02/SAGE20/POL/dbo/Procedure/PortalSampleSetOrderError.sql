/****** Object:  Procedure [dbo].[PortalSampleSetOrderError]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalSampleSetOrderError]
	-- Add the parameters for the stored procedure here
	@OrderNumber varchar(10)
AS
BEGIN
--DECLARE @emailbody varchar(100);
DECLARE @OrderNumberInt bigint;
SET @OrderNumberInt = CONVERT(bigint, @OrderNumber);
UPDATE PortalSampleOrderTransmitHeader
SET STATUS = 'E'
WHERE ORDERNO = @OrderNumberInt
END
