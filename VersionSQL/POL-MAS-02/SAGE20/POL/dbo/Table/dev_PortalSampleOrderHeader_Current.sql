/****** Object:  Table [dbo].[dev_PortalSampleOrderHeader_Current]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[dev_PortalSampleOrderHeader_Current](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ShipToCode] [varchar](4) NOT NULL,
	[OrderRep] [varchar](4) NOT NULL,
	[PurchaseOrderNo] [varchar](7) NOT NULL,
	[Date] [datetime] NULL,
	[isPosted] [int] NOT NULL,
 CONSTRAINT [PK__dev_PortalSa__0E03773C2898D86D] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[PurchaseOrderNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[dev_PortalSampleOrderHeader_Current] ADD  CONSTRAINT [DF_dev_PortalSampleOrderHeader_Current_isPosted]  DEFAULT ((1)) FOR [isPosted]
