/****** Object:  View [dbo].[Web_Invoices_Coops]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Invoices_Coops]
AS
SELECT                h.InvoiceDate AS InvoiceDate, 
                      SUM(d.QUANTITYORDERED) AS QUANTITYORDERED,
                      h.UDF_NJ_COOP as 'CoopNo'
                      FROM         MAS_POL.dbo.AR_InvoiceHistoryHeader h WITH ( NOLOCK ) INNER JOIN
                      MAS_POL.dbo.AR_InvoiceHistoryDetail d WITH ( NOLOCK ) ON h.InvoiceNo = d.InvoiceNo
                      
WHERE     (d.ITEMTYPE = 1) and h.UDF_NJ_COOP <> '' and h.UDF_NJ_COOP <> 'None' and h.InvoiceDate <= getdate()  and h.InvoiceDate >= DATEADD(week, -2, getdate())
GROUP BY InvoiceDate, UDF_NJ_COOP
