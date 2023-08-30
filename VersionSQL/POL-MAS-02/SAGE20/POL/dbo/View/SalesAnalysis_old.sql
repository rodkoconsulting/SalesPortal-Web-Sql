/****** Object:  View [dbo].[SalesAnalysis_old]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[SalesAnalysis_old]
AS
SELECT        TOP (100) PERCENT MAS_POL.dbo.AR_Customer.CustomerName, COUNT(DISTINCT (CASE WHEN Year(INVOICEDATE) = YEAR(GETDATE()) AND Month(INVOICEDATE) 
                         = Month(GETDATE()) THEN MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.ItemCode ELSE NULL END)) AS MTD_SKU, 
                         COUNT(DISTINCT (CASE WHEN Year(INVOICEDATE) = YEAR(GETDATE()) - 1 AND Month(INVOICEDATE) = Month(GETDATE()) 
                         THEN MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.ItemCode ELSE NULL END)) AS LY_MTD_SKU, SUM(CASE WHEN Year(INVOICEDATE) = YEAR(GETDATE()) AND 
                         Month(INVOICEDATE) = Month(GETDATE()) THEN ISNULL(MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.EXTENSIONAMT, 0) ELSE 0 END) AS MTD, 
                         SUM(CASE WHEN Year(INVOICEDATE) = YEAR(GETDATE()) - 1 AND Month(INVOICEDATE) = Month(GETDATE()) 
                         THEN ISNULL(MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.EXTENSIONAMT, 0) ELSE 0 END) AS LY_MTD, SUM(CASE WHEN Year(INVOICEDATE) = YEAR(GETDATE()) 
                         AND Month(INVOICEDATE) <= Month(GETDATE()) THEN ISNULL(MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.EXTENSIONAMT, 0) ELSE 0 END) AS YTD, 
                         SUM(CASE WHEN Year(INVOICEDATE) = YEAR(GETDATE()) - 1 AND Month(INVOICEDATE) <= Month(GETDATE()) 
                         THEN ISNULL(MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.EXTENSIONAMT, 0) ELSE 0 END) AS LY_YTD, MAS_POL.dbo.AR_Customer.SalespersonNo
FROM            MAS_POL.dbo.AR_InvoiceHistoryDetail RIGHT OUTER JOIN
                         MAS_POL.dbo.AR_InvoiceHistoryHeader ON MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo AND 
                         MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo RIGHT OUTER JOIN
                         MAS_POL.dbo.AR_Salesperson INNER JOIN
                         MAS_POL.dbo.AR_Customer ON MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo = MAS_POL.dbo.AR_Customer.SalespersonDivisionNo AND 
                         MAS_POL.dbo.AR_Salesperson.SalespersonNo = MAS_POL.dbo.AR_Customer.SalespersonNo ON 
                         MAS_POL.dbo.AR_InvoiceHistoryHeader.CustomerNo = MAS_POL.dbo.AR_Customer.CustomerNo AND 
                         MAS_POL.dbo.AR_InvoiceHistoryHeader.ARDivisionNo = MAS_POL.dbo.AR_Customer.ARDivisionNo
WHERE        (MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate IS NULL) AND (MAS_POL.dbo.AR_Customer.CustomerType <> 'MISC') AND 
                         (MAS_POL.dbo.AR_Customer.SalespersonNo NOT LIKE 'XX%') AND (MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemType IS NULL OR
                         MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemType = 1) AND (NOT (MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate IS NOT NULL)) OR
                         (NOT (MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate IS NOT NULL)) AND (MAS_POL.dbo.AR_Customer.CustomerType <> 'MISC') AND 
                         (MAS_POL.dbo.AR_Customer.SalespersonNo NOT LIKE 'XX%') AND (MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemType IS NULL OR
                         MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemType = 1) AND (MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate >= DATEFROMPARTS ( DATEPART(yyyy, GETDATE()) - 1, 1, 1 )) OR
                         (MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate IS NULL) AND (MAS_POL.dbo.AR_Customer.CustomerType <> 'MISC') AND 
                         (MAS_POL.dbo.AR_Customer.SalespersonNo NOT LIKE 'XX%') AND (MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemType IS NULL OR
                         MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemType = 1) AND (NOT (MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode IS NULL)) OR
                         (MAS_POL.dbo.AR_Customer.CustomerType <> 'MISC') AND (MAS_POL.dbo.AR_Customer.SalespersonNo NOT LIKE 'XX%') AND 
                         (MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemType IS NULL OR
                         MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemType = 1) AND (MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate >= DATEFROMPARTS ( DATEPART(yyyy, GETDATE()) - 1, 1, 1 )) AND 
                         (NOT (MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode IS NULL))
GROUP BY MAS_POL.dbo.AR_Customer.CustomerName, MAS_POL.dbo.AR_Customer.SalespersonNo

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
         Begin Table = "AR_InvoiceHistoryDetail (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_InvoiceHistoryHeader (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 330
               Bottom = 135
               Right = 613
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_Salesperson (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 651
               Bottom = 135
               Right = 889
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_Customer (MAS_POL.dbo)"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 349
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
      Begin ColumnWidths = 13
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
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SalesAnalysis_old'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SalesAnalysis_old'
