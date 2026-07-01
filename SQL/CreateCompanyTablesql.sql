USE [EmpSearch]
GO

/****** Object:  Table [dbo].[Company]    Script Date: 1/26/2026 9:40:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Company](
	[Company_Key] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nchar](50) NOT NULL,
	[Phone] [nchar](13) NOT NULL,
	[Link] [nvarchar](max) NOT NULL,
	[Address1] [nchar](50) NOT NULL,
	[Address2] [nchar](50) NOT NULL,
	[City] [nchar](30) NOT NULL,
	[State] [nchar](2) NOT NULL,
	[Zip] [nchar](10) NOT NULL,
	[Comment][nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


