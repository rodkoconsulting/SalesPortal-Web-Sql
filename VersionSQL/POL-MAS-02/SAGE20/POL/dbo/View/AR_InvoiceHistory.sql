/****** Object:  View [dbo].[AR_InvoiceHistory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_InvoiceHistory]
AS
SELECT        Year(MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate) as InvoiceYear,MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceType, MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate, MAS_POL.dbo.AR_InvoiceHistoryHeader.TransactionDate, MAS_POL.dbo.AR_InvoiceHistoryHeader.ARDivisionNo, 
                         MAS_POL.dbo.AR_InvoiceHistoryHeader.CustomerNo, MAS_POL.dbo.AR_InvoiceHistoryHeader.TermsCode, MAS_POL.dbo.AR_InvoiceHistoryHeader.SalespersonDivisionNo, 
                         MAS_POL.dbo.AR_InvoiceHistoryHeader.SalespersonNo, MAS_POL.dbo.AR_InvoiceHistoryHeader.Comment, MAS_POL.dbo.AR_InvoiceHistoryHeader.BillToName, MAS_POL.dbo.AR_InvoiceHistoryHeader.BillToAddress1, 
                         MAS_POL.dbo.AR_InvoiceHistoryHeader.BillToAddress2, MAS_POL.dbo.AR_InvoiceHistoryHeader.BillToAddress3, MAS_POL.dbo.AR_InvoiceHistoryHeader.BillToCity, MAS_POL.dbo.AR_InvoiceHistoryHeader.BillToState, 
                         MAS_POL.dbo.AR_InvoiceHistoryHeader.BillToZipCode, MAS_POL.dbo.AR_InvoiceHistoryHeader.BillToCountryCode, MAS_POL.dbo.AR_InvoiceHistoryHeader.ShipToCode, MAS_POL.dbo.AR_InvoiceHistoryHeader.ShipToName, 
                         MAS_POL.dbo.AR_InvoiceHistoryHeader.ShipToAddress1, MAS_POL.dbo.AR_InvoiceHistoryHeader.ShipToAddress2, MAS_POL.dbo.AR_InvoiceHistoryHeader.ShipToAddress3, 
                         MAS_POL.dbo.AR_InvoiceHistoryHeader.ShipToCity, MAS_POL.dbo.AR_InvoiceHistoryHeader.ShipToZipCode, MAS_POL.dbo.AR_InvoiceHistoryHeader.ShipToState, MAS_POL.dbo.AR_InvoiceHistoryHeader.ShipToCountryCode, 
                         MAS_POL.dbo.AR_InvoiceHistoryHeader.ShipVia, MAS_POL.dbo.AR_InvoiceHistoryHeader.PaymentType, MAS_POL.dbo.AR_InvoiceHistoryHeader.NonTaxableSalesAmt, MAS_POL.dbo.AR_InvoiceHistoryHeader.ShipDate, 
                         MAS_POL.dbo.AR_InvoiceHistoryHeader.CostOfSalesAmt, MAS_POL.dbo.AR_InvoiceHistoryHeader.AmountSubjectToDiscount, MAS_POL.dbo.AR_InvoiceHistoryHeader.SalesSubjectToComm, 
                         MAS_POL.dbo.AR_InvoiceHistoryHeader.CostSubjectToComm, MAS_POL.dbo.AR_InvoiceHistoryHeader.CommissionRate, MAS_POL.dbo.AR_InvoiceHistoryHeader.UDF_NJ_COOP, 
                         MAS_POL.dbo.AR_InvoiceHistoryHeader.UDF_CORP_NAME, MAS_POL.dbo.AR_InvoiceHistoryHeader.UDF_CUSTOMERNAME, MAS_POL.dbo.AR_InvoiceHistoryHeader.UDF_CORP_NAME_INV, 
                         MAS_POL.dbo.AR_InvoiceHistoryHeader.UDF_CUSTOMERNAME_INV, MAS_POL.dbo.AR_InvoiceHistoryHeader.UDF_GUARANTEED_AM, MAS_POL.dbo.AR_InvoiceHistoryHeader.UDF_IS_BH_INV, 
                         MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode, MAS_POL.dbo.AR_InvoiceHistoryDetail.SalesAcctKey, MAS_POL.dbo.AR_InvoiceHistoryDetail.CostOfGoodsSoldAcctKey, 
                         MAS_POL.dbo.AR_InvoiceHistoryDetail.WarehouseCode, MAS_POL.dbo.AR_InvoiceHistoryDetail.PriceLevel, MAS_POL.dbo.AR_InvoiceHistoryDetail.ProductLine, MAS_POL.dbo.AR_InvoiceHistoryDetail.CommentText, 
                         MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped, MAS_POL.dbo.AR_InvoiceHistoryDetail.UnitPrice, MAS_POL.dbo.AR_InvoiceHistoryDetail.UnitCost, MAS_POL.dbo.AR_InvoiceHistoryDetail.CommissionAmt AS Expr1, 
                         MAS_POL.dbo.AR_InvoiceHistoryDetail.ExtensionAmt
FROM            MAS_POL.dbo.AR_InvoiceHistoryHeader INNER JOIN
                         MAS_POL.dbo.AR_InvoiceHistoryDetail ON MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo AND 
                         MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo

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
         Begin Table = "AR_InvoiceHistoryHeader (MAS_POL.dbo)"
            Begin Extent = 
               Top = 81
               Left = 335
               Bottom = 287
               Right = 578
            End
            DisplayFlags = 280
            TopColumn = 78
         End
         Begin Table = "AR_InvoiceHistoryDetail (MAS_POL.dbo)"
            Begin Extent = 
               Top = 85
               Left = 650
               Bottom = 288
               Right = 890
            End
            DisplayFlags = 280
            TopColumn = 62
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'AR_InvoiceHistory'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'AR_InvoiceHistory'
