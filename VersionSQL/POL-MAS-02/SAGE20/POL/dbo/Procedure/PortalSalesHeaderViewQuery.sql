/****** Object:  Procedure [dbo].[PortalSalesHeaderViewQuery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalSalesHeaderViewQuery]
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
	   ,SHIPDAYS
	   ,CUTOFF
	   ,TERRITORY
	   ,PREMISE
	   ,SHIPMETHOD
	   ,CUSTOMERACTIVE
	   ,LICEXPDATE
	   ,ISCERTONFILE
	   ,CREDITHOLD
	   ,POREQUIRED
	   ,USERCODE
	   ,OrderId
FROM PORTALORDERHEADERVIEW WHERE ORDERNO=@OrderNo
END
