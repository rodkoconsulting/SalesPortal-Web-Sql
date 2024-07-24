/****** Object:  View [dbo].[RareWine_Inventory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[RareWine_Inventory]
AS
SELECT        iw.ItemCode as [Item Code]
				, i.UDF_DESCRIPTION as [Item Name]
				, b.UDF_BRAND_NAME as [Producer Name]
				, i.UDF_VINTAGE as [Vintage]
				, CASE WHEN CHARINDEX('ML',i.UDF_BOTTLE_SIZE)>0 THEN ISNULL(TRY_CONVERT(int, REPLACE(i.UDF_BOTTLE_SIZE,' ML','')),750) ELSE 1000 * ISNULL(TRY_CONVERT(float, REPLACE(i.UDF_BOTTLE_SIZE,' L','')),1.5) END as [Bottle Size]
				, REPLACE(i.SalesUnitOfMeasure, 'C', '') as [Pack Size]
				, SUM(TRY_CONVERT(int, (iw.QuantityOnHand * ISNULL(TRY_CONVERT(int, REPLACE(i.SalesUnitOfMeasure, 'C', '')),12)), 0)) as [Qty in Bottles]
				, CONVERT(date, GetDate()) as [Report Date]
				, w.WarehouseName as [Warehouse Location]
FROM            MAS_POL.dbo.IM_ItemWarehouse iw INNER JOIN
                         MAS_POL.dbo.CI_Item i ON iw.ItemCode = i.ItemCode INNER JOIN
                         MAS_POL.dbo.IM_Warehouse w ON iw.WarehouseCode = w.WarehouseCode INNER JOIN
						 MAS_POL.dbo.CI_UDT_BRANDS b ON i.UDF_BRAND = b.UDF_BRAND_CODE
WHERE i.UDF_MASTER_VENDOR = 'Rare Wine'
	AND i.ProductLine != 'SAMP'
	AND TRY_CONVERT(int, (iw.QuantityOnHand * ISNULL(TRY_CONVERT(int, REPLACE(i.SalesUnitOfMeasure, 'C', '')),12)), 0) > 0
GROUP BY iw.ItemCode
			, i.UDF_DESCRIPTION
			, b.UDF_BRAND_NAME
			, i.UDF_VINTAGE
			, i.UDF_BOTTLE_SIZE
			, i.SalesUnitOfMeasure
			, w.WarehouseName


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
         Begin Table = "IM_ItemWarehouse (MAS_POL.dbo)"
            Begin Extent = 
               Top = 56
               Left = 72
               Bottom = 292
               Right = 301
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CI_Item (MAS_POL.dbo)"
            Begin Extent = 
               Top = 31
               Left = 673
               Bottom = 335
               Right = 940
            End
            DisplayFlags = 280
            TopColumn = 15
         End
         Begin Table = "IM_Warehouse (MAS_POL.dbo)"
            Begin Extent = 
               Top = 162
               Left = 393
               Bottom = 292
               Right = 612
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'RareWine_Inventory'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'RareWine_Inventory'
