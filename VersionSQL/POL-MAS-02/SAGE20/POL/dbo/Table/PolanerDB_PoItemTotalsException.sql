/****** Object:  Table [dbo].[PolanerDB_PoItemTotalsException]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PolanerDB_PoItemTotalsException](
	[TimeStamp] [datetime] NOT NULL,
	[PurchaseOrderNo] [varchar](7) NOT NULL,
	[ItemCode] [varchar](30) NULL,
	[Qty] [int] NULL
) ON [PRIMARY]
