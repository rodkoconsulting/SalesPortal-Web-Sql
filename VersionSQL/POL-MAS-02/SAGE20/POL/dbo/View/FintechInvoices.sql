/****** Object:  View [dbo].[FintechInvoices]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[FintechInvoices]
AS
SELECT        '1553589494964' AS Division_id
			, h.InvoiceNo AS invoice_number
			, h.InvoiceDate AS invoice_date
			, h.ARDivisionNo + h.CustomerNo AS Vendor_store_id
			, CASE WHEN h.InvoiceType = 'IN' THEN h.InvoiceDueDate ELSE NULL END AS invoice_due_date
			, CASE WHEN h.InvoiceType = 'IN' THEN '' ELSE LEFT(h.InvoiceNo, len(h.InvoiceNo) - 1) END AS ref_invoice_number
			, CASE WHEN i.ItemType = '1' then ROUND(d.QuantityShipped, 2) ELSE 1 END AS quantity_shipped
			, CASE WHEN i.ItemType = '1' then 'CA' else 'EA' END AS Quantity_uom
			, d.ItemCode AS item_number, CASE WHEN len(i.UDF_UPC_CODE) = 12 THEN i.UDF_UPC_CODE ELSE '' END AS upc_pack
			, Replace (CASE WHEN i.ItemType = '1' then LEFT(REPLACE(i.UDF_BRAND_NAMES + ' ' + i.UDF_DESCRIPTION + ' ' + i.UDF_VINTAGE + CASE WHEN LEN(i.UDF_BOTTLE_SIZE) > 0 THEN ' (' + REPLACE(i.SalesUnitOfMeasure, 'C', '') + '/' + LEFT(i.UDF_BOTTLE_SIZE, CHARINDEX(' ', i.UDF_BOTTLE_SIZE) - 1)
                         + ') ' ELSE '' END + i.UDF_DAMAGED_NOTES, '  ', ' '), 80) ELSE d.ItemCodeDesc END, ',','') AS product_description
			, CASE WHEN i.ItemType = '1' then d.UnitPrice ELSE d.ExtensionAmt END AS unit_price
			, d.ExtensionAmt AS extended_price
			, CASE WHEN i.ItemType = '1' then dbo.TryConvertInt(REPLACE(i.SalesUnitOfMeasure, 'C', '')) ELSE 1 END AS packs_per_case
			, h.InvoiceType
			, CASE WHEN YEAR(h.DateCreated) > 2000 THEN h.DateCreated ELSE h.DateUpdated END as DateCreated
FROM            dbo.AR_InvoiceHistoryHeader AS h INNER JOIN
                         dbo.AR_InvoiceHistoryDetail AS d ON h.InvoiceNo = d.InvoiceNo AND h.HeaderSeqNo = d.HeaderSeqNo INNER JOIN
                         dbo.CI_Item AS i ON d.ItemCode = i.ItemCode INNER JOIN
						 dbo.AR_Customer as c ON h.ARDivisionNo = c.ARDivisionNo and h.CustomerNo = c.CustomerNo
WHERE (c.DefaultPaymentType = 'FINTK') AND (d.UnitPrice > 0 or i.ItemCode IN ('/STORAGE','/DEL','/DEL30'))

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
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 136
               Right = 511
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 6
               Left = 549
               Bottom = 102
               Right = 719
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "i"
            Begin Extent = 
               Top = 6
               Left = 757
               Bottom = 136
               Right = 1018
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'FintechInvoices'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'FintechInvoices'
