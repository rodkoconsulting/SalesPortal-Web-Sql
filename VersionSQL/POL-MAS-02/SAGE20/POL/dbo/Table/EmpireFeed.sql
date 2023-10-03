/****** Object:  Table [dbo].[EmpireFeed]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmpireFeed](
	[Brand] [varchar](50) NOT NULL,
 CONSTRAINT [PK_EmpireFeed] PRIMARY KEY CLUSTERED 
(
	[Brand] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
