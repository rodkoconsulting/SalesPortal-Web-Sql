/****** Object:  Table [dbo].[PortalOrderDetail_Previous]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalOrderDetail_Previous](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[SalesOrderNo] [varchar](7) NOT NULL,
	[LineKey] [varchar](3) NOT NULL,
	[ItemCode] [varchar](30) NULL,
	[Quantity] [decimal](15, 6) NOT NULL,
	[Price] [decimal](15, 6) NOT NULL,
	[Total] [decimal](11, 2) NOT NULL,
	[Comment] [varchar](2048) NULL,
 CONSTRAINT [PK__PortalOrderDetailPrevious] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[SalesOrderNo] ASC,
	[LineKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
