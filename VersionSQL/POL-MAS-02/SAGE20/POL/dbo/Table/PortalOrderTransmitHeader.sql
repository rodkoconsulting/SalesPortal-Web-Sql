/****** Object:  Table [dbo].[PortalOrderTransmitHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalOrderTransmitHeader](
	[ORDERNO] [bigint] IDENTITY(1,1) NOT NULL,
	[STATUS] [char](1) NOT NULL,
	[ORDERTYPE] [varchar](3) NULL,
	[CUSTOMERNO] [varchar](7) NOT NULL,
	[DELIVERYDAY] [datetime] NOT NULL,
	[NOTES] [varchar](150) NULL,
	[COOPNO] [varchar](8) NULL,
	[PONO] [varchar](25) NULL,
	[SHIPTO] [varchar](4) NOT NULL,
	[DIVISIONNO] [varchar](2) NOT NULL,
	[USERCODE] [varchar](25) NULL,
	[OrderId] [varchar](50) NULL,
 CONSTRAINT [PK__PortalOr__4918B2C139A368DE] PRIMARY KEY CLUSTERED 
(
	[ORDERNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PortalOrderTransmitHeader] ADD  CONSTRAINT [DF_PortalOrderTransmitHeader_SHIPTO]  DEFAULT ('') FOR [SHIPTO]
ALTER TABLE [dbo].[PortalOrderTransmitHeader] ADD  CONSTRAINT [DF_PortalOrderTransmitHeader_DIVISIONNO]  DEFAULT ((0)) FOR [DIVISIONNO]
