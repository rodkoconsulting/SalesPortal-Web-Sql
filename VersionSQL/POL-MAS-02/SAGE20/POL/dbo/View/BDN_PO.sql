/****** Object:  View [dbo].[BDN_PO]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[BDN_PO]
AS
SELECT     MAS_POL.dbo.AP_Vendor.APDivisionNo, MAS_POL.dbo.AP_Vendor.VendorNo, MAS_POL.dbo.AP_Vendor.UDF_MASTER_VENDOR, 
                      MAS_POL.dbo.AR_Salesperson.SalespersonNo, MAS_POL.dbo.AR_Salesperson.SalespersonName, MAS_POL.dbo.AR_Salesperson.UDF_TERRITORY, 
                      MAS_POL.dbo.CI_Item.ItemCode, MAS_POL.dbo.PO_PurchaseOrderDetail.QuantityInvoiced, MAS_POL.dbo.PO_PurchaseOrderHeader.RequiredExpireDate
FROM         MAS_POL.dbo.PO_PurchaseOrderDetail INNER JOIN
                      MAS_POL.dbo.AP_Vendor INNER JOIN
                      MAS_POL.dbo.CI_Item ON MAS_POL.dbo.AP_Vendor.APDivisionNo = MAS_POL.dbo.CI_Item.PrimaryAPDivisionNo AND 
                      MAS_POL.dbo.AP_Vendor.VendorNo = MAS_POL.dbo.CI_Item.PrimaryVendorNo ON 
                      MAS_POL.dbo.PO_PurchaseOrderDetail.ItemCode = MAS_POL.dbo.CI_Item.ItemCode INNER JOIN
                      MAS_POL.dbo.PO_PurchaseOrderHeader ON 
                      MAS_POL.dbo.PO_PurchaseOrderDetail.PurchaseOrderNo = MAS_POL.dbo.PO_PurchaseOrderHeader.PurchaseOrderNo INNER JOIN
                      MAS_POL.dbo.PO_ShipToAddress ON MAS_POL.dbo.PO_PurchaseOrderHeader.ShipToCode = MAS_POL.dbo.PO_ShipToAddress.ShipToCode INNER JOIN
                      MAS_POL.dbo.AR_Salesperson ON MAS_POL.dbo.PO_ShipToAddress.UDF_REP_CODE = MAS_POL.dbo.AR_Salesperson.SalespersonNo

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
         Begin Table = "AR_Salesperson (MAS_POL.dbo)"
            Begin Extent = 
               Top = 38
               Left = 95
               Bottom = 266
               Right = 303
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
               Top = 211
               Left = 1264
               Bottom = 319
               Right = 1490
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PO_PurchaseOrderDetail (MAS_POL.dbo)"
            Begin Extent = 
               Top = 18
               Left = 865
               Bottom = 186
               Right = 1106
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PO_PurchaseOrderHeader (MAS_POL.dbo)"
            Begin Extent = 
               Top = 13
               Left = 603
               Bottom = 257
               Right = 821
            End
            DisplayFlags = 280
            TopColumn = 12
         End
         Begin Table = "PO_ShipToAddress (MAS_POL.dbo)"
            Begin Extent = 
               Top = 22
               Left = 378
               Bottom = 263
               Right = 554
            End
            DisplayFlags = 280
            TopColumn = 10
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'BDN_PO'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'ParameterDefaults = ""
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'BDN_PO'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'BDN_PO'
