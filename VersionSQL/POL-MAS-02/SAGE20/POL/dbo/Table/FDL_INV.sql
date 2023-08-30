/****** Object:  Table [dbo].[FDL_INV]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[FDL_INV](
	[ItemCode] [varchar](30) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[Quantity] [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
