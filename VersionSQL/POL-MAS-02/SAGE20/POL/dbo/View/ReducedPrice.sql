/****** Object:  View [dbo].[ReducedPrice]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[ReducedPrice]
AS
WITH MINPRICE AS (SELECT     ItemCode, CustomerPriceLevel, MIN(DiscountMarkup1) AS MinPrice
                                             FROM         MAS_POL.dbo.IM_PriceCode
                                             WHERE     (ValidDate_234 <= GETDATE() and CustomerPriceLevel <> '')
                                             GROUP BY ItemCode, CustomerPriceLevel), MINDATE AS
    (SELECT     ItemCode, CustomerPriceLevel, MIN(ValidDate_234) AS MinDate
      FROM          MAS_POL.dbo.IM_PriceCode AS IM_PriceCode_2
      WHERE      (ValidDate_234 <= GETDATE())
      GROUP BY ItemCode, CustomerPriceLevel)
    SELECT     TOP (100) PERCENT MINPRICE_1.ItemCode, MINPRICE_1.CustomerPriceLevel, MAX(CASE WHEN DiscountMarkup1 > MinPrice AND 
                            ValidDate_234 = MinDate THEN 1 ELSE 0 END) AS ISREDUCED
     FROM         MAS_POL.dbo.IM_PriceCode AS IM_PriceCode_1 INNER JOIN
                            MINPRICE AS MINPRICE_1 ON IM_PriceCode_1.ItemCode = MINPRICE_1.ItemCode AND 
                            IM_PriceCode_1.CustomerPriceLevel = MINPRICE_1.CustomerPriceLevel INNER JOIN
                            MINDATE AS MINDATE_1 ON IM_PriceCode_1.ItemCode = MINDATE_1.ItemCode AND 
                            IM_PriceCode_1.CustomerPriceLevel = MINDATE_1.CustomerPriceLevel
     WHERE     (IM_PriceCode_1.ValidDate_234 <= GETDATE())
     GROUP BY MINPRICE_1.ItemCode, MINPRICE_1.CustomerPriceLevel


EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[24] 4[29] 2[12] 3) )"
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
         Begin Table = "IM_PriceCode_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 259
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MINPRICE_1"
            Begin Extent = 
               Top = 6
               Left = 297
               Bottom = 99
               Right = 471
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MINDATE_1"
            Begin Extent = 
               Top = 6
               Left = 509
               Bottom = 99
               Right = 683
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
      Begin ColumnWidths = 12
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ReducedPrice'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'ReducedPrice'
