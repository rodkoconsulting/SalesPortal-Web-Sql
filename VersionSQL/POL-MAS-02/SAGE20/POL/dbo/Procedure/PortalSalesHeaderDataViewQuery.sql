/****** Object:  Procedure [dbo].[PortalSalesHeaderDataViewQuery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalSalesHeaderDataViewQuery]
	-- Add the parameters for the stored procedure here
	@OrderNo bigint
AS
BEGIN
SET NOCOUNT ON
SELECT ORDERTYPE
	   ,CUSTOMERNO
	   ,DIVISIONNO
	   ,DELIVERYDAY
	   ,NOTES
	   ,COOPNO
	   ,PONO
	   ,SHIPTO
	   ,USERCODE
FROM PortalOrderTransmitHeader WHERE ORDERNO=@OrderNo
END
