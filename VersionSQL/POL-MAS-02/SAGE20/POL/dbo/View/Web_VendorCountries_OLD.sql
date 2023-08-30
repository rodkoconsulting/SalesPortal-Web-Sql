/****** Object:  View [dbo].[Web_VendorCountries_OLD]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_VendorCountries_OLD]
AS
SELECT     UDF_BRAND, COUNT(DISTINCT UDF_COUNTRY) AS CountryCount
FROM         MAS_POL.dbo.CI_ITEM
WHERE     (udf_brand <> '') AND (ITEMCODE not like '%D') AND (StandardUnitCost > 0) AND (ProductLine <> 'SAMP')
GROUP BY UDF_BRAND
HAVING      (COUNT(DISTINCT UDF_COUNTRY) > 1)
