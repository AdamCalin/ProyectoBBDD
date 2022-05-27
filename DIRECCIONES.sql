USE [DAW]
GO

/****** Object:  Table [dbo].[DIRECCIONES]    Script Date: 27/05/2022 14:57:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DIRECCIONES](
	[ID_DIRECCION] [int] IDENTITY(1,1) NOT NULL,
	[ID_USUARIO] [int] NULL,
	[CALLE] [varchar](100) NULL,
	[PROVINCIA] [varchar](100) NULL,
	[POBLACION] [varchar](100) NULL,
	[CODIGO_POSTAL] [int] NULL,
	[NUMERO] [int] NULL,
	[PISO] [int] NULL,
	[PUERTA] [char](1) NULL,
	[PERSONA_CONTACTO] [varchar](100) NULL,
	[TELEFONO] [varchar](12) NULL,
 CONSTRAINT [PK_DIRECCIONES] PRIMARY KEY CLUSTERED 
(
	[ID_DIRECCION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DIRECCIONES]  WITH CHECK ADD  CONSTRAINT [FK_DIRECCIONES_USUARIOS] FOREIGN KEY([ID_USUARIO])
REFERENCES [dbo].[USUARIOS] ([ID_USUARIO])
GO

ALTER TABLE [dbo].[DIRECCIONES] CHECK CONSTRAINT [FK_DIRECCIONES_USUARIOS]
GO

