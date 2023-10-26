/****** Object:  View [dbo].[EmpireWinesFeed_Query]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[EmpireWinesFeed_Query]
AS
SELECT        i.UDF_BRAND_NAMES as Vendor
			, i.ItemCode as [Item Code]
			, i.UDF_DESCRIPTION
			, i.UDF_VINTAGE
			, i.SalesUnitOfMeasure
			, i.UDF_BOTTLE_SIZE
			, i.UDF_CLOSURE
			, p.DiscountMarkup1
			, p.ValidDateDescription_234
			, inv.QuantityAvailable
			, i.UDF_COUNTRY
			, i.UDF_REGION
			, i.UDF_SUBREGION_T
			, i.UDF_WINE_COLOR
			, i.UDF_VARIETALS_T
			, i.UDF_ORGANIC
			, i.UDF_BIODYNAMIC
			, i.UDF_PARKER
			, i.UDF_SPECTATOR
			, i.UDF_TANZER
			, i.UDF_BURGHOUND
			, i.UDF_VFC
			, i.UDF_UPC_CODE
FROM            dbo.CI_Item i INNER JOIN
                         dbo.EmpireFeedBrands b ON i.UDF_BRAND_NAMES = b.Brand INNER JOIN
                         dbo.ReducedPrice r ON i.ItemCode = r.ItemCode INNER JOIN
                         dbo.IM_InventoryAvailable inv ON i.ItemCode = inv.ITEMCODE LEFT OUTER JOIN
                         dbo.PO_Inventory_CR po ON i.ItemCode = po.ItemCode LEFT OUTER JOIN
                         dbo.IM_PriceCode p ON i.ItemCode = p.ItemCode
WHERE p.CustomerPriceLevel = 'Y'
		and r.CustomerPriceLevel = 'Y'

GROUP BY i.ItemCode
		, i.UDF_BRAND_NAMES
		, i.UDF_DESCRIPTION
		, i.UDF_VINTAGE
		, i.SalesUnitOfMeasure
		, i.UDF_BOTTLE_SIZE
		, i.UDF_CLOSURE
		, p.DiscountMarkup1
		, p.ValidDateDescription_234
		, inv.QuantityAvailable
		, i.UDF_COUNTRY
		, i.UDF_REGION
		, i.UDF_SUBREGION_T
		, i.UDF_WINE_COLOR
		, i.UDF_VARIETALS_T
		, i.UDF_ORGANIC
		, i.UDF_BIODYNAMIC
		, i.UDF_PARKER
		, i.UDF_SPECTATOR
		, i.UDF_TANZER
		, i.UDF_BURGHOUND
		, i.UDF_VFC
		, i.UDF_UPC_CODE

EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[58] 4[3] 2[20] 3) )"
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
         Begin Table = "CI_Item"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 324
               Right = 286
            End
            DisplayFlags = 280
            TopColumn = 54
         End
         Begin Table = "IM_PriceCode"
            Begin Extent = 
               Top = 36
               Left = 1195
               Bottom = 231
               Right = 1441
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "IM_InventoryAvailable"
            Begin Extent = 
               Top = 330
               Left = 1053
               Bottom = 460
               Right = 1297
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PO_Inventory_CR"
            Begin Extent = 
               Top = 251
               Left = 407
               Bottom = 381
               Right = 598
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ReducedPrice"
            Begin Extent = 
               Top = 105
               Left = 868
               Bottom = 218
               Right = 1062
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "EmpireFeedBrands"
            Begin Extent = 
               Top = 392
               Left = 309
               Bottom = 471
               Right = 479
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
      Begin ColumnWid', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'EmpireWinesFeed_Query'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'ths = 11
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'EmpireWinesFeed_Query'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'EmpireWinesFeed_Query'
