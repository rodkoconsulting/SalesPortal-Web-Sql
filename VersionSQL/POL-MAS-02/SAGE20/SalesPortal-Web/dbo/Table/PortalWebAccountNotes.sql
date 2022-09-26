/****** Object:  Table [dbo].[PortalWebAccountNotes]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PortalWebAccountNotes](
	[ARDivisionNo] [char](2) NOT NULL,
	[CustomerNo] [varchar](10) NOT NULL,
	[Notes] [nvarchar](max) NULL,
 CONSTRAINT [PK_PortalWebAccountNotes] PRIMARY KEY CLUSTERED 
(
	[ARDivisionNo] ASC,
	[CustomerNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
