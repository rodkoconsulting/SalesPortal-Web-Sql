/****** Object:  Procedure [dbo].[PortalSalesDetailViewQuery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalSalesDetailViewQuery]
	@OrderNo bigint
AS
BEGIN
SET NOCOUNT ON
SELECT ITEMCODE
		,PRICE
		,MOBOLIST
		,BOTTLES
		,MOBOTOTAL
		,ISOVERRIDE
		,UOM
		,INVENTORYAVAILABLE
		,BOAVAILABLE
		,OFFSALE
		,OffSaleNotes
		,ONPREMISE
		,ALLOCATED
		,APPROVAL
		,MAXCASES
		,STATERESTRICT
		,NOBO
		,NOMO
		,INACTIVE
FROM PORTALORDERDETAILSVIEW WHERE ORDERNO=@OrderNo
END
