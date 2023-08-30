/****** Object:  Table [dbo].[AchInfo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AchInfo](
	[CustNo] [varchar](50) NULL,
	[RoutingNo] [varchar](50) NULL,
	[AccountNo] [varchar](50) NULL,
	[BankName] [varchar](50) NULL
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE CLUSTERED INDEX [IDX_CustNo] ON [dbo].[AchInfo]
(
	[CustNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
