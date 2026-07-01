USE [EmpSearch]
GO

/****** Object:  Table [dbo].[Person]    Script Date: 1/26/2026 9:40:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Person](
	[Person_Key] [int] IDENTITY(1,1) NOT NULL,
	[Position_Key] [int] NOT NULL,
	[Company_Key] [int] NOT NULL,
	[Name] [nchar](50) NOT NULL,
	[PhoneOffice] [nchar](13) NOT NULL,
	[PhoneCell] [nchar](13) NOT NULL,
	[PreferedPhone] [nchar](06) NOT NULL,
	[PreferedContact] [nchar](06) NOT NULL,
	[Email] [nvarchar](max) NOT NULL,
	[LinkedIn] [nvarchar](max) NOT NULL,
	[Comment][nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


