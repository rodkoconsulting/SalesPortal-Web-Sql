/****** Object:  Procedure [dbo].[PortalWebSamplesItemHistory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebSamplesItemHistory]
	-- Add the parameters for the stored procedure here
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
SELECT @RepCode = RepCode FROM Web_ActiveUsers where UserName=@UserName;

WITH ItemHistory AS (
SELECT     
ROW_NUMBER() OVER (PARTITION BY d.Code ORDER BY h.Date desc) AS 'RN'
	, d.Code
	, h.Date
	, SUM(Qty) AS Qty
FROM [dbo].[PortalWebSamplesMain] h INNER JOIN
  [dbo].[PortalWebSamplesDet] d on h.PoNo = d.PoNo             
WHERE h.Date >= DATEADD(YEAR, -2, GETDATE()) and RepNo = @RepCode
group by d.Code, h.Date
HAVING SUM(Qty) > 0
)
SELECT Main= (SELECT
	Code
	, Date
	, Qty
FROM ItemHistory
WHERE RN=1
FOR JSON PATH
)
, Item= (SELECT
	ih.Code
	, UDF_BRAND_NAMES as Brand
	, UDF_DESCRIPTION as [Desc]
	, UDF_VINTAGE as Vintage
	, CAST(REPLACE(SalesUnitOfMeasure, 'C', '') AS INT) AS Uom
	, UDF_BOTTLE_SIZE AS Size
	, UDF_DAMAGED_NOTES AS DamNotes
	, UDF_COUNTRY AS Country
	FROM ItemHistory ih INNER JOIN
                      MAS_POL.dbo.CI_Item i ON ih.Code = i.ItemCode INNER JOIN
                      MAS_POL.dbo.IM_ItemWarehouse w ON ih.Code = w.ItemCode
 WHERE WarehouseCode= '000' AND (CATEGORY1 = 'N' OR (QuantityOnHand + QuantityOnPurchaseOrder + QuantityOnSalesOrder + QuantityOnBackOrder <= 0.04))
 FOR JSON PATH
)
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
