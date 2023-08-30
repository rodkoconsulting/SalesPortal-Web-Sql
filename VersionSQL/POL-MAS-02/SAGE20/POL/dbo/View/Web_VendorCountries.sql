/****** Object:  View [dbo].[Web_VendorCountries]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_VendorCountries]
AS
SELECT     MAS_POL.dbo.CI_Item.UDF_BRAND, COUNT(DISTINCT MAS_POL.dbo.CI_Item.UDF_COUNTRY) AS CountryCount
FROM         MAS_POL.dbo.CI_Item INNER JOIN
                      MAS_POL.dbo.AP_Vendor ON MAS_POL.dbo.CI_Item.PrimaryAPDivisionNo = MAS_POL.dbo.AP_Vendor.APDivisionNo AND 
                      MAS_POL.dbo.CI_Item.PrimaryVendorNo = MAS_POL.dbo.AP_Vendor.VendorNo INNER JOIN
                      dbo.IM_ItemWarehouse_000 ON MAS_POL.dbo.CI_Item.ItemCode = dbo.IM_ItemWarehouse_000.ItemCode LEFT OUTER JOIN
                      dbo.IM_SalesOrderTransactionsOneMonth ON MAS_POL.dbo.CI_Item.ItemCode = dbo.IM_SalesOrderTransactionsOneMonth.ItemCode LEFT OUTER JOIN
                      dbo.PO_Inventory_CR_ALL ON MAS_POL.dbo.CI_Item.ItemCode = dbo.PO_Inventory_CR_ALL.ItemCode
WHERE     (MAS_POL.dbo.CI_Item.UDF_BRAND <> '') AND (MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES = '') AND (MAS_POL.dbo.CI_Item.StandardUnitCost > 0) AND 
                      (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND 
                      (MAS_POL.dbo.AP_Vendor.UDF_VEND_INACTIVE <> 'Y') AND (MAS_POL.dbo.CI_Item.Category2 = 'N') AND (dbo.IM_ItemWarehouse_000.QuantityOnHand > 0.04) AND 
                      (MAS_POL.dbo.CI_Item.UDF_RESTRICT_MANAGER = '') OR
                      (MAS_POL.dbo.CI_Item.UDF_BRAND <> '') AND (MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES = '') AND (MAS_POL.dbo.CI_Item.StandardUnitCost > 0) AND 
                      (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND 
                      (MAS_POL.dbo.AP_Vendor.UDF_VEND_INACTIVE <> 'Y') AND (MAS_POL.dbo.CI_Item.Category2 = 'N') AND (MAS_POL.dbo.CI_Item.UDF_RESTRICT_MANAGER = '') AND
					  (dbo.PO_Inventory_CR_ALL.QtyOrdered - dbo.PO_Inventory_CR_ALL.QtyReceived > 0) OR
                      (MAS_POL.dbo.CI_Item.UDF_BRAND <> '') AND (MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES = '') AND (MAS_POL.dbo.CI_Item.StandardUnitCost > 0) AND 
                      (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND 
                      (MAS_POL.dbo.AP_Vendor.UDF_VEND_INACTIVE <> 'Y') AND (MAS_POL.dbo.CI_Item.Category2 = 'N') AND (MAS_POL.dbo.CI_Item.UDF_RESTRICT_MANAGER = '') AND
					  (dbo.IM_SalesOrderTransactionsOneMonth.ItemCode IS NOT NULL) OR
                      (MAS_POL.dbo.CI_Item.UDF_BRAND <> '') AND (MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES = '') AND (MAS_POL.dbo.CI_Item.StandardUnitCost > 0) AND 
                      (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND 
                      (MAS_POL.dbo.AP_Vendor.UDF_VEND_INACTIVE <> 'Y') AND (MAS_POL.dbo.CI_Item.Category2 = 'N') AND (dbo.IM_ItemWarehouse_000.QuantityOnHand > 0.04) AND 
                      (MAS_POL.dbo.CI_Item.UDF_RESTRICT_MANAGER <> 'SPECIAL ORDER') OR
                      (MAS_POL.dbo.CI_Item.UDF_BRAND <> '') AND (MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES = '') AND (MAS_POL.dbo.CI_Item.StandardUnitCost > 0) AND 
                      (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND 
                      (MAS_POL.dbo.AP_Vendor.UDF_VEND_INACTIVE <> 'Y') AND (MAS_POL.dbo.CI_Item.Category2 = 'N') AND 
                      (dbo.PO_Inventory_CR_ALL.QtyOrdered - dbo.PO_Inventory_CR_ALL.QtyReceived > 0) AND 
                      (MAS_POL.dbo.CI_Item.UDF_RESTRICT_MANAGER <> 'SPECIAL ORDER') OR
                      (MAS_POL.dbo.CI_Item.UDF_BRAND <> '') AND (MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES = '') AND (MAS_POL.dbo.CI_Item.StandardUnitCost > 0) AND 
                      (MAS_POL.dbo.CI_Item.ProductLine <> 'SAMP') AND 
                      (MAS_POL.dbo.AP_Vendor.UDF_VEND_INACTIVE <> 'Y') AND (MAS_POL.dbo.CI_Item.Category2 = 'N') AND 
                      (dbo.IM_SalesOrderTransactionsOneMonth.ItemCode IS NOT NULL) AND (MAS_POL.dbo.CI_Item.UDF_RESTRICT_MANAGER <> 'SPECIAL ORDER')
GROUP BY MAS_POL.dbo.CI_Item.UDF_BRAND
HAVING      (COUNT(DISTINCT MAS_POL.dbo.CI_Item.UDF_COUNTRY) > 1)

EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[54] 4[7] 2[12] 3) )"
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
         Begin Table = "CI_Item (MAS_POL.dbo)"
            Begin Extent = 
               Top = 13
               Left = 231
               Bottom = 288
               Right = 474
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AP_Vendor (MAS_POL.dbo)"
            Begin Extent = 
               Top = 317
               Left = 595
               Bottom = 425
               Right = 837
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IM_ItemWarehouse_000"
            Begin Extent = 
               Top = 190
               Left = 751
               Bottom = 283
               Right = 975
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PO_Inventory_CR_ALL"
            Begin Extent = 
               Top = 9
               Left = 0
               Bottom = 102
               Right = 167
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IM_SalesOrderTransactionsOneMonth"
            Begin Extent = 
               Top = 19
               Left = 803
               Bottom = 82
               Right = 970
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
      ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Web_VendorCountries'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'Begin ColumnWidths = 15
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
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Web_VendorCountries'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Web_VendorCountries'
