/****** Object:  View [dbo].[WpfPortalOrderHeaderView]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[WpfPortalOrderHeaderView]
AS
SELECT        dbo.PortalShipping.ShipDays, CASE WHEN SUBSTRING(dbo.AR_CUSTOMER.CUSTOMERTYPE, 3, 2) = 'ON' THEN 'On' ELSE 'Off' END AS Premise,
                             (SELECT        CutOffTime
                               FROM            dbo.Web_MasFlags
                               WHERE        (ID = 1)) AS CutOff, dbo.AR_UDT_SHIPPING.UDF_TERRITORY AS Territory, dbo.AR_Customer.SHIPMETHOD, dbo.AR_Customer.UDF_CUST_ACTIVE_STAT AS CustomerActive, 
                         ISNULL(CASE WHEN YEAR(dbo.AR_CUSTOMER.UDF_LIC_EXPIRATION) > 1900 THEN dbo.AR_CUSTOMER.UDF_LIC_EXPIRATION ELSE '12/31/9999' END, '12/31/1999') AS LicExpDate, 
                         dbo.AR_Customer.UDF_CERT_ON_FILE AS IsCertOnFile, dbo.AR_Customer.CREDITHOLD, dbo.AR_Customer.UDF_PO_REQUIRED AS PoRequired, dbo.Web_Account_OgHeader.ORDERNO, 
                         dbo.Web_Account_OgHeader.ORDERSTATUS AS STATUS, dbo.Web_Account_OgHeader.ORDERTYPE, dbo.Web_Account_OgHeader.CUSTOMERNO, dbo.Web_Account_OgHeader.DELIVERYDAY, 
                         dbo.Web_Account_OgHeader.NOTES, dbo.Web_Account_OgHeader.COOPNO, dbo.Web_Account_OgHeader.PONO
FROM            dbo.PortalShipping INNER JOIN
                         dbo.AR_Customer ON dbo.PortalShipping.CUSTOMERNO = dbo.AR_Customer.CustomerNo INNER JOIN
                         dbo.SO_ShipToAddress ON dbo.AR_Customer.PrimaryShipToCode = dbo.SO_ShipToAddress.ShipToCode AND dbo.AR_Customer.CustomerNo = dbo.SO_ShipToAddress.CustomerNo INNER JOIN
                         dbo.AR_UDT_SHIPPING ON dbo.SO_ShipToAddress.UDF_REGION_CODE = dbo.AR_UDT_SHIPPING.UDF_REGION_CODE INNER JOIN
                         dbo.Web_Account_OgHeader ON dbo.PortalShipping.CUSTOMERNO = dbo.Web_Account_OgHeader.CUSTOMERNO
WHERE        (dbo.AR_Customer.ARDivisionNo = '00')

EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[46] 4[15] 2[32] 3) )"
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
         Begin Table = "PortalShipping"
            Begin Extent = 
               Top = 11
               Left = 880
               Bottom = 124
               Right = 1050
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_Customer"
            Begin Extent = 
               Top = 42
               Left = 1167
               Bottom = 104
               Right = 1426
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SO_ShipToAddress"
            Begin Extent = 
               Top = 342
               Left = 977
               Bottom = 472
               Right = 1185
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AR_UDT_SHIPPING"
            Begin Extent = 
               Top = 154
               Left = 641
               Bottom = 267
               Right = 835
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Web_Account_OgHeader"
            Begin Extent = 
               Top = 14
               Left = 249
               Bottom = 294
               Right = 519
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
         ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'WpfPortalOrderHeaderView'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'WpfPortalOrderHeaderView'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'WpfPortalOrderHeaderView'
