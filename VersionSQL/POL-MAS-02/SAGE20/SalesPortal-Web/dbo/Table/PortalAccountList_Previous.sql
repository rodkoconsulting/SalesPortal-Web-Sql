/****** Object:  Table [dbo].[PortalAccountList_Previous]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalAccountList_Previous](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ARDivisionNo] [varchar](2) NOT NULL,
	[CustomerNo] [varchar](20) NOT NULL,
	[CustomerName] [varchar](50) NULL,
	[ShipDays] [varchar](5) NOT NULL,
	[PriceLevel] [varchar](1) NOT NULL,
	[CoopList] [varchar](40) NOT NULL,
	[Status] [varchar](2) NOT NULL,
	[Buyer1] [varchar](25) NOT NULL,
	[Buyer2] [varchar](25) NOT NULL,
	[Buyer3] [varchar](25) NOT NULL,
	[Buyer1Phone] [varchar](20) NOT NULL,
	[Buyer2Phone] [varchar](20) NOT NULL,
	[Buyer3Phone] [varchar](20) NOT NULL,
	[Buyer1Email] [varchar](40) NOT NULL,
	[Buyer2Email] [varchar](40) NOT NULL,
	[Buyer3Email] [varchar](40) NOT NULL,
	[Affil] [varchar](25) NOT NULL,
	[Addr1] [varchar](40) NOT NULL,
	[Addr2] [varchar](40) NOT NULL,
	[City] [varchar](40) NOT NULL,
	[State] [varchar](2) NOT NULL,
	[Zip] [varchar](10) NOT NULL,
	[Rep] [varchar](4) NOT NULL,
	[Region] [varchar](3) NOT NULL,
	[PrimaryShipTo] [varchar](4) NOT NULL,
	[ShipVia] [varchar](15) NOT NULL,
 CONSTRAINT [PK__PortalAccountList_Previous] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[ARDivisionNo] ASC,
	[CustomerNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PortalAccountList_Previous] ADD  CONSTRAINT [DF_PortalAccountList_Previous_PrimaryShipTo]  DEFAULT ((0)) FOR [PrimaryShipTo]
ALTER TABLE [dbo].[PortalAccountList_Previous] ADD  CONSTRAINT [DF_PortalAccountList_Previous_ShipVia]  DEFAULT ('FDL') FOR [ShipVia]
