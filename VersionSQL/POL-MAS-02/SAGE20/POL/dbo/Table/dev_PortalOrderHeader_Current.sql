/****** Object:  Table [dbo].[dev_PortalOrderHeader_Current]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[dev_PortalOrderHeader_Current](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ARDivisionNo] [varchar](2) NOT NULL,
	[CustomerNo] [varchar](20) NOT NULL,
	[SalesOrderNo] [varchar](7) NOT NULL,
	[OrderDate] [datetime] NULL,
	[ShipExpireDate] [datetime] NULL,
	[OrderStatus] [varchar](1) NULL,
	[HoldCode] [varchar](5) NOT NULL,
	[CoopNo] [varchar](10) NULL,
	[Comment] [varchar](30) NULL,
	[ArrivalDate] [datetime] NULL,
	[ShipTo] [varchar](30) NOT NULL,
 CONSTRAINT [PK__dev_PortalOr__E526276B1F247CCC] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[SalesOrderNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[dev_PortalOrderHeader_Current] ADD  CONSTRAINT [DF_dev_PortalOrderHeader_Current_ShipTo]  DEFAULT ('') FOR [ShipTo]
