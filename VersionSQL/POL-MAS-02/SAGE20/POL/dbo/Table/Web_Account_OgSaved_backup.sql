/****** Object:  Table [dbo].[Web_Account_OgSaved_backup]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Web_Account_OgSaved_backup](
	[CUSTOMERNO] [varchar](9) NOT NULL,
	[ITEMCODE] [varchar](15) NOT NULL,
	[ARDIVISIONNO] [char](2) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[Web_Account_OgSaved_backup] ADD  CONSTRAINT [DF_Web_Account_OgSaved_backup_ARDIVISIONNO]  DEFAULT ('00') FOR [ARDIVISIONNO]
