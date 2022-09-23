/****** Object:  View [dbo].[PortalWebInventoryMain]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebInventoryMain]
AS
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
SELECT      d.ItemCode
			,Sum(d.QuantityOrdered - d.QuantityReceived) as OnPo	
FROM        MAS_POL.dbo.PO_PurchaseOrderHeader h INNER JOIN
            MAS_POL.dbo.PO_PurchaseOrderDetail d ON h.PurchaseOrderNo = d.PurchaseOrderNo INNER JOIN
			MAS_POL.dbo.CI_Item i ON d.ItemCode = i.ItemCode
WHERE  (h.OrderType = 'S') AND (h.WarehouseCode = '000') AND (h.OrderStatus != 'B') AND 
       (d.QuantityOrdered - d.QuantityReceived > 0) AND (i.Category1 = 'Y') and (i.ProductLine != 'SAMP') 
GROUP BY d.ItemCode
UNION ALL
SELECT	ItemCode
		, Sum(QuantityOnHand) as OnPo
FROM         MAS_POL.dbo.IM_ItemWarehouse
WHERE     (WarehouseCode = '900' and QuantityOnHand > 0)
GROUP BY ItemCode
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
WHERE  h.ORDERSTATUS IN ('O','N','H') and d.ITEMTYPE='1' and d.WAREHOUSECODE='000'
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
)
SELECT 
CASE WHEN i.UDF_SAMPLE_FOCUS = 'Y' THEN 'Y' ELSE '' END AS Focus
, i.ItemCode
, i.UDF_BRAND_NAMES AS Brand
, i.UDF_DESCRIPTION AS 'Description'
, i.UDF_VINTAGE AS Vintage
, CAST(REPLACE(i.SalesUnitOfMeasure, 'C', '') AS INT) AS Uom
, i.UDF_BOTTLE_SIZE AS BottleSize
, i.UDF_DAMAGED_NOTES AS DamagedNotes 
, CONVERT(DECIMAL(9,2),(ROUND(w.QuantityOnHand - IsNull(p.POQuantityHeld,0) - IsNull(s.QuantityHeld,0) - IsNull(s.QuantityHeldBh,0) - IsNull(s.QuantityHeldMo,0) - IsNull(r.QuantityHeld,0),2))) AS QtyAvailable
, CONVERT(DECIMAL(9,2),(ROUND(w.QuantityOnHand - IsNull(s.QuantityHeldBh,0),2))) as QtyOnHand
, CONVERT(DECIMAL(9,2),(ROUND(IsNull(s.QuantityHeld,0),2))) as OnSO
, CONVERT(DECIMAL(9,2),(ROUND(IsNull(s.QuantityHeldMo,0),2))) as OnMO
, CONVERT(DECIMAL(9,2),(ROUND(IsNull(s.QuantityHeldBo,0),2))) as OnBO
, CASE WHEN i.UDF_RESTRICT_OFFSALE = 'Y' THEN 'Y' ELSE '' END AS RestrictOffSale
, CASE WHEN i.UDF_RESTRICT_NORETAIL = 'Y' THEN 'Y' ELSE '' END AS RestrictOnPremise
, i.UDF_RESTRICT_OFFSALE_NOTES AS RestrictOffSaleNotes
, CASE WHEN i.UDF_RESTRICT_ALLOCATED = 'Y' THEN 'Y' ELSE '' END AS RestrictAllocated
, i.UDF_RESTRICT_MANAGER AS RestrictApproval
, CASE WHEN i.UDF_RESTRICT_MAX > 0 THEN CONVERT(VARCHAR(3), CONVERT(INT,i.UDF_RESTRICT_MAX)) ELSE '' END AS RestrictMaxCases
, i.UDF_RESTRICT_STATE AS RestrictState
, CASE WHEN i.UDF_RESTRICT_SAMPLES = 'Y' THEN 'Y' ELSE '' END AS RestrictSamples
, CASE WHEN i.UDF_RESTRICT_BO = 'Y' THEN 'Y' ELSE '' END AS RestrictBo
, CASE WHEN i.UDF_RESTRICT_MO = 'Y' THEN 'Y' ELSE '' END AS RestrictMo
, CASE WHEN i.CATEGORY3 = 'Y' THEN 'Y' ELSE '' END AS 'Core'
, i.UDF_WINE_COLOR AS Type
, IsNull(v.UDF_VARIETAL,'') AS Varietal
, LEFT(i.UDF_ORGANIC, 1) AS Organic
, LEFT(i.UDF_BIODYNAMIC, 1) AS Biodynamic
, i.UDF_COUNTRY AS Country
, IsNull(reg.UDF_REGION,'') AS Region
, IsNull(a.UDF_NAME,'') AS Appellation
, i.UDF_MASTER_VENDOR AS MasterVendor
, i.UDF_CLOSURE AS Closure
, i.UDF_UPC_CODE AS Upc
, i.UDF_PARKER AS ScoreWA
, i.UDF_SPECTATOR AS ScoreWS
, i.UDF_TANZER AS ScoreIWC
, i.UDF_BURGHOUND AS ScoreBH
, i.UDF_GALLONI_SCORE AS ScoreVM
, i.UDF_VFC AS ScoreOther
, CASE WHEN i.UDF_BM_FOCUS = 'Y' THEN 'Y' ELSE '' END AS FocusBm
, CONVERT(DECIMAL(9,2),(ROUND(ISNULL(potot.OnPo,0),2))) as OnPoSort
, CASE WHEN i.UDF_REGENERATIVE = 'Y' THEN 'x' ELSE '' END AS Regen
, CASE WHEN i.UDF_NATURAL = 'Y' THEN 'x' ELSE '' END AS Nat
, CASE WHEN i.UDF_VEGAN = 'Y' THEN 'x' ELSE '' END AS Veg
, CASE WHEN i.UDF_HAUTE_VALEUR = 'Y' THEN 'x' ELSE '' END AS Hve
, CASE WHEN YEAR(LastReceiptDate)>1900 THEN CONVERT(varchar,LastReceiptDate,23) ELSE '' END as Rcpt
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
          (w.QuantityOnHand + w.QuantityOnPurchaseOrder + w.QuantityOnSalesOrder + w.QuantityOnBackOrder > 0.04)
