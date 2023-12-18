/****** Object:  Table [dbo].[PortalWebSampleSavedHeader]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE dbo.PortalWebSampleSavedHeader(
	[ORDERNO] [bigint] IDENTITY(1,1) NOT NULL,
	[USERNAME] [varchar](15) NOT NULL,
	[DATE_SAVED] [datetime] NOT NULL,
	[DATE_DELIVERY] [datetime] NOT NULL,
	[NOTES] [varchar](150) NULL,
	[SHIPTO] [varchar](4) NOT NULL,
 CONSTRAINT [PK__PortalWebSampleSavedHeader] PRIMARY KEY CLUSTERED 
(
	[ORDERNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
