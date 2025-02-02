/****** Object:  View [dbo].[PO_SampleIndexbyCountry]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PO_SampleIndexbyCountry]
AS
SELECT        s.SalespersonName as Rep, s.UDF_TERRITORY as Territory, i.UDF_COUNTRY AS Country, CAST(ROUND(CAST(REPLACE(i.StandardUnitOfMeasure, 'C', '') AS int) * d.QuantityOrdered, 0) AS INT) AS Quantity, CONVERT(DECIMAL(9, 2), ROUND(d.QuantityOrdered * d.UnitCost, 2)) 
                         AS Cost, CASE WHEN h.OrderStatus = 'X' THEN CompletionDate ELSE RequiredExpireDate END AS Date
FROM            MAS_POL.dbo.PO_PurchaseOrderHeader AS h INNER JOIN
                         dbo.PortalPoAddress AS a ON h.ShipToCode = a.ShipToCode INNER JOIN
                         MAS_POL.dbo.PO_PurchaseOrderDetail AS d ON h.PurchaseOrderNo = d.PurchaseOrderNo INNER JOIN
                         MAS_POL.dbo.CI_Item AS i ON d.ItemCode = i.ItemCode INNER JOIN
                         MAS_POL.dbo.AR_Salesperson AS s ON a.Rep = s.SalespersonNo
WHERE        h.OrderType = 'X'
				AND s.SalespersonDivisionNo = '00'
				AND s.SalespersonName <> 'Non-Commissionable Sales'
				AND s.SalespersonNo not like 'XX%'
				AND s.SalespersonNo not like 'HS%'
				AND s.UDF_ACTIVE = 'Y'
				AND d.QuantityOrdered > 0.04
				AND d.WarehouseCode = '000'
				AND d.PurchasesAcctKey = '00000001K'
				AND i.ItemType='1'
				AND len(i.UDF_COUNTRY) > 0

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
         Begin Table = "h"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 317
               Bottom = 136
               Right = 487
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 525
               Bottom = 136
               Right = 786
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "i"
            Begin Extent = 
               Top = 6
               Left = 824
               Bottom = 136
               Right = 1085
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 6
               Left = 1123
               Bottom = 136
               Right = 1345
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PO_SampleIndexbyCountry'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PO_SampleIndexbyCountry'
