/****** Object:  Procedure [dbo].[PortalWebInventoryProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebInventoryProc]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON;
WITH PoInventoryHeld AS
(
SELECT      d.ItemCode
			,Sum(d.QuantityOrdered) as POQuantityHeld 		
FROM        MAS_POL.dbo.PO_PurchaseOrderHeader h INNER JOIN
            MAS_POL.dbo.PO_PurchaseOrderDetail d ON h.PurchaseOrderNo = d.PurchaseOrderNo
WHERE  (h.OrderStatus='O' or h.OrderStatus='N') and h.OrderType='X' and d.ItemType='1' and d.WarehouseCode='000'
GROUP BY d.ItemCode
),
PoUnion AS
(
SELECT	d.ItemCode
		, h.PurchaseOrderNo
		, SUM(d.QuantityOrdered - d.QuantityReceived) AS OnPo
		, MAX(h.RequiredExpireDate) AS RequiredDate
		, MAX(h.PurchaseOrderDate) AS PoDate
		, MAX(h.UDF_AVAILABLE_COMMENT) AS AvailableComment
FROM MAS_POL.dbo.PO_PurchaseOrderHeader h INNER JOIN
     MAS_POL.dbo.PO_PurchaseOrderDetail d ON h.PurchaseOrderNo = d.PurchaseOrderNo INNER JOIN
     MAS_POL.dbo.CI_Item i ON d.ItemCode = i.ItemCode
WHERE  (h.OrderType = 'S') AND (h.WarehouseCode = '000') AND (h.OrderStatus != 'B') AND 
       (d.QuantityOrdered - d.QuantityReceived > 0) AND (i.Category1 = 'Y') and (i.ProductLine != 'SAMP') 
GROUP BY d.ItemCode, h.PurchaseOrderNo
UNION ALL
SELECT	ItemCode
		,'900' as PurchaseOrderNo
		, QuantityOnHand as OnPO
		, '1753-01-01 00:00:00.000' as RequiredDate
		, '1753-01-01 00:00:00.000' as PoDate
		, '' as AvailableComment
FROM         MAS_POL.dbo.IM_ItemWarehouse
WHERE     (WarehouseCode = '900' and QuantityOnHand > 0)
),
PoTotals AS
(
SELECT	ItemCode
		, CAST(ROUND(SUM(OnPo), 2) AS FLOAT) AS OnPO
FROM PoUnion
GROUP BY ItemCode
),
SoOrderUnion AS
(
SELECT     d.ITEMCODE
		, Sum(Case WHEN h.CANCELREASONCODE NOT IN ('BH','MO','IN','BO','AL') and d.UnitPrice > 0 then d.QUANTITYORDERED ELSE 0 End) as QuantityHeld
		, Sum(Case WHEN h.CANCELREASONCODE IN ('MO','IN') then d.QUANTITYORDERED ELSE 0 End) as QuantityHeldMo
		, Sum(Case WHEN h.CANCELREASONCODE IN ('BO','AL') then d.QUANTITYORDERED ELSE 0 End) as QuantityHeldBo
		, Sum(Case WHEN h.CANCELREASONCODE='BH' or d.UnitPrice = 0 then d.QUANTITYORDERED ELSE 0 End) as QuantityHeldBh
FROM         MAS_POL.dbo.SO_SALESORDERHEADER h INNER JOIN
                      MAS_POL.dbo.SO_SALESORDERDETAIL d ON h.SALESORDERNO = d.SALESORDERNO       
WHERE  h.ORDERSTATUS IN ('O','N','H') and d.ITEMTYPE='1' and (d.WAREHOUSECODE='000' or d.WAREHOUSECODE='001')
GROUP BY d.ITEMCODE
UNION
SELECT     d.ITEMCODE
		, Sum(d.QUANTITYORDERED) as QuantityHeld
		, 0 as QuantityHeldBh
		, 0 as QuantityHeldMo
		, 0 as QuantityHeldBo
FROM         MAS_POL.dbo.SO_INVOICEHEADER h INNER JOIN
                      MAS_POL.dbo.SO_INVOICEDETAIL d ON h.INVOICENO = d.INVOICENO   
WHERE  h.SalesOrderNo = '' and d.ITEMTYPE='1' and d.WAREHOUSECODE='000' 
GROUP BY d.ITEMCODE
),
SoInventoryHeld AS
(
SELECT ItemCode
	  , Sum(QuantityHeld) as QuantityHeld
	  , Sum(QuantityHeldBh) as QuantityHeldBh
	  , Sum(QuantityHeldMo) as QuantityHeldMo
	  , Sum(QuantityHeldBo) as QuantityHeldBo
FROM SoOrderUnion
GROUP BY ItemCode
),
RgInventoryHeld AS
(
SELECT      d.ItemCode, Sum(d.QuantityOrdered) as QuantityHeld
FROM        MAS_POL.dbo.PO_ReturnHeader h INNER JOIN
                      MAS_POL.dbo.PO_ReturnDetail d ON h.ReturnNo = d.ReturnNo  
WHERE  h.ShipToCode like 'TAS%' AND d.WarehouseCode='000' and d.ItemType = '1'
GROUP BY d.ItemCode
),
Price AS
(
SELECT  ROW_NUMBER() OVER (PARTITION BY p.ITEMCODE, CustomerPriceLevel ORDER BY ValidDate_234 DESC) AS 'RN'
		, ITEMCODE
		, CustomerPriceLevel
		, ValidDate_234
		, ValidDateDescription_234
		, DiscountMarkup1
		, DiscountMarkup2
		, DiscountMarkup3
		, DiscountMarkup4
		, DiscountMarkup5
		, BreakQuantity1
		, BreakQuantity2
		, BreakQuantity3
		, BreakQuantity4
		, BreakQuantity5
			FROM       MAS_POL.dbo.IM_PriceCode p
WHERE     p.ValidDate_234<=GETDATE()
),
PriceCurrent AS
(
SELECT ItemCode
		, CustomerPriceLevel
		, ValidDate_234
		, ValidDateDescription_234
		, DiscountMarkup1
		, DiscountMarkup2
		, DiscountMarkup3
		, DiscountMarkup4
		, DiscountMarkup5
		, BreakQuantity1
		, BreakQuantity2
		, BreakQuantity3
		, BreakQuantity4
		, BreakQuantity5
FROM Price
WHERE RN = 1
),
PricePrevious AS
(
SELECT	ItemCode
		, CustomerPriceLevel
		, ValidDate_234
		, ValidDateDescription_234
		, DiscountMarkup1
FROM Price
WHERE RN = 2
),
PriceFutureFilter AS
(
SELECT   ROW_NUMBER() OVER (PARTITION BY p.ITEMCODE, CustomerPriceLevel ORDER BY ValidDate_234) AS 'RN'
		, ITEMCODE
		, CustomerPriceLevel
		, ValidDate_234
		, ValidDateDescription_234
		, DiscountMarkup1
		, DiscountMarkup2
		, DiscountMarkup3
		, DiscountMarkup4
		, DiscountMarkup5
		, BreakQuantity1
		, BreakQuantity2
		, BreakQuantity3
		, BreakQuantity4
		, BreakQuantity5
			FROM       MAS_POL.dbo.IM_PriceCode p
WHERE     p.ValidDate_234>GETDATE()
),
PriceFuture AS
(
	SELECT	ITEMCODE
			, CustomerPriceLevel
			, ValidDate_234
			, ValidDateDescription_234
			, DiscountMarkup1
			, DiscountMarkup2
			, DiscountMarkup3
			, DiscountMarkup4
			, DiscountMarkup5
			, BreakQuantity1
			, BreakQuantity2
			, BreakQuantity3
			, BreakQuantity4
			, BreakQuantity5
	FROM PriceFutureFilter p
	WHERE RN = 1
),
PriceFutureReduced AS
(
	SELECT	pf.ItemCode
			, pf.CustomerPriceLevel
			, pf.ValidDate_234
			, pf.ValidDateDescription_234
			, CASE	WHEN pf.CustomerPriceLevel != 'P' AND pf.DiscountMarkup1 < pc.DiscountMarkup1 THEN 'Y'
					WHEN pf.CustomerPriceLevel = 'P' AND 
					dbo.TryConvertPaPrice(CASE WHEN CHARINDEX(',', pf.ValidDateDescription_234)=0 THEN pf.ValidDateDescription_234 ELSE SUBSTRING(pf.ValidDateDescription_234,0,CHARINDEX(',',pf.ValidDateDescription_234)) END)
					< dbo.TryConvertPaPrice(CASE WHEN CHARINDEX(',', pc.ValidDateDescription_234)=0 THEN pc.ValidDateDescription_234 ELSE SUBSTRING(pc.ValidDateDescription_234,0,CHARINDEX(',',pc.ValidDateDescription_234)) END)
				THEN 'Y'
				ELSE ''
			 END  AS Reduced
	FROM	MAS_POL.dbo.CI_Item i INNER JOIN
			PriceFuture pf ON i.ItemCode = pf.ItemCode INNER JOIN
			MAS_POL.dbo.IM_ItemWarehouse w ON i.ItemCode = w.ItemCode LEFT OUTER JOIN
			PriceCurrent pc ON pf.ItemCode = pc.ItemCode AND pf.CustomerPriceLevel = pc.CustomerPriceLevel
			WHERE i.Category1 = 'Y' AND i.ProductLine != 'SAMP' AND i.ItemType = '1' AND w.WarehouseCode = '000' AND (w.QuantityOnHand + w.QuantityOnPurchaseOrder + w.QuantityOnSalesOrder + w.QuantityOnBackOrder > 0.04) 
),
PriceUnion AS
(
SELECT	pc.ItemCode
		, pc.CustomerPriceLevel
		, pc.ValidDate_234
		, pc.ValidDateDescription_234
		, CASE	WHEN pc.CustomerPriceLevel != 'P' AND pc.DiscountMarkup1 < pp.DiscountMarkup1 THEN 'Y'
				WHEN pc.CustomerPriceLevel = 'P' AND 
					dbo.TryConvertPaPrice(CASE WHEN CHARINDEX(',', pc.ValidDateDescription_234)=0 THEN pc.ValidDateDescription_234 ELSE SUBSTRING(pc.ValidDateDescription_234,0,CHARINDEX(',',pc.ValidDateDescription_234)) END)
					< dbo.TryConvertPaPrice(CASE WHEN CHARINDEX(',', pp.ValidDateDescription_234)=0 THEN pp.ValidDateDescription_234 ELSE SUBSTRING(pp.ValidDateDescription_234,0,CHARINDEX(',',pp.ValidDateDescription_234)) END)
				THEN 'Y'
				ELSE ''
			 END  AS Reduced
FROM	MAS_POL.dbo.CI_Item i INNER JOIN
		PriceCurrent pc ON i.ItemCode = pc.ItemCode INNER JOIN
		MAS_POL.dbo.IM_ItemWarehouse w ON i.ItemCode = w.ItemCode LEFT OUTER JOIN
		PricePrevious pp ON pc.ItemCode = pp.ItemCode AND pc.CustomerPriceLevel = pp.CustomerPriceLevel
WHERE i.Category1 = 'Y' AND i.ProductLine != 'SAMP' AND i.ItemType = '1' AND w.WarehouseCode = '000' AND (w.QuantityOnHand + w.QuantityOnPurchaseOrder + w.QuantityOnSalesOrder + w.QuantityOnBackOrder > 0.04) 
UNION ALL
SELECT *
FROM PriceFutureReduced
)
SELECT Main = (SELECT 
				i.ItemCode as Code
				, i.UDF_BRAND_NAMES AS Brand
				, i.UDF_DESCRIPTION AS [Desc]
				, i.UDF_VINTAGE AS Vintage
				, CAST(REPLACE(i.SalesUnitOfMeasure, 'C', '') AS INT) AS Uom
				, i.UDF_BOTTLE_SIZE as Size
				, i.UDF_DAMAGED_NOTES AS DamNotes
				, i.UDF_MASTER_VENDOR AS MVendor
				, i.UDF_CLOSURE AS Closure
				, i.UDF_WINE_COLOR AS [Type]
				, IsNull(v.UDF_VARIETAL,'') AS Varietal
				, LEFT(i.UDF_ORGANIC, 1) AS Org
				, LEFT(i.UDF_BIODYNAMIC, 1) AS Bio
				, CASE WHEN i.UDF_SAMPLE_FOCUS = 'Y' THEN 'Y' ELSE '' END AS Focus
				, i.UDF_COUNTRY AS Country
				, IsNull(reg.UDF_REGION,'') AS Region
				, IsNull(a.UDF_NAME,'') AS App
				, CASE WHEN i.UDF_RESTRICT_OFFSALE = 'Y' THEN 'Y' ELSE '' END AS RstOff
				, i.UDF_RESTRICT_OFFSALE_NOTES AS RstOffNotes
				, CASE WHEN i.UDF_RESTRICT_NORETAIL = 'Y' THEN 'Y' ELSE '' END AS RstPrem
				, CASE WHEN i.UDF_RESTRICT_ALLOCATED = 'Y' THEN 'Y' ELSE '' END AS RstAllo
				, i.UDF_RESTRICT_MANAGER AS RstApp
				, CASE WHEN i.UDF_RESTRICT_MAX > 0 THEN CONVERT(VARCHAR(3), CONVERT(INT,i.UDF_RESTRICT_MAX)) ELSE '' END AS RstMax
				, i.UDF_RESTRICT_STATE AS RstState
				, CASE WHEN i.UDF_RESTRICT_SAMPLES = 'Y' THEN 'Y' ELSE '' END AS RstSam
				, CASE WHEN i.UDF_RESTRICT_BO = 'Y' THEN 'Y' ELSE '' END AS RstBo
				, CASE WHEN i.UDF_RESTRICT_MO = 'Y' THEN 'Y' ELSE '' END AS RstMo
				, CASE WHEN i.CATEGORY3 = 'Y' THEN 'Y' ELSE '' END AS Core
				, CASE WHEN i.UDF_BM_FOCUS = 'Y' THEN 'Y' ELSE '' END AS FocusBm
				, i.UDF_UPC_CODE AS Upc
				, i.UDF_PARKER AS ScoreWA
				, i.UDF_SPECTATOR AS ScoreWS
				, i.UDF_VFC as ScoreVFC
				, i.UDF_BURGHOUND AS ScoreBH
				, i.UDF_GALLONI_SCORE AS ScoreVM
				, i.UDF_TANZER AS ScoreOther
				, CASE WHEN CONVERT(DECIMAL(9,2),(ROUND(w.QuantityOnHand 
						- IsNull(p.POQuantityHeld,0) - IsNull(s.QuantityHeld,0) 
						- IsNull(s.QuantityHeldMo,0) 
						- IsNull(r.QuantityHeld,0),2))) > 0 THEN CONVERT(DECIMAL(9,2),(ROUND(w.QuantityOnHand 
						- IsNull(p.POQuantityHeld,0) - IsNull(s.QuantityHeld,0) 
						- IsNull(s.QuantityHeldMo,0) 
						- IsNull(r.QuantityHeld,0),2))) ELSE 0 END AS QtyA
				, CASE WHEN CONVERT(DECIMAL(9,2),(ROUND(w.QuantityOnHand,2))) > 0 THEN CONVERT(DECIMAL(9,2),(ROUND(w.QuantityOnHand,2))) ELSE 0 END as QtyOh
				, CONVERT(DECIMAL(9,2),(ROUND(IsNull(s.QuantityHeld,0),2))) as OnSo
				, CONVERT(DECIMAL(9,2),(ROUND(IsNull(s.QuantityHeldMo,0),2))) as OnMo
				, CONVERT(DECIMAL(9,2),(ROUND(IsNull(s.QuantityHeldBo,0),2))) as OnBo
				, CONVERT(DECIMAL(9,2),(ROUND(ISNULL(potot.OnPo,0),2))) as OnPoSort
				, CASE WHEN i.UDF_REGENERATIVE = 'Y' THEN 'Y' ELSE '' END AS Regen
				, CASE WHEN i.UDF_NATURAL = 'Y' THEN 'Y' ELSE '' END AS Nat
				, CASE WHEN i.UDF_VEGAN = 'Y' THEN 'Y' ELSE '' END AS Veg
				, CASE WHEN i.UDF_HAUTE_VALEUR = 'Y' THEN 'Y' ELSE '' END AS Hve
				, CASE WHEN YEAR(LastReceiptDate)>1900 THEN CONVERT(varchar,LastReceiptDate,23) ELSE '' END as Rcpt
				, UDF_ALCOHOL_PCT AS Abv
FROM 
MAS_POL.dbo.CI_ITEM i
	INNER JOIN MAS_POL.dbo.IM_ItemWarehouse w on w.ItemCode = i.ItemCode
	LEFT OUTER JOIN PoInventoryHeld p on p.ItemCode = w.ItemCode
	LEFT OUTER JOIN SoInventoryHeld s on s.ItemCode = w.ItemCode
	LEFT OUTER JOIN RgInventoryHeld r on r.ItemCode = w.ItemCode
	LEFT OUTER JOIN MAS_POL.dbo.CI_UDT_VARIETALS v ON i.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE
	LEFT OUTER JOIN MAS_POL.dbo.CI_UDT_PRIMARY_REGION reg ON i.UDF_REGION = reg.UDF_PRIMARY_REGION_CODE
	LEFT OUTER JOIN MAS_POL.dbo.CI_UDT_APPELLATION as a ON i.UDF_SUBREGION_T = a.UDF_APPELLATION
	LEFT OUTER JOIN PoTotals as potot ON i.ItemCode = potot.ItemCode
WHERE     (i.ITEMTYPE = '1') and (i.InactiveItem !='Y') and (i.ProductLine != 'SAMP') and (w.WarehouseCode = '000') and 
          (w.QuantityOnHand + w.QuantityOnPurchaseOrder + w.QuantityOnSalesOrder + w.QuantityOnBackOrder + IsNull(s.QuantityHeldBh,0) > 0.04)
FOR JSON PATH
),
Price = (SELECT	ItemCode as Code
		, CustomerPriceLevel as [Level]
		, CONVERT(varchar, ValidDate_234, 12) as [Date]
		, Replace(ValidDateDescription_234,' ','') as Price
		, Reduced as Red
FROM PriceUnion
FOR JSON PATH
),
Po = (SELECT	ItemCode as Code
		, CONVERT(DECIMAL(9,2),(ROUND(Sum(OnPo),2))) as OnPo
		, CASE WHEN YEAR(MAX(RequiredDate)) < 2000 THEN '' ELSE CONVERT(varchar, MAX(RequiredDate), 12) END AS EtaDate
		, CONVERT(varchar, MAX(PoDate), 12) AS PoDate
		, AvailableComment as AvailCmt
FROM PoUnion
GROUP BY ItemCode, PurchaseOrderNo, AvailableComment
FOR JSON PATH
)
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
