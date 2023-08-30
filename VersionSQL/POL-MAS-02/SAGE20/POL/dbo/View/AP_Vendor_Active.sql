/****** Object:  View [dbo].[AP_Vendor_Active]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AP_Vendor_Active]
AS
SELECT     APDivisionNo, VendorNo, VendorName, UDF_MASTER_VENDOR, UDF_VEND_INACTIVE, UDF_CURRENCY, Sort, City, State
FROM         MAS_POL.dbo.AP_Vendor
WHERE UDF_VEND_INACTIVE<>'Y'
