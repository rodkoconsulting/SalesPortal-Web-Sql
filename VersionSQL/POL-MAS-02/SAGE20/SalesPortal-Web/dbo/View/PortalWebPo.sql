/****** Object:  View [dbo].[PortalWebPo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebPo] AS
WITH po AS
(
SELECT	d.ItemCode
		, h.PurchaseOrderNo
		, SUM(d.QuantityOrdered - d.QuantityReceived) AS OnPo
		, MAX(h.RequiredExpireDate) AS RequiredDate
		, MAX(h.PurchaseOrderDate) AS PoDate
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
FROM         MAS_POL.dbo.IM_ItemWarehouse
WHERE     (WarehouseCode = '900' and QuantityOnHand > 0) 
)
SELECT	ItemCode
		, CAST(ROUND(SUM(OnPo), 2) AS FLOAT) AS OnPO
		, CASE WHEN YEAR(MAX(RequiredDate)) < 2000 THEN '' ELSE CONVERT(varchar, MAX(RequiredDate), 12) END AS RequiredDate
		, CONVERT(varchar, MAX(PoDate), 12) AS PoDate
FROM PO
GROUP BY ItemCode, PurchaseOrderNo
