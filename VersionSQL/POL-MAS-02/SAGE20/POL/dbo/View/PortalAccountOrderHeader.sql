/****** Object:  View [dbo].[PortalAccountOrderHeader]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalAccountOrderHeader]
AS
SELECT     MAS_POL.dbo.AR_Customer.SalespersonNo, MAS_POL.dbo.SO_SalesOrderHeader.SalesOrderNo, MAS_POL.dbo.SO_SalesOrderHeader.OrderDate, 
                      CASE WHEN MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'MO' OR
                      MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'IN' THEN MAS_POL.dbo.SO_SALESORDERHEADER.SHIPEXPIREDATE ELSE NULL 
                      END AS EXPDATE, CASE WHEN MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'MO' OR
                      MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'BO' OR
                      MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'IN' THEN NULL 
                      ELSE MAS_POL.dbo.SO_SALESORDERHEADER.SHIPEXPIREDATE END AS SHIPDATE, 
                      CASE WHEN MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'MO' OR
                      MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'BH' THEN 'MO' WHEN MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'BO' OR
                      MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'IN' THEN 'BO' ELSE 'S' END AS ORDERTYPE, 
                      CASE WHEN (MAS_POL.dbo.SO_SALESORDERHEADER.ORDERTYPE = 'S' AND MAS_POL.dbo.SO_SALESORDERHEADER.ORDERSTATUS = 'H') OR
                      MAS_POL.dbo.SO_SALESORDERHEADER.ORDERTYPE = 'B' THEN MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE ELSE '' END AS HOLDCODE, 
                      CASE WHEN MAS_POL.dbo.SO_INVOICEHEADER.SALESORDERNO IS NULL THEN '' ELSE 'x' END AS Invoiced, 
                      MAS_POL.dbo.AR_Salesperson.UDF_TERRITORY AS Territory, MAS_POL.dbo.SO_SalesOrderHeader.Comment, 
                      CASE WHEN IsNumeric(MAS_POL.dbo.SO_SALESORDERHEADER.UDF_NJ_COOP) = 1 AND CHARINDEX('.', MAS_POL.dbo.SO_SALESORDERHEADER.UDF_NJ_COOP) 
                      = 0 THEN CAST(MAS_POL.dbo.SO_SALESORDERHEADER.UDF_NJ_COOP AS INT) ELSE NULL END AS 'CoopNo', 
                      CASE WHEN RIGHT(MAS_POL.dbo.AR_CUSTOMER.CUSTOMERTYPE, 1) = 'N' THEN 'On' WHEN RIGHT(MAS_POL.dbo.AR_CUSTOMER.CUSTOMERTYPE, 1) 
                      = 'F' THEN 'Off' ELSE '' END AS 'Premise'
FROM         MAS_POL.dbo.SO_SalesOrderHeader INNER JOIN
                      MAS_POL.dbo.SO_SalesOrderDetail ON MAS_POL.dbo.SO_SalesOrderHeader.SalesOrderNo = MAS_POL.dbo.SO_SalesOrderDetail.SalesOrderNo INNER JOIN
                      MAS_POL.dbo.AR_Customer ON MAS_POL.dbo.SO_SalesOrderHeader.ARDivisionNo = MAS_POL.dbo.AR_Customer.ARDivisionNo AND 
                      MAS_POL.dbo.SO_SalesOrderHeader.CustomerNo = MAS_POL.dbo.AR_Customer.CustomerNo INNER JOIN
                      MAS_POL.dbo.AR_Salesperson ON MAS_POL.dbo.SO_SalesOrderHeader.SalespersonDivisionNo = MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo AND 
                      MAS_POL.dbo.SO_SalesOrderHeader.SalespersonNo = MAS_POL.dbo.AR_Salesperson.SalespersonNo INNER JOIN
                      MAS_POL.dbo.CI_Item ON MAS_POL.dbo.SO_SalesOrderDetail.ItemCode = MAS_POL.dbo.CI_Item.ItemCode LEFT OUTER JOIN
                      MAS_POL.dbo.SO_InvoiceHeader ON MAS_POL.dbo.SO_SalesOrderHeader.SalesOrderNo = MAS_POL.dbo.SO_InvoiceHeader.SalesOrderNo LEFT OUTER JOIN
                      dbo.PO_Inventory_ETA ON MAS_POL.dbo.SO_SalesOrderDetail.ItemCode = dbo.PO_Inventory_ETA.ItemCode
WHERE     (MAS_POL.dbo.SO_SalesOrderDetail.ItemType = 1) AND (MAS_POL.dbo.SO_SalesOrderDetail.QuantityOrdered > 0) OR
                      (MAS_POL.dbo.SO_SalesOrderDetail.ItemType = 3) AND (MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo = '00')

EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[16] 2[25] 3) )"
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
         Begin Table = "SO_SalesOrderHeader (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 177
               Right = 293
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SO_SalesOrderDetail (MAS_POL.dbo)"
            Begin Extent = 
               Top = 176
               Left = 488
               Bottom = 284
               Right = 732
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_Customer (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 613
               Bottom = 114
               Right = 886
            End
            DisplayFlags = 280
            TopColumn = 23
         End
         Begin Table = "AR_Salesperson (MAS_POL.dbo)"
            Begin Extent = 
               Top = 165
               Left = 1129
               Bottom = 319
               Right = 1328
            End
            DisplayFlags = 280
            TopColumn = 27
         End
         Begin Table = "CI_Item (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 1161
               Bottom = 114
               Right = 1405
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SO_InvoiceHeader (MAS_POL.dbo)"
            Begin Extent = 
               Top = 202
               Left = 34
               Bottom = 310
               Right = 286
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PO_Inventory_ETA"
            Begin Extent = 
               T', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PortalAccountOrderHeader'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'op = 180
               Left = 845
               Bottom = 317
               Right = 990
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
      Begin ColumnWidths = 13
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PortalAccountOrderHeader'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PortalAccountOrderHeader'
