﻿/****** Object:  View [dbo].[SpRpt_SalesAnalysis]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[SpRpt_SalesAnalysis]
AS
SELECT     MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNO, MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNAME, MAS_POL.dbo.AR_CUSTOMER.CUSTOMERTYPE, ISNULL(MAS_POL.dbo.AR_INVOICEHISTORYHEADER.INVOICENO,1) AS INVOICENO, 
                      ISNULL(MAS_POL.dbo.AR_INVOICEHISTORYHEADER.HEADERSEQNO, 1) AS HEADERSEQNO, ISNULL(MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.DETAILSEQNO,1) AS DETAILSEQNO, ISNULL(MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.ITEMCODE,'NULL') AS ITEMCODE, 
                      ISNULL(MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.ITEMTYPE,1) AS ITEMTYPE, ISNULL(MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.EXTENSIONAMT,0) AS EXTENSIONAMT, ISNULL(MAS_POL.dbo.AR_INVOICEHISTORYHEADER.INVOICEDATE,GETDATE()) AS INVOICEDATE, 
                      MAS_POL.dbo.AR_CUSTOMER.SALESPERSONNO
FROM         MAS_POL.dbo.AR_INVOICEHISTORYDETAIL RIGHT OUTER JOIN
                      MAS_POL.dbo.AR_INVOICEHISTORYHEADER ON MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.INVOICENO = MAS_POL.dbo.AR_INVOICEHISTORYHEADER.INVOICENO AND 
                      MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.HEADERSEQNO = MAS_POL.dbo.AR_INVOICEHISTORYHEADER.HEADERSEQNO RIGHT OUTER JOIN
                      MAS_POL.dbo.AR_SALESPERSON INNER JOIN
                      MAS_POL.dbo.AR_CUSTOMER ON MAS_POL.dbo.AR_SALESPERSON.SALESPERSONDIVISIONNO = MAS_POL.dbo.AR_CUSTOMER.SALESPERSONDIVISIONNO AND 
                      MAS_POL.dbo.AR_SALESPERSON.SALESPERSONNO = MAS_POL.dbo.AR_CUSTOMER.SALESPERSONNO ON 
                      MAS_POL.dbo.AR_INVOICEHISTORYHEADER.CUSTOMERNO = MAS_POL.dbo.AR_CUSTOMER.CUSTOMERNO AND 
                      MAS_POL.dbo.AR_INVOICEHISTORYHEADER.ARDIVISIONNO = MAS_POL.dbo.AR_CUSTOMER.ARDIVISIONNO
WHERE (INVOICEDATE IS NULL OR INVOICEDATE >= DATEFROMPARTS ( DATEPART(yyyy, GETDATE()) - 1, 1, 1 )) and MAS_POL.dbo.AR_CUSTOMER.CUSTOMERTYPE<>'MISC' AND MAS_POL.dbo.AR_CUSTOMER.SALESPERSONNO NOT LIKE 'XX%' AND (MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.ITEMTYPE IS NULL OR MAS_POL.dbo.AR_INVOICEHISTORYDETAIL.ITEMTYPE=1) AND not (INVOICEDATE is not null and ITEMCODE is null)
