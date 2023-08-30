﻿/****** Object:  View [dbo].[PortalItemHistory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalItemHistory]
AS
WITH LASTORDERED AS
(
SELECT     ROW_NUMBER() OVER (PARTITION BY MAS_POL.dbo.AR_Customer.ARDivisionNo, MAS_POL.dbo.AR_Customer.CustomerNo, MAS_POL.dbo.AR_Customer.SalespersonNo,
	MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode ORDER BY MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate desc) AS 'RN',
	MAS_POL.dbo.AR_Customer.ARDivisionNo, MAS_POL.dbo.AR_Customer.CustomerNo, MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate as TransactionDate, MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode, 
                      SUM(MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped) AS QuantityShipped, MAS_POL.dbo.AR_InvoiceHistoryDetail.UnitPrice, MAS_POL.dbo.AR_Customer.SalespersonNo
FROM         MAS_POL.dbo.AR_Customer INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryHeader ON MAS_POL.dbo.AR_Customer.ARDivisionNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.ARDivisionNo AND 
                      MAS_POL.dbo.AR_Customer.CustomerNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.CustomerNo INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryDetail ON MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo
WHERE     (MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate > DATEADD(year, - 1, GETDATE())) AND (MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemType = '1') AND 
                      (MAS_POL.dbo.AR_Customer.SalespersonNo NOT LIKE '%XX%') AND MAS_POL.dbo.AR_InvoiceHistoryDetail.UnitPrice > 0
GROUP BY MAS_POL.dbo.AR_Customer.ARDivisionNo, MAS_POL.dbo.AR_Customer.CustomerNo, MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate, MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode, 
                      MAS_POL.dbo.AR_InvoiceHistoryDetail.UnitPrice, MAS_POL.dbo.AR_Customer.SalespersonNo
HAVING      (SUM(MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped) > 0)
)
SELECT ARDivisionNo, CustomerNo, TransactionDate, ItemCode, QuantityShipped, UnitPrice, SalespersonNo FROM LASTORDERED
WHERE RN=1


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
         Begin Table = "AR_Customer"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 277
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_InvoiceHistoryHeader"
            Begin Extent = 
               Top = 6
               Left = 315
               Bottom = 114
               Right = 518
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_InvoiceHistoryDetail"
            Begin Extent = 
               Top = 6
               Left = 556
               Bottom = 114
               Right = 732
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
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PortalItemHistory'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PortalItemHistory'
