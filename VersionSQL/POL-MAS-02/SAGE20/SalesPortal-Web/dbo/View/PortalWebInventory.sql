/****** Object:  View [dbo].[PortalWebInventory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalWebInventory]
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
, CAST(ROUND(w.QuantityOnHand - IsNull(p.POQuantityHeld,0) - IsNull(s.QuantityHeld,0) - IsNull(s.QuantityHeldBh,0) - IsNull(s.QuantityHeldMo,0) - IsNull(r.QuantityHeld,0),2) AS FLOAT) AS QtyAvailable
, CAST(ROUND(w.QuantityOnHand - IsNull(s.QuantityHeldBh,0),2) AS FLOAT) as QtyOnHand
, CAST(ROUND(IsNull(s.QuantityHeld,0),2) AS FLOAT) as OnSO
, CAST(ROUND(IsNull(s.QuantityHeldMo,0),2) AS FLOAT) as OnMO
, CAST(ROUND(IsNull(s.QuantityHeldBo,0),2) AS FLOAT) as OnBO
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
, ISNULL(potot.OnPo,0) as OnPoSort
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



EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "i"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 297
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "w"
            Begin Extent = 
               Top = 6
               Left = 335
               Bottom = 136
               Right = 564
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 602
               Bottom = 102
               Right = 778
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 6
               Left = 816
               Bottom = 136
               Right = 994
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "r"
            Begin Extent = 
               Top = 6
               Left = 1032
               Bottom = 102
               Right = 1202
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "v"
            Begin Extent = 
               Top = 6
               Left = 1240
               Bottom = 102
               Right = 1443
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "reg"
            Begin Extent = 
               Top = 6
               Left = 1481
               Bottom = 102
               Right = 1730
            End
            DisplayFlags = 280
            TopColumn = 0
         End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PortalWebInventory'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'         Begin Table = "a"
            Begin Extent = 
               Top = 102
               Left = 602
               Bottom = 198
               Right = 793
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PortalWebInventory'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PortalWebInventory'
