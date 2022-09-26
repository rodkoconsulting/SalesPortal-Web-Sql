/****** Object:  Procedure [dbo].[PortalWebInventoryProc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PortalWebInventoryProc]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON
SELECT Main = (SELECT
	  [ItemCode] as Code
	  ,[Brand]
	  ,[Description] as [Desc]
	  ,[Vintage]
	  ,[Uom]
	  ,[BottleSize] as Size
	  ,[DamagedNotes] as DamNotes
	  ,[MasterVendor] as MVendor
	  ,[Closure]
	  ,[Type]
	  ,[Varietal]
	  ,[Organic] as Org
      ,[Biodynamic] as Bio
	  ,[Focus]
	  ,[Country]
	  ,[Region]
      ,[Appellation] as App
	  ,[RestrictOffSale] as RstOff
	  ,[RestrictOffSaleNotes] as RstOffNotes
	  ,[RestrictOnPremise] as RstPrem
	  ,[RestrictAllocated] as RstAllo
	  ,[RestrictApproval] as RstApp
	  ,[RestrictMaxCases] as RstMax
	  ,[RestrictState] as RstState
	  ,[RestrictSamples] as RstSam
	  ,[RestrictBo] as RstBo
	  ,[RestrictMo] as RstMo
	  ,[Core]
	  ,[FocusBm]
	  ,[Upc]
	  ,[ScoreWA]
      ,[ScoreWS]
      ,[ScoreIWC] as ScoreVFC
      ,[ScoreBH]
      ,[ScoreVM]
      ,[ScoreOther]
      ,[QtyAvailable] as QtyA
      ,[QtyOnHand] as QtyOh
      ,[OnSO] as OnSo
      ,[OnMO] as OnMo
      ,[OnBO] as OnBo
      ,[OnPoSort]
	  ,[Regen]
      ,[Nat]
      ,[Veg]
      ,[Hve]
      ,[Rcpt]
  FROM [SalesPortal-Web].[dbo].[PortalWebInventoryMain]
FOR JSON PATH
),
Price = (SELECT [ItemCode] as Code
      ,[Level]
      ,[Date]
      ,[Price]
      ,[Reduced] as Red
  FROM [SalesPortal-Web].[dbo].[PortalWebInventoryPrice]
FOR JSON PATH
),
Po = (SELECT
      [ItemCode] as Code
      ,[OnPO] as OnPo
      ,[RequiredDate] as EtaDate
      ,[PoDate]
  FROM [SalesPortal-Web].[dbo].[PortalWebInventoryPo]
FOR JSON PATH
)
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
END
