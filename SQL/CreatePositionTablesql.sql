USE [EmpSearch]
GO

/****** Object:  Table [dbo].[Position]    Script Date: 1/25/2026 12:57:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Position](
	[Position_Key] [int] IDENTITY(1,1) NOT NULL,
	[Company_Key] [int] NOT NULL,
	[Position] [nchar](200) NOT NULL,
	[Note] [nvarchar](MAX) NOT NULL,
	[Rate] [nchar](25) NOT NULL,
	[Link] [nvarchar](MAX) NOT NULL,
	[ApplicationDate] [datetime2](7) NOT NULL,
	[LastContactDate] [datetime2](7) NOT NULL,
	[Status] [nchar](10) NOT NULL,
	[StatusDate] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO


