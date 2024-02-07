/****** Object:  View [dbo].[AP_Vendor_Wine_Contacts_Active]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.AP_Vendor_Wine_Contacts_Active
AS
SELECT DISTINCT v.VendorNo, v.VendorName, c.ContactName, c.EmailAddress, v.Sort
FROM            MAS_POL.dbo.AP_Vendor AS v INNER JOIN
                         MAS_POL.dbo.CI_Item AS i ON v.APDivisionNo = i.PrimaryAPDivisionNo AND v.VendorNo = i.PrimaryVendorNo INNER JOIN
                         MAS_POL.dbo.AP_VendorContact AS c ON v.APDivisionNo = c.APDivisionNo AND v.VendorNo = c.VendorNo
WHERE        (v.UDF_VEND_INACTIVE <> 'Y') AND (v.APDivisionNo = '00')
