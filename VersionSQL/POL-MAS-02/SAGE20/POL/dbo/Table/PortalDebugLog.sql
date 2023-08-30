/****** Object:  Table [dbo].[PortalDebugLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalDebugLog](
	[Date] [datetime] NOT NULL,
	[OrderNo] [bigint] NOT NULL,
	[Account] [varchar](15) NOT NULL,
	[LastMessage] [varchar](50) NOT NULL
) ON [PRIMARY]
