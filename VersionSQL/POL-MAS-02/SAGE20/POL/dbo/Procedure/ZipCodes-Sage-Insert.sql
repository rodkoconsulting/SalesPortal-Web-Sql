/****** Object:  Procedure [dbo].[ZipCodes-Sage-Insert]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ZipCodes-Sage-Insert]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


    -- Insert statements for procedure here
	INSERT INTO [dbo].[ZipCodes-Sage]
SELECT         Left(s.ShipToZipCode,5) as 'ZipCode - Sage'
				, MAX(s.ShipToCity) as City
				, MAX(s.UDF_DELIVERY_MON) as [Ship-Monday]
				, MAX(s.UDF_DELIVERY_TUES) as [Ship-Tuesday]
				, MAX(s.UDF_DELIVERY_WED) as [Ship-Wednesday]
				, MAX(s.UDF_DELIVERY_THURS) as [Ship-Thursday]
				, MAX(s.UDF_DELIVERY_FRI) as [Ship-Friday]
				, MAX(r.UDF_TERRITORY) as Territory
				, MAX(IsNull(CASE WHEN s.ShipVia='' THEN c.ShipMethod ELSE s.ShipVia END,'')) as ShipVia
				, MAX(r.UDF_COUNTY) as County
				, MAX('') as [FDL Route]
FROM            MAS_POL.dbo.AR_Customer c INNER JOIN
                MAS_POL.dbo.SO_ShipToAddress s ON c.ARDivisionNo = s.ARDivisionNo AND c.CustomerNo = s.CustomerNo INNER JOIN
				MAS_POL.dbo.AR_UDT_SHIPPING r ON s.UDF_REGION_CODE = r.UDF_REGION_CODE
WHERE c.ARDivisionNo = '00' and CustomerName not like 'MASTER%' and s.ShipToState in ('NY','NJ') and s.ShipToZipCode != ''
GROUP BY Left(s.ShipToZipCode,5)
END
