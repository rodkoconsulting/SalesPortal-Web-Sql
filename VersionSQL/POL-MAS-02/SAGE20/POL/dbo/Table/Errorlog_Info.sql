/****** Object:  Table [dbo].[Errorlog_Info]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Errorlog_Info](
	[ErrorCode] [int] NOT NULL,
	[ErrorDescription] [nvarchar](100) NOT NULL,
	[ErrorLevel] [nchar](10) NOT NULL,
	[ImportLine] [char](1) NOT NULL,
	[HoldOrder] [char](1) NOT NULL,
	[CauseDescription] [nvarchar](100) NOT NULL
) ON [PRIMARY]

CREATE CLUSTERED INDEX [IDX_ErrorCode] ON [dbo].[Errorlog_Info]
(
	[ErrorCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
