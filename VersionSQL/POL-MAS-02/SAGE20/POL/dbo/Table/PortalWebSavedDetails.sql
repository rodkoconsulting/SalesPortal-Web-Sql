/****** Object:  Table [dbo].[PortalWebSavedDetails]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalWebSavedDetails](
	[ORDERNO] [bigint] NOT NULL,
	[ITEMCODE] [varchar](15) NOT NULL,
	[MoboList] [varchar](40) NULL,
	[Quantity] [decimal](9, 5) NOT NULL,
	[MoboTotal] [decimal](9, 5) NOT NULL,
	[Comment] [varchar](100) NULL,
 CONSTRAINT [PK_PortalWebSavedDetails] PRIMARY KEY CLUSTERED 
(
	[ORDERNO] ASC,
	[ITEMCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
