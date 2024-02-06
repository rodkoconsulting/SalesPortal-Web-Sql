/****** Object:  Table [dbo].[PortalWebSampleSavedDetails]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE dbo.PortalWebSampleSavedDetails(
	[ORDERNO] [bigint] NOT NULL,
	[ITEMCODE] [varchar](15) NOT NULL,
	[Bottles] [int] NOT NULL,
	[Comment] [varchar](100) NULL,
 CONSTRAINT [PK_PortalWebSampleSavedDetails] PRIMARY KEY CLUSTERED 
(
	[ORDERNO] ASC,
	[ITEMCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
