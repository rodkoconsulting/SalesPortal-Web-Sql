/****** Object:  View [dbo].[AP_Vendor_List]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AP_Vendor_List]
AS
SELECT      DISTINCT (MAS_POL.dbo.AP_VENDOR.APDivisionNo+MAS_POL.dbo.AP_VENDOR.VENDORNO) AS VENDORNO, MAS_POL.dbo.AP_VENDOR.VENDORNAME
FROM         MAS_POL.dbo.AP_VENDOR INNER JOIN
                      MAS_POL.dbo.CI_ITEM ON MAS_POL.dbo.AP_VENDOR.APDIVISIONNO = MAS_POL.dbo.CI_ITEM.PRIMARYAPDIVISIONNO AND 
                      MAS_POL.dbo.AP_VENDOR.VENDORNO = MAS_POL.dbo.CI_ITEM.PRIMARYVENDORNO
/**WHERE MAS_POL.dbo.AP_Vendor.APDivisionNo='00'***/
