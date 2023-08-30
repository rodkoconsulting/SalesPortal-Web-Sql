/****** Object:  Table [dbo].[PolanerDB_BoListException]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PolanerDB_BoListException](
	[TimeStamp] [datetime] NOT NULL,
	[SalesOrderNo] [varchar](7) NOT NULL,
	[ItemCode] [varchar](30) NULL
) ON [PRIMARY]
