/****** Object:  Table [dbo].[SLA_Inactive]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SLA_Inactive](
	[SerialNumber] [varchar](7) NOT NULL,
	[County] [varchar](4) NOT NULL,
	[LicenseTypeCode] [varchar](3) NOT NULL,
	[LicenseClassCode] [varchar](3) NOT NULL,
	[PremiseName] [varchar](50) NOT NULL,
	[Dba] [varchar](50) NOT NULL,
	[PremiseAddress] [varchar](50) NOT NULL,
	[PremiseCity] [varchar](50) NOT NULL,
	[PremiseState] [varchar](2) NOT NULL,
	[PremiseZip] [varchar](5) NOT NULL,
	[DateInactive] [varchar](9) NOT NULL,
	[Zone] [varchar](1) NOT NULL,
	[CountyName] [varchar](25) NOT NULL,
	[CertificateNumber] [varchar](6) NOT NULL,
	[MethodOfOperation] [varchar](50) NOT NULL,
	[DaysHoursOfOperation] [varchar](50) NOT NULL,
	[Other] [varchar](50) NOT NULL,
	[EffectiveDate] [varchar](9) NOT NULL,
	[LicenseIssueDate] [varchar](9) NOT NULL,
	[ExpirationDate] [varchar](9) NOT NULL,
	[OriginalDate] [varchar](9) NOT NULL,
	[ReceivedDate] [varchar](9) NOT NULL
) ON [PRIMARY]
