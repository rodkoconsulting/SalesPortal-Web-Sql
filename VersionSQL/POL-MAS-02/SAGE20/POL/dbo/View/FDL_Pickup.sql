/****** Object:  View [dbo].[FDL_Pickup]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[FDL_Pickup]
AS
SELECT     MAS_POL.dbo.RA_ReturnHeader.RMANo
			,MAS_POL.dbo.RA_ReturnHeader.RMADate
			,MAS_POL.dbo.RA_ReturnHeader.CustomerNo
			,MAS_POL.dbo.AR_Customer.EmailAddress
			,MAS_POL.dbo.AR_Customer.CustomerName
			,ROUND(SUM(MAS_POL.dbo.RA_ReturnDetail.QuantityReturned),4) AS Cases
            ,ROUND(SUM((CASE WHEN LEN(MAS_POL.dbo.CI_Item.ShipWeight) > 0 THEN MAS_POL.dbo.CI_Item.ShipWeight ELSE 36 END) * MAS_POL.dbo.RA_ReturnDetail.QuantityReturned),2) as Weight
            ,MAS_POL.dbo.RA_ReturnHeader.ShipToCode
            ,CASE WHEN MAS_POL.dbo.SO_ShipToAddress.UDF_GUARANTEED_AM ='Y' THEN 'GUARANTEED AM'
				WHEN MAS_POL.dbo.SO_ShipToAddress.UDF_PERM_INSTRUCTIONS = 'Y' THEN MAS_POL.dbo.SO_ShipToAddress.UDF_INSTRUCTIONS ELSE '' END AS 'Comment'
			,CASE WHEN MAS_POL.dbo.SO_ShipToAddress.UDF_GUARANTEED_AM ='Y' THEN 'AM' ELSE '' END AS 'AM',
			MAS_POL.dbo.SO_ShipToAddress.ShipToAddress1 + CASE WHEN SO_ShipToAddress.ShipToAddress2='' THEN '' ELSE ', '+SO_ShipToAddress.ShipToAddress2 END AS Address,
			SO_ShipToAddress.ShipToCity as City,
			SO_ShipToAddress.ShipToState as State,
			SO_ShipToAddress.ShipToZipCode as Zip
FROM         MAS_POL.dbo.RA_ReturnHeader INNER JOIN
                      MAS_POL.dbo.RA_ReturnDetail ON MAS_POL.dbo.RA_ReturnHeader.RMANo = MAS_POL.dbo.RA_ReturnDetail.RMANo INNER JOIN
                      MAS_POL.dbo.AR_Customer ON MAS_POL.dbo.RA_ReturnHeader.ARDivisionNo = MAS_POL.dbo.AR_Customer.ARDivisionNo AND 
                      MAS_POL.dbo.RA_ReturnHeader.CustomerNo =MAS_POL.dbo.AR_Customer.CustomerNo INNER JOIN
                      MAS_POL.dbo.CI_Item ON MAS_POL.dbo.RA_ReturnDetail.ItemCode = MAS_POL.dbo.CI_Item.ItemCode INNER JOIN
                      MAS_POL.dbo.SO_ShipToAddress ON MAS_POL.dbo.RA_ReturnHeader.ARDivisionNo = MAS_POL.dbo.SO_ShipToAddress.ARDivisionNo AND 
                      MAS_POL.dbo.RA_ReturnHeader.CustomerNo = MAS_POL.dbo.SO_ShipToAddress.CustomerNo AND MAS_POL.dbo.RA_ReturnHeader.ShipToCode = MAS_POL.dbo.SO_ShipToAddress.ShipToCode
WHERE MAS_POL.dbo.RA_ReturnHeader.UDF_TYPE = 'PICK UP' and MAS_POL.dbo.RA_ReturnHeader.UDF_SHIPMETHOD = 'FDL'
GROUP BY MAS_POL.dbo.RA_ReturnHeader.RMANo, MAS_POL.dbo.RA_ReturnHeader.RMADate, MAS_POL.dbo.RA_ReturnHeader.CustomerNo, MAS_POL.dbo.AR_Customer.EmailAddress, 
                      MAS_POL.dbo.AR_Customer.CustomerName, MAS_POL.dbo.SO_ShipToAddress.UDF_GUARANTEED_AM, 
                      MAS_POL.dbo.SO_ShipToAddress.UDF_PERM_INSTRUCTIONS, MAS_POL.dbo.RA_ReturnHeader.ShipToCode
					  , MAS_POL.dbo.SO_ShipToAddress.UDF_INSTRUCTIONS
					  ,MAS_POL.dbo.SO_ShipToAddress.ShipToAddress1
					  ,MAS_POL.dbo.SO_ShipToAddress.ShipToAddress2
					  ,MAS_POL.dbo.SO_ShipToAddress.ShipToCity
					  ,MAS_POL.dbo.SO_ShipToAddress.ShipToState
					  ,MAS_POL.dbo.SO_ShipToAddress.ShipToZipCode
