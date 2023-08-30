/****** Object:  View [dbo].[PortalWebPo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebPo]
AS
SELECT     ItemCode, CAST(ROUND(SUM(OnPo), 2) AS FLOAT) AS OnPO, CASE WHEN YEAR(MAX(RequiredDate)) < 2000 THEN '' ELSE CONVERT(varchar, MAX(RequiredDate), 
                      12) END AS RequiredDate, CONVERT(varchar, MAX(PoDate), 12) AS PoDate
FROM         (SELECT     MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode, MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo, 
                                              SUM(MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered - MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityReceived) AS OnPo, 
                                              MAX(MAS_POL.dbo.PO_PurchaseOrderHeader.RequiredExpireDate) AS 'RequiredDate', MAX(MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderDate) 
                                              AS PoDate
                       FROM          MAS_POL.dbo.PO_PurchaseOrderHeader INNER JOIN
                                              MAS_POL.dbo.PO_PurchaseOrderDetail ON 
                                              MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo INNER JOIN
                                              MAS_POL.dbo.CI_Item ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode
                       WHERE      (MAS_POL.dbo.PO_PurchaseOrderHeader.OrderType = 'S') AND (MAS_POL.dbo.PO_PurchaseOrderHeader.WarehouseCode = '000') AND 
                                              (MAS_POL.dbo.PO_PurchaseOrderHeader.OrderStatus <> 'B') AND 
                                              (MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityOrdered - MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityReceived > 0) AND 
                                              (MAS_POL.dbo.CI_Item.Category1 = 'Y') and (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') 
                       GROUP BY MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode, MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo
                       UNION ALL
                       SELECT     ItemCode, PurchaseOrderNo, OnPO, '1753-01-01 00:00:00.000' AS RequiredDate, '1753-01-01 00:00:00.000' AS PoDate
                       FROM         dbo.IM_ItemWarehouse_900) AS Derived
GROUP BY ItemCode, PurchaseOrderNo
