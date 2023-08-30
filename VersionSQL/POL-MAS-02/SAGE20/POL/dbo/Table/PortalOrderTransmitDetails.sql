/****** Object:  Table [dbo].[PortalOrderTransmitDetails]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalOrderTransmitDetails](
	[ORDERNO] [bigint] NOT NULL,
	[ITEMCODE] [varchar](15) NOT NULL,
	[Price] [decimal](16, 6) NOT NULL,
	[MoboList] [varchar](40) NULL,
	[Bottles] [int] NOT NULL,
	[MoboTotal] [int] NOT NULL,
	[IsOverride] [bit] NOT NULL,
 CONSTRAINT [PK_PortalOrderTransmitDetails] PRIMARY KEY CLUSTERED 
(
	[ORDERNO] ASC,
	[ITEMCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
