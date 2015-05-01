USE [crud_delphi]
GO

/****** Object:  Table [dbo].[aluno]    Script Date: 05/01/2015 12:11:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[aluno](
	[matricula] [nchar](10) NOT NULL,
	[nome] [nchar](50) NULL,
	[curso] [nchar](30) NULL,
 CONSTRAINT [PK_aluno] PRIMARY KEY CLUSTERED 
(
	[matricula] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

