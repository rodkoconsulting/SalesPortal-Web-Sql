/****** Object:  Table [dbo].[PortalImportLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalImportLog](
	[ORDERNO] [nvarchar](10) NOT NULL,
	[TIMESTAMP] [datetime] NOT NULL,
	[NOTES] [nvarchar](50) NOT NULL
) ON [PRIMARY]
