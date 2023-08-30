/****** Object:  Table [dbo].[ErrorLog_Data]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ErrorLog_Data](
	[LogID] [int] NOT NULL,
	[LineNumber] [int] NOT NULL,
	[OrderNumber] [varchar](10) NULL,
	[ItemNumber] [varchar](10) NULL,
	[ErrorNumber] [int] NOT NULL,
	[LogTimeStamp] [datetime] NOT NULL
) ON [PRIMARY]
