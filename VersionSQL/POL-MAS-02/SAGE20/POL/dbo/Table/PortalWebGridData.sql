/****** Object:  Table [dbo].[PortalWebGridData]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalWebGridData](
	[username] [varchar](25) NOT NULL,
	[gridname] [varchar](25) NOT NULL,
	[griddata] [varchar](max) NULL,
 CONSTRAINT [PK__PortalWe__294BB5932AF6222B] PRIMARY KEY CLUSTERED 
(
	[username] ASC,
	[gridname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
