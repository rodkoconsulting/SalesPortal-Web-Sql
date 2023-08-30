/****** Object:  View [dbo].[Website_Export]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Website_Export]
AS
SELECT     MAS_POL.dbo.CI_Item.ItemCode AS [Item Code], CASE WHEN dbo.Web_VendorCountries.UDF_BRAND IS NULL 
                      THEN MAS_POL.dbo.ci_item.UDF_BRAND_NAMES ELSE MAS_POL.dbo.CI_ITEM.UDF_BRAND_NAMES + ' - ' + MAS_POL.dbo.CI_ITEM.UDF_COUNTRY
                       END AS Vendor, MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES + Replace(' ' + MAS_POL.dbo.CI_Item.UDF_DESCRIPTION, ' ,', ',') + CASE WHEN MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES like 'CANS%' THEN ' CANS' ELSE '' END AS Description, 
                      MAS_POL.dbo.CI_Item.UDF_VINTAGE AS Vintage, MAS_POL.dbo.CI_Item.UDF_BOTTLE_SIZE AS [Bottle Size], 
                      dbo.IM_BOTTLE_SIZES.PRIORITY AS [Bottle Size Priority]
FROM         dbo.IM_ItemWarehouse_000 INNER JOIN
                      MAS_POL.dbo.CI_Item ON dbo.IM_ItemWarehouse_000.ItemCode = MAS_POL.dbo.CI_Item.ItemCode INNER JOIN
                      dbo.IM_BOTTLE_SIZES ON MAS_POL.dbo.CI_Item.UDF_BOTTLE_SIZE = dbo.IM_BOTTLE_SIZES.BOTTLE_SIZE INNER JOIN
                      MAS_POL.dbo.AP_Vendor ON MAS_POL.dbo.CI_Item.PrimaryAPDivisionNo = MAS_POL.dbo.AP_Vendor.APDivisionNo AND 
                      MAS_POL.dbo.CI_Item.PrimaryVendorNo = MAS_POL.dbo.AP_Vendor.VendorNo LEFT OUTER JOIN
                      dbo.IM_SalesOrderTransactionsOneMonth ON MAS_POL.dbo.CI_Item.ItemCode = dbo.IM_SalesOrderTransactionsOneMonth.ItemCode LEFT OUTER JOIN
                      dbo.Web_VendorCountries ON MAS_POL.dbo.CI_Item.UDF_BRAND = dbo.Web_VendorCountries.UDF_BRAND LEFT OUTER JOIN
                      dbo.PO_Inventory_CR_ALL ON MAS_POL.dbo.CI_Item.ItemCode = dbo.PO_Inventory_CR_ALL.ItemCode
WHERE     (MAS_POL.dbo.AP_VENDOR.UDF_VEND_INACTIVE<>'Y')and(MAS_POL.dbo.CI_ITEM.CATEGORY2 = 'N') AND (IM_ItemWarehouse_000.QuantityOnHand > 0.04 or dbo.PO_Inventory_CR_ALL.QtyOrdered - dbo.PO_Inventory_CR_ALL.QtyReceived > 0 or IM_SalesOrderTransactionsOneMonth.ItemCode IS NOT NULL) AND 
                      (MAS_POL.dbo.CI_ITEM.StandardUnitCost > 0) AND (MAS_POL.dbo.CI_ITEM.ProcurementType <> 'SAMP') AND 
                      (MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MANAGER = '' OR 
                      MAS_POL.dbo.CI_ITEM.UDF_RESTRICT_MANAGER <> 'SPECIAL ORDER') and MAS_POL.dbo.CI_ITEM.ProductLine <> 'OOIL' and MAS_POL.dbo.CI_ITEM.UDF_WINE_COLOR <> 'Olive Oil'




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
         Begin Table = "IM_ItemWarehouse_000"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 99
               Right = 246
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CI_Item (MAS_POL.dbo)"
            Begin Extent = 
               Top = 102
               Left = 38
               Bottom = 210
               Right = 282
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IM_BOTTLE_SIZES"
            Begin Extent = 
               Top = 6
               Left = 284
               Bottom = 84
               Right = 435
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AP_Vendor (MAS_POL.dbo)"
            Begin Extent = 
               Top = 133
               Left = 975
               Bottom = 241
               Right = 1201
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IM_TransactionsThreeMonths"
            Begin Extent = 
               Top = 53
               Left = 525
               Bottom = 116
               Right = 967
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Web_VendorCountries"
            Begin Extent = 
               Top = 240
               Left = 531
               Bottom = 318
               Right = 682
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PO_Inventory_CR_ALL"
            Begin Extent = 
               Top = 151
               Left = 778
            ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Website_Export'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'   Bottom = 244
               Right = 929
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 16
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
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Website_Export'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Website_Export'
