/****** Object:  Procedure [dbo].[PortalSampleDetailViewQuery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalSampleDetailViewQuery]
	-- Add the parameters for the stored procedure here
	@OrderNo bigint
AS
BEGIN
SET NOCOUNT ON
SELECT ITEMCODE
		,BOTTLES
		,UOM
		,INVENTORYAVAILABLE
		,NOSAMPLES
		,INACTIVE
		,COMMENT
FROM PORTALSAMPLEDETAILSVIEW WHERE ORDERNO=@OrderNo
END
