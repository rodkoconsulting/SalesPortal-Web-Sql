/****** Object:  View [dbo].[PortalInventoryAvailable]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalInventoryAvailable]
AS
SELECT     dbo.CI_Item.ItemCode, CONVERT(Numeric(10, 5), ISNULL(dbo.IM_ItemWarehouse_000.QuantityOnHand, 0) - ISNULL(dbo.SO_InventoryHeld.QuantityHeld, 0) - ISNULL(dbo.SO_InventoryHeld.QuantityHeldBh, 0) 
                      - ISNULL(dbo.PO_InventoryHeld.POQuantityHeld, 0) - ISNULL(dbo.RG_InventoryHeld.RGQuantityHeld, 0) - ISNULL(dbo.MO_InventoryHeld.QuantityHeld, 0)) AS InventoryAvailable, 
                      ISNULL(dbo.IM_ItemWarehouse_000.QuantityOnPurchaseOrder, 0) - CONVERT(Numeric(10, 5), ISNULL(dbo.BO_InventoryHeld.QuantityHeld, 0)) AS BoAvailable, 
                      ISNULL(CAST(CASE WHEN ISNUMERIC(REPLACE(dbo.CI_Item.SalesUNITOFMEASURE, 'C', '')) = 1 THEN REPLACE(dbo.CI_Item.SalesUNITOFMEASURE, 'C', '') 
                      ELSE '1' END AS INT), 12) AS UOM,
            dbo.CI_Item.UDF_RESTRICT_OFFSALE as OffSale,
			IsNull(dbo.CI_Item.UDF_RESTRICT_OFFSALE_NOTES,'') as OffSaleNotes,
			dbo.CI_Item.UDF_RESTRICT_NORETAIL as OnPremise,
			dbo.CI_Item.UDF_RESTRICT_ALLOCATED as Allocated,
			dbo.CI_Item.UDF_RESTRICT_MANAGER as Approval,
			dbo.CI_Item.UDF_RESTRICT_MAX as MaxCases,
			dbo.CI_Item.UDF_RESTRICT_STATE as StateRestrict,
			CASE WHEN dbo.CI_Item.UDF_RESTRICT_BO is NULL then 'N' else dbo.CI_Item.UDF_RESTRICT_BO END as NoBo,
			dbo.CI_Item.UDF_RESTRICT_MO as NoMo,
			dbo.CI_Item.UDF_RESTRICT_SAMPLES as NoSamples,
			dbo.CI_ITEM.InactiveItem AS Inactive
FROM         dbo.PO_InventoryHeld RIGHT OUTER JOIN
                      dbo.BO_InventoryHeld RIGHT OUTER JOIN
                      dbo.IM_ItemWarehouse_000 ON dbo.BO_InventoryHeld.ITEMCODE = dbo.IM_ItemWarehouse_000.ItemCode RIGHT OUTER JOIN
                      dbo.CI_Item ON dbo.IM_ItemWarehouse_000.ItemCode = dbo.CI_Item.ItemCode ON 
                      dbo.PO_InventoryHeld.ItemCode = dbo.IM_ItemWarehouse_000.ItemCode LEFT OUTER JOIN
                      dbo.RG_InventoryHeld ON dbo.IM_ItemWarehouse_000.ItemCode = dbo.RG_InventoryHeld.ItemCode LEFT OUTER JOIN
                      dbo.SO_InventoryHeld ON dbo.IM_ItemWarehouse_000.ItemCode = dbo.SO_InventoryHeld.ITEMCODE LEFT OUTER JOIN
                      dbo.MO_InventoryHeld ON dbo.IM_ItemWarehouse_000.ItemCode = dbo.MO_InventoryHeld.ITEMCODE
WHERE     (dbo.CI_Item.ItemType = '1')








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
         Begin Table = "PO_InventoryHeld"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 84
               Right = 195
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BO_InventoryHeld"
            Begin Extent = 
               Top = 17
               Left = 259
               Bottom = 218
               Right = 426
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IM_ItemWarehouse_000"
            Begin Extent = 
               Top = 70
               Left = 1121
               Bottom = 270
               Right = 1331
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RG_InventoryHeld"
            Begin Extent = 
               Top = 195
               Left = 746
               Bottom = 273
               Right = 903
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SO_InventoryHeld"
            Begin Extent = 
               Top = 131
               Left = 964
               Bottom = 209
               Right = 1115
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CI_Item"
            Begin Extent = 
               Top = 6
               Left = 464
               Bottom = 114
               Right = 708
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
 ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PortalInventoryAvailable'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'        Width = 1500
         Width = 2280
         Width = 2655
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PortalInventoryAvailable'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PortalInventoryAvailable'
