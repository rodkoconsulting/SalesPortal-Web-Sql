﻿/****** Object:  View [dbo].[PricingExceptions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PricingExceptions]
AS
SELECT        i.ItemCode, i.UDF_BRAND_NAMES, i.UDF_DESCRIPTION, i.UDF_VINTAGE, i.SalesUnitOfMeasure, i.UDF_DAMAGED_NOTES, i.UDF_BOTTLE_SIZE, dbo.IM_InventoryAvailable.QtyOnHand, 
                         dbo.IM_InventoryAvailable.QtyOnPurchaseOrder
FROM            MAS_POL.dbo.CI_Item AS i INNER JOIN
                         dbo.IM_InventoryAvailable ON i.ItemCode = dbo.IM_InventoryAvailable.ITEMCODE LEFT OUTER JOIN
                         MAS_POL.dbo.IM_PriceCode AS p ON i.ItemCode = p.ItemCode
WHERE        (p.ItemCode IS NULL) AND (i.ItemType = '1') AND (i.ItemCode NOT LIKE '%XX') AND (i.ItemCode NOT LIKE '%XX%') AND (i.ItemCode NOT LIKE '%-BH') AND (i.ProductLine <> 'SAMP') AND (i.ItemCode NOT LIKE '%TAS') AND 
                         (i.ItemCode NOT LIKE '%TST') AND (i.ProductType <> 'R') AND (i.ItemCode NOT LIKE '%X99') AND (i.UDF_DAMAGED_NOTES <> 'SAMPLES') AND (i.InactiveItem = 'N')

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
               Bottom = 343
               Right = 298
            End
            DisplayFlags = 280
            TopColumn = 62
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 16
               Left = 573
               Bottom = 146
               Right = 812
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IM_InventoryAvailable"
            Begin Extent = 
               Top = 203
               Left = 559
               Bottom = 333
               Right = 803
            End
            DisplayFlags = 280
            TopColumn = 5
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PricingExceptions'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PricingExceptions'
