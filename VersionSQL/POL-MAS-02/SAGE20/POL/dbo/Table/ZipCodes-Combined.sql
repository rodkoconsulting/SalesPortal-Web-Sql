﻿/****** Object:  Table [dbo].[ZipCodes-Combined]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ZipCodes-Combined](
	[ZipCode] [char](5) NOT NULL,
	[City] [varchar](30) NULL,
	[Ship-Monday] [char](1) NOT NULL,
	[Ship-Tuesday] [char](1) NOT NULL,
	[Ship-Wednesday] [char](1) NOT NULL,
	[Ship-Thursday] [char](1) NOT NULL,
	[Ship-Friday] [char](1) NOT NULL,
	[Territory] [varchar](30) NOT NULL,
	[ShipVia] [varchar](15) NOT NULL,
	[County] [varchar](25) NOT NULL,
	[FDL Route] [varchar](50) NOT NULL
) ON [PRIMARY]
