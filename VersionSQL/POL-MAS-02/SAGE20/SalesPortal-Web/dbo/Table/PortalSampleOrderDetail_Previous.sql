﻿/****** Object:  Table [dbo].[PortalSampleOrderDetail_Previous]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalSampleOrderDetail_Previous](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[PurchaseOrderNo] [varchar](7) NOT NULL,
	[LineKey] [varchar](3) NOT NULL,
	[ItemCode] [varchar](30) NULL,
	[Quantity] [decimal](15, 6) NOT NULL,
	[Comment] [varchar](2048) NULL,
 CONSTRAINT [PK__PortalSampleOrderDetail_Previous] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[PurchaseOrderNo] ASC,
	[LineKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
