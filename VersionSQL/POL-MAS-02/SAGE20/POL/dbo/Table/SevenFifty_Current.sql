/****** Object:  Table [dbo].[SevenFifty_Current]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SevenFifty_Current](
	[SKU] [varchar](15) NOT NULL,
	[Status] [varchar](20) NOT NULL,
	[Importer/Supplier] [varchar](25) NULL,
	[Product Type] [varchar](5) NOT NULL,
	[Product Subtype] [varchar](9) NOT NULL,
	[Product Style] [varchar](8000) NULL,
	[Producer Name] [varchar](50) NULL,
	[Product Name] [varchar](8000) NULL,
	[Vintage] [varchar](4) NULL,
	[Grapes & Raw Materials] [varchar](8000) NULL,
	[Country] [varchar](8000) NULL,
	[Region] [varchar](8000) NULL,
	[Appellation] [varchar](8000) NULL,
	[Description] [varchar](2002) NULL,
	[Features] [varchar](19) NULL,
	[Alcohol by volume] [decimal](5, 2) NULL,
	[Size] [varchar](15) NULL,
	[Size Unit] [varchar](15) NULL,
	[Container Type] [varchar](15) NOT NULL,
	[Case size] [varchar](8000) NULL,
	[Pricing] [varchar](40) NULL,
	[IsHidden] [varchar](10) NULL,
	[ImageURL] [varchar](83) NULL,
	[State] [nchar](1) NULL,
	[TTB] [varchar](14) NULL,
	[SkuPa] [varchar](15) NOT NULL
) ON [PRIMARY]
