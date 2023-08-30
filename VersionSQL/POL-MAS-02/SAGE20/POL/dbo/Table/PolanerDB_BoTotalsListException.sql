/****** Object:  Table [dbo].[PolanerDB_BoTotalsListException]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PolanerDB_BoTotalsListException](
	[Timestamp] [datetime] NOT NULL,
	[SalesOrderNo] [varchar](7) NOT NULL,
	[ItemCode] [varchar](30) NULL,
	[Qty] [int] NULL,
	[Allocated] [varchar](1) NULL
) ON [PRIMARY]
