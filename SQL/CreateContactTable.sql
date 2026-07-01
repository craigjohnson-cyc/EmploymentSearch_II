USE [EmpSearch]
GO

/****** Object:  Table [dbo].[Contact]    Script Date: 1/26/2026 9:38:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Contact](
	[Contact_Key] [int] IDENTITY(1,1) NOT NULL,
	[Position_Key] [int] NOT NULL,
	[Person_Key] [int] NOT NULL,
	[ContactMethod] [nchar] (5) NOT NULL,
	[ContactDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


