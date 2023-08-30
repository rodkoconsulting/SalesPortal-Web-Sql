﻿/****** Object:  Table [dbo].[PortalSampleAddresses_Current]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalSampleAddresses_Current](
	[TimeSync] [datetime] NOT NULL,
	[RepCode] [varchar](4) NOT NULL,
	[ShipToRep] [varchar](4) NOT NULL,
	[ShipToCode] [varchar](4) NOT NULL,
	[ShipToName] [varchar](30) NULL,
	[ShipToAddress] [varchar](60) NULL,
	[RepRegion] [varchar](3) NOT NULL,
	[isUser] [int] NOT NULL,
	[isActive] [int] NOT NULL,
 CONSTRAINT [PK__PortalSa__9C9751030F4E07B6] PRIMARY KEY CLUSTERED 
(
	[RepCode] ASC,
	[ShipToCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
