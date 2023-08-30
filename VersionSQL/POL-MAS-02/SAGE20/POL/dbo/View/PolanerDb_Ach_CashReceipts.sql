/****** Object:  View [dbo].[PolanerDb_Ach_CashReceipts]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PolanerDb_Ach_CashReceipts]
AS
SELECT     MAS_POL.dbo.AR_CashReceiptsHeader.DepositNo, MAS_POL.dbo.AR_CashReceiptsHeader.ARDivisionNo, MAS_POL.dbo.AR_CashReceiptsHeader.CustomerNo, 
                      MAS_POL.dbo.AR_Customer.UDF_CORP_NAME as 'CustomerName', MAS_POL.dbo.AR_CashReceiptsHeader.CheckNo, MAS_POL.dbo.AR_CashReceiptsHeader.BatchNo, 
                      MAS_POL.dbo.AR_Customer.UDF_BANKACCOUNTNO AS 'BankAccountNo', MAS_POL.dbo.AR_Customer.UDF_ROUTINGNO AS 'RoutingNo', 
                      CAST(ROUND(SUM(MAS_POL.dbo.AR_CashReceiptsDetail.AmountPosted),2) AS FLOAT) AS 'AmountPosted'
FROM         MAS_POL.dbo.AR_CashReceiptsDetail INNER JOIN
                      MAS_POL.dbo.AR_CashReceiptsHeader ON MAS_POL.dbo.AR_CashReceiptsDetail.DepositNo = MAS_POL.dbo.AR_CashReceiptsHeader.DepositNo AND 
                      MAS_POL.dbo.AR_CashReceiptsDetail.ARDivisionNo = MAS_POL.dbo.AR_CashReceiptsHeader.ARDivisionNo AND 
                      MAS_POL.dbo.AR_CashReceiptsDetail.CustomerNo = MAS_POL.dbo.AR_CashReceiptsHeader.CustomerNo AND 
                      MAS_POL.dbo.AR_CashReceiptsDetail.CheckNo = MAS_POL.dbo.AR_CashReceiptsHeader.CheckNo INNER JOIN
                      MAS_POL.dbo.AR_CashReceiptsDeposit ON MAS_POL.dbo.AR_CashReceiptsHeader.DepositNo = MAS_POL.dbo.AR_CashReceiptsDeposit.DepositNo INNER JOIN
                      MAS_POL.dbo.AR_Customer ON MAS_POL.dbo.AR_CashReceiptsHeader.ARDivisionNo = MAS_POL.dbo.AR_Customer.ARDivisionNo AND 
                      MAS_POL.dbo.AR_CashReceiptsHeader.CustomerNo = MAS_POL.dbo.AR_Customer.CustomerNo
GROUP BY MAS_POL.dbo.AR_CashReceiptsHeader.DepositNo, MAS_POL.dbo.AR_CashReceiptsHeader.ARDivisionNo, MAS_POL.dbo.AR_CashReceiptsHeader.CustomerNo, 
                      MAS_POL.dbo.AR_Customer.UDF_CORP_NAME, MAS_POL.dbo.AR_CashReceiptsHeader.CheckNo, MAS_POL.dbo.AR_CashReceiptsHeader.BatchNo, 
                      MAS_POL.dbo.AR_Customer.UDF_BANKACCOUNTNO, MAS_POL.dbo.AR_Customer.UDF_ROUTINGNO 
