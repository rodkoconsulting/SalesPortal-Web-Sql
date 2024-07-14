/****** Object:  View [dbo].[PivotSales]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PivotSales]
AS
SELECT    
			IsNull(pl.ProductLineDesc,'') as ProductLine
			, IsNull(i.UDF_MASTER_VENDOR, '') as MasterVendor
			, IsNull(v.VendorName, '') as Vendor
			, IsNull(i.UDF_BRAND, '') as Brand
			, IsNull(i.UDF_COUNTRY, '') as Country
			, IsNull(i.UDF_REGION, '') as Region
			, IsNull(i.UDF_SUBREGION_T, '') as Appellation
			, MAX(CASE WHEN IsNull(i.UDF_SAMPLE_FOCUS,'') = 'Y' THEN 'Y' ELSE '' END) as Focus
			, c.CustomerNo
			, c.CustomerName as Customer
			, c.UDF_AFFILIATIONS as Affiliations
			, c.SortField as Premise
			, sp.SalespersonNo as Rep
			, sp.UDF_TERRITORY as RepTerritory
			, s.UDF_TERRITORY AS CustTerritory
			, sh.UDF_COUNTY as County
			, c.UDF_PREMISIS_CITY as City
			, c.UDF_PREMISIS_STATE as State
			, c.UDF_PREMISIS_ZIP as Zip
			, IsNull(i.UDF_BRAND_NAMES +' '+ i.UDF_DESCRIPTION +' ('+ REPLACE(i.SalesUnitOfMeasure,'C','')+'/'+ (CASE WHEN CHARINDEX('ML',i.UDF_BOTTLE_SIZE)>0 THEN REPLACE(i.UDF_BOTTLE_SIZE,' ML','') ELSE REPLACE(i.UDF_BOTTLE_SIZE,' ','') END)+')', '') as 'Desc'
			, SUM(CASE WHEN h.TransactionDate between '1/1/2023' and '12/31/2023' THEN d.QuantityShipped ELSE 0 END) as PriorYrCase
			, SUM(CASE WHEN h.TransactionDate between '1/1/2024' and '12/31/2024' THEN d.QuantityShipped ELSE 0 END) as CurrentYrCase
			, SUM(CASE WHEN h.TransactionDate between '1/1/2023' and '12/31/2023' THEN d.ExtensionAmt ELSE 0 END) as PriorYrDol
			, SUM(CASE WHEN h.TransactionDate between '1/1/2024' and '12/31/2024' THEN d.ExtensionAmt ELSE 0 END) as CurrentYrDol
		FROM            MAS_POL.dbo.AP_Vendor v RIGHT OUTER JOIN MAS_POL.dbo.CI_Item i LEFT OUTER JOIN
                         MAS_POL.dbo.IM_ProductLine pl ON i.ProductLine = pl.ProductLine ON v.APDivisionNo = i.PrimaryAPDivisionNo AND v.VendorNo = i.PrimaryVendorNo RIGHT OUTER JOIN
                         MAS_POL.dbo.AR_InvoiceHistoryDetail d RIGHT OUTER JOIN
                         MAS_POL.dbo.AR_InvoiceHistoryHeader h ON d.InvoiceNo = h.InvoiceNo AND d.HeaderSeqNo = h.HeaderSeqNo ON i.ItemCode = d.ItemCode RIGHT OUTER JOIN
                         MAS_POL.dbo.AR_Customer c LEFT OUTER JOIN
                         MAS_POL.dbo.AR_Salesperson sp ON c.SalespersonNo = sp.SalespersonNo AND c.SalespersonDivisionNo = sp.SalespersonDivisionNo ON h.ARDivisionNo = c.ARDivisionNo AND 
                         h.CustomerNo = c.CustomerNo LEFT OUTER JOIN
                         MAS_POL.dbo.AR_UDT_SHIPPING s RIGHT OUTER JOIN
                         MAS_POL.dbo.SO_ShipToAddress sh ON s.UDF_REGION_CODE = sh.UDF_REGION_CODE ON 
                         c.PrimaryShipToCode = sh.ShipToCode AND c.CustomerNo = sh.CustomerNo AND c.ARDivisionNo = sh.ARDivisionNo
		WHERE	(c.SortField like '%REST' OR c.SortField like '%RETAIL' OR c.SortField = 'WHOLESALE') AND
					sp.SalespersonNo != 'NC01' AND
					(
						h.InvoiceNo IS NULL OR
						(
							h.TransactionDate between '1/1/2023' and '12/31/2024' AND
							h.ModuleCode = 'S/O' AND
							d.ItemType = '1' AND
							d.UnitPrice > 0 AND
							d.WarehouseCode IN ('000', '902', '200') AND
							d.CostOfGoodsSoldAcctKey != '00000008M'
						)
					)
		GROUP BY pl.ProductLineDesc
				, i.UDF_MASTER_VENDOR
				, v.VendorName
				, i.UDF_BRAND
				, i.UDF_COUNTRY
				, i.UDF_REGION
				, i.UDF_SUBREGION_T
				, c.CustomerNo
				, c.CustomerName
				, c.UDF_AFFILIATIONS
				, c.SortField
				, sp.SalespersonNo
				, sp.UDF_TERRITORY
				, s.UDF_TERRITORY
				, sh.UDF_COUNTY
				, c.UDF_PREMISIS_CITY
				, c.UDF_PREMISIS_STATE
				, c.UDF_PREMISIS_ZIP
				, i.UDF_BRAND_NAMES
				, i.UDF_DESCRIPTION
				, i.SalesUnitOfMeasure
				, i.UDF_BOTTLE_SIZE



EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[56] 4[9] 2[18] 3) )"
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
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "AR_Customer (MAS_POL.dbo)"
            Begin Extent = 
               Top = 12
               Left = 9
               Bottom = 248
               Right = 304
            End
            DisplayFlags = 280
            TopColumn = 95
         End
         Begin Table = "AR_Salesperson (MAS_POL.dbo)"
            Begin Extent = 
               Top = 427
               Left = 39
               Bottom = 597
               Right = 261
            End
            DisplayFlags = 280
            TopColumn = 24
         End
         Begin Table = "SO_ShipToAddress (MAS_POL.dbo)"
            Begin Extent = 
               Top = 21
               Left = 402
               Bottom = 238
               Right = 652
            End
            DisplayFlags = 280
            TopColumn = 28
         End
         Begin Table = "AR_UDT_SHIPPING (MAS_POL.dbo)"
            Begin Extent = 
               Top = 16
               Left = 752
               Bottom = 146
               Right = 960
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "AR_InvoiceHistoryHeader (MAS_POL.dbo)"
            Begin Extent = 
               Top = 347
               Left = 292
               Bottom = 568
               Right = 559
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "AR_InvoiceHistoryDetail (MAS_POL.dbo)"
            Begin Extent = 
               Top = 289
               Left = 585
               Bottom = 570
               Right = 829
            End
            DisplayFlags = 280
            TopColumn = 49
         End
         Begin Table = "CI_Item (MAS_POL.dbo)"
            Begin Exten', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PivotSales'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N't = 
               Top = 215
               Left = 894
               Bottom = 473
               Right = 1132
            End
            DisplayFlags = 280
            TopColumn = 114
         End
         Begin Table = "AP_Vendor (MAS_POL.dbo)"
            Begin Extent = 
               Top = 86
               Left = 1197
               Bottom = 216
               Right = 1454
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IM_ProductLine (MAS_POL.dbo)"
            Begin Extent = 
               Top = 273
               Left = 1302
               Bottom = 403
               Right = 1560
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PivotSales'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'PivotSales'
