/****** Object:  Procedure [dbo].[NYSLA_Inactive_Insert]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[NYSLA_Inactive_Insert]
	-- Add the parameters for the stored procedure her
	@LicenseNumber varchar(7)
AS
IF NOT EXISTS(SELECT 'True' FROM AR_NYSLA_Inactive WHERE LICENSENUMBER = @LicenseNumber)
BEGIN
INSERT INTO AR_NYSLA_Inactive(LICENSENUMBER)
VALUES(@LicenseNumber)
END
