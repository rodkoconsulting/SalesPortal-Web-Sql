/****** Object:  Table [dbo].[CrystalParameters]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CrystalParameters](
	[ID] [int] NOT NULL,
	[ReportName] [nvarchar](255) NULL,
	[ParameterName] [nvarchar](255) NULL,
	[ParameterField] [nvarchar](255) NULL,
	[ParameterTable] [nvarchar](255) NULL,
	[ParameterAll] [bit] NOT NULL
) ON [PRIMARY]

CREATE UNIQUE CLUSTERED INDEX [IDX_ID] ON [dbo].[CrystalParameters]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
