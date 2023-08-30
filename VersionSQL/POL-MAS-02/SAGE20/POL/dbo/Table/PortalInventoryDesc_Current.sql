/****** Object:  Table [dbo].[PortalInventoryDesc_Current]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalInventoryDesc_Current](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ItemCode] [varchar](30) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[Brand] [varchar](50) NOT NULL,
	[MasterVendor] [varchar](40) NOT NULL,
	[Vintage] [varchar](4) NOT NULL,
	[Uom] [varchar](4) NOT NULL,
	[BottleSize] [varchar](10) NOT NULL,
	[DamagedNotes] [varchar](30) NOT NULL,
	[Closure] [varchar](20) NOT NULL,
	[WineType] [varchar](40) NOT NULL,
	[Varietal] [varchar](40) NOT NULL,
	[Organic] [varchar](10) NOT NULL,
	[Biodynamic] [varchar](10) NOT NULL,
	[SampleFocus] [varchar](1) NOT NULL,
	[Country] [varchar](20) NOT NULL,
	[Region] [varchar](40) NOT NULL,
	[Appellation] [varchar](50) NOT NULL,
	[RestrictOffSale] [varchar](1) NOT NULL,
	[RestrictOffSaleNotes] [varchar](30) NOT NULL,
	[RestrictOnPremise] [varchar](1) NOT NULL,
	[RestrictAllocated] [varchar](1) NOT NULL,
	[RestrictApproval] [varchar](20) NOT NULL,
	[RestrictMaxCases] [varchar](5) NOT NULL,
	[RestrictState] [varchar](20) NOT NULL,
	[RestrictSamples] [varchar](1) NOT NULL,
	[RestrictBo] [varchar](1) NOT NULL,
	[Upc] [varchar](13) NOT NULL,
	[ScoreWA] [varchar](20) NOT NULL,
	[ScoreWS] [varchar](20) NOT NULL,
	[ScoreIWC] [varchar](20) NOT NULL,
	[ScoreBH] [varchar](20) NOT NULL,
	[ScoreVM] [varchar](20) NOT NULL,
	[ScoreOther] [varchar](20) NOT NULL,
	[RestrictMo] [varchar](1) NOT NULL,
	[ReceiptDate] [datetime] NULL,
	[Regen] [varchar](1) NOT NULL,
	[Natural] [varchar](1) NOT NULL,
	[Vegan] [varchar](1) NOT NULL,
	[HVE] [varchar](1) NOT NULL,
 CONSTRAINT [PK__PortalIn__8DDEE42D36870511] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[ItemCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PortalInventoryDesc_Current] ADD  CONSTRAINT [DF__PortalInv__Restr__1A3FCC1E]  DEFAULT ('') FOR [RestrictMo]
ALTER TABLE [dbo].[PortalInventoryDesc_Current] ADD  CONSTRAINT [DF_PortalInventoryDesc_Current_Regen]  DEFAULT ('N') FOR [Regen]
ALTER TABLE [dbo].[PortalInventoryDesc_Current] ADD  CONSTRAINT [DF_PortalInventoryDesc_Current_Natural]  DEFAULT ('N') FOR [Natural]
ALTER TABLE [dbo].[PortalInventoryDesc_Current] ADD  CONSTRAINT [DF_PortalInventoryDesc_Current_Vegan]  DEFAULT ('N') FOR [Vegan]
ALTER TABLE [dbo].[PortalInventoryDesc_Current] ADD  CONSTRAINT [DF_PortalInventoryDesc_Current_HVE]  DEFAULT ('N') FOR [HVE]
