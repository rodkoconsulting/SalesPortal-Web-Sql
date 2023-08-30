/****** Object:  View [dbo].[PortalItemsInactive]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalItemsInactive]
AS
WITH ITEMHISTORY AS
(
SELECT     
	DISTINCT MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode
FROM         MAS_POL.dbo.AR_Customer INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryHeader ON MAS_POL.dbo.AR_Customer.ARDivisionNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.ARDivisionNo AND 
                      MAS_POL.dbo.AR_Customer.CustomerNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.CustomerNo INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryDetail ON MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo
WHERE     (MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate > DATEADD(year, - 1, GETDATE())) AND (MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemType = '1') AND 
                      (MAS_POL.dbo.AR_Customer.SalespersonNo NOT LIKE 'XX%')
GROUP BY MAS_POL.dbo.AR_Customer.ARDivisionNo, MAS_POL.dbo.AR_Customer.CustomerNo, MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate, MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode, 
                      MAS_POL.dbo.AR_InvoiceHistoryDetail.UnitPrice, MAS_POL.dbo.AR_Customer.SalespersonNo
HAVING      (SUM(MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped) > 0)
UNION
SELECT DISTINCT MAS_POL.dbo.SO_SalesOrderDetail.ItemCode
FROM MAS_POL.dbo.SO_SalesOrderHeader INNER JOIN MAS_POL.dbo.SO_SalesOrderDetail on MAS_POL.dbo.SO_SalesOrderHeader.SalesOrderNo = MAS_POL.dbo.SO_SalesOrderDetail.SalesOrderNo
)
SELECT DISTINCT ITEMHISTORY.ItemCode FROM ITEMHISTORY INNER JOIN
                      [POL].dbo.CI_Item ON ITEMHISTORY.ITEMCODE = [POL].dbo.CI_Item.ItemCode INNER JOIN
                      [POL].dbo.IM_ItemWarehouse ON ITEMHISTORY.ItemCode = [POL].dbo.IM_ItemWarehouse.ItemCode
 WHERE [POL].dbo.IM_ItemWarehouse.WarehouseCode= '000' AND ([POL].dbo.CI_ITEM.CATEGORY1 = 'N' OR
                      (POL.dbo.IM_ItemWarehouse.QuantityOnHand + POL.dbo.IM_ItemWarehouse.QuantityOnPurchaseOrder + POL.dbo.IM_ItemWarehouse.QuantityOnSalesOrder + POL.dbo.IM_ItemWarehouse.QuantityOnBackOrder
                       <= 0.04))

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
         Begin Table = "ITEMHISTORY_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 84
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CI_Item"
            Begin Extent = 
               Top = 6
               Left = 227
               Bottom = 114
               Right = 471
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IM_ItemWarehouse"
            Begin Extent = 
               Top = 6
               Left = 509
               Bottom = 114
               Right = 717
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PortalItemsInactive'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PortalItemsInactive'
