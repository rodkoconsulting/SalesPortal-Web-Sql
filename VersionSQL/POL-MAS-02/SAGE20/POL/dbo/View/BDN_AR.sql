/****** Object:  View [dbo].[BDN_AR]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[BDN_AR]
AS
SELECT     MAS_POL.dbo.AP_Vendor.APDivisionNo, MAS_POL.dbo.AP_Vendor.VendorNo, MAS_POL.dbo.AP_Vendor.UDF_MASTER_VENDOR, 
                      MAS_POL.dbo.AR_Customer.CustomerNo, MAS_POL.dbo.AR_Customer.CustomerName, MAS_POL.dbo.AR_Customer.AddressLine1, MAS_POL.dbo.AR_Customer.City, 
                      MAS_POL.dbo.AR_Customer.ZipCode, MAS_POL.dbo.AR_Customer.CustomerType, MAS_POL.dbo.AR_Customer.UDF_LICENSE_NUM, 
                      MAS_POL.dbo.AR_Customer.UDF_WINE_BUYER, MAS_POL.dbo.AR_Customer.UDF_WINE_BUYER_PHONE, 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate as TransactionDate,
                      MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped, MAS_POL.dbo.AR_InvoiceHistoryDetail.UnitPrice, 
                      MAS_POL.dbo.AR_InvoiceHistoryDetail.ExtensionAmt, MAS_POL.dbo.AR_Salesperson.SalespersonNo, MAS_POL.dbo.AR_Salesperson.SalespersonName, 
                      MAS_POL.dbo.AR_Salesperson.UDF_TERRITORY, MAS_POL.dbo.CI_Item.ItemCode
FROM         MAS_POL.dbo.AR_Customer INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryHeader ON MAS_POL.dbo.AR_Customer.ARDivisionNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.ARDivisionNo AND 
                      MAS_POL.dbo.AR_Customer.CustomerNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.CustomerNo INNER JOIN
                      MAS_POL.dbo.AR_Salesperson ON MAS_POL.dbo.AR_Customer.SalespersonDivisionNo = MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo AND 
                      MAS_POL.dbo.AR_Customer.SalespersonNo = MAS_POL.dbo.AR_Salesperson.SalespersonNo INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryDetail ON MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo INNER JOIN
                      MAS_POL.dbo.CI_Item ON MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode = MAS_POL.dbo.CI_Item.ItemCode INNER JOIN
                      MAS_POL.dbo.AP_Vendor ON MAS_POL.dbo.CI_Item.PrimaryAPDivisionNo = MAS_POL.dbo.AP_Vendor.APDivisionNo AND 
                      MAS_POL.dbo.CI_Item.PrimaryVendorNo = MAS_POL.dbo.AP_Vendor.VendorNo
WHERE MAS_POL.dbo.AR_InvoiceHistoryHeader.WarehouseCode='000' and (AR_InvoiceHistoryHeader.ARDivisionNo = '00' or AR_InvoiceHistoryHeader.ARDivisionNo = '02')


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
         Begin Table = "AR_Customer (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 306
               Right = 301
            End
            DisplayFlags = 280
            TopColumn = 99
         End
         Begin Table = "AR_InvoiceHistoryHeader (MAS_POL.dbo)"
            Begin Extent = 
               Top = 124
               Left = 372
               Bottom = 319
               Right = 655
            End
            DisplayFlags = 280
            TopColumn = 61
         End
         Begin Table = "AR_Salesperson (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 633
               Bottom = 234
               Right = 832
            End
            DisplayFlags = 280
            TopColumn = 19
         End
         Begin Table = "AR_InvoiceHistoryDetail (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 870
               Bottom = 178
               Right = 1084
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CI_Item (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 1126
               Bottom = 114
               Right = 1370
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AP_Vendor (MAS_POL.dbo)"
            Begin Extent = 
               Top = 165
               Left = 1237
               Bottom = 273
               Right = 1463
            End
            DisplayFlags = 280
            TopColumn = 64
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin Par', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'BDN_AR'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'ameterDefaults = ""
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'BDN_AR'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'BDN_AR'
