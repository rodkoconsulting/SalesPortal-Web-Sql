/****** Object:  View [dbo].[FDL_DeliveryWindows]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[FDL_DeliveryWindows]
AS
SELECT     'DP' + dbo.FDL_DeliveryWindows_Internal.CustomerNo + 'L' + dbo.FDL_DeliveryWindows_Internal.ShipToCode AS 'Ship to ID', 
                      dbo.AR_Customer.CustomerName AS Name, dbo.SO_ShipToAddress.SHIPTOADDRESS1 AS 'Address', dbo.SO_ShipToAddress.SHIPTOCITY AS 'City', 
                      dbo.SO_ShipToAddress.SHIPTOSTATE AS 'State', dbo.SO_ShipToAddress.SHIPTOZIPCODE AS 'Zip', LEFT(dbo.SO_ShipToAddress.UDF_INSTRUCTIONS, 50) 
                      AS 'Delivery Instruction', CASE WHEN dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_1_START IS NULL OR dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_1_START = 0
                      THEN '' WHEN LEN(dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_1_START) 
                      = 1 THEN '0' + CAST(dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_1_START AS VARCHAR(1)) 
                      + ':00' ELSE CAST(dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_1_START AS VARCHAR(2)) + ':00' END AS 'Delivery Window # 1 - Open', 
                      CASE WHEN dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_1_END IS NULL OR dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_1_END = 0
                      THEN '' WHEN LEN(dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_1_END) 
                      = 1 THEN '0' + CAST(dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_1_END AS VARCHAR(1)) 
                      + ':00' ELSE CAST(dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_1_END AS VARCHAR(2)) + ':00' END AS 'Delivery Window # 1 - Close', 
                      CASE WHEN dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_2_START IS NULL OR dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_2_START = 0
                      THEN '' WHEN LEN(dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_2_START) 
                      = 1 THEN '0' + CAST(dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_2_START AS VARCHAR(1)) 
                      + ':00' ELSE CAST(dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_2_START AS VARCHAR(2)) + ':00' END AS 'Delivery Window # 2 - Open', 
                      CASE WHEN dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_2_END IS NULL OR dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_2_END = 0
                      THEN '' WHEN LEN(dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_2_END) 
                      = 1 THEN '0' + CAST(dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_2_END AS VARCHAR(1)) 
                      + ':00' ELSE CAST(dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_2_END AS VARCHAR(2)) + ':00' END AS 'Delivery Window # 2 - Close'
FROM         dbo.FDL_DeliveryWindows_Internal INNER JOIN
                      dbo.AR_Customer ON dbo.FDL_DeliveryWindows_Internal.ARDivisionNo = dbo.AR_Customer.ARDivisionNo AND 
                      dbo.FDL_DeliveryWindows_Internal.CustomerNo = dbo.AR_Customer.CustomerNo INNER JOIN
                      dbo.SO_ShipToAddress ON dbo.FDL_DeliveryWindows_Internal.ARDivisionNo = dbo.SO_ShipToAddress.ARDivisionNo AND 
                      dbo.FDL_DeliveryWindows_Internal.CustomerNo = dbo.SO_ShipToAddress.CustomerNo AND 
                      dbo.FDL_DeliveryWindows_Internal.ShipToCode = dbo.SO_ShipToAddress.ShipToCode
WHERE NOT dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_1_START IS NULL OR dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_1_START > 0 OR
		NOT dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_1_END IS NULL OR dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_1_END > 0 OR
		NOT dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_2_START IS NULL OR dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_2_START > 0 OR
		NOT dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_2_END IS NULL OR dbo.FDL_DeliveryWindows_Internal.UDF_DELIVERY_WINDOW_2_END > 0


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
         Begin Table = "FDL_DeliveryWindows_Internal"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 294
               Right = 362
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_Customer"
            Begin Extent = 
               Top = 6
               Left = 400
               Bottom = 290
               Right = 697
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SO_ShipToAddress"
            Begin Extent = 
               Top = 6
               Left = 735
               Bottom = 273
               Right = 953
            End
            DisplayFlags = 280
            TopColumn = 3
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
         Width = 284
         Width = 1500
         Width = 3510
         Width = 2460
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 3615
         Width = 2595
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'FDL_DeliveryWindows'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'FDL_DeliveryWindows'
