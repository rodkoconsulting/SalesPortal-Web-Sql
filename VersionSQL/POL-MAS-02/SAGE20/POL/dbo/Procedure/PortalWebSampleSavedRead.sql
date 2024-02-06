/****** Object:  Procedure [dbo].[PortalWebSampleSavedRead]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.PortalWebSampleSavedRead 
	-- Add the parameters for the stored procedure here
	@UserName varchar(15)
AS
BEGIN
	DECLARE @RepCode varchar(4);
	DECLARE @AccountType char(3);
	SELECT @RepCode = RepCode FROM Web_UserMappings where UserName=@UserName
	SELECT @AccountType = AccountType FROM Web_UserMappings where UserName=@UserName;
	SELECT
		h.OrderNo
		,CONVERT(varchar, Date_Saved, 20) as DateSaved
		,CONVERT(varchar, Date_Delivery, 12) as DateDelivery
		,h.Notes as 'Note'
		,ShipTo
		,d.ItemCode
		,CASE WHEN TRY_CAST(REPLACE(i.SalesUnitOfMeasure,'C','') AS INT) IS NULL OR TRY_CAST(REPLACE(i.SalesUnitOfMeasure,'C','') AS INT) <=0 THEN 12 ELSE TRY_CAST(REPLACE(i.SalesUnitOfMeasure,'C','') AS INT) END AS 'Uom'
		,i.UDF_BRAND_NAMES + ' ' + i.UDF_DESCRIPTION + ' ' + i.UDF_VINTAGE + ' (' + REPLACE(i.SalesUnitOfMeasure,
                       'C', '') + '/' + (CASE WHEN CHARINDEX('ML', i.UDF_BOTTLE_SIZE) > 0 THEN REPLACE(IsNull(i.UDF_BOTTLE_SIZE, ''), 
                      ' ML', '') ELSE REPLACE(i.UDF_BOTTLE_SIZE, ' ', '') END) + ') ' + i.UDF_DAMAGED_NOTES AS Description
		,d.Bottles
		,ISNULL(d.Comment,'') AS Comment
	FROM dbo.PortalWebSampleSavedHeader h INNER JOIN dbo.PortalWebSampleSavedDetails d ON h.OrderNo = d.OrderNo
		INNER JOIN CI_Item i ON d.ITEMCODE = i.ItemCode
	WHERE h.UserName = @UserName
END
