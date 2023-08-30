/****** Object:  View [dbo].[FreshDirect]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[FreshDirect]
AS
SELECT     MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode AS 'Item Number', 
                      MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES + ' ' + MAS_POL.dbo.CI_Item.UDF_DESCRIPTION + ' ' + MAS_POL.dbo.CI_Item.UDF_VINTAGE + ' (' + REPLACE(MAS_POL.dbo.CI_Item.SalesUnitOfMeasure,
                       'C', '') + '/' + (CASE WHEN CHARINDEX('ML', MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE) > 0 THEN REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ML', '') 
                      ELSE REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ', '') END) + ') ' + MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES AS 'Item', 
                      MAS_POL.dbo.CI_Item.UDF_WINE_COLOR AS 'Item Class', IsNull(v.UDF_VARIETAL,'') AS 'Wine Variety', 
                      MAS_POL.dbo.CI_Item.UDF_COUNTRY AS 'Country', IsNull(r.UDF_REGION,'') AS 'Region', MAS_POL.dbo.CI_Item.UDF_BOTTLE_SIZE AS 'Size', 
                      SUM(CASE WHEN LEFT(MAS_POL.dbo.SO_ShipToAddress.UDF_REGION_CODE, 3) = 'NYC' OR
                      LEFT(MAS_POL.dbo.SO_ShipToAddress.UDF_REGION_CODE, 3) = 'NYL' OR
                      LEFT(MAS_POL.dbo.SO_ShipToAddress.UDF_REGION_CODE, 3) 
                      = 'NYW' THEN MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped * MAS_POL.dbo.CI_Item.Volume / 9 ELSE 0 END) AS 'CC 9L Equiv Metro', 
                      SUM(CASE WHEN MAS_POL.dbo.SO_ShipToAddress.UDF_REGION_CODE = 'NYC1' THEN MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped * MAS_POL.dbo.CI_Item.Volume
                       / 9 ELSE 0 END) AS 'CC 9L Equiv Manhattan', 
                      SUM(CASE WHEN MAS_POL.dbo.SO_ShipToAddress.UDF_REGION_CODE = 'NYCB1' THEN MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped * MAS_POL.dbo.CI_Item.Volume
                       / 9 ELSE 0 END) AS 'CC 9L Equiv BK', SUM(CASE WHEN (LEFT(MAS_POL.dbo.SO_ShipToAddress.UDF_REGION_CODE, 3) = 'NYC' OR
                      LEFT(MAS_POL.dbo.SO_ShipToAddress.UDF_REGION_CODE, 3) = 'NYL' OR
                      LEFT(MAS_POL.dbo.SO_ShipToAddress.UDF_REGION_CODE, 3) = 'NYW') AND 
                      MAS_POL.dbo.AR_Customer.CustomerType = 'NYOF' THEN MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped * MAS_POL.dbo.CI_Item.Volume / 9 ELSE 0 END) 
                      AS 'CC 9L Equiv Metro Off', SUM(CASE WHEN MAS_POL.dbo.SO_ShipToAddress.UDF_REGION_CODE = 'NYC1' AND 
                      MAS_POL.dbo.AR_Customer.CustomerType = 'NYOF' THEN MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped * MAS_POL.dbo.CI_Item.Volume / 9 ELSE 0 END) 
                      AS 'CC 9L Equiv Manhattan Off', SUM(CASE WHEN MAS_POL.dbo.SO_ShipToAddress.UDF_REGION_CODE = 'NYCB1' AND 
                      MAS_POL.dbo.AR_Customer.CustomerType = 'NYOF' THEN MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped * MAS_POL.dbo.CI_Item.Volume / 9 ELSE 0 END) 
                      AS 'CC 9L Equiv BK Off'
FROM         MAS_POL.dbo.CI_Item INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryDetail ON MAS_POL.dbo.CI_Item.ItemCode = MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryHeader ON MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo INNER JOIN
                      MAS_POL.dbo.SO_ShipToAddress ON MAS_POL.dbo.AR_InvoiceHistoryHeader.ARDivisionNo = MAS_POL.dbo.SO_ShipToAddress.ARDivisionNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.CustomerNo = MAS_POL.dbo.SO_ShipToAddress.CustomerNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.ShipToCode = MAS_POL.dbo.SO_ShipToAddress.ShipToCode INNER JOIN
                      MAS_POL.dbo.AR_Customer ON MAS_POL.dbo.AR_InvoiceHistoryHeader.ARDivisionNo = MAS_POL.dbo.AR_Customer.ARDivisionNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.CustomerNo = MAS_POL.dbo.AR_Customer.CustomerNo LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_VARIETALS AS v ON MAS_POL.dbo.CI_Item.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
					  MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON MAS_POL.dbo.CI_Item.UDF_REGION = r.UDF_PRIMARY_REGION_CODE
WHERE     (MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate >= DATEADD(YEAR, - 1, GETDATE())) AND (MAS_POL.dbo.CI_Item.ItemType = '1')
			and CI_Item.UDF_RESTRICT_ALLOCATED <> 'Y'
			and CI_Item.UDF_RESTRICT_MANAGER = ''
			and CI_Item.UDF_RESTRICT_MAX=0
			and CI_Item.UDF_RESTRICT_NORETAIL <>'Y'
			and CI_Item.UDF_RESTRICT_OFFSALE <> 'Y'
			and CI_Item.UDF_RESTRICT_STATE <> 'NJ ONLY'
GROUP BY MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode, MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES, MAS_POL.dbo.CI_Item.UDF_DESCRIPTION, 
                      MAS_POL.dbo.CI_Item.UDF_VINTAGE, MAS_POL.dbo.CI_Item.SalesUnitOfMeasure, MAS_POL.dbo.CI_Item.UDF_BOTTLE_SIZE, 
                      MAS_POL.dbo.CI_Item.UDF_DAMAGED_NOTES, MAS_POL.dbo.CI_Item.UDF_WINE_COLOR, MAS_POL.dbo.CI_Item.UDF_VARIETALS_T, 
                      MAS_POL.dbo.CI_Item.UDF_COUNTRY, MAS_POL.dbo.CI_Item.UDF_REGION, v.UDF_VARIETAL, r.UDF_REGION
HAVING      (SUM(MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped) > 0)


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
         Begin Table = "CI_Item (MAS_POL.dbo)"
            Begin Extent = 
               Top = 26
               Left = 952
               Bottom = 178
               Right = 1197
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_InvoiceHistoryHeader (MAS_POL.dbo)"
            Begin Extent = 
               Top = 29
               Left = 62
               Bottom = 294
               Right = 332
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_InvoiceHistoryDetail (MAS_POL.dbo)"
            Begin Extent = 
               Top = 23
               Left = 620
               Bottom = 131
               Right = 838
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SO_ShipToAddress (MAS_POL.dbo)"
            Begin Extent = 
               Top = 210
               Left = 529
               Bottom = 318
               Right = 784
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_Customer (MAS_POL.dbo)"
            Begin Extent = 
               Top = 150
               Left = 1292
               Bottom = 258
               Right = 1565
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
      Begin ColumnWidths = 14
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'FreshDirect'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'Width = 1500
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'FreshDirect'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'FreshDirect'
