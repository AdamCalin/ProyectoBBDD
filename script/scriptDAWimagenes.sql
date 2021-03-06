USE [DAW]
GO
/****** Object:  View [dbo].[V_TIENDA]    Script Date: 30/05/2022 16:29:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_TIENDA]
AS
SELECT        dbo.ARTICULOS.DESCRIPCION, dbo.ARTICULOS.PRECIO, dbo.ROPA.TALLA, dbo.ROPA.COLOR, dbo.ROPA.IMAGEN, dbo.ARTICULOS.SEXO
FROM            dbo.ARTICULOS INNER JOIN
                         dbo.ROPA ON dbo.ARTICULOS.ID_ARTICULO = dbo.ROPA.ID_ARTICULO
GO
/****** Object:  Table [dbo].[ARTICULOS]    Script Date: 30/05/2022 16:29:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARTICULOS](
	[ID_ARTICULO] [int] IDENTITY(1,1) NOT NULL,
	[DESCRIPCION] [varchar](50) NULL,
	[FABRICANTE] [varchar](50) NULL,
	[PESO] [int] NULL,
	[ALTO] [int] NULL,
	[LARGO] [int] NULL,
	[ANCHO] [int] NULL,
	[PRECIO] [decimal](10, 2) NULL,
	[N_REGISTRO] [varchar](50) NULL,
	[SEXO] [char](1) NULL,
 CONSTRAINT [PK_ARTICULOS] PRIMARY KEY CLUSTERED 
(
	[ID_ARTICULO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PERFILES]    Script Date: 30/05/2022 16:29:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PERFILES](
	[ID_PERFIL] [int] IDENTITY(1,1) NOT NULL,
	[PERFIL] [varchar](50) NULL,
	[PERMISOS] [varchar](50) NULL,
 CONSTRAINT [PK_PERFILES] PRIMARY KEY CLUSTERED 
(
	[ID_PERFIL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ROPA]    Script Date: 30/05/2022 16:29:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROPA](
	[ID_ROPA] [int] IDENTITY(1,1) NOT NULL,
	[ID_ARTICULO] [int] NOT NULL,
	[TALLA] [char](1) NULL,
	[COLOR] [varchar](50) NULL,
	[IMAGEN] [varchar](max) NULL,
 CONSTRAINT [PK_ROPA] PRIMARY KEY CLUSTERED 
(
	[ID_ROPA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ARTICULOS]  WITH CHECK ADD  CONSTRAINT [FK_ARTICULOS_ARTICULOS] FOREIGN KEY([ID_ARTICULO])
REFERENCES [dbo].[ARTICULOS] ([ID_ARTICULO])
GO
ALTER TABLE [dbo].[ARTICULOS] CHECK CONSTRAINT [FK_ARTICULOS_ARTICULOS]
GO
ALTER TABLE [dbo].[ROPA]  WITH CHECK ADD  CONSTRAINT [FK_ROPA_ARTICULOS] FOREIGN KEY([ID_ARTICULO])
REFERENCES [dbo].[ARTICULOS] ([ID_ARTICULO])
GO
ALTER TABLE [dbo].[ROPA] CHECK CONSTRAINT [FK_ROPA_ARTICULOS]
GO
/****** Object:  StoredProcedure [dbo].[PA_CREAR_ARTICULO]    Script Date: 30/05/2022 16:29:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PA_CREAR_ARTICULO]
(  
 
 @DESCRIPCION VARCHAR(50),  
 @FABRICANTE VARCHAR(50),
 @PESO INT,  
 @LARGO INT,
 @ANCHO INT,  
 @ALTO INT,
 @PRECIO DECIMAL(10, 2), 
 @TALLA CHAR(1),
 @COLOR VARCHAR(50),
 @N_REGISTRO VARCHAR(50),
 @IMAGEN VARCHAR(100),
 @SEXO CHAR(1),

  
 @MENSAJE VARCHAR(100) OUTPUT,  
 @RETCODE INT OUTPUT,
 @ID_ARTICULO INT OUTPUT
)  
AS  
  
BEGIN TRY  
   

   SET @RETCODE = 0
   SET @MENSAJE = ''
   
 IF ISNULL(@N_REGISTRO,'') = ''  
 BEGIN  
  SET  @RETCODE = 10  
  SET @MENSAJE = 'El parametro n_registro no puede ser vacío'  
  RETURN  
 END  

  
  
 INSERT INTO ARTICULOS  
 (  
	DESCRIPCION,
	FABRICANTE,
	PESO,
	LARGO,
	ANCHO,
	ALTO,
	PRECIO,
	N_REGISTRO,
	SEXO
 )  
 VALUES  
 (  
	@DESCRIPCION,
	@FABRICANTE,
	@PESO,
	@LARGO,
	@ANCHO,
	@ALTO,
	@PRECIO,
	@N_REGISTRO,
	@SEXO
	 
 )

 SET @ID_ARTICULO =  SCOPE_IDENTITY()

 SELECT @ID_ARTICULO = MAX(ID_ARTICULO) FROM ARTICULOS

 INSERT INTO ROPA 
 (
	ID_ARTICULO,
	TALLA,
	COLOR,
	IMAGEN
 )
 VALUES
 ( 
	@ID_ARTICULO,
	@TALLA,
	@COLOR,
	@IMAGEN
 )
 RETURN   
  
END TRY  
  
BEGIN CATCH  
  
END CATCH
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -384
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ARTICULOS"
            Begin Extent = 
               Top = 390
               Left = 38
               Bottom = 520
               Right = 246
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ROPA"
            Begin Extent = 
               Top = 390
               Left = 284
               Bottom = 520
               Right = 492
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_TIENDA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_TIENDA'
GO
