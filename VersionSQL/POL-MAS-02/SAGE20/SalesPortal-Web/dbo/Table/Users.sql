/****** Object:  Table [dbo].[Users]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Users](
	[UserName] [nvarchar](25) NOT NULL,
	[AccountType] [nvarchar](10) NOT NULL,
	[RepCode] [varchar](10) NULL,
	[FullName] [nvarchar](25) NULL
) ON [PRIMARY]
