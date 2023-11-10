/****** Object:  Table [dbo].[PortalSampleOrderHeader_Previous]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalSampleOrderHeader_Previous](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ShipToCode] [varchar](4) NOT NULL,
	[OrderRep] [varchar](4) NOT NULL,
	[PurchaseOrderNo] [varchar](7) NOT NULL,
	[Date] [datetime] NULL,
	[isPosted] [int] NOT NULL,
 CONSTRAINT [PK__PortalSampleOrderHeader_Previous] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[PurchaseOrderNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PortalSampleOrderHeader_Previous] ADD  CONSTRAINT [DF_PortalSampleOrderHeader_Previous_isInvoiced]  DEFAULT ((1)) FOR [isPosted]
