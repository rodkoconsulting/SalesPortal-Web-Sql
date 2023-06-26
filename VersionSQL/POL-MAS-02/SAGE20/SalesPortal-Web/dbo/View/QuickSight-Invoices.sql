/****** Object:  View [dbo].[QuickSight-Invoices]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[QuickSight-Invoices]
AS
WITH Invoices AS (SELECT DISTINCT 
                                                                  h.InvoiceNo, h.HeaderSeqNo, h.InvoiceType, h.InvoiceDate, h.ARDivisionNo, h.CustomerNo, h.SalespersonNo, h.Comment, h.UDF_NJ_COOP, d.ItemCode, d.ItemCodeDesc, d.QuantityShipped, d.UnitPrice, 
                                                                  d.ExtensionAmt, d.ItemType
                                         FROM            MAS_POL.dbo.AR_InvoiceHistoryHeader AS h INNER JOIN
                                                                  MAS_POL.dbo.AR_InvoiceHistoryDetail AS d ON h.InvoiceNo = d.InvoiceNo AND h.HeaderSeqNo = d.HeaderSeqNo
                                         WHERE        (h.ModuleCode = 'S/O') AND (h.InvoiceDate >= DATEADD(YEAR, - 2, GETDATE())) AND (d.ItemCode NOT IN ('/C', '/COBRA'))
                                         UNION ALL
                                         SELECT DISTINCT 
                                                                  h.InvoiceNo, h.InvoiceNo AS Expr1, h.InvoiceType, h.ShipDate, h.ARDivisionNo, h.CustomerNo, h.SalespersonNo, h.Comment, h.UDF_NJ_COOP, d.ItemCode, d.ItemCodeDesc, d.QuantityShipped, d.UnitPrice, 
                                                                  d.ExtensionAmt, d.ItemType
                                         FROM            MAS_POL.dbo.SO_InvoiceHeader AS h INNER JOIN
                                                                  MAS_POL.dbo.SO_InvoiceDetail AS d ON h.InvoiceNo = d.InvoiceNo
                                         WHERE        (d.ItemCode NOT IN ('/C', '/COBRA')))
    SELECT        c.CustomerName
	, c.UDF_AFFILIATIONS
	, c.SalespersonNo
	, CASE WHEN SUBSTRING(c.CUSTOMERTYPE, 3, 2) = 'ON' THEN 'On' ELSE 'Off' END AS Premise
	, CASE WHEN rep.UDF_TERRITORY <> '' THEN rep.UDF_TERRITORY ELSE 'NDD' END AS Territory
	, inv.InvoiceNo
	, inv.InvoiceType
	, inv.InvoiceDate
	, inv.Comment
	, inv.UDF_NJ_COOP
	, CASE WHEN inv.ItemType = '1' THEN CASE WHEN i.UDF_BRAND_NAMES = '' THEN '' ELSE i.UDF_BRAND_NAMES + ' ' + i.UDF_DESCRIPTION + ' ' + i.UDF_VINTAGE + ' (' + REPLACE(i.SalesUNITOFMEASURE, 'C', '') + '/' + (CASE WHEN CHARINDEX('ML', 
                              i.UDF_BOTTLE_SIZE) > 0 THEN REPLACE(i.UDF_BOTTLE_SIZE, ' ML', '') ELSE REPLACE(i.UDF_BOTTLE_SIZE, ' ', '') END) + ')' + i.UDF_DAMAGED_NOTES END ELSE inv.ItemCodeDesc END AS 'Description'
	, inv.ItemCode
	, inv.QuantityShipped
	, inv.UnitPrice
	, inv.ExtensionAmt
	, IsNull(i.UDF_WINE_COLOR,'') as UDF_WINE_COLOR
	, IsNull(v.UDF_VARIETAL,'') as UDF_VARIETAL
	, IsNull(i.UDF_COUNTRY,'') as UDF_COUNTRY
	, IsNull(r.UDF_REGION,'') as UDF_REGION
	, IsNull(ap.UDF_NAME,'') as UDF_NAME
	, IsNull(i.UDF_MASTER_VENDOR,'') as UDF_MASTER_VENDOR
	, IsNull(i.UDF_ORGANIC,'') as UDF_ORGANIC
	, IsNull(i.UDF_BIODYNAMIC,'') as UDF_BIODYNAMIC
	, CASE WHEN i.UDF_SAMPLE_FOCUS = 'Y' THEN 'Y' ELSE '' END AS Focus
     FROM            MAS_POL.dbo.AR_Customer AS c INNER JOIN
                              MAS_POL.dbo.AR_Salesperson AS rep ON c.SalespersonDivisionNo = rep.SalespersonDivisionNo AND c.SalespersonNo = rep.SalespersonNo INNER JOIN
                              Invoices AS inv ON c.ARDivisionNo = inv.ARDivisionNo AND c.CustomerNo = inv.CustomerNo LEFT OUTER JOIN
                              MAS_POL.dbo.CI_Item AS i ON inv.ItemCode = i.ItemCode LEFT OUTER JOIN
                              MAS_POL.dbo.CI_UDT_VARIETALS AS v ON i.UDF_VARIETALS_T = v.UDF_VARIETAL_CODE LEFT OUTER JOIN
                              MAS_POL.dbo.CI_UDT_PRIMARY_REGION AS r ON i.UDF_REGION = r.UDF_PRIMARY_REGION_CODE LEFT OUTER JOIN
                              MAS_POL.dbo.CI_UDT_APPELLATION AS ap ON i.UDF_SUBREGION_T = ap.UDF_APPELLATION

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
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 331
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "rep"
            Begin Extent = 
               Top = 6
               Left = 369
               Bottom = 136
               Right = 591
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "inv"
            Begin Extent = 
               Top = 6
               Left = 629
               Bottom = 136
               Right = 807
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "i"
            Begin Extent = 
               Top = 6
               Left = 845
               Bottom = 136
               Right = 1104
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "v"
            Begin Extent = 
               Top = 6
               Left = 1142
               Bottom = 102
               Right = 1345
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "r"
            Begin Extent = 
               Top = 6
               Left = 1383
               Bottom = 102
               Right = 1632
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ap"
            Begin Extent = 
               Top = 102
               Left = 1142
               Bottom = 198
               Right = 1333
            End
            DisplayFlags = 280
            TopColumn = 0
        ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'QuickSight-Invoices'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N' End
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'QuickSight-Invoices'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'QuickSight-Invoices'
