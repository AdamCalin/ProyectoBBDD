USE [DAW]
GO
/****** Object:  Table [dbo].[PEDIDOS]    Script Date: 27/05/2022 15:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PEDIDOS](
	[ID_PEDIDO] [int] IDENTITY(1,1) NOT NULL,
	[ID_ARTICULO] [int] NULL,
	[CANTIDAD] [int] NULL,
	[PRECIO] [decimal](10, 2) NULL,
 CONSTRAINT [PK_PEDIDOS] PRIMARY KEY CLUSTERED 
(
	[ID_PEDIDO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PEDIDOS]  WITH CHECK ADD  CONSTRAINT [FK__PEDIDOS__ID_ARTI__3F115E1A] FOREIGN KEY([ID_ARTICULO])
REFERENCES [dbo].[ARTICULOS] ([ID_ARTICULO])
GO
ALTER TABLE [dbo].[PEDIDOS] CHECK CONSTRAINT [FK__PEDIDOS__ID_ARTI__3F115E1A]
GO
ALTER TABLE [dbo].[PEDIDOS]  WITH CHECK ADD  CONSTRAINT [fk_ID_ARTICULO] FOREIGN KEY([ID_ARTICULO])
REFERENCES [dbo].[ARTICULOS] ([ID_ARTICULO])
GO
ALTER TABLE [dbo].[PEDIDOS] CHECK CONSTRAINT [fk_ID_ARTICULO]
GO
ALTER TABLE [dbo].[PEDIDOS]  WITH CHECK ADD  CONSTRAINT [FK_PEDIDOS_ARTICULOS] FOREIGN KEY([ID_ARTICULO])
REFERENCES [dbo].[ARTICULOS] ([ID_ARTICULO])
GO
ALTER TABLE [dbo].[PEDIDOS] CHECK CONSTRAINT [FK_PEDIDOS_ARTICULOS]
GO
