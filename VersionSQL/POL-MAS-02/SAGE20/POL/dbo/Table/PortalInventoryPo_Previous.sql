/****** Object:  Table [dbo].[PortalInventoryPo_Previous]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalInventoryPo_Previous](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ItemCode] [varchar](30) NOT NULL,
	[PurchaseOrderNo] [varchar](7) NOT NULL,
	[OnPo] [float] NOT NULL,
	[Eta] [datetime] NOT NULL,
	[PoDate] [datetime] NOT NULL,
	[PoCmt] [varchar](25) NOT NULL,
 CONSTRAINT [PK__PortalIn__7FDDF1136F8A7843] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[ItemCode] ASC,
	[PurchaseOrderNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PortalInventoryPo_Previous] ADD  CONSTRAINT [DF_PortalInventoryPo_Previous_PoCmt]  DEFAULT ('') FOR [PoCmt]
