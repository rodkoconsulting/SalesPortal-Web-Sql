/****** Object:  Table [dbo].[Web_Accounts_RepNotes]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Web_Accounts_RepNotes](
	[CustomerNo] [varchar](10) NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[ARDivisionNo] [char](2) NOT NULL,
 CONSTRAINT [PK__Web_Acco__A4AFBF6312FDD1B2] PRIMARY KEY CLUSTERED 
(
	[ARDivisionNo] ASC,
	[CustomerNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[Web_Accounts_RepNotes] ADD  CONSTRAINT [DF_Web_Accounts_RepNotes_ARDivisionNo]  DEFAULT ('00') FOR [ARDivisionNo]
