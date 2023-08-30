/****** Object:  Table [dbo].[AccountsWebsitePipeline]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AccountsWebsitePipeline](
	[ref_id] [nvarchar](255) NULL,
	[nm] [nvarchar](255) NULL,
	[num] [nvarchar](255) NULL,
	[status] [bit] NOT NULL,
	[sys_create_date] [datetime] NULL
) ON [PRIMARY]
