﻿/****** Object:  View [dbo].[AR_CashReceipts]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_CashReceipts]
AS
SELECT     MAS_POL.dbo.AR_CashReceiptsHeader.DepositNo, MAS_POL.dbo.AR_CashReceiptsHeader.ARDivisionNo, MAS_POL.dbo.AR_CashReceiptsHeader.CustomerNo, 
                      MAS_POL.dbo.AR_Customer.UDF_CORP_NAME as 'CustomerName', MAS_POL.dbo.AR_CashReceiptsHeader.CheckNo, MAS_POL.dbo.AR_CashReceiptsHeader.BatchNo, 
                      MAS_POL.dbo.AR_Customer.UDF_BANKACCOUNTNO AS 'BankAccountNo', MAS_POL.dbo.AR_Customer.UDF_ROUTINGNO AS 'RoutingNo', 
                      SUM(MAS_POL.dbo.AR_CashReceiptsDetail.AmountPosted) AS 'AmountPosted'

FROM         MAS_POL.dbo.AR_CashReceiptsDetail INNER JOIN
                      MAS_POL.dbo.AR_CashReceiptsHeader ON MAS_POL.dbo.AR_CashReceiptsDetail.DepositNo = MAS_POL.dbo.AR_CashReceiptsHeader.DepositNo AND 
                      MAS_POL.dbo.AR_CashReceiptsDetail.ARDivisionNo = MAS_POL.dbo.AR_CashReceiptsHeader.ARDivisionNo AND 
                      MAS_POL.dbo.AR_CashReceiptsDetail.CustomerNo = MAS_POL.dbo.AR_CashReceiptsHeader.CustomerNo AND 
                      MAS_POL.dbo.AR_CashReceiptsDetail.CheckNo = MAS_POL.dbo.AR_CashReceiptsHeader.CheckNo INNER JOIN
                      MAS_POL.dbo.AR_CashReceiptsDeposit ON MAS_POL.dbo.AR_CashReceiptsHeader.DepositNo = MAS_POL.dbo.AR_CashReceiptsDeposit.DepositNo INNER JOIN
                      MAS_POL.dbo.AR_Customer ON MAS_POL.dbo.AR_CashReceiptsHeader.ARDivisionNo = MAS_POL.dbo.AR_Customer.ARDivisionNo AND 
                      MAS_POL.dbo.AR_CashReceiptsHeader.CustomerNo = MAS_POL.dbo.AR_Customer.CustomerNo
GROUP BY MAS_POL.dbo.AR_CashReceiptsHeader.DepositNo, MAS_POL.dbo.AR_CashReceiptsHeader.ARDivisionNo, MAS_POL.dbo.AR_CashReceiptsHeader.CustomerNo, 
                      MAS_POL.dbo.AR_Customer.UDF_CORP_NAME, MAS_POL.dbo.AR_CashReceiptsHeader.CheckNo, MAS_POL.dbo.AR_CashReceiptsHeader.BatchNo, 
                      MAS_POL.dbo.AR_Customer.UDF_BANKACCOUNTNO, MAS_POL.dbo.AR_Customer.UDF_ROUTINGNO


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
         Begin Table = "AR_CashReceiptsDetail (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 252
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "AR_CashReceiptsHeader (MAS_POL.dbo)"
            Begin Extent = 
               Top = 0
               Left = 370
               Bottom = 225
               Right = 612
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_CashReceiptsDeposit (MAS_POL.dbo)"
            Begin Extent = 
               Top = 46
               Left = 825
               Bottom = 311
               Right = 1021
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_Customer (MAS_POL.dbo)"
            Begin Extent = 
               Top = 64
               Left = 1029
               Bottom = 279
               Right = 1302
            End
            DisplayFlags = 280
            TopColumn = 135
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2310
         Width = 1500
         Width = 2085
         Width = 1500
         Width = 2610
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
         NewValue = 1170', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'AR_CashReceipts'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'AR_CashReceipts'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'AR_CashReceipts'
