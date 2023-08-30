/****** Object:  Table [dbo].[PortalExportLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalExportLog](
	[Date] [datetime] NOT NULL,
	[Id] [varchar](50) NOT NULL,
	[Customer] [varchar](9) NULL
) ON [PRIMARY]
