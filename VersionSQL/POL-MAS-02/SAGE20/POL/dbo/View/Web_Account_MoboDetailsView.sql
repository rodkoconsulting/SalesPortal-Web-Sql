/****** Object:  View [dbo].[Web_Account_MoboDetailsView]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Web_Account_MoboDetailsView]
AS
SELECT		MAS_POL.dbo.SO_SALESORDERHEADER.ORDERDATE,
			MAS_POL.dbo.SO_SALESORDERHEADER.SHIPEXPIREDATE AS EXPDATE, 
            CASE WHEN MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'IN' THEN 'BO' ELSE CancelReasonCode END AS ORDERTYPE, 
            MAS_POL.dbo.SO_SALESORDERDETAIL.QUANTITYORDERED,
            MAS_POL.dbo.SO_SALESORDERHEADER.BILLTONAME as 'Account', 
            MAS_POL.dbo.CI_Item.UDF_BRAND_NAMES+' '+MAS_POL.dbo.CI_ITEM.UDF_DESCRIPTION+' '+MAS_POL.dbo.CI_ITEM.UDF_VINTAGE+ ' (' +
				REPLACE(MAS_POL.dbo.CI_ITEM.SalesUnitOfMeasure, 'C', '')+'/'+(CASE WHEN CHARINDEX('ML', MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE)> 0
				THEN REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ML', '') ELSE REPLACE(MAS_POL.dbo.CI_ITEM.UDF_BOTTLE_SIZE, ' ', '') END)+ ') ' +
				MAS_POL.dbo.CI_ITEM.UDF_DAMAGED_NOTES AS ItemDescription,
			IsNull(CAST(REPLACE(MAS_POL.dbo.SO_SALESORDERDETAIL.UNITOFMEASURE, 'C', '') AS INT),12) AS UOM,
			MAS_POL.dbo.SO_SALESORDERHEADER.COMMENT,
			MAS_POL.dbo.SO_SALESORDERHEADER.ARDIVISIONNO AS ARDIVISIONNO, 
			MAS_POL.dbo.SO_SALESORDERHEADER.CUSTOMERNO AS CUSTOMERNO, 
            dbo.Web_Account_MoboDetails.ORDERNO,
            dbo.Web_Account_MoboDetails.ITEMCODE,
            dbo.Web_Account_MoboDetails.SALESORDERNO
FROM         MAS_POL.dbo.SO_SalesOrderHeader INNER JOIN
                      MAS_POL.dbo.SO_SalesOrderDetail ON MAS_POL.dbo.SO_SalesOrderHeader.SalesOrderNo = MAS_POL.dbo.SO_SalesOrderDetail.SalesOrderNo INNER JOIN
                      MAS_POL.dbo.AR_Salesperson ON MAS_POL.dbo.SO_SalesOrderHeader.SalespersonDivisionNo = MAS_POL.dbo.AR_Salesperson.SalespersonDivisionNo AND 
                      MAS_POL.dbo.SO_SalesOrderHeader.SalespersonNo = MAS_POL.dbo.AR_Salesperson.SalespersonNo INNER JOIN
                      MAS_POL.dbo.CI_Item ON MAS_POL.dbo.SO_SalesOrderDetail.ItemCode = MAS_POL.dbo.CI_Item.ItemCode INNER JOIN
                      dbo.Web_Account_MoboDetails ON MAS_POL.dbo.SO_SalesOrderDetail.SalesOrderNo = dbo.Web_Account_MoboDetails.SALESORDERNO AND 
                      MAS_POL.dbo.SO_SalesOrderDetail.ItemCode = dbo.Web_Account_MoboDetails.ITEMCODE
WHERE     (MAS_POL.dbo.SO_SALESORDERDETAIL.ITEMTYPE = 1) AND (MAS_POL.dbo.SO_SALESORDERDETAIL.QUANTITYORDERED > 0) AND 
                      (MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'IN' OR
                      MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'MO' OR MAS_POL.dbo.SO_SALESORDERHEADER.CANCELREASONCODE = 'BH')
