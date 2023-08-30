/****** Object:  View [dbo].[SevenFifty_ItemChange]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[SevenFifty_ItemChange]
AS
SELECT     TOP (100) PERCENT MIN(tmp.[Table]) AS [Table], tmp.SKU, tmp.[Importer/Supplier], tmp.[Product Type], tmp.[Product Subtype], tmp.[Product Style], 
                      tmp.[Producer Name], tmp.[Product Name], tmp.Vintage, tmp.[Grapes & Raw Materials], tmp.Country, tmp.Region, tmp.Appellation, tmp.Features, 
                      tmp.[Alcohol by volume], tmp.Size, tmp.[Size Unit], tmp.[Container Type], tmp.[Case size], tmp.[State]
FROM         dbo.SevenFifty_Current AS c INNER JOIN
                          (SELECT     'Previous' AS [Table], SKU, [Importer/Supplier], [Product Type], [Product Subtype], [Product Style], [Producer Name], [Product Name], Vintage, 
                                                   [Grapes & Raw Materials], Country, Region, Appellation, Features, [Alcohol by volume], Size, [Size Unit], [Container Type], [Case size], [State]
                            FROM          dbo.SevenFifty_Previous
                            UNION ALL
                            SELECT     'Current' AS [Table], SKU, [Importer/Supplier], [Product Type], [Product Subtype], [Product Style], [Producer Name], [Product Name], Vintage, 
                                                  [Grapes & Raw Materials], Country, Region, Appellation, Features, [Alcohol by volume], Size, [Size Unit], [Container Type], [Case size], [State]
                            FROM         SevenFifty_Current) AS tmp ON c.SKU = tmp.SKU AND c.[State] = tmp.[State] INNER JOIN
                      dbo.SevenFifty_Previous AS p ON c.SKU = p.SKU AND c.[State] = p.[State]
GROUP BY tmp.SKU, tmp.[Importer/Supplier], tmp.[Product Type], tmp.[Product Subtype], tmp.[Product Style], tmp.[Producer Name], tmp.[Product Name], tmp.Vintage, 
                      tmp.[Grapes & Raw Materials], tmp.Country, tmp.Region, tmp.Appellation, tmp.Features, tmp.[Alcohol by volume], tmp.Size, tmp.[Size Unit], tmp.[Container Type], 
                      tmp.[Case size], tmp.[State]
HAVING      (COUNT(*) = 1)
ORDER BY tmp.SKU, tmp.[State], [Table]
