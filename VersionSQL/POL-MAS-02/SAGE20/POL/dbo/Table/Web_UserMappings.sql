/****** Object:  Table [dbo].[Web_UserMappings]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Web_UserMappings](
	[UserName] [nvarchar](25) NOT NULL,
	[AccountType] [nvarchar](10) NOT NULL,
	[RepCode] [varchar](10) NULL,
	[ZoomPercent] [decimal](18, 0) NOT NULL,
	[FullName] [nvarchar](25) NULL
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE CLUSTERED INDEX [indxUserMappings] ON [dbo].[Web_UserMappings]
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
