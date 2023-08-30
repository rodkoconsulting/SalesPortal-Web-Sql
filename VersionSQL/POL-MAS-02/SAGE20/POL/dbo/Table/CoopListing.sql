/****** Object:  Table [dbo].[CoopListing]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CoopListing](
	[Cooperative Purchasing Group Name] [nvarchar](255) NULL,
	[Contact Name] [nvarchar](255) NULL,
	[Mailing Address for Co-Op Group] [nvarchar](255) NULL,
	[Permit Number] [nvarchar](255) NULL,
	[License Number] [nvarchar](255) NULL,
	[License Type] [nvarchar](255) NULL,
	[DBA t/a] [nvarchar](255) NULL,
	[Licensee] [nvarchar](255) NULL,
	[Member Effective Date] [datetime] NULL
) ON [PRIMARY]
