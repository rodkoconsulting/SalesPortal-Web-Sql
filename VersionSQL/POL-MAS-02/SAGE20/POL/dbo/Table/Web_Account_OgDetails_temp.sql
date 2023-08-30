/****** Object:  Table [dbo].[Web_Account_OgDetails_temp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Web_Account_OgDetails_temp](
	[ORDERNO] [bigint] NOT NULL,
	[ITEMCODE] [varchar](15) NOT NULL,
	[PriceCase] [decimal](16, 6) NOT NULL,
	[PriceBottle] [decimal](16, 6) NOT NULL,
	[DiscountCase] [decimal](16, 6) NOT NULL,
	[DiscountBottle] [decimal](16, 6) NOT NULL,
	[DiscountList] [varchar](30) NOT NULL,
	[MoboList] [varchar](40) NULL,
	[LastInvoiceDate] [datetime] NULL,
	[LastQuantityShipped] [decimal](36, 6) NULL,
	[LastPrice] [decimal](16, 6) NULL,
	[Cases] [int] NOT NULL,
	[Bottles] [int] NOT NULL,
	[UnitPriceCase] [decimal](16, 6) NOT NULL,
	[UnitPriceBottle] [decimal](16, 6) NOT NULL,
	[Total] [decimal](16, 2) NOT NULL,
	[MoboTotal] [int] NOT NULL,
	[IsOverride] [bit] NOT NULL,
	[IsMix] [bit] NOT NULL,
 CONSTRAINT [PK_Web_Account_OgDetails_temp] PRIMARY KEY CLUSTERED 
(
	[ORDERNO] ASC,
	[ITEMCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
