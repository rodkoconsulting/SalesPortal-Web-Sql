/****** Object:  View [dbo].[SalesPortal_Pivot]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[SalesPortal_Pivot]
AS

SELECT     MAS_POL.dbo.IM_ProductLine.ProductLineDesc AS 'ProductLine', MAS_POL.dbo.CI_Item.UDF_MASTER_VENDOR AS 'MasterVendor', 
                      MAS_POL.dbo.AP_Vendor.VendorName AS 'Vendor', MAS_POL.dbo.CI_Item.UDF_BRAND AS 'Brand', MAS_POL.dbo.CI_Item.UDF_COUNTRY AS 'Country', 
                      MAS_POL.dbo.AR_Customer.CustomerName AS 'Customer', MAS_POL.dbo.AR_Customer.UDF_AFFILIATIONS AS 'Affiliations', 
                      MAS_POL.dbo.AR_Customer.SortField AS 'Premise', MAS_POL.dbo.AR_Customer.SalespersonNo AS 'Rep', 
                      MAS_POL.dbo.AR_Salesperson.UDF_TERRITORY AS 'Territory', MAS_POL.dbo.AR_UDT_SHIPPING.UDF_TERRITORY AS 'CustRegion', 
                      MAS_POL.dbo.SO_ShipToAddress.UDF_COUNTY AS 'County', 
                      MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES + ' ' + MAS_POL.dbo.CI_Item.UDF_DESCRIPTION + ' (' + REPLACE(MAS_POL.dbo.CI_Item.SalesUnitOfMeasure, 'C', '') 
                      + '/' + REPLACE(CASE WHEN CHARINDEX('ML', MAS_POL.dbo.CI_Item.UDF_BOTTLE_SIZE) 
                      > 0 THEN RTRIM(LTRIM(REPLACE(MAS_POL.dbo.CI_Item.UDF_BOTTLE_SIZE, 'ML', ''))) ELSE REPLACE(MAS_POL.dbo.CI_Item.UDF_BOTTLE_SIZE, ' ', '') END + ')', ' ', 
                      '') AS 'Description', ISNULL(SUM(CASE WHEN YEAR(MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate) = YEAR(GETDATE()) - 1 AND 
                      MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate <= DATEADD(YEAR, - 1, GETDATE()) 
                      THEN MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped ELSE 0 END), 0) AS 'PriorYrCase', 
                      ISNULL(SUM(CASE WHEN YEAR(MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate) = YEAR(GETDATE()) AND 
                      MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate <= GETDATE() THEN MAS_POL.dbo.AR_InvoiceHistoryDetail.QuantityShipped ELSE 0 END), 0) 
                      AS 'CurrentYrCase', ISNULL(SUM(CASE WHEN YEAR(MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate) = YEAR(GETDATE()) - 1 AND 
                      MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate <= DATEADD(YEAR, - 1, GETDATE()) 
                      THEN MAS_POL.dbo.AR_InvoiceHistoryDetail.ExtensionAmt ELSE 0 END), 0) AS 'PriorYrDollar', 
                      ISNULL(SUM(CASE WHEN YEAR(MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate) = YEAR(GETDATE()) AND 
                      MAS_POL.dbo.AR_INVOICEHISTORYHEADER.InvoiceDate <= GETDATE() THEN MAS_POL.dbo.AR_InvoiceHistoryDetail.ExtensionAmt ELSE 0 END), 0) 
                      AS 'CurrentYrDollar'
FROM         MAS_POL.dbo.AR_Salesperson RIGHT OUTER JOIN
                      MAS_POL.dbo.SO_ShipToAddress LEFT OUTER JOIN
                      MAS_POL.dbo.AR_UDT_SHIPPING ON 
                      MAS_POL.dbo.SO_ShipToAddress.UDF_REGION_CODE = MAS_POL.dbo.AR_UDT_SHIPPING.UDF_REGION_CODE RIGHT OUTER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryDetail RIGHT OUTER JOIN
                      MAS_POL.dbo.AR_Customer LEFT OUTER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryHeader ON MAS_POL.dbo.AR_Customer.CustomerNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.CustomerNo AND 
                      MAS_POL.dbo.AR_Customer.ARDivisionNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.ARDivisionNo ON 
                      MAS_POL.dbo.AR_InvoiceHistoryDetail.InvoiceNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo AND 
                      MAS_POL.dbo.AR_InvoiceHistoryDetail.HeaderSeqNo = MAS_POL.dbo.AR_InvoiceHistoryHeader.HeaderSeqNo LEFT OUTER JOIN
                      MAS_POL.dbo.CI_Item ON MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemCode = MAS_POL.dbo.CI_Item.ItemCode LEFT OUTER JOIN
                      MAS_POL.dbo.IM_ProductLine ON MAS_POL.dbo.CI_Item.ProductLine = MAS_POL.dbo.IM_ProductLine.ProductLine LEFT OUTER JOIN
                      MAS_POL.dbo.AP_Vendor ON MAS_POL.dbo.CI_Item.PrimaryAPDivisionNo = MAS_POL.dbo.AP_Vendor.APDivisionNo AND 
                      MAS_POL.dbo.CI_Item.PrimaryVendorNo = MAS_POL.dbo.AP_Vendor.VendorNo ON 
                      MAS_POL.dbo.SO_ShipToAddress.ARDivisionNo = MAS_POL.dbo.AR_Customer.ARDivisionNo AND 
                      MAS_POL.dbo.SO_ShipToAddress.CustomerNo = MAS_POL.dbo.AR_Customer.CustomerNo AND 
                      MAS_POL.dbo.SO_ShipToAddress.ShipToCode = MAS_POL.dbo.AR_Customer.PrimaryShipToCode ON 
                      MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo = MAS_POL.dbo.AR_Customer.SalespersonDivisionNo AND 
                      MAS_POL.dbo.AR_Salesperson.SalespersonNo = MAS_POL.dbo.AR_Customer.SalespersonNo
WHERE     (MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceNo IS NULL) AND (MAS_POL.dbo.AR_Customer.SortField LIKE 'NY%' OR
                      MAS_POL.dbo.AR_Customer.SortField LIKE 'NJ%') OR
                      (MAS_POL.dbo.AR_Customer.SortField LIKE 'NY%' OR
                      MAS_POL.dbo.AR_Customer.SortField LIKE 'NJ%') AND (MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate <= GETDATE()) AND 
					  MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate >= DATEFROMPARTS ( DATEPART(yyyy, GETDATE()), 1, 1 ) AND
					  MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate < DATEFROMPARTS ( DATEPART(yyyy, GETDATE()) + 1, 1, 1 ) AND
                      (MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemType = '1') AND 
                      (MAS_POL.dbo.AR_InvoiceHistoryDetail.WarehouseCode = '000') AND (MAS_POL.dbo.AR_InvoiceHistoryHeader.ARDivisionNo = '00') AND 
                      (MAS_POL.dbo.AR_InvoiceHistoryHeader.ModuleCode = 'S/O') OR
                      (MAS_POL.dbo.AR_Customer.SortField LIKE 'NY%' OR
                      MAS_POL.dbo.AR_Customer.SortField LIKE 'NJ%') AND (MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate <= DATEADD(YEAR, - 1, GETDATE())) AND 
                      MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate >= DATEFROMPARTS ( DATEPART(yyyy, GETDATE()), 1, 1 ) AND
					  MAS_POL.dbo.AR_InvoiceHistoryHeader.InvoiceDate < DATEFROMPARTS ( DATEPART(yyyy, GETDATE()) + 1, 1, 1 ) AND 
                      (MAS_POL.dbo.AR_InvoiceHistoryDetail.ItemType = '1') AND (MAS_POL.dbo.AR_InvoiceHistoryDetail.WarehouseCode = '000') AND 
                      (MAS_POL.dbo.AR_InvoiceHistoryHeader.ARDivisionNo = '00') AND (MAS_POL.dbo.AR_InvoiceHistoryHeader.ModuleCode = 'S/O')
GROUP BY MAS_POL.dbo.IM_ProductLine.ProductLineDesc, MAS_POL.dbo.CI_Item.UDF_MASTER_VENDOR, MAS_POL.dbo.CI_Item.UDF_BRAND, 
                      MAS_POL.dbo.AP_Vendor.VendorName, MAS_POL.dbo.CI_Item.UDF_COUNTRY, MAS_POL.dbo.AR_Customer.CustomerName, 
                      MAS_POL.dbo.AR_Customer.UDF_AFFILIATIONS, MAS_POL.dbo.AR_Customer.SortField, MAS_POL.dbo.AR_Customer.SalespersonNo, 
                      MAS_POL.dbo.AR_Salesperson.UDF_TERRITORY, MAS_POL.dbo.AR_UDT_SHIPPING.UDF_TERRITORY, MAS_POL.dbo.SO_ShipToAddress.UDF_COUNTY, 
                      MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES, MAS_POL.dbo.CI_Item.UDF_DESCRIPTION, MAS_POL.dbo.CI_Item.SalesUnitOfMeasure, 
                      MAS_POL.dbo.CI_Item.UDF_BOTTLE_SIZE




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
               Top = 6
               Left = 38
               Bottom = 114
               Right = 253
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SO_ShipToAddress (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 291
               Bottom = 114
               Right = 499
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_UDT_SHIPPING (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 537
               Bottom = 114
               Right = 745
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_InvoiceHistoryDetail (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 783
               Bottom = 114
               Right = 1017
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_Customer (MAS_POL.dbo)"
            Begin Extent = 
               Top = 6
               Left = 1055
               Bottom = 114
               Right = 1344
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_INVOICEHISTORYHEADER_3YR"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 213
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CI_Item (MAS_POL.dbo)"
            Begin Extent = 
            ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SalesPortal_Pivot'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'   Top = 114
               Left = 251
               Bottom = 222
               Right = 511
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CI_UDT_BRANDS_GOALS (MAS_POL.dbo)"
            Begin Extent = 
               Top = 114
               Left = 549
               Bottom = 222
               Right = 739
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IM_ProductLine (MAS_POL.dbo)"
            Begin Extent = 
               Top = 114
               Left = 777
               Bottom = 222
               Right = 1025
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AP_Vendor (MAS_POL.dbo)"
            Begin Extent = 
               Top = 114
               Left = 1063
               Bottom = 222
               Right = 1305
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SalesPortal_Pivot'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SalesPortal_Pivot'
