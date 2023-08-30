/****** Object:  View [dbo].[Website_Shelftalkers_Items]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Website_Shelftalkers_Items]
AS
SELECT     MAS_POL.dbo.CI_Item.ItemCode AS [Item Code], MAS_POL.dbo.CI_Item.UDF_COUNTRY AS Country, 
                      MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES + ' ' + MAS_POL.dbo.CI_Item.UDF_DESCRIPTION + ' ' + MAS_POL.dbo.CI_Item.UDF_VINTAGE  AS Description, 
                      REPLACE(REPLACE(MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES + ' ' + MAS_POL.dbo.CI_Item.UDF_DESCRIPTION, ' ', '_'), '/', '#') AS FileName
FROM         dbo.IM_ItemWarehouse_000 INNER JOIN
                      MAS_POL.dbo.CI_Item ON dbo.IM_ItemWarehouse_000.ItemCode = MAS_POL.dbo.CI_Item.ItemCode INNER JOIN
                      MAS_POL.dbo.AP_Vendor ON MAS_POL.dbo.CI_Item.PrimaryAPDivisionNo = MAS_POL.dbo.AP_Vendor.APDivisionNo AND 
                      MAS_POL.dbo.CI_Item.PrimaryVendorNo = MAS_POL.dbo.AP_Vendor.VendorNo LEFT OUTER JOIN
                      dbo.IM_TransactionsThreeMonths ON MAS_POL.dbo.CI_Item.ItemCode = dbo.IM_TransactionsThreeMonths.ItemCode LEFT OUTER JOIN
                      dbo.PO_Inventory_CR_ALL ON MAS_POL.dbo.CI_Item.ItemCode = dbo.PO_Inventory_CR_ALL.ItemCode LEFT OUTER JOIN
                      dbo.PO_CompletedThreeMonths ON MAS_POL.dbo.CI_Item.ItemCode = dbo.PO_CompletedThreeMonths.ItemCode
WHERE     (MAS_POL.dbo.AP_Vendor.UDF_VEND_INACTIVE <> 'Y') AND (MAS_POL.dbo.CI_Item.Category2 = 'N') AND (dbo.IM_ItemWarehouse_000.QuantityOnHand > 0.04) AND 
                      (MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES = '') AND (MAS_POL.dbo.CI_Item.StandardUnitCost > 0) AND (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND
					   (LEN(MAS_POL.dbo.CI_Item.UDF_RESTRICT_MANAGER) = 0) OR
                      (MAS_POL.dbo.AP_Vendor.UDF_VEND_INACTIVE <> 'Y') AND (MAS_POL.dbo.CI_Item.Category2 = 'N') AND (MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES = '') AND 
                      (MAS_POL.dbo.CI_Item.StandardUnitCost > 0) AND (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND (MAS_POL.dbo.CI_Item.UDF_RESTRICT_MANAGER = '') AND 
                      (dbo.PO_Inventory_CR_ALL.QtyOrdered - dbo.PO_Inventory_CR_ALL.QtyReceived > 0) OR
                      (MAS_POL.dbo.AP_Vendor.UDF_VEND_INACTIVE <> 'Y') AND (MAS_POL.dbo.CI_Item.Category2 = 'N') AND (MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES = '') AND 
                      (MAS_POL.dbo.CI_Item.StandardUnitCost > 0) AND (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND (MAS_POL.dbo.CI_Item.UDF_RESTRICT_MANAGER = '') AND
					   (dbo.IM_TransactionsThreeMonths.ItemCode IS NOT NULL) OR
                      (MAS_POL.dbo.AP_Vendor.UDF_VEND_INACTIVE <> 'Y') AND (MAS_POL.dbo.CI_Item.Category2 = 'N') AND (MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES = '') AND 
                      (MAS_POL.dbo.CI_Item.StandardUnitCost > 0) AND (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND (MAS_POL.dbo.CI_Item.UDF_RESTRICT_MANAGER = '') AND
					  (dbo.PO_CompletedThreeMonths.ItemCode IS NOT NULL) OR
                      (MAS_POL.dbo.AP_Vendor.UDF_VEND_INACTIVE <> 'Y') AND (MAS_POL.dbo.CI_Item.Category2 = 'N') AND (dbo.IM_ItemWarehouse_000.QuantityOnHand > 0.04) AND 
                      (MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES = '') AND (MAS_POL.dbo.CI_Item.StandardUnitCost > 0) AND (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND
					  (MAS_POL.dbo.CI_Item.UDF_RESTRICT_MANAGER <> 'SPECIAL ORDER') OR
                      (MAS_POL.dbo.AP_Vendor.UDF_VEND_INACTIVE <> 'Y') AND (MAS_POL.dbo.CI_Item.Category2 = 'N') AND (MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES = '') AND 
                      (MAS_POL.dbo.CI_Item.StandardUnitCost > 0) AND (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND
					  (dbo.PO_Inventory_CR_ALL.QtyOrdered - dbo.PO_Inventory_CR_ALL.QtyReceived > 0) AND 
                      (MAS_POL.dbo.CI_Item.UDF_RESTRICT_MANAGER <> 'SPECIAL ORDER') OR
                      (MAS_POL.dbo.AP_Vendor.UDF_VEND_INACTIVE <> 'Y') AND (MAS_POL.dbo.CI_Item.Category2 = 'N') AND (MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES = '') AND 
                      (MAS_POL.dbo.CI_Item.StandardUnitCost > 0) AND (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND (dbo.IM_TransactionsThreeMonths.ItemCode IS NOT NULL) AND
					  (MAS_POL.dbo.CI_Item.UDF_RESTRICT_MANAGER <> 'SPECIAL ORDER') OR
                      (MAS_POL.dbo.AP_Vendor.UDF_VEND_INACTIVE <> 'Y') AND (MAS_POL.dbo.CI_Item.Category2 = 'N') AND (MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES = '') AND 
                      (MAS_POL.dbo.CI_Item.StandardUnitCost > 0) AND (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND (dbo.PO_CompletedThreeMonths.ItemCode IS NOT NULL) AND
					  (MAS_POL.dbo.CI_Item.UDF_RESTRICT_MANAGER <> 'SPECIAL ORDER')


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
               Top = 6
               Left = 284
               Bottom = 325
               Right = 528
            End
            DisplayFlags = 280
            TopColumn = 20
         End
         Begin Table = "AP_Vendor (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 566
               Bottom = 114
               Right = 792
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IM_TransactionsThreeMonths"
            Begin Extent = 
               Top = 6
               Left = 830
               Bottom = 69
               Right = 981
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PO_Inventory_CR_ALL"
            Begin Extent = 
               Top = 6
               Left = 1019
               Bottom = 99
               Right = 1170
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PO_CompletedThreeMonths"
            Begin Extent = 
               Top = 6
               Left = 1208
               Bottom = 69
               Right = 1359
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
   Begin Cr', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Website_Shelftalkers_Items'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'iteriaPane = 
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Website_Shelftalkers_Items'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Website_Shelftalkers_Items'
