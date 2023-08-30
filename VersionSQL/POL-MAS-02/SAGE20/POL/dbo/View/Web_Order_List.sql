/****** Object:  View [dbo].[Web_Order_List]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Order_List]
AS
SELECT *
 
FROM
 
(
 
  SELECT SALESORDERNO, BILLTONAME, ORDERDATE, EXPDATE, SHIPDATE, ARRIVALDATE, ORDERTYPE, HOLDCODE, BOETA, AVAILABLECOMMENT, QUANTITYORDERED, UNITPRICE, EXTENSIONAMT, ItemDescription, ITEMCODE, UOM, Invoiced, Territory, SALESPERSONNO, LINEKEY, COMMENT, Premise, CoopNo, Affiliations, ShipTo

  FROM dbo.Web_SalesOrders
 
  UNION ALL

  SELECT INVOICENO As SALESORDERNO, BILLTONAME, ORDERDATE, Null as EXPDATE, SHIPDATE, Null as ARRIVALDATE,INVOICETYPE As ORDERTYPE,'' AS HOLDCODE,null AS BOETA,'' as AVAILABLECOMMENT,QUANTITYORDERED,UnitPrice as UNITPRICE,ExtensionAmt as EXTENSIONAMT,ItemDescription,ItemCode as ITEMCODE,UOM,'x' as 'Invoiced',Territory,SALESPERSONNO,LineKey AS LINEKEY,Comment as 'COMMENT',Premise,CoopNo,Affiliations, ShipTo

  FROM dbo.Web_Order_List_Batch
 
) tmp


EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[48] 4[8] 2[39] 3) )"
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
               Top = 146
               Left = 29
               Bottom = 275
               Right = 311
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SO_SalesOrderDetail (MAS_POL.dbo)"
            Begin Extent = 
               Top = 11
               Left = 657
               Bottom = 140
               Right = 918
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_Customer (MAS_POL.dbo)"
            Begin Extent = 
               Top = 34
               Left = 1094
               Bottom = 163
               Right = 1389
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_Salesperson (MAS_POL.dbo)"
            Begin Extent = 
               Top = 388
               Left = 1061
               Bottom = 517
               Right = 1283
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CI_Item (MAS_POL.dbo)"
            Begin Extent = 
               Top = 581
               Left = 828
               Bottom = 710
               Right = 1089
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SO_InvoiceHeader (MAS_POL.dbo)"
            Begin Extent = 
               Top = 427
               Left = 487
               Bottom = 556
               Right = 760
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PO_Inventory_ETA"
            Begin Extent = 
             ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Web_Order_List'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'  Top = 419
               Left = 57
               Bottom = 514
               Right = 227
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Web_Order_List'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Web_Order_List'
