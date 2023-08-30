/****** Object:  View [dbo].[AR_CashReceiptsInvoice]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AR_CashReceiptsInvoice]
AS
WITH wsp as
(
SELECT  distinct   h.ARDivisionNo
		 , h.CustomerNo
		 , h.BatchNo
		 , d.InvoiceNo
FROM         MAS_POL.dbo.AR_CashReceiptsDetail d INNER JOIN
                      MAS_POL.dbo.AR_CashReceiptsHeader h ON
                      d.ARDivisionNo = h.ARDivisionNo AND 
                      d.CustomerNo = h.CustomerNo
WHERE h.BatchNo LIKE 'W%'
),
man as
(
SELECT  distinct   h.ARDivisionNo
		 , h.CustomerNo
		 , h.BatchNo
		 , d.InvoiceNo
FROM         MAS_POL.dbo.AR_CashReceiptsDetail d INNER JOIN
                      MAS_POL.dbo.AR_CashReceiptsHeader h ON
                      d.ARDivisionNo = h.ARDivisionNo AND 
                      d.CustomerNo = h.CustomerNo
WHERE h.BatchNo NOT LIKE 'W%'
)
SELECT wsp.InvoiceNo, man.BatchNo, man.CustomerNo
FROM wsp INNER JOIN man on wsp.InvoiceNo = man.InvoiceNo and wsp.CustomerNo = man.CustomerNo and wsp.ARDivisionNo = man.ARDivisionNo
