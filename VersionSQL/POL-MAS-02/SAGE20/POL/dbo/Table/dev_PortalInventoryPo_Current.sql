﻿/****** Object:  Table [dbo].[dev_PortalInventoryPo_Current]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[dev_PortalInventoryPo_Current](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ItemCode] [varchar](30) NOT NULL,
	[PurchaseOrderNo] [varchar](7) NOT NULL,
	[OnPo] [float] NOT NULL,
	[Eta] [datetime] NOT NULL,
	[PoDate] [datetime] NOT NULL,
	[PoCmt] [varchar](25) NOT NULL,
 CONSTRAINT [PK__dev_PortalIn__7FDDF1136BB9E75F] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[ItemCode] ASC,
	[PurchaseOrderNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[dev_PortalInventoryPo_Current] ADD  CONSTRAINT [DF_dev_PortalInventoryPo_Current_PoCmt]  DEFAULT ('') FOR [PoCmt]
