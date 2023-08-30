/****** Object:  Table [dbo].[AR_PA_INV]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AR_PA_INV](
	[Blank] [varchar](1) NOT NULL,
	[Invoice] [varchar](15) NOT NULL,
	[InvoiceDate] [date] NULL,
	[Type] [varchar](15) NULL,
	[Amount] [varchar](15) NULL,
	[Due] [varchar](15) NULL,
	[Status] [varchar](15) NULL,
	[DueDate] [date] NULL
) ON [PRIMARY]
