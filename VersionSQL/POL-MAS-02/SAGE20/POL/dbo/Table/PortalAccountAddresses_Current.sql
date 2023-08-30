/****** Object:  Table [dbo].[PortalAccountAddresses_Current]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalAccountAddresses_Current](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ARDivisionNo] [varchar](2) NOT NULL,
	[CustomerNo] [varchar](20) NOT NULL,
	[ShipToCode] [varchar](4) NOT NULL,
	[ShipToName] [varchar](30) NULL,
	[ShipToAddress] [varchar](60) NULL,
 CONSTRAINT [PK__PortalAccountAddresses_Current] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[ARDivisionNo] ASC,
	[CustomerNo] ASC,
	[ShipToCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
