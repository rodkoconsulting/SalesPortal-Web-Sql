/****** Object:  Procedure [dbo].[PortalWebSampleAddressesProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebSampleAddressesProc]
	-- Add the parameters for the stored procedure here
	@UserName varchar(25)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RepCode varchar(4);
SELECT @RepCode = RepCode FROM Web_ActiveUsers where UserName=@UserName  
SELECT     s.ShipToCode as Code
			,s.ShipToName as [Name]
			, CASE WHEN len(s.ShipToAddress2)=0 then s.ShipToAddress1 ELSE s.ShipToAddress1 + ', ' + s.ShipToAddress2 END as Address
FROM         MAS_POL.dbo.PO_ShipToAddress s INNER JOIN dbo.PortalPoAddress r ON s.ShipToCode = r.ShipToCode
WHERE s.UDF_REP_CODE = @RepCode
FOR JSON PATH
END
