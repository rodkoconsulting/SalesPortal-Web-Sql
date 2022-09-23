/****** Object:  Procedure [dbo].[PortalWebInventoryProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebInventoryProc]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON
SELECT Main = (SELECT
	   [Focus]
      ,[ItemCode]
      ,[Brand]
      ,[Description]
      ,[Vintage]
      ,[Uom]
      ,[BottleSize]
      ,[DamagedNotes]
      ,[QtyAvailable]
      ,[QtyOnHand]
      ,[OnSO]
      ,[OnMO]
      ,[OnBO]
      ,[RestrictOffSale]
      ,[RestrictOnPremise]
      ,[RestrictOffSaleNotes]
      ,[RestrictAllocated]
      ,[RestrictApproval]
      ,[RestrictMaxCases]
      ,[RestrictState]
      ,[RestrictSamples]
      ,[RestrictBo]
      ,[RestrictMo]
      ,[Core]
      ,[Type]
      ,[Varietal]
      ,[Organic]
      ,[Biodynamic]
      ,[Country]
      ,[Region]
      ,[Appellation]
      ,[MasterVendor]
      ,[Closure]
      ,[Upc]
      ,[ScoreWA]
      ,[ScoreWS]
      ,[ScoreIWC]
      ,[ScoreBH]
      ,[ScoreVM]
      ,[ScoreOther]
      ,[FocusBm]
      ,[OnPoSort]
	   ,[Regen]
      ,[Nat]
      ,[Veg]
      ,[Hve]
      ,[Rcpt]
  FROM [SalesPortal-Web].[dbo].[PortalWebInventoryMain]
FOR JSON PATH
),
Price = (SELECT [ItemCode]
      ,[Level]
      ,[Date]
      ,[Price]
      ,[Reduced]
  FROM [SalesPortal-Web].[dbo].[PortalWebInventoryPrice]
FOR JSON PATH
),
Po = (SELECT
[ItemCode]
      ,[OnPO]
      ,[RequiredDate]
      ,[PoDate]
  FROM [SalesPortal-Web].[dbo].[PortalWebInventoryPo]
FOR JSON PATH
)
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
