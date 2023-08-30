/****** Object:  View [dbo].[SalesAnalysis]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[SalesAnalysis]
AS
SELECT        TOP (100) PERCENT MAS_POL.dbo.AR_Customer.CustomerName, COUNT(DISTINCT (CASE WHEN Year(INVOICEDATE) = YEAR(GETDATE()) AND Month(INVOICEDATE) 
                         = Month(GETDATE()) THEN POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.ItemCode ELSE NULL END)) AS MTD_SKU, 
                         COUNT(DISTINCT (CASE WHEN Year(INVOICEDATE) = YEAR(GETDATE()) - 1 AND Month(INVOICEDATE) = Month(GETDATE()) 
                         THEN POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.ItemCode ELSE NULL END)) AS LY_MTD_SKU, SUM(CASE WHEN Year(INVOICEDATE) = YEAR(GETDATE()) AND 
                         Month(INVOICEDATE) = Month(GETDATE()) THEN ISNULL(POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.EXTENSIONAMT, 0) ELSE 0 END) AS MTD, 
                         SUM(CASE WHEN Year(INVOICEDATE) = YEAR(GETDATE()) - 1 AND Month(INVOICEDATE) = Month(GETDATE()) 
                         THEN ISNULL(POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.EXTENSIONAMT, 0) ELSE 0 END) AS LY_MTD, SUM(CASE WHEN Year(INVOICEDATE) = YEAR(GETDATE()) 
                         AND Month(INVOICEDATE) <= Month(GETDATE()) THEN ISNULL(POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.EXTENSIONAMT, 0) ELSE 0 END) AS YTD, 
                         SUM(CASE WHEN Year(INVOICEDATE) = YEAR(GETDATE()) - 1 AND Month(INVOICEDATE) <= Month(GETDATE()) 
                         THEN ISNULL(POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.EXTENSIONAMT, 0) ELSE 0 END) AS LY_YTD, MAS_POL.dbo.AR_Customer.SalespersonNo
FROM            POL.dbo.AR_INVOICEHISTORYDETAIL_UNION RIGHT OUTER JOIN
                         POL.dbo.AR_INVOICEHISTORYHEADER_UNION ON POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.InvoiceNo = POL.dbo.AR_INVOICEHISTORYHEADER_UNION.InvoiceNo AND 
                         POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.HeaderSeqNo = POL.dbo.AR_INVOICEHISTORYHEADER_UNION.HeaderSeqNo RIGHT OUTER JOIN
                         MAS_POL.dbo.AR_Salesperson INNER JOIN
                         MAS_POL.dbo.AR_Customer ON MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo = MAS_POL.dbo.AR_Customer.SalespersonDivisionNo AND 
                         MAS_POL.dbo.AR_Salesperson.SalespersonNo = MAS_POL.dbo.AR_Customer.SalespersonNo ON 
                         POL.dbo.AR_INVOICEHISTORYHEADER_UNION.CustomerNo = MAS_POL.dbo.AR_Customer.CustomerNo AND 
                         POL.dbo.AR_INVOICEHISTORYHEADER_UNION.ARDivisionNo = MAS_POL.dbo.AR_Customer.ARDivisionNo
WHERE        (POL.dbo.AR_INVOICEHISTORYHEADER_UNION.InvoiceDate IS NULL) AND 
                         (MAS_POL.dbo.AR_Customer.SalespersonNo NOT LIKE 'XX%') AND (POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.ItemType IS NULL OR
                         POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.ItemType = 1) AND (NOT (POL.dbo.AR_INVOICEHISTORYHEADER_UNION.InvoiceDate IS NOT NULL)) OR
                         (NOT (POL.dbo.AR_INVOICEHISTORYHEADER_UNION.InvoiceDate IS NOT NULL)) AND 
                         (MAS_POL.dbo.AR_Customer.SalespersonNo NOT LIKE 'XX%') AND (POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.ItemType IS NULL OR
                         POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.ItemType = 1) AND (POL.dbo.AR_INVOICEHISTORYHEADER_UNION.InvoiceDate >= DATEFROMPARTS ( DATEPART(yyyy, GETDATE()) - 1, 1, 1 )) OR
                         (POL.dbo.AR_INVOICEHISTORYHEADER_UNION.InvoiceDate IS NULL) AND 
                         (MAS_POL.dbo.AR_Customer.SalespersonNo NOT LIKE 'XX%') AND (POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.ItemType IS NULL OR
                         POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.ItemType = 1) AND (NOT (POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.ItemCode IS NULL)) OR
                         (MAS_POL.dbo.AR_Customer.SalespersonNo NOT LIKE 'XX%') AND 
                         (POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.ItemType IS NULL OR
                         POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.ItemType = 1) AND (POL.dbo.AR_INVOICEHISTORYHEADER_UNION.InvoiceDate >= DATEFROMPARTS ( DATEPART(yyyy, GETDATE()) - 1, 1, 1 )) AND 
                         (NOT (POL.dbo.AR_INVOICEHISTORYDETAIL_UNION.ItemCode IS NULL))
GROUP BY MAS_POL.dbo.AR_Customer.CustomerName, MAS_POL.dbo.AR_Customer.SalespersonNo
