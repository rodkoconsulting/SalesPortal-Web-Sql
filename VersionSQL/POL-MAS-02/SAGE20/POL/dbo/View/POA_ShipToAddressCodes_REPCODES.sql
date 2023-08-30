/****** Object:  View [dbo].[POA_ShipToAddressCodes_REPCODES]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[POA_ShipToAddressCodes_REPCODES]
AS
SELECT     ShipToCode, LEFT(ShipToCode, 2) + '0' + RIGHT(ShipToCode, 1) AS RepCode
FROM         MAS_POL.dbo.PO_ShipToAddress
