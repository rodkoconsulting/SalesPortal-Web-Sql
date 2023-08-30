/****** Object:  View [dbo].[FDL_DeliveryWindows_Update]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[FDL_DeliveryWindows_Update]
AS
SELECT     MAS_POL.dbo.SO_ShipToAddress.ARDivisionNo, MAS_POL.dbo.SO_ShipToAddress.CustomerNo, MAS_POL.dbo.SO_ShipToAddress.ShipToCode,
MAS_POL.dbo.SO_ShipToAddress.UDF_INSTRUCTIONS,
dbo.FDL_DeliveryWindows_Import.UDF_INSTRUCTIONS AS UDF_INSTRUCTIONS_NEW,
                      MAS_POL.dbo.SO_ShipToAddress.UDF_DELIVERY_WINDOW_1_START, MAS_POL.dbo.SO_ShipToAddress.UDF_DELIVERY_WINDOW_1_END, 
                      MAS_POL.dbo.SO_ShipToAddress.UDF_DELIVERY_WINDOW_2_END, MAS_POL.dbo.SO_ShipToAddress.UDF_DELIVERY_WINDOW_2_START, 
                      dbo.FDL_DeliveryWindows_Import.UDF_DELIVERY_WINDOW_1_START AS UDF_DELIVERY_WINDOW_1_START_NEW, 
                      dbo.FDL_DeliveryWindows_Import.UDF_DELIVERY_WINDOW_1_END AS UDF_DELIVERY_WINDOW_1_END_NEW, 
                      dbo.FDL_DeliveryWindows_Import.UDF_DELIVERY_WINDOW_2_START AS UDF_DELIVERY_WINDOW_2_START_NEW, 
                      dbo.FDL_DeliveryWindows_Import.UDF_DELIVERY_WINDOW_2_END AS UDF_DELIVERY_WINDOW_2_END_NEW
FROM         dbo.FDL_DeliveryWindows_Import INNER JOIN
                      MAS_POL.dbo.SO_ShipToAddress ON dbo.FDL_DeliveryWindows_Import.ARDivisionNo = MAS_POL.dbo.SO_ShipToAddress.ARDivisionNo AND 
                      dbo.FDL_DeliveryWindows_Import.CustomerNo = MAS_POL.dbo.SO_ShipToAddress.CustomerNo AND 
                      dbo.FDL_DeliveryWindows_Import.ShipToCode = MAS_POL.dbo.SO_ShipToAddress.ShipToCode


EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[20] 3) )"
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
         Begin Table = "FDL_DeliveryWindows_Import"
            Begin Extent = 
               Top = 0
               Left = 130
               Bottom = 260
               Right = 385
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SO_ShipToAddress (MAS_POL.dbo)"
            Begin Extent = 
               Top = 49
               Left = 493
               Bottom = 256
               Right = 751
            End
            DisplayFlags = 280
            TopColumn = 37
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'FDL_DeliveryWindows_Update'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'FDL_DeliveryWindows_Update'
