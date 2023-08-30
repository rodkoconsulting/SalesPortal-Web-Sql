/****** Object:  Table [dbo].[Web_MasFlags]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Web_MasFlags](
	[IsMasActive] [bit] NOT NULL,
	[CutOffTime] [varchar](8) NOT NULL,
	[CutOffTimeDefault] [varchar](8) NOT NULL,
	[ID] [smallint] NOT NULL,
	[CutOffTimeSamples] [varchar](8) NULL,
	[DisableTime] [datetime] NULL
) ON [PRIMARY]
