/****** Object:  Procedure [dbo].[PortalWebInventoryReviews]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PortalWebInventoryReviews] 
	-- Add the parameters for the stored procedure here
	@ItemCode varchar(15)
AS
BEGIN
	SELECT
	UDF_PARKER_REVIEW as ReviewWA,
	UDF_SPECTATOR_REVIEW as ReviewWS,
	UDF_VIEW_REVIEW as ReviewVFC,
	UDF_BURGHOUND_REVIEW as ReviewBH,
	UDF_GALLONI_REVIEW as ReviewVM,
	UDF_TANZER_REVIEW as ReviewOther
	FROM [MAS_POL].dbo.CI_Item
	WHERE ItemCode = @ItemCode
END
