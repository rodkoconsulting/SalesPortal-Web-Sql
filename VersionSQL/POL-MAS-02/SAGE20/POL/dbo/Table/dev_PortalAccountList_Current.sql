/****** Object:  Table [dbo].[dev_PortalAccountList_Current]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[dev_PortalAccountList_Current](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ARDivisionNo] [varchar](2) NOT NULL,
	[CustomerNo] [varchar](20) NOT NULL,
	[CustomerName] [varchar](30) NULL,
	[ShipDays] [char](5) NOT NULL,
	[PriceLevel] [char](1) NOT NULL,
	[CoopList] [varchar](20) NOT NULL,
	[Status] [varchar](2) NOT NULL,
	[Buyer1] [varchar](25) NOT NULL,
	[Buyer2] [varchar](25) NOT NULL,
	[Buyer3] [varchar](25) NOT NULL,
	[Buyer1Phone] [varchar](20) NOT NULL,
	[Buyer2Phone] [varchar](20) NOT NULL,
	[Buyer3Phone] [varchar](20) NOT NULL,
	[Buyer1Email] [varchar](35) NOT NULL,
	[Buyer2Email] [varchar](35) NOT NULL,
	[Buyer3Email] [varchar](35) NOT NULL,
	[Affil] [varchar](25) NOT NULL,
	[Addr1] [varchar](30) NOT NULL,
	[Addr2] [varchar](30) NOT NULL,
	[City] [varchar](20) NOT NULL,
	[State] [char](2) NOT NULL,
	[Zip] [varchar](10) NOT NULL,
	[Rep] [char](4) NOT NULL,
	[Region] [char](3) NOT NULL,
	[LastOrdered] [datetime] NULL,
	[PrimaryShipTo] [varchar](4) NOT NULL,
	[ShipVia] [varchar](12) NOT NULL,
 CONSTRAINT [PK__dev_PortalAc__D38DF47355D59338] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[ARDivisionNo] ASC,
	[CustomerNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[dev_PortalAccountList_Current] ADD  CONSTRAINT [DF_dev_PortalAccountList_Current_PrimaryShipTo]  DEFAULT ((0)) FOR [PrimaryShipTo]
ALTER TABLE [dbo].[dev_PortalAccountList_Current] ADD  CONSTRAINT [DF_dev_PortalAccountList_Current_ShipVia]  DEFAULT ('FDL') FOR [ShipVia]
