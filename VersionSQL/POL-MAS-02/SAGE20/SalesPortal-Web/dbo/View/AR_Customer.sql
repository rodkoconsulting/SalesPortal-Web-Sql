/****** Object:  View [dbo].[AR_Customer]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_Customer]
AS
SELECT     
ARDivisionNo,
CustomerNo,
CustomerName,
CustomerType,
SalespersonDivisionNo,
SalespersonNo,
PrimaryShipToCode,
SortField,
TermsCode,
PriceLevel,
SHIPMETHOD,
AgingCategory1,
AgingCategory2,
AgingCategory3,
AgingCategory4,
CURRENTBALANCE,
CREDITHOLD,
CREDITLIMIT,
OPENORDERAMT,
UDF_ACCOUNT_TYPE,
RTRIM(UDF_LICENSE_NUM) as UDF_LICENSE_NUM,
UDF_AFFILIATIONS,
UDF_GROWTH_POTENTIAL,
UDF_STORE_REST_FOCUS,
UDF_OTHER_KEY_SUPPLIERS,
UDF_CUST_ACTIVE_STAT,
UDF_LIC_EXPIRATION,
UDF_CERT_ON_FILE,
UDF_PERM_SPEC_DELIV,
UDF_WINE_BUYER,
UDF_WINE_BUYER_2,
UDF_WINE_BUYER_3,
UDF_WINE_BUYER_PHONE,
UDF_WINE_BUYER_PHONE_2,
UDF_WINE_BUYER_PHONE_3,
UDF_WINE_BUYER_EMAIL,
UDF_WINE_BUYER_2_EMAIL,
UDF_WINE_BUYER_3_EMAIL,
UDF_PO_REQUIRED,
UDF_NJ_COOP,
UDF_PREMISIS_ADDRESS_LINE_1,
UDF_PREMISIS_ADDRESS_LINE_2,
UDF_PREMISIS_CITY,
UDF_PREMISIS_STATE,
UDF_PREMISIS_ZIP,
UDF_REP_EMAIL_ADDRESS,
DefaultPaymentType,
CustomerStatus
FROM         MAS_POL.dbo.AR_Customer











EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[21] 2[20] 3) )"
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
         Begin Table = "AR_Customer_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 311
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'AR_Customer'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'AR_Customer'
