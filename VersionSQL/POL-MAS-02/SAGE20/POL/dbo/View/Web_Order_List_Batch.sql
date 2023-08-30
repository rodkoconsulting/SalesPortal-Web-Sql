/****** Object:  View [dbo].[Web_Order_List_Batch]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Order_List_Batch]
AS
SELECT        inh.InvoiceNo
			, CustomerName AS BILLTONAME
			, CASE WHEN Year(OrderDate) < 2000 then InvoiceDate ELSE OrderDate END as OrderDate
			, InvoiceDate AS SHIPDATE
			, CASE WHEN inh.Comment like 'BILL & HOLD TRANSFER%' THEN 'BHT'
				   WHEN inh.Comment like 'BILL & HOLD INVOICE%' OR (inh.Comment like 'BILL & HOLD%' AND ExtensionAmt > 0) THEN 'BHI'
				   ELSE InvoiceType END AS INVOICETYPE
			, QuantityOrdered
			, UnitPrice
			, ExtensionAmt
			, CASE WHEN ind.ITEMTYPE = 1 THEN UDF_BRAND_NAMES + ' ' + UDF_DESCRIPTION + ' ' + UDF_VINTAGE + ' (' + REPLACE(SalesUnitOfMeasure, 'C', '') + '/'
				 + (CASE WHEN CHARINDEX('ML', UDF_BOTTLE_SIZE) > 0 THEN REPLACE(UDF_BOTTLE_SIZE, ' ML', '') ELSE REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ', '') END) + ') '
				 + UDF_DAMAGED_NOTES ELSE ind.ITEMCODEDESC END AS ItemDescription
			, ind.ItemCode
			, CAST(REPLACE(UnitOfMeasure, 'C', '') AS INT) AS UOM
			, UDF_TERRITORY AS Territory
			, inh.SalespersonNo
			, LineKey
			, inh.Comment
			, CASE WHEN IsNumeric(inh.UDF_NJ_COOP) = 1 AND CHARINDEX('.', inh.UDF_NJ_COOP) = 0 THEN CAST(inh.UDF_NJ_COOP AS INT) ELSE NULL END AS CoopNo
			, CASE WHEN RIGHT(c.CUSTOMERTYPE, 1) = 'N' THEN 'On' WHEN RIGHT(c.CUSTOMERTYPE, 1) = 'F' THEN 'Off' ELSE '' END AS Premise
			, UDF_AFFILIATIONS as Affiliations
			, Replace(ShipToName,'''','') as ShipTo
FROM            MAS_POL.dbo.SO_InvoiceHeader as inh INNER JOIN
                         MAS_POL.dbo.AR_Customer as c ON inh.CustomerNo = c.CustomerNo AND 
                         inh.ARDivisionNo = c.ARDivisionNo INNER JOIN
                         MAS_POL.dbo.AR_Salesperson ON inh.SalespersonDivisionNo = MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo AND 
                         inh.SalespersonNo = MAS_POL.dbo.AR_Salesperson.SalespersonNo INNER JOIN
                         MAS_POL.dbo.SO_InvoiceDetail as ind ON inh.InvoiceNo = ind.InvoiceNo INNER JOIN
                         MAS_POL.dbo.CI_Item ON ind.ItemCode = MAS_POL.dbo.CI_Item.ItemCode
WHERE        (MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo = '00') and inh.SalesOrderNo = ''

EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[32] 4[17] 2[32] 3) )"
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
         Begin Table = "AR_Customer (MAS_POL.dbo)"
            Begin Extent = 
               Top = 7
               Left = 1081
               Bottom = 136
               Right = 1376
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_Salesperson (MAS_POL.dbo)"
            Begin Extent = 
               Top = 183
               Left = 1094
               Bottom = 312
               Right = 1316
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CI_Item (MAS_POL.dbo)"
            Begin Extent = 
               Top = 144
               Left = 46
               Bottom = 273
               Right = 307
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SO_InvoiceHeader (MAS_POL.dbo)"
            Begin Extent = 
               Top = 9
               Left = 607
               Bottom = 225
               Right = 890
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SO_InvoiceDetail (MAS_POL.dbo)"
            Begin Extent = 
               Top = 131
               Left = 329
               Bottom = 314
               Right = 564
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
  ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Web_Order_List_Batch'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'       GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Web_Order_List_Batch'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Web_Order_List_Batch'
