/****** Object:  View [dbo].[RareWine_Depletions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[RareWine_Depletions]
AS
SELECT    
				CONVERT(date, t.TransactionDate) as 'Transaction Date'
				, t.ItemCode as [Item Code]
				, i.UDF_DESCRIPTION as [Item Name]
				, b.UDF_BRAND_NAME as [Producer Name]
				, i.UDF_VINTAGE as [Vintage]
				, CASE WHEN CHARINDEX('ML',i.UDF_BOTTLE_SIZE)>0 THEN ISNULL(TRY_CONVERT(int, REPLACE(i.UDF_BOTTLE_SIZE,' ML','')),750) ELSE 1000 * ISNULL(TRY_CONVERT(float, REPLACE(i.UDF_BOTTLE_SIZE,' L','')),1.5) END as [Bottle Size]
				, REPLACE(i.SalesUnitOfMeasure, 'C', '') as [Pack Size]
				, TRY_CONVERT(int, SUM(ROUND(-t.TransactionQty * ISNULL(TRY_CONVERT(int, REPLACE(i.SalesUnitOfMeasure, 'C', '')),12),0)),0) as [Qty in Bottles]
				, IsNull(c.SalespersonNo,'') as 'Sales rep code'
				, IsNull(s.SalesPersonName,'') as 'Sales rep name'
				, IsNull(c.CustomerName,'Samples') as 'Account name'
				, IsNull(t.ARDivisionNo,'') + IsNull(t.CustomerNo,'') as 'Account code'
				, CASE WHEN c.CustomerType IS NULL THEN ''
					WHEN RIGHT(c.CustomerType, 2) = 'ON' THEN 'On'
					ELSE 'Off' END as 'Premise'
				, IsNull(c.UDF_PREMISIS_ADDRESS_LINE_1, '') AS 'Address 1'
				, IsNull(c.UDF_PREMISIS_ADDRESS_LINE_2, '') AS 'Address 2'
				, IsNull(c.UDF_PREMISIS_CITY, '') AS 'City'
				, IsNull(c.UDF_PREMISIS_STATE, '') AS 'State'
				, IsNull(c.UDF_PREMISIS_ZIP, '') AS 'Zip'
FROM		 MAS_POL.dbo.IM_ItemTransactionHistory t INNER JOIN 
                        MAS_POL.dbo.CI_Item i ON t.ItemCode = i.ItemCode INNER JOIN
						MAS_POL.dbo.CI_UDT_BRANDS b ON i.UDF_BRAND = b.UDF_BRAND_CODE LEFT OUTER JOIN
						MAS_POL.dbo.AR_Customer c ON t.ARDivisionNo = c.ARDivisionNo AND t.CustomerNo = c.CustomerNo LEFT OUTER JOIN
						MAS_POL.dbo.AR_Salesperson s ON c.SalespersonDivisionNo = s.SalespersonDivisionNo AND c.SalespersonNo = s.SalespersonNo
WHERE i.UDF_MASTER_VENDOR = 'Rare Wine'
	AND i.ProductLine != 'SAMP'
	AND t.TransactionCode IN ('SO', 'PM')
	AND Year(t.TransactionDate) >= 2022
GROUP BY t.ItemCode
			, i.UDF_DESCRIPTION
			, b.UDF_BRAND_NAME
			, i.UDF_VINTAGE
			, i.UDF_BOTTLE_SIZE
			, i.SalesUnitOfMeasure
			, c.SalespersonNo
			, s.SalesPersonName
			, c.CustomerName
			, t.ArDivisionNo
			, t.CustomerNo
			, c.CustomerType
			, c.UDF_PREMISIS_ADDRESS_LINE_1
			, c.UDF_PREMISIS_ADDRESS_LINE_2
			, c.UDF_PREMISIS_CITY
			, c.UDF_PREMISIS_STATE
			, c.UDF_PREMISIS_ZIP
			, t.TransactionDate
HAVING TRY_CONVERT(int, SUM(ROUND(-t.TransactionQty * ISNULL(TRY_CONVERT(int, REPLACE(i.SalesUnitOfMeasure, 'C', '')),12),0)),0) != 0
