/****** Object:  View [dbo].[PortalShipping]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PortalShipping]
AS
SELECT     c.ARDivisionNo,
		   c.CUSTOMERNO,
		   s.UDF_DELIVERY_MON +
		   s.UDF_DELIVERY_TUES + 
		   s.UDF_DELIVERY_WED + 
		   s.UDF_DELIVERY_THURS +
		   s.UDF_DELIVERY_FRI AS ShipDays,
		   s.UDF_REGION_CODE AS Region,
		   IsNull(c.ShipMethod,'') AS ShipVia
FROM         MAS_POL.dbo.AR_CUSTOMER c INNER JOIN
                      MAS_POL.dbo.SO_SHIPTOADDRESS s ON c.ARDIVISIONNO = s.ARDIVISIONNO AND 
                      c.CUSTOMERNO = s.CUSTOMERNO AND 
                      c.PRIMARYSHIPTOCODE = s.SHIPTOCODE
where s.UDF_REGION_CODE <> ''
