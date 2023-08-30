/****** Object:  Table [dbo].[AR_NYSLA]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AR_NYSLA](
	[LICENSE_NUMBER] [varchar](7) NOT NULL,
	[LICENSE_TYPE_NAME] [varchar](30) NOT NULL,
	[LICENSE_CLASS] [varchar](3) NOT NULL,
	[LICENSE_TYPE_CODE] [varchar](3) NOT NULL,
	[COUNTY] [varchar](20) NOT NULL,
	[NAME_PREMISES] [varchar](50) NOT NULL,
	[NAME_DBA] [varchar](50) NULL,
	[ADDRESS1] [varchar](50) NOT NULL,
	[ADDRESS2] [varchar](50) NULL,
	[CITY] [varchar](25) NOT NULL,
	[STATE] [varchar](2) NOT NULL,
	[ZIP] [varchar](9) NOT NULL,
	[DATE_ISSUE] [varchar](10) NOT NULL,
	[DATE_EFFECTIVE] [varchar](10) NOT NULL,
	[DATE_EXPIRATION] [varchar](10) NOT NULL
) ON [PRIMARY]
