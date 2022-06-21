USE [master]
GO
/****** Object:  User [##MS_PolicyEventProcessingLogin##]    Script Date: 21/06/2022 22:34:22 ******/
CREATE USER [##MS_PolicyEventProcessingLogin##] FOR LOGIN [##MS_PolicyEventProcessingLogin##] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [##MS_AgentSigningCertificate##]    Script Date: 21/06/2022 22:34:22 ******/
CREATE USER [##MS_AgentSigningCertificate##] FOR LOGIN [##MS_AgentSigningCertificate##]
GO
/****** Object:  DatabaseRole [db_executor]    Script Date: 21/06/2022 22:34:22 ******/
CREATE ROLE [db_executor]
GO
/****** Object:  Schema [db_executor]    Script Date: 21/06/2022 22:34:22 ******/
CREATE SCHEMA [db_executor]
GO
/****** Object:  XmlSchemaCollection [dbo].[SCHEMA_PAL]    Script Date: 21/06/2022 22:34:22 ******/
CREATE XML SCHEMA COLLECTION [dbo].[SCHEMA_PAL] AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified"><xsd:element name="r"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="i" type="xsd:string" minOccurs="0" maxOccurs="unbounded" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:schema>'
GO
/****** Object:  UserDefinedFunction [dbo].[FN_CONEXION_ACTUAL]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-----------------------------------------------------------------------------------------------------------------------------------------------------

	NOMBRE DE LA FUNCIÓN		FN_CONEXION_ACTUAL
	FECHA DE CREACIÓN: 		16/07/2020		
	AUTOR:				O.RODRIGO
	VSS:				ICP/CODIGO_SQL/ICPM/02. FUNCIONES

	FUNCIONAMIENTO:			NOS DEVUELVE LA CONEXIÓN ACTUAL 
		
					A NIVEL GENERAL, LO RECOMENDABLE SERÍA TRABAJAR SIEMPRE CON LAS TABLAS:
						ENTORNOS
						CONEXIONES 
						ENTORNOS_CONEXIONES

------------------------------------------------------------------------------------------------------------------------------------------------------*/

-- ██████╗ ███████╗███████╗████████╗██╗ ██████╗ ███╗   ██╗		██████╗ ███████╗███████╗██████╗ ███████╗		██╗███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗  ██╗   ██╗ ██████╗██████╗ ███╗   ███╗
--██╔════╝ ██╔════╝██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║		██╔══██╗██╔════╝██╔════╝██╔══██╗██╔════╝		██║██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗███║   ██║██╔════╝██╔══██╗████╗ ████║
--██║  ███╗█████╗  ███████╗   ██║   ██║██║   ██║██╔██╗ ██║		██║  ██║█████╗  ███████╗██║  ██║█████╗  		██║███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝╚██║   ██║██║     ██████╔╝██╔████╔██║
--██║   ██║██╔══╝  ╚════██║   ██║   ██║██║   ██║██║╚██╗██║		██║  ██║██╔══╝  ╚════██║██║  ██║██╔══╝  		██║╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗ ██║   ██║██║     ██╔═══╝ ██║╚██╔╝██║
--╚██████╔╝███████╗███████║   ██║   ██║╚██████╔╝██║ ╚████║		██████╔╝███████╗███████║██████╔╝███████╗		██║███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║ ██║██╗██║╚██████╗██║     ██║ ╚═╝ ██║
-- ╚═════╝ ╚══════╝╚══════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝		╚═════╝ ╚══════╝╚══════╝╚═════╝ ╚══════╝		╚═╝╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝ ╚═╝╚═╝╚═╝ ╚═════╝╚═╝     ╚═╝     ╚═╝

-- ¡¡¡ LOS CAMBIOS QUE SE REALICEN EN ESTA FUNCIÓN TENDRAN EFECTO EN VARIOS SERVIDORES !!!

CREATE FUNCTION [dbo].[FN_CONEXION_ACTUAL]()
RETURNS INT
BEGIN

	DECLARE	@ID_CONEXION INT
	
	SELECT 
		@ID_CONEXION = ID_CONEXION --NO DEBERÍA DEVOLVER NUNCA 2 RESULTADOS. SI ES EL CASO MAL ASUNTO, DE MOMENTO PREFIERO QUE FALLE.
	FROM 
		ICPM.DBO.ENTORNOS_CONEXIONES 
	WHERE 
		ENTORNO = DBO.FN_ENTORNO() 
		AND SERVIDOR = @@SERVERNAME 
		AND BASE_DATOS = DB_NAME() 


	RETURN @ID_CONEXION

END

GO
/****** Object:  UserDefinedFunction [dbo].[FN_ENTORNO]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-----------------------------------------------------------------------------------------------------------------------------------------------------

	NOMBRE DE LA FUNCIÓN		FN_ENTORNO
	FECHA DE CREACIÓN: 		29/05/2019		
	AUTOR:				O.RODRIGO
	VSS:				ICP/CODIGO_SQL/ICPM/02. FUNCIONES

	FUNCIONAMIENTO:			NOS DEVUELVE EL ENTORNO PARA PODER TRABAJAR CON LOS SERVIDORES. 
		
					A NIVEL GENERAL, LO RECOMENDABLE SERÍA TRABAJAR SIEMPRE CON LAS TABLAS:
						ENTORNOS
						CONEXIONES 
						ENTORNOS_CONEXIONES

------------------------------------------------------------------------------------------------------------------------------------------------------*/

-- ██████╗ ███████╗███████╗████████╗██╗ ██████╗ ███╗   ██╗		██████╗ ███████╗███████╗██████╗ ███████╗		██╗███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗  ██╗   ██╗ ██████╗██████╗ ███╗   ███╗
--██╔════╝ ██╔════╝██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║		██╔══██╗██╔════╝██╔════╝██╔══██╗██╔════╝		██║██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗███║   ██║██╔════╝██╔══██╗████╗ ████║
--██║  ███╗█████╗  ███████╗   ██║   ██║██║   ██║██╔██╗ ██║		██║  ██║█████╗  ███████╗██║  ██║█████╗  		██║███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝╚██║   ██║██║     ██████╔╝██╔████╔██║
--██║   ██║██╔══╝  ╚════██║   ██║   ██║██║   ██║██║╚██╗██║		██║  ██║██╔══╝  ╚════██║██║  ██║██╔══╝  		██║╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗ ██║   ██║██║     ██╔═══╝ ██║╚██╔╝██║
--╚██████╔╝███████╗███████║   ██║   ██║╚██████╔╝██║ ╚████║		██████╔╝███████╗███████║██████╔╝███████╗		██║███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║ ██║██╗██║╚██████╗██║     ██║ ╚═╝ ██║
-- ╚═════╝ ╚══════╝╚══════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝		╚═════╝ ╚══════╝╚══════╝╚═════╝ ╚══════╝		╚═╝╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝ ╚═╝╚═╝╚═╝ ╚═════╝╚═╝     ╚═╝     ╚═╝

-- ¡¡¡ LOS CAMBIOS QUE SE REALICEN EN ESTA FUNCIÓN TENDRAN EFECTO EN VARIOS SERVIDORES !!!

CREATE FUNCTION [dbo].[FN_ENTORNO]
(
	
)
RETURNS VARCHAR(5)
BEGIN

	DECLARE @ENTORNO  VARCHAR(5)

	SELECT 
		@ENTORNO = ISNULL(ENTORNO,'')
	FROM 
		ICPM.dbo.ENTORNOS_CONEXIONES E 
		LEFT OUTER JOIN ICPM.dbo.ALIAS_SERVIDORES ASE ON E.SERVIDOR = ASE.ALIAS_SERVIDOR
	WHERE 
		(
		     E.SERVIDOR = @@SERVERNAME
		  OR ASE.SERVIDOR = @@SERVERNAME
		)
		
		AND E.BASE_DATOS = DB_NAME() 

	RETURN @ENTORNO

END

/*----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------               PRUEBAS              ------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


PRINT DBO.FN_ENTORNO()


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------             FIN PRUEBAS            ------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------*/
GO
/****** Object:  Table [dbo].[ARTICULOS]    Script Date: 21/06/2022 22:34:22 ******/
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
/****** Object:  Table [dbo].[ROPA]    Script Date: 21/06/2022 22:34:22 ******/
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
/****** Object:  View [dbo].[V_TIENDA]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_TIENDA]    
AS    
SELECT       ROPA.ID_ROPA, ARTICULOS.ID_ARTICULO, dbo.ARTICULOS.DESCRIPCION, dbo.ARTICULOS.PRECIO, dbo.ROPA.TALLA, dbo.ROPA.COLOR, dbo.ROPA.IMAGEN, dbo.ARTICULOS.SEXO    
FROM            dbo.ARTICULOS LEFT OUTER JOIN    
                         dbo.ROPA ON dbo.ARTICULOS.ID_ARTICULO = dbo.ROPA.ID_ARTICULO    
GO
/****** Object:  View [dbo].[V_ARTICULOS]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_ARTICULOS]
AS
SELECT        dbo.ARTICULOS.DESCRIPCION, dbo.ARTICULOS.PRECIO, dbo.ARTICULOS.SEXO, dbo.ROPA.TALLA, dbo.ROPA.IMAGEN, dbo.ROPA.COLOR
FROM            dbo.ARTICULOS INNER JOIN
                         dbo.ROPA ON dbo.ARTICULOS.ID_ARTICULO = dbo.ROPA.ID_ARTICULO
GO
/****** Object:  Table [dbo].[STOCK]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STOCK](
	[ID_STOCK] [int] IDENTITY(1,1) NOT NULL,
	[ID_ARTICULO] [int] NOT NULL,
	[CANTIDAD_STOCK] [int] NULL,
	[CANTIDAD_PEDIDO] [int] NULL,
	[CANTIDAD_ENVIO] [int] NULL,
 CONSTRAINT [PK_STOCK] PRIMARY KEY CLUSTERED 
(
	[ID_STOCK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_STOCK]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[V_STOCK]    
AS    
SELECT STOCK.ID_STOCK, ROPA.ID_ROPA, DBO.ARTICULOS.ID_ARTICULO, ARTICULOS.DESCRIPCION, dbo.ROPA.COLOR, dbo.ROPA.TALLA, dbo.STOCK.CANTIDAD_STOCK, dbo.STOCK.CANTIDAD_PEDIDO, dbo.STOCK.CANTIDAD_ENVIO          
FROM            dbo.ARTICULOS LEFT OUTER JOIN          
                         dbo.ROPA ON dbo.ARTICULOS.ID_ARTICULO = dbo.ROPA.ID_ARTICULO LEFT OUTER JOIN          
                         dbo.STOCK ON dbo.ARTICULOS.ID_ARTICULO = dbo.STOCK.ID_ARTICULO AND dbo.ARTICULOS.ID_ARTICULO = dbo.STOCK.ID_ARTICULO
GO
/****** Object:  UserDefinedFunction [dbo].[FN_FECHA_GT]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-----------------------------------------------------------------------------------------------------------------------------------------------------

	NOMBRE DE LA FUNCIÓN		FN_GET_GEOGRAPHICAL_TIME
	FECHA DE CREACIÓN: 		11/03/2020		
	AUTOR:				A.VINAS
	VSS:				RUTA VISUAL SOURCESAFE EJ: BP\CODIGO_SQL\03. FUNCIONES\EDI\DESADV

	FUNCIONAMIENTO:			DEVUELVE LA FECHA EN EL TIMEZONE QUE PASEMOS POR PARAMETRO

	PARAMETROS:			(OPCIONAL)
		TIME_ZONE_DESTINO 	INPUT	NOMBRE DEL TIMEZONE - PODEMOS REVISARLO AQUÍ SELECT * FROM sys.time_zone_info

------------------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[FN_FECHA_GT]
(
	@FECHA			DATETIME,
	@TIME_ZONE_DESTINO	VARCHAR(100)	
)
RETURNS TABLE
RETURN

	SELECT CONVERT(DATETIME, @FECHA AT TIME ZONE 'Romance Standard Time' AT TIME ZONE @TIME_ZONE_DESTINO) FECHA



/*----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------               PRUEBAS              ------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


DECLARE @FECHA	DATETIME

SET @FECHA = GETDATE()

PRINT DBO.FN_FECHA_GT(@FECHA, 'China Standard Time')



------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------             FIN PRUEBAS            ------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------*/
GO
/****** Object:  View [dbo].[V_SQL_FICHEROS]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-----------------------------------------------------------------------------------------------------------------------------------------------------

	NOMBRE DE AL VISTA:		V_SQL_FICHEROS
	FECHA DE CREACIÓN: 		20/10/2019
	AUTOR:				OSCAR RODRIGO

	FUNCIONAMIENTO:			NOS DA DATOS SOBRE EL TAMAÑO Y PORCENTAJE DE OCUPACIÓN

	

-------------------------------------------------------------------------------------------------------------------------------------------------------
--	FECHA DE MODIFICACIÓN:
--	AUTOR:
--	EXPLICACIÓN:	
------------------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE VIEW [dbo].[V_SQL_FICHEROS] AS

SELECT	
	DB_NAME(mf.database_id) AS BBDD , 
	mf.Name COLLATE SQL_Latin1_General_CP1_CI_AS AS FICHERO , 
	mf.Physical_Name RUTA_FICHERO, 
	sfg.GROUPNAME COLLATE SQL_Latin1_General_CP1_CI_AS GRUPO_FICHERO,
	(mf.size * 8 )/ 1024 TOTAL_MB,
	convert(int, sf.size/128.0 -CAST(FILEPROPERTY(sf.name, 'SpaceUsed' )AS int)/128.0) AS LIBRE_MB,
	CASE  (( mf.size * 8 )/ 1024 )
		WHEN 0 THEN 0 
		ELSE  convert(int, sf.size/128.0 -CAST(FILEPROPERTY(sf.name, 'SpaceUsed' )AS int)/128.0) * 100 / (( mf.size * 8 ) / 1024 ) 
	END PORCENTAJE_LIBRE

FROM	
	sys.master_files mf

	LEFT OUTER JOIN
	sys.SYSFILES sf
	ON mf.Name COLLATE SQL_Latin1_General_CP1_CI_AS = sf.name COLLATE SQL_Latin1_General_CP1_CI_AS

	LEFT OUTER JOIN 
	sys.sysfilegroups sfg
	on sf.groupid = sfg.groupid
			
WHERE	
	DB_NAME (mf.database_id ) = DB_NAME()


/*----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------               PRUEBAS              ------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


SELECT 
	*
FROM
	V_SQL_FICHEROS WHERE FICHERO <> GRUPO_FICHERO
ORDER BY 
	1


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------             FIN PRUEBAS            ------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------*/

GO
/****** Object:  Table [dbo].[DIRECCIONES]    Script Date: 21/06/2022 22:34:22 ******/
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
/****** Object:  Table [dbo].[PEDIDOS]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PEDIDOS](
	[ID_PEDIDO] [int] IDENTITY(1,1) NOT NULL,
	[USUARIO] [varchar](50) NULL,
	[CODIGO] [varchar](100) NULL,
	[ESTADO] [int] NULL,
	[FECHA] [date] NULL,
 CONSTRAINT [PK_PEDIDOS] PRIMARY KEY CLUSTERED 
(
	[ID_PEDIDO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PEDIDOS_ARTICULOS]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PEDIDOS_ARTICULOS](
	[ID_PEDIDO_ARTICULO] [int] IDENTITY(1,1) NOT NULL,
	[ID_ARTICULO] [int] NULL,
	[DESCRIPCION] [varchar](50) NULL,
	[TALLA] [char](1) NULL,
	[COLOR] [varchar](50) NULL,
	[CANTIDAD] [int] NULL,
	[PRECIO_UNIDAD] [decimal](10, 2) NULL,
	[PRECIO] [decimal](10, 2) NULL,
 CONSTRAINT [PK_PEDIDOS_ARTICULOS] PRIMARY KEY CLUSTERED 
(
	[ID_PEDIDO_ARTICULO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PERFILES]    Script Date: 21/06/2022 22:34:22 ******/
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
/****** Object:  Table [dbo].[USUARIOS]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USUARIOS](
	[ID_USUARIO] [int] IDENTITY(1,1) NOT NULL,
	[USUARIO] [varchar](100) NULL,
	[PASS] [varchar](max) NULL,
	[ID_PERFIL] [int] NULL,
	[EMAIL] [varchar](100) NULL,
	[SALT] [varchar](max) NULL,
 CONSTRAINT [PK_USUARIOS] PRIMARY KEY CLUSTERED 
(
	[ID_USUARIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ARTICULOS]  WITH CHECK ADD  CONSTRAINT [FK_ARTICULOS_ARTICULOS] FOREIGN KEY([ID_ARTICULO])
REFERENCES [dbo].[ARTICULOS] ([ID_ARTICULO])
GO
ALTER TABLE [dbo].[ARTICULOS] CHECK CONSTRAINT [FK_ARTICULOS_ARTICULOS]
GO
ALTER TABLE [dbo].[DIRECCIONES]  WITH CHECK ADD  CONSTRAINT [FK_DIRECCIONES_USUARIOS] FOREIGN KEY([ID_USUARIO])
REFERENCES [dbo].[USUARIOS] ([ID_USUARIO])
GO
ALTER TABLE [dbo].[DIRECCIONES] CHECK CONSTRAINT [FK_DIRECCIONES_USUARIOS]
GO
ALTER TABLE [dbo].[PEDIDOS_ARTICULOS]  WITH CHECK ADD  CONSTRAINT [FK__PEDIDOS_A__ID_AR__40F9A68C] FOREIGN KEY([ID_ARTICULO])
REFERENCES [dbo].[ARTICULOS] ([ID_ARTICULO])
GO
ALTER TABLE [dbo].[PEDIDOS_ARTICULOS] CHECK CONSTRAINT [FK__PEDIDOS_A__ID_AR__40F9A68C]
GO
ALTER TABLE [dbo].[ROPA]  WITH CHECK ADD  CONSTRAINT [FK_ROPA_ARTICULOS] FOREIGN KEY([ID_ARTICULO])
REFERENCES [dbo].[ARTICULOS] ([ID_ARTICULO])
GO
ALTER TABLE [dbo].[ROPA] CHECK CONSTRAINT [FK_ROPA_ARTICULOS]
GO
/****** Object:  StoredProcedure [dbo].[PA_BORRAR_PEDIDO]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PA_BORRAR_PEDIDO]  
( 
	@ID_PEDIDO INT,  
	 @RETCODE INT OUTPUT,
	 @MENSAJE VARCHAR(100) OUTPUT
)  
AS   
BEGIN TRY   
		
 SET @RETCODE = 0
 SET @MENSAJE = ''

 IF ISNULL (@ID_PEDIDO, 0) <= 0  
  
 BEGIN  
  SET @MENSAJE = 'ID NO VÁLIDO'  
  SET @RETCODE = 1  
  RETURN  
 END  

 IF EXISTS (SELECT * FROM PEDIDOS WHERE ID_PEDIDO = @ID_PEDIDO)  
 BEGIN  
  DELETE PEDIDOS  
  WHERE ID_PEDIDO = @ID_PEDIDO
  SET @MENSAJE = 'Pedido Usuario cancelado correctamente'
 END  

  
END TRY  
  
BEGIN CATCH  
 SET @MENSAJE = ERROR_MESSAGE()
 SET @RETCODE = -1
END CATCH  
GO
/****** Object:  StoredProcedure [dbo].[PA_BORRAR_PEDIDO_ARTICULO]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PA_BORRAR_PEDIDO_ARTICULO]  
( 
@ID_PEDIDO_ARTICULO INT,  

 @MENSAJE VARCHAR(2000) OUTPUT,  
 @RETCODE INT OUTPUT  
)  
AS   
BEGIN TRY   
		
 SET @RETCODE = 0
 SET @MENSAJE = ''

 IF ISNULL (@ID_PEDIDO_ARTICULO, 0) <= 0  
  
 BEGIN  
  SET @MENSAJE = 'ID NO VÁLIDO'  
  SET @RETCODE = 1  
  RETURN  
 END  

 IF EXISTS (SELECT * FROM PEDIDOS_ARTICULOS WHERE ID_PEDIDO_ARTICULO = @ID_PEDIDO_ARTICULO)  
 BEGIN  
  DELETE PEDIDOS_ARTICULOS   
  WHERE ID_PEDIDO_ARTICULO = @ID_PEDIDO_ARTICULO  
 END  

  SET @MENSAJE = 'Pedido Articulo borrado correctamente'
  
END TRY  
  
BEGIN CATCH  
 SET @MENSAJE = ERROR_MESSAGE()
 SET @RETCODE = -1
END CATCH  
GO
/****** Object:  StoredProcedure [dbo].[PA_BORRAR_ROPA]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PA_BORRAR_ROPA]  
( 
	@ID_ROPA INT,  

 @MENSAJE VARCHAR(100) OUTPUT,  
 @RETCODE INT OUTPUT  
)  
AS   
BEGIN TRY   
		
 SET @RETCODE = 0
 SET @MENSAJE = ''

  
 BEGIN  
  SET @MENSAJE = 'ID NO VÁLIDO'  
  SET @RETCODE = 1  
  RETURN  
 END  

 IF EXISTS (SELECT * FROM ROPA WHERE ID_ROPA = @ID_ROPA)  
 BEGIN  
  DELETE ROPA   
  WHERE ID_ROPA = @ID_ROPA  
  SET @MENSAJE = 'Version Articulo borrado correctamente'
 END  

  
END TRY  
  
BEGIN CATCH  
 SET @MENSAJE = ERROR_MESSAGE()
 SET @RETCODE = -1
END CATCH  
GO
/****** Object:  StoredProcedure [dbo].[PA_BORRAR_USUARIO]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PA_BORRAR_USUARIO]  
( 
@ID_USUARIO INT,  

 @MENSAJE VARCHAR(2000) OUTPUT,  
 @RETCODE INT OUTPUT  
)  
AS   
BEGIN TRY   
		
 SET @RETCODE = 0
 SET @MENSAJE = ''

 IF ISNULL (@ID_USUARIO, 0) <= 0  
  
 BEGIN  
  SET @MENSAJE = 'ID NO VÁLIDO'  
  SET @RETCODE = 1  
  RETURN  
 END  

 IF EXISTS (SELECT * FROM USUARIOS WHERE ID_USUARIO = @ID_USUARIO)  
 BEGIN  
  DELETE USUARIOS   
  WHERE ID_USUARIO = @ID_USUARIO  
  SET @MENSAJE = 'Usuario borrado correctamente'
 END  

  
END TRY  
  
BEGIN CATCH  
 SET @MENSAJE = ERROR_MESSAGE()
 SET @RETCODE = -1
END CATCH  
GO
/****** Object:  StoredProcedure [dbo].[PA_CREAR_ARTICULO]    Script Date: 21/06/2022 22:34:22 ******/
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
 @IMAGEN VARCHAR(MAX),  
 @SEXO CHAR(1),  


 @MENSAJE VARCHAR(100) OUTPUT,    
 @RETCODE INT OUTPUT,  
 @ID_ARTICULO INT OUTPUT,  
 @CANTIDAD_ENVIO INT OUTPUT,
 @CANTIDAD_PEDIDO INT OUTPUT,
 @CANTIDAD_STOCK INT OUTPUT
)    
AS    
    
BEGIN TRY    
    
   SET @RETCODE = 0  
   SET @MENSAJE = ''  
   SET @CANTIDAD_ENVIO = 0
   SET @CANTIDAD_PEDIDO = 0
   SET @CANTIDAD_STOCK = 20
    
 SET @ID_ARTICULO =  SCOPE_IDENTITY()  
  
 SELECT @ID_ARTICULO = MAX(ID_ARTICULO) FROM ARTICULOS  
  
  
/*Condicion para insertar unicamente datos de ropa si el articulo existe*/  
IF EXISTS(SELECT DESCRIPCION FROM ARTICULOS WHERE @DESCRIPCION = DESCRIPCION)  
BEGIN  
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

  SET @RETCODE = 1  
 SET @MENSAJE = 'Version del Articulo añadido'  
END  
ELSE IF (EXISTS(SELECT COLOR FROM ROPA WHERE @COLOR = COLOR) AND EXISTS(SELECT DESCRIPCION FROM ARTICULOS WHERE @DESCRIPCION = DESCRIPCION))  
 BEGIN  
 SET @RETCODE = 0  
 SET @MENSAJE = 'Ese Articulo con ese Color ya existe'  
  
 END  
ELSE IF (EXISTS(SELECT IMAGEN FROM ROPA WHERE @IMAGEN = IMAGEN) AND EXISTS(SELECT DESCRIPCION FROM ARTICULOS WHERE @DESCRIPCION = DESCRIPCION))  
 BEGIN  
 SET @RETCODE = 0  
 SET @MENSAJE = 'Ese Articulo con ese Color ya existe'  
  
 END  
 ELSE   
 BEGIN   
  
  
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
  SET @RETCODE = 0  
  SET @MENSAJE = 'Articulo y version añadida'  

	INSERT INTO STOCK (
		ID_ARTICULO,
		CANTIDAD_PEDIDO,
		CANTIDAD_ENVIO,
		CANTIDAD_STOCK
	)
	VALUES
	(
		@ID_ARTICULO,
		@CANTIDAD_STOCK,
		@CANTIDAD_PEDIDO,
		@CANTIDAD_ENVIO
	)

 END  
   
      
  
  
END TRY    
  
BEGIN CATCH    
    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[PA_CREAR_DIRECCION]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PA_CREAR_DIRECCION]
( 
 @ID_USUARIO INT,	
 @CALLE VARCHAR(100),  
 @PROVINCIA VARCHAR(100),
 @POBLACION VARCHAR(100),  
 @CODIGO_POSTAL INT,
 @NUMERO INT,  
 @PISO INT,
 @PUERTA CHAR(1),  
 @PERSONA_CONTACTO VARCHAR(100),
 @TELEFONO VARCHAR(12),

  
 @MENSAJE VARCHAR(100) OUTPUT,  
 @RETCODE INT OUTPUT  
)  
AS  
  
BEGIN TRY  
   

   SET @RETCODE = 0
   SET @MENSAJE = ''
   
 IF ISNULL(@ID_USUARIO,'') = ''  
 BEGIN  
  SET  @RETCODE = 10  
  SET @MENSAJE = 'Se necesita conocer el usuario'  
  RETURN  
 END  

  
  
 INSERT INTO DIRECCIONES  
 (  
	ID_USUARIO,
	CALLE,
	PROVINCIA,
	POBLACION,
	CODIGO_POSTAL,
	NUMERO,
	PISO,
	PUERTA,
	PERSONA_CONTACTO,
	TELEFONO
 )  
 VALUES  
 (  
	@ID_USUARIO,
	@CALLE,
	@PROVINCIA,
	@POBLACION,
	@CODIGO_POSTAL,
	@NUMERO,
	@PISO,
	@PUERTA,
	@PERSONA_CONTACTO,
	@TELEFONO
	 
 )  
   
 RETURN   
  
END TRY  
  
BEGIN CATCH  
  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[PA_CREAR_PEDIDO]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PA_CREAR_PEDIDO]
( 
	@USUARIO VARCHAR(50),
	@CODIGO VARCHAR(100),
	@ESTADO INT,
	@FECHA DATE,
  
 @RETCODE INT OUTPUT ,
 @MENSAJE VARCHAR(100) OUTPUT

)  
AS  
  
BEGIN TRY  
   

   SET @RETCODE = 0
   SET @MENSAJE = ''


	IF ISNULL(@ESTADO,0) = 0
	 BEGIN 
		  SET @ESTADO = (SELECT ROUND(((4 - 1) * RAND() + 1), 0)) 
	 END
		
	IF ISNULL(@FECHA,'') = ''
	 BEGIN 
		  SET @FECHA = (SELECT dateadd(day,7,getdate()))
	 END
	  
	 
 INSERT INTO PEDIDOS
 (  
	USUARIO,
	CODIGO,
	ESTADO,
	FECHA
 )  
 VALUES  
 ( 
	@USUARIO,
	@CODIGO,
	@ESTADO,
	@FECHA
	 
 )  
   SET @RETCODE = 0
   SET @MENSAJE = 'Pedido realizado correctamente'
 RETURN   

END TRY  
  
BEGIN CATCH  
  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[PA_CREAR_PEDIDO_ARTICULO]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PA_CREAR_PEDIDO_ARTICULO]
(  
 @ID_ARTICULO INT,
 @DESCRIPCION VARCHAR(50),
 @TALLA CHAR,
 @COLOR VARCHAR(20),
 @CANTIDAD INT,
 @PRECIO DECIMAL,
 @PRECIO_UND INT,

  
 @MENSAJE VARCHAR(100) OUTPUT,  
 @RETCODE INT OUTPUT  
)  
AS  
  
BEGIN TRY  
   

   SET @RETCODE = 0
   SET @MENSAJE = ''
   
 IF ISNULL(@ID_ARTICULO,'') = ''  
 BEGIN  
  SET  @RETCODE = 10  
  SET @MENSAJE = 'El parametro id_articulo no puede ser vacío'  
  RETURN  
 END  
  IF ISNULL(@TALLA,'') = ''  
 BEGIN  
  SET  @RETCODE = 10  
  SET @MENSAJE = 'El parametro talla no puede ser vacío'  
  RETURN  
 END  
  IF ISNULL(@COLOR,'') = ''  
 BEGIN  
  SET  @RETCODE = 10  
  SET @MENSAJE = 'El parametro color no puede ser vacío'  
  RETURN  
 END  
  IF ISNULL(@CANTIDAD,0) = 0
 BEGIN  
  SET  @RETCODE = 10  
  SET @MENSAJE = 'El parametro cantidad no puede ser vacío'  
  RETURN  
 END  

   IF ISNULL(@DESCRIPCION,'') = ''
 BEGIN 
	 SET @DESCRIPCION = (
	 SELECT DESCRIPCION FROM ARTICULOS WHERE @ID_ARTICULO = ID_ARTICULO
	 )
 END

   IF ISNULL(@PRECIO,0) = 0 
 BEGIN 
	 SET @PRECIO = (
	 SELECT PRECIO FROM ARTICULOS WHERE @ID_ARTICULO = ID_ARTICULO
	 ) * @CANTIDAD
 END
 
   IF ISNULL(@PRECIO_UND,0) = 0 
 BEGIN 
	 SET @PRECIO_UND = @PRECIO / @CANTIDAD
 END

 
 INSERT INTO PEDIDOS_ARTICULOS
 (  
	ID_ARTICULO,
	DESCRIPCION,
	TALLA,
	COLOR,
	CANTIDAD,
	PRECIO_UNIDAD,
	PRECIO
 )  
 VALUES  
 (  
	@ID_ARTICULO,
	@DESCRIPCION,
	@TALLA,
	@COLOR,
	@CANTIDAD,
	@PRECIO_UND,
	@PRECIO
	 
 )  
   
   SET @RETCODE = 0
   SET @MENSAJE = 'Pedido creado correctamente'

 RETURN   
  
END TRY  
  
BEGIN CATCH  
  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[PA_CREAR_STOCK]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PA_CREAR_STOCK]
(  
	@ID_ARTICULO INT,
	@CANTIDAD_STOCK INT,
	@CANTIDAD_PEDIDO INT,
	@CANTIDAD_ENVIO INT,

  
 @MENSAJE VARCHAR(100) OUTPUT,  
 @RETCODE INT OUTPUT  
)  
AS  
  
BEGIN TRY  
   

   SET @RETCODE = 0
   SET @MENSAJE = ''
   
 IF ISNULL(@ID_ARTICULO,'') = ''  
 BEGIN  
  SET  @RETCODE = 10  
  SET @MENSAJE = 'El parametro id_articulo no puede estar vacio'  
  RETURN  
 END  

  
  
 INSERT INTO STOCK  
 (  
	ID_ARTICULO,
	CANTIDAD_STOCK,
	CANTIDAD_PEDIDO,
	CANTIDAD_ENVIO
 )  
 VALUES  
 (  
	@ID_ARTICULO,
	@CANTIDAD_STOCK,
	@CANTIDAD_PEDIDO,
	@CANTIDAD_ENVIO
	 
 )  
   
 RETURN   
  
END TRY  
  
BEGIN CATCH  
  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[PA_CREAR_USUARIO]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PA_CREAR_USUARIO]
(  
	@USUARIO VARCHAR(100),
	@PASS VARCHAR(100),
	@ID_PERFIL INT,
	@EMAIL VARCHAR(100),

  
 @MENSAJE VARCHAR(100) OUTPUT,  
 @RETCODE INT OUTPUT  
)  
AS  
  
BEGIN TRY  
   

   SET @RETCODE = 0
   SET @MENSAJE = ''
   
 IF ISNULL(@USUARIO,'') = ''  
 BEGIN  
  SET  @RETCODE = 10  
  SET @MENSAJE = 'El parametro usuario no puede ser vacío'  
  RETURN  
 END  

   IF EXISTS(SELECT EMAIL FROM USUARIOS WHERE @EMAIL = EMAIL)
 BEGIN
	SET @RETCODE = 1
	SET @MENSAJE = 'Este usuario ya existe'
	RETURN 
 END 
  
 IF EXISTS(SELECT USUARIO FROM USUARIOS WHERE @USUARIO = USUARIO)
 BEGIN
	SET @RETCODE = 1
	SET @MENSAJE = 'Este usuario ya existe'
	RETURN 
 END 
  
 INSERT INTO USUARIOS  
 (  
	USUARIO,
	PASS,
	ID_PERFIL,
	EMAIL
 )  
 VALUES  
 (  
	@USUARIO,
	@PASS,
	@ID_PERFIL,
	@EMAIL
	 
 )  
   
 SET @RETCODE = 0
 SET @MENSAJE = 'Usuario añadido correctamente'
  
END TRY  
  
BEGIN CATCH  
  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[PA_EDITAR_USUARIO]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PA_EDITAR_USUARIO]
(
	@ID_USUARIO INT,
	@USUARIO VARCHAR(100),
	@EMAIL VARCHAR(100),
	@ID_PERFIL INT,

	@MENSAJE VARCHAR(50) OUTPUT,
	@RETCODE INT OUTPUT
)
AS 
BEGIN TRY 

	IF ISNULL(@ID_USUARIO,'') = ''
	BEGIN
		SET @MENSAJE = 'Se necesita el id_usuario'
		SET @RETCODE = 1
		RETURN
	END


	IF ISNULL(@EMAIL,'') = ''
	BEGIN
		SET @MENSAJE = 'se necesita el email'
		SET @RETCODE = 1
		RETURN
	END



	IF ISNULL(@ID_PERFIL,'') = ''
	BEGIN
		SET @MENSAJE = 'se necesita id_perfil'
		SET @RETCODE = 1
		RETURN
	END

	IF EXISTS (SELECT * FROM USUARIOS WHERE ID_USUARIO = @ID_USUARIO)
	BEGIN
		
		UPDATE	USUARIOS 
		SET		USUARIO = @USUARIO,
				EMAIL = @EMAIL, 
				ID_PERFIL = @ID_PERFIL 
		WHERE	ID_USUARIO = @ID_USUARIO;

		SET @RETCODE = 0
		SET @MENSAJE = 'Usuario editado correctamente'
	END
	ELSE
	BEGIN
		SET @RETCODE = 1
		SET @MENSAJE = 'El usuario no existe'
		RETURN
	END
	
END TRY

BEGIN CATCH
	SET @MENSAJE = ERROR_MESSAGE()
	SET @RETCODE = -1
END CATCH


GO
/****** Object:  StoredProcedure [dbo].[PA_LOGIN]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PA_LOGIN]
(  
	@USERNAME_EMAIL VARCHAR(100),
	@PASS VARCHAR(100),

	@ID_USUARIO INT OUTPUT,
	@MENSAJE VARCHAR(100) OUTPUT,  
	@RETCODE INT OUTPUT  
)  
AS  
  
BEGIN TRY  
   

   SET @RETCODE = 0
   SET @MENSAJE = ''

   SET @ID_USUARIO = 0

   
	 IF ISNULL(@USERNAME_EMAIL,'') = ''  
	 BEGIN  
	  SET  @RETCODE = 10  
	  SET @MENSAJE = 'El parametro usuario o email no puede ser vacío'  
	  RETURN  
	 END 
 

	  IF ISNULL(@PASS,'') = ''  
	 BEGIN  
	  SET  @RETCODE = 10  
	  SET @MENSAJE = 'El parametro password no puede ser vacío'  
	  RETURN  
	 END 


	 SELECT	 @ID_USUARIO = ID_USUARIO
	 FROM	USUARIOS
	 WHERE	
	 (USUARIO = @USERNAME_EMAIL OR EMAIL = @USERNAME_EMAIL)
	 AND PASS = @PASS

	 IF ISNULL(@ID_USUARIO,0) = 0
	 BEGIN
		SET @RETCODE = 10
		SET @MENSAJE = 'Credenciales incorrectas'
		RETURN
	 END
	 

	SET @RETCODE = 0
	SET @MENSAJE = 'Credenciales correctas'
	SET @ID_USUARIO = @ID_USUARIO
END TRY  

BEGIN CATCH  
	SET @RETCODE = -1
	SET @MENSAJE = ERROR_MESSAGE()
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[PA_REGISTER]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PA_REGISTER]
(  
	@USER VARCHAR(100),
	@PASS VARCHAR(MAX),
	@PERFIL INT, 
	@EMAIL VARCHAR(100),

 @ID_USUARIO INT OUTPUT,
 @MENSAJE VARCHAR(100) OUTPUT,  
 @RETCODE INT OUTPUT  
)  
AS  
  
BEGIN TRY  
   

   SET @RETCODE = 0
   SET @MENSAJE = ''
   
 IF ISNULL(@EMAIL,'') = ''  
 BEGIN  
  SET  @RETCODE = 10  
  SET @MENSAJE = 'El parametro email no puede ser vacío'  
  RETURN  
 END  

  IF ISNULL(@PERFIL,0) = 0 
 BEGIN  
	SET @PERFIL = 4
 END  

 IF EXISTS(SELECT EMAIL FROM USUARIOS WHERE @EMAIL = EMAIL)
 BEGIN
	SET @RETCODE = 1
	SET @MENSAJE = 'Este usuario ya existe'
	RETURN 
 END 
  
 IF EXISTS(SELECT USUARIO FROM USUARIOS WHERE @USER = USUARIO)
 BEGIN
	SET @RETCODE = 1
	SET @MENSAJE = 'Este usuario ya existe'
	RETURN 
 END 
  
 INSERT INTO USUARIOS  
 (  
	USUARIO,
	PASS,
	ID_PERFIL,
	EMAIL
 )  
 VALUES  
 (  
	@USER,
	@PASS,
	@PERFIL,
	@EMAIL
 )  
   SELECT	 @ID_USUARIO = ID_USUARIO
	 FROM	USUARIOS
	 WHERE	
	 (USUARIO = @USER OR EMAIL = @EMAIL)
	 AND PASS = @PASS

	SET @RETCODE = 0
	SET @MENSAJE = 'Operacion register realizada con exito'
	SET @ID_USUARIO = @ID_USUARIO



END TRY  
  
BEGIN CATCH  
  SET @RETCODE = -1
  SET @MENSAJE = ERROR_MESSAGE()
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[PA_SQLD]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
####################################################################################################################################################################################################

	FECHA DE CREACIÓN: 		30/09/2021		
	AUTOR:				JJ
	FUNCIONAMIENTO:			DEVUELVE TEXTO SQL DINÁMICO DADO UN PA

####################################################################################################################################################################################################

	FECHA DE MODIFICACIÓN: 
	AUTOR:
	EXPLICACIÓN:	

####################################################################################################################################################################################################
*/

CREATE PROCEDURE [dbo].[PA_SQLD]
	@NOMBRE_PA		VARCHAR(200)
AS

	DECLARE @SQLSTRING0	VARCHAR(8000) = ''
	DECLARE @SQLSTRING1	VARCHAR(8000) = ''
	DECLARE @SQLSTRING2	VARCHAR(8000) = ''
	DECLARE @SQLSTRING3	VARCHAR(8000) = ''
	DECLARE @SERVIDOR	VARCHAR(50) = ''	
	DECLARE @BBDD		VARCHAR(50) = ''



	SET @SQLSTRING0 = 'DECLARE @PARAMDEFINITION NVARCHAR(4000)' + CHAR(10) +
	'DECLARE @SQLSTRING	NVARCHAR(4000)' + CHAR(10) +
	'DECLARE @NOMBRE_PA	VARCHAR(200)' + CHAR(10) + 
	'DECLARE @SERVIDOR	VARCHAR(200)' + CHAR(10) + 
	'DECLARE @BBDD		VARCHAR(200)' + CHAR(10) + CHAR(10)

	SELECT	@SQLSTRING1 =	@SQLSTRING1 + 

				-- NOMBRE DEL PARÁMETRO
				CASE
					WHEN IS_OUTPUT = 1 THEN name + '_OUT'
					ELSE name + '_IN'
				END  + 
			
				-- TIPO DEL PARÁMETRO
				' ' + TYPE_NAME(USER_TYPE_ID) + 

				-- DIMENSIÓN DEL PARÁMETRO
				CASE  
					WHEN TYPE_NAME (USER_TYPE_ID) IN ('VARCHAR', 'CHAR', 'NVARCHAR') THEN '(' + CASE WHEN MAX_LENGTH = -1 THEN 'MAX' ELSE CAST(MAX_LENGTH AS VARCHAR(30)) END +')'   
					WHEN TYPE_NAME (USER_TYPE_ID) IN ('VARBINARY') THEN '(MAX)'		
					ELSE ''  
				END +

				-- OUTPUT
				CASE
					WHEN IS_OUTPUT = 1 THEN ' OUTPUT'
					ELSE ''
				END +

				-- COMA
				CASE
					WHEN parameter_id = (SELECT MAX(parameter_id) FROM SYS.ALL_PARAMETERS SP WHERE OBJECT_ID = OBJECT_ID(@NOMBRE_PA)) THEN ''
					ELSE ',' + CHAR(10)
				END ,

		@SQLSTRING2 =	@SQLSTRING2 + 

				-- NOMBRE DEL PARÁMETRO
				CASE
					WHEN IS_OUTPUT = 1 THEN name + '_OUT'
					ELSE name + '_IN'
				END + 			

				-- OUTPUT
				CASE
					WHEN IS_OUTPUT = 1 THEN ' OUTPUT'
					ELSE ''
				END +

				-- COMA
				CASE
					WHEN parameter_id = (SELECT MAX(parameter_id) FROM SYS.ALL_PARAMETERS SP WHERE OBJECT_ID = OBJECT_ID(@NOMBRE_PA)) THEN ''
					ELSE ',' + CHAR(10)
				END,

		@SQLSTRING3 =	@SQLSTRING3 + 
				-- NOMBRE DEL PARÁMETRO
				CASE
					WHEN IS_OUTPUT = 1 THEN name + '_OUT'
					ELSE name + '_IN'
				END + ' = ' + name + 

				-- OUTPUT
				CASE
					WHEN IS_OUTPUT = 1 THEN ' OUTPUT'
					ELSE ''
				END +

				-- COMA
				CASE
					WHEN parameter_id = (SELECT MAX(parameter_id) FROM SYS.ALL_PARAMETERS SP WHERE OBJECT_ID = OBJECT_ID(@NOMBRE_PA)) THEN ''
					ELSE ',' + CHAR(10)
				END 


	FROM	SYS.ALL_PARAMETERS SP
	WHERE	OBJECT_ID = OBJECT_ID(@NOMBRE_PA)   
	ORDER	BY PARAMETER_ID  

	SET @SQLSTRING1 = 'SET @PARAMDEFINITION = N' + CHAR(39) + @SQLSTRING1 + CHAR(39)
	SET @SQLSTRING2 = 'SET @SQLSTRING = N''EXEC '' + @SERVIDOR + ''.'' + @BBDD + ''.dbo.' + ''' + @NOMBRE_PA + ''' + CHAR(10) + @SQLSTRING2 + CHAR(39)

	SET @SQLSTRING3 = 'EXECUTE SP_EXECUTESQL ' + CHAR(10) + '@SQLSTRING,' + CHAR(10) + '@PARAMDEFINITION,' + CHAR(10) + @SQLSTRING3

	PRINT @SQLSTRING0 + CHAR(10) + CHAR(10) + @SQLSTRING1 + CHAR(10) + CHAR(10) + @SQLSTRING2 + CHAR(10) + CHAR(10) + @SQLSTRING3






GO
/****** Object:  StoredProcedure [dbo].[PAB]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================  
-- Author: Bruno Ramos Silva  
-- CREACION date: 03/03/2015  
-- Description: PA que devuelve todos los objetos que tengan parametro de entrada TEXTO_BUSCAR  
  
-- Modificacion: Edgar  
-- Fecha: 11/05/2017  
-- Descripcion: Reestructuración del PA para que nos muestre los JOBS y el TEXTO_ICPL (si procede).  
  
-- Modificación: Edgar  
-- Fecha: 27/06/2017  
-- Descripción: Ahora se puede hacer búsquedas de hasta 2 elementos:  
-- Ejemplo:  PAB '@TEXTO_BUSCAR','ID__TEMPORAL__OBJECT_ID'  
  
-- Modificación: Javier Rod  
-- Fecha: 07/02/2018  
-- Descripción: Unificación de ambos PAB y búsquedas de hasta 5 elementos  
  
-- Modificación: Cecilia N.Pri  
-- Fecha: 04/10/2018  
-- Descripción: Añado Replace para que en la búsqueda el guíon bajo no sea un comodín  
  
-- Modificación: Edgar  
-- Fecha: 13/04/2021  
-- Descripción: Impementación del invoker 99 para revisar todas las bases de datos  
-- =================================================================================================  
  
CREATE PROCEDURE [dbo].[PAB]  
 @TEXTO_BUSCAR AS VARCHAR (1000),  
 @TEXTO_BUSCAR_2 AS VARCHAR (1000) = @TEXTO_BUSCAR,  
 @TEXTO_BUSCAR_3 AS VARCHAR (1000) = @TEXTO_BUSCAR,  
 @TEXTO_BUSCAR_4 AS VARCHAR (1000) = @TEXTO_BUSCAR,  
 @TEXTO_BUSCAR_5 AS VARCHAR (1000) = @TEXTO_BUSCAR,  
 @INVOKER INT = 0  
  
AS  
BEGIN  
 SET NOCOUNT ON;  
 --VARIABLE PARA CONTROLAR LA BÚSQUEDA SEGÚN LA BASE DE DATOS TENGA LA TABLA 'N_TAREAS_PROGRAMADAS' O NO  
 DECLARE @TAREAS AS BIT = 0  
 DECLARE @TEXTO_ORIGINAL VARCHAR(1000) = @TEXTO_BUSCAR  
 IF EXISTS (SELECT [NAME] FROM SYS.tables WHERE [NAME] = 'N_TAREAS_PROGRAMADAS') SET @TAREAS = 1  
  
  
 SET @TEXTO_BUSCAR = REPLACE(@TEXTO_BUSCAR,'_','[_]')  
 SET @TEXTO_BUSCAR_2 = REPLACE(@TEXTO_BUSCAR_2,'_','[_]')  
 SET @TEXTO_BUSCAR_3 = REPLACE(@TEXTO_BUSCAR_3,'_','[_]')  
 SET @TEXTO_BUSCAR_4 = REPLACE(@TEXTO_BUSCAR_4,'_','[_]')  
 SET @TEXTO_BUSCAR_5 = REPLACE(@TEXTO_BUSCAR_5,'_','[_]')  
   
    
 IF @INVOKER = 99   
 BEGIN  
  CREATE TABLE #AUXILIAR_PAB  
    (  
     TIPO  VARCHAR(10),  
     BBDD  VARCHAR(50),  
     ELEMENTO VARCHAR(100),  
     [SP_HELPTEXT]   VARCHAR(150),  
     CODIGO  VARCHAR(MAX),  
     ACTUALIZADO BIT DEFAULT(0)  
    )  
  
  DECLARE @command varchar(4000)   
  SELECT @command = 'USE ?   
  
      
    BEGIN TRY   
     INSERT INTO #AUXILIAR_PAB (TIPO, ELEMENTO, [SP_HELPTEXT], CODIGO)  
     EXEC PAB '''+@TEXTO_ORIGINAL+''', @INVOKER = 98   
     IF EXISTS (SELECT 1 FROM #AUXILIAR_PAB)  
     BEGIN  
      UPDATE #AUXILIAR_PAB SET BBDD = DB_NAME(), ACTUALIZADO = 1  WHERE ACTUALIZADO = 0  
        
      --SELECT DB_NAME()   
      --SELECT * FROM #AUXILIAR_PAB  
     END  
    END TRY   
    BEGIN CATCH   
     --PRINT DB_NAME()   
     --PRINT ERROR_MESSAGE()   
    END CATCH'   
  
  EXEC sp_MSforeachdb @command   
  
  --SET @INVOKER = 98  
 END  
  
-- Creamos una tabla temporal y le añadimos un índice para acelerar el pab, ya que ahora es más grande que antes.  
  CREATE TABLE #T  
  (  
   ID  INTEGER ,  
   [OBJECT_ID] INTEGER,  
   TIPO  VARCHAR(10),  
   ELEMENTO VARCHAR(100),  
   [SP_HELPTEXT]   VARCHAR(150),  
   CODIGO  VARCHAR(MAX)  
  )  
  
   
  CREATE TABLE #T2  
  (  
   ID  INTEGER ,  
   [OBJECT_ID] INTEGER,  
   TIPO  VARCHAR(10),  
   ELEMENTO VARCHAR(100),  
   [SP_HELPTEXT]   VARCHAR(150),  
   CODIGO  VARCHAR(MAX)  
  )  
  
  
  
-- METO PRIMERO EN UNA TEMPORAL LOS RESULTADOS QUE SIEMPRE HA DADO EL PAB:  
 INSERT INTO #T2(TIPO,ELEMENTO,[SP_HELPTEXT],CODIGO,[OBJECT_ID],ID)  
  SELECT   
   B.TIPO,   
   B.ELEMENTO,   
   B.SP_HELPTEXT,   
   B.CODIGO,   
   B.object_id,   
   B.ID   
  FROM  
   (  
   SELECT   
          SYSOBJ.XTYPE             [TIPO] ,  
          SYSOBJ.NAME              [ELEMENTO],  
          'USE '+DB_NAME()+CHAR(10) +'GO'+CHAR(10)+'PAH ' + '''' + SYSOBJ.NAME + ''''  [SP_HELPTEXT] ,  
          MODU.DEFINITION   [CODIGO],  
          MODU.OBJECT_ID,  
          SYSOBJ.ID            
   FROM   
    SYSOBJECTS  AS SYSOBJ WITH(NOLOCK)  
  
    INNER JOIN   
    SYS.OBJECTS AS SYS_OBJ WITH (NOLOCK)   
    ON SYSOBJ.ID = SYS_OBJ.OBJECT_ID  
  
    INNER JOIN   
    SYS.SQL_MODULES AS MODU WITH (NOLOCK)   
    ON SYS_OBJ.OBJECT_ID = MODU.OBJECT_ID  
  
    INNER JOIN   
    SYS.SYSUSERS AS USERS WITH (NOLOCK)   
    ON SYSOBJ.UID = USERS.UID  
   WHERE   
    MODU.OBJECT_ID = SYSOBJ.ID  
  
   GROUP BY   
    SYSOBJ.XTYPE,  
    SYSOBJ.NAME,  
    MODU.DEFINITION,  
       SYS_OBJ.OBJECT_ID,  
    USERS.NAME,  
    MODU.OBJECT_ID,  
    SYSOBJ.ID  
   ) B --OPTION (RECOMPILE)  
 --PRINT 'A1'     
 INSERT INTO #T(TIPO,ELEMENTO,[SP_HELPTEXT],CODIGO,[OBJECT_ID],ID)  
 SELECT   
   TIPO,   
   ELEMENTO,   
   SP_HELPTEXT,   
   CODIGO,  
   object_id,   
   ID   
 FROM #T2  
 WHERE   CODIGO  LIKE '%' + @TEXTO_BUSCAR + '%'  
    AND CODIGO LIKE '%' + @TEXTO_BUSCAR_2 + '%'  
    AND CODIGO LIKE '%' + @TEXTO_BUSCAR_3 + '%'  
    AND CODIGO LIKE '%' + @TEXTO_BUSCAR_4 + '%'  
    AND CODIGO LIKE '%' + @TEXTO_BUSCAR_5 + '%'  
--PRINT 'A2'P  
 INSERT INTO #T(TIPO,ELEMENTO,[SP_HELPTEXT],CODIGO,[OBJECT_ID],ID)  
 select 'CLR',assembly_method,'CLR','CLR',-1,-1 from sys.assembly_modules where assembly_method LIKE '%' + @TEXTO_BUSCAR + '%'  
    AND assembly_method LIKE '%' + @TEXTO_BUSCAR_2 + '%'  
    AND assembly_method LIKE '%' + @TEXTO_BUSCAR_3 + '%'  
    AND assembly_method LIKE '%' + @TEXTO_BUSCAR_4 + '%'  
    AND assembly_method LIKE '%' + @TEXTO_BUSCAR_5 + '%'  
--PRINT 'A3'   
--LO CONSULTO Y LE AÑADO LOS JOBS:  
  
  
 IF @INVOKER = 98  
 BEGIN    
   
  SELECT * FROM   
  (  
   SELECT   
    TIPO   [TIPO] ,  
    --DB_NAME()  BBDD,  
    ELEMENTO  [ELEMENTO],  
    'USE '+DB_NAME()+CHAR(10) +'GO'+CHAR(10)+'PAH ' + '''' + ELEMENTO + ''''  [SP_HELPTEXT] ,  
    LEFT(CODIGO,100) +'....................USA PAH PARA VER MÁS' [CODIGO]    
   FROM   
    #T   
   --UNION ALL  
   --SELECT TIPO, BBDD, ELEMENTO, [SP_HELPTEXT], CODIGO FROM #AUXILIAR_PAB  
  ) TT   
   ORDER BY   
   --BBDD,  
   CASE   
    WHEN TIPO = 'P' THEN 1  
    WHEN TIPO = 'FN' THEN 2  
    WHEN TIPO = 'TR' THEN 3  
    WHEN TIPO = 'V' THEN 4  
    WHEN TIPO = 'JOB' THEN 5  
    WHEN TIPO = 'ICPL' THEN 6  
    ELSE 7   
   END ASC-- ORDENO PARA QUE APAREZCA LO QUE YO QUIERA PRIMERO  
  
   RETURN 0  
 END  
  
 --IF @INVOKER = 98  
 --BEGIN  
 -- RETURN 0  
 --END  
  
 IF @INVOKER <> 99   
 BEGIN  
  IF @TAREAS = 1   
   BEGIN  
    SELECT   
     TIPO,   
     ELEMENTO, [SP_HELPTEXT],  
     CODIGO  
    FROM   
     (  
      SELECT   
       TIPO             [TIPO] ,  
       ELEMENTO              [ELEMENTO],  
       'USE '+DB_NAME()+CHAR(10) +'GO'+CHAR(10)+'PAH ' + '''' + ELEMENTO + ''''  [SP_HELPTEXT] ,  
       LEFT(CODIGO,100) +'....................USA PAH PARA VER MÁS' [CODIGO]    
      FROM   
       #T   
        
      UNION  
      SELECT   
       C1.TIPO,   
       C1.ELEMENTO,   
       C1.[SP_HELPTEXT],   
       C1.CODIGO   
      FROM   
       --JOBS  
       (  
        SELECT DISTINCT  
         'JOB' TIPO,  
         ISNULL(SYSJOBS.NAME,'') ELEMENTO,  
         '' SP_HELPTEXT,  
         SYSJOBSS.COMMAND CODIGO  
        FROM    
         MSDB.DBO.SYSJOBSTEPS AS SYSJOBSS WITH(NOLOCK)   
  
         INNER JOIN   
         MSDB.DBO.SYSJOBS AS SYSJOBS WITH(NOLOCK)   
         ON SYSJOBS.JOB_ID = SYSJOBSS.JOB_ID  
        WHERE    
         SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR  + '%'  
         AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_2 + '%'  
         AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_3 + '%'  
         AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_4 + '%'  
         AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_5 + '%'  
         OR (  
          SYSJOBS.NAME  LIKE '%' +  @TEXTO_BUSCAR  + '%'  
         AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_2  + '%'  
         AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_3  + '%'  
         AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_4  + '%'  
         AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_5  + '%'  
         )  
       )C1       
  
      UNION   
        
      SELECT   
       ICPL1.TIPO,   
       ICPL1.ELEMENTO,   
       ICPL1.[SP_HELPTEXT],   
       ICPL1.CODIGO   
      FROM  
       -- AÑADO TEXTO_ICPL  
       (  
        SELECT DISTINCT  
         'ICPL' TIPO,  
         CONVERT(VARCHAR,ID_TAREA) +' - '+ ISNULL(PROGRAMADAS.DESCRIPCION_TAREA,'') ELEMENTO,  
         '' SP_HELPTEXT,  
         PROGRAMADAS.TEXTO_ICPL CODIGO  
        FROM    
         N_TAREAS_PROGRAMADAS AS PROGRAMADAS WITH(NOLOCK)   
        WHERE   
         TEXTO_ICPL LIKE '%' +  @TEXTO_BUSCAR  + '%'  
         AND TEXTO_ICPL LIKE '%' + @TEXTO_BUSCAR_2  + '%'  
         AND TEXTO_ICPL LIKE '%' + @TEXTO_BUSCAR_3  + '%'  
         AND TEXTO_ICPL LIKE '%' + @TEXTO_BUSCAR_4  + '%'  
         AND TEXTO_ICPL LIKE '%' + @TEXTO_BUSCAR_5  + '%'  
          
       ) ICPL1  
     ) T  
    ORDER BY   
     CASE   
      WHEN TIPO = 'P' THEN 1  
      WHEN TIPO = 'FN' THEN 2  
      WHEN TIPO = 'TR' THEN 3  
      WHEN TIPO = 'V' THEN 4  
      WHEN TIPO = 'JOB' THEN 5  
      WHEN TIPO = 'ICPL' THEN 6  
      ELSE 7   
     END ASC-- ORDENO PARA QUE APAREZCA LO QUE YO QUIERA PRIMERO  
     --PRINT 'A4'  
   END  
  ELSE  
   BEGIN  
    SELECT   
     TIPO,   
     ELEMENTO, [SP_HELPTEXT],  
     CODIGO  
    FROM   
     (  
      SELECT   
       TIPO             [TIPO] ,  
       ELEMENTO              [ELEMENTO],  
       'USE '+DB_NAME()+CHAR(10) +'GO'+CHAR(10)+'PAH ' + '''' + ELEMENTO + ''''  [SP_HELPTEXT] ,  
       LEFT(CODIGO,100) +'....................USA PAH PARA VER MÁS' [CODIGO]    
       FROM   
       #T   
        
      UNION  
      SELECT   
       C1.TIPO,   
       C1.ELEMENTO,   
       C1.[SP_HELPTEXT],   
       C1.CODIGO   
      FROM   
       --JOBS  
       (  
        SELECT DISTINCT  
         'JOB' TIPO,  
         ISNULL(SYSJOBS.NAME,'') ELEMENTO,  
         '' SP_HELPTEXT,  
         SYSJOBSS.COMMAND CODIGO  
        FROM    
         MSDB.DBO.SYSJOBSTEPS AS SYSJOBSS WITH(NOLOCK)  
  
         INNER JOIN   
         MSDB.DBO.SYSJOBS AS SYSJOBS WITH(NOLOCK)  
         ON SYSJOBS.JOB_ID = SYSJOBSS.JOB_ID  
        WHERE    
         SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR + '%'  
         AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_2 + '%'  
         AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_3 + '%'  
         AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_4 + '%'  
         AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_5 + '%'  
         OR  
         (  
         SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR  + '%'  
         AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_2  + '%'  
         AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_3  + '%'  
         AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_4  + '%'  
         AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_5  + '%'  
         )  
       )C1       
     ) T   
    ORDER BY   
     CASE   
      WHEN TIPO = 'P' THEN 1  
      WHEN TIPO = 'FN' THEN 2  
      WHEN TIPO = 'TR' THEN 3  
      WHEN TIPO = 'V' THEN 4  
      WHEN TIPO = 'JOB' THEN 5  
      WHEN TIPO = 'ICPL' THEN 6  
      ELSE 7   
     END ASC-- ORDENO PARA QUE APAREZCA LO QUE YO QUIERA PRIMERO  
     --PRINT 'A5'  
  END  
 END  
 ELSE  
 BEGIN  
  IF @TAREAS = 1   
  BEGIN  
   INSERT INTO #AUXILIAR_PAB (TIPO, BBDD, ELEMENTO, [SP_HELPTEXT], CODIGO)  
   --SELECT 'JOBS+ICPL'  
   SELECT * FROM (  
   SELECT   
    C1.TIPO,   
    '' BBDD,  
    C1.ELEMENTO,   
    C1.[SP_HELPTEXT],   
    C1.CODIGO   
   FROM   
    --JOBS  
    (  
     SELECT DISTINCT  
      'JOB' TIPO,  
      ISNULL(SYSJOBS.NAME,'') ELEMENTO,  
      '' SP_HELPTEXT,  
      SYSJOBSS.COMMAND CODIGO  
     FROM    
      MSDB.DBO.SYSJOBSTEPS AS SYSJOBSS WITH(NOLOCK)   
  
      INNER JOIN   
      MSDB.DBO.SYSJOBS AS SYSJOBS WITH(NOLOCK)   
      ON SYSJOBS.JOB_ID = SYSJOBSS.JOB_ID  
     WHERE    
      SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR  + '%'  
      AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_2 + '%'  
      AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_3 + '%'  
      AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_4 + '%'  
      AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_5 + '%'  
      OR (  
       SYSJOBS.NAME  LIKE '%' +  @TEXTO_BUSCAR  + '%'  
      AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_2  + '%'  
      AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_3  + '%'  
      AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_4  + '%'  
      AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_5  + '%'  
      )  
    )C1       
  
   UNION   
     
   SELECT   
    ICPL1.TIPO,   
    '' BBDD,  
    ICPL1.ELEMENTO,   
    ICPL1.[SP_HELPTEXT],   
    ICPL1.CODIGO   
   FROM  
    -- AÑADO TEXTO_ICPL  
    (  
     SELECT DISTINCT  
      'ICPL' TIPO,  
      CONVERT(VARCHAR,ID_TAREA) +' - '+ ISNULL(PROGRAMADAS.DESCRIPCION_TAREA,'') ELEMENTO,  
      '' SP_HELPTEXT,  
      PROGRAMADAS.TEXTO_ICPL CODIGO  
     FROM    
      N_TAREAS_PROGRAMADAS AS PROGRAMADAS WITH(NOLOCK)   
     WHERE   
      TEXTO_ICPL LIKE '%' +  @TEXTO_BUSCAR  + '%'  
      AND TEXTO_ICPL LIKE '%' + @TEXTO_BUSCAR_2  + '%'  
      AND TEXTO_ICPL LIKE '%' + @TEXTO_BUSCAR_3  + '%'  
      AND TEXTO_ICPL LIKE '%' + @TEXTO_BUSCAR_4  + '%'  
      AND TEXTO_ICPL LIKE '%' + @TEXTO_BUSCAR_5  + '%'  
       
    ) ICPL1 ) TT    
   ORDER BY   
   CASE   
    WHEN TIPO = 'P' THEN 1  
    WHEN TIPO = 'FN' THEN 2  
    WHEN TIPO = 'TR' THEN 3  
    WHEN TIPO = 'V' THEN 4  
    WHEN TIPO = 'JOB' THEN 5  
    WHEN TIPO = 'ICPL' THEN 6  
    ELSE 7   
   END ASC-- ORDENO PARA QUE APAREZCA LO QUE YO QUIERA PRIMERO  
   --PRINT 'A4'  
  END  
  ELSE  
  BEGIN  
   INSERT INTO #AUXILIAR_PAB(TIPO, BBDD, ELEMENTO, [SP_HELPTEXT], CODIGO)  
   --SELECT 'JOBS'  
   SELECT   
    C1.TIPO,   
    '' BBDD,  
    C1.ELEMENTO,   
    C1.[SP_HELPTEXT],   
    C1.CODIGO   
   FROM   
   --JOBS  
   (  
    SELECT DISTINCT  
     'JOB' TIPO,  
     ISNULL(SYSJOBS.NAME,'') ELEMENTO,  
     '' SP_HELPTEXT,  
     SYSJOBSS.COMMAND CODIGO  
    FROM    
     MSDB.DBO.SYSJOBSTEPS AS SYSJOBSS WITH(NOLOCK)  
  
     INNER JOIN   
     MSDB.DBO.SYSJOBS AS SYSJOBS WITH(NOLOCK)  
     ON SYSJOBS.JOB_ID = SYSJOBSS.JOB_ID  
    WHERE    
     SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR + '%'  
     AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_2 + '%'  
     AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_3 + '%'  
     AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_4 + '%'  
     AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_5 + '%'  
     OR  
     (  
     SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR  + '%'  
     AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_2  + '%'  
     AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_3  + '%'  
     AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_4  + '%'  
     AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_5  + '%'  
     )  
   )C1       
     
   ORDER BY   
    CASE   
     WHEN TIPO = 'P' THEN 1  
     WHEN TIPO = 'FN' THEN 2  
     WHEN TIPO = 'TR' THEN 3  
     WHEN TIPO = 'V' THEN 4  
     WHEN TIPO = 'JOB' THEN 5  
     WHEN TIPO = 'ICPL' THEN 6  
     ELSE 7   
    END ASC-- ORDENO PARA QUE APAREZCA LO QUE YO QUIERA PRIMERO  
    --PRINT 'A5'  
  END  
 END  
  
   
 IF @INVOKER = 99 AND EXISTS (select OBJECT_ID('tempdb..#AUXILIAR_PAB'))  
 BEGIN    
   
   
   SELECT TIPO, BBDD, ELEMENTO, [SP_HELPTEXT], CODIGO FROM #AUXILIAR_PAB  
   ORDER BY  
   CASE  
    WHEN BBDD = '' THEN 99  
    ELSE 0  
   END ASC,  
   BBDD ASC,  
   CASE   
    WHEN TIPO = 'P' THEN 1  
    WHEN TIPO = 'FN' THEN 2  
    WHEN TIPO = 'TR' THEN 3  
    WHEN TIPO = 'V' THEN 4  
    WHEN TIPO = 'JOB' THEN 5  
    WHEN TIPO = 'ICPL' THEN 6  
    ELSE 7   
   END ASC,-- ORDENO PARA QUE APAREZCA LO QUE YO QUIERA PRIMERO  
   ELEMENTO ASC  
 END  
   
  
  
END
GO
/****** Object:  StoredProcedure [dbo].[PACE]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- AUTOR: Edgar
-- FECHA: 13/12/2019
-- DESCRIPCION:	PA que devuelve los posibles resultados de búsqueda de conexiones de servidores, así como su omónimo en desarrollo/producción
-- =============================================


CREATE PROCEDURE [dbo].[PACE]
(
	@BUSQUEDA AS VARCHAR(MAX) = '',
	@INVOKER INT = 0 -- 0: NORMAL -> 1: BÚSQUEDA LITERAL
)
AS
IF @INVOKER = 0
BEGIN
	SELECT 
		C.ID_CONEXION, 
		E.SERVIDOR, 
		E.BASE_DATOS, 
		C.CONEXION
	FROM 
		ICPM.DBO.CONEXIONES C
		INNER JOIN
		ICPM.DBO.ENTORNOS_CONEXIONES E
		ON C.ID_CONEXION = E.ID_CONEXION
	
		LEFT OUTER JOIN ICPM.DBO.ALIAS_SERVIDORES ALS
		ON ALS.ALIAS_SERVIDOR = E.SERVIDOR
	
		LEFT OUTER JOIN 
		(
			SELECT S.SERVIDOR , S.F_BAJA FROM ICPM.DBO.SERVIDORES S
			UNION ALL
			SELECT ALS.ALIAS_SERVIDOR, SS.F_BAJA FROM ICPM.DBO.ALIAS_SERVIDORES ALS 
			INNER JOIN ICPM.DBO.SERVIDORES SS
			ON SS.SERVIDOR = ALS.SERVIDOR
		) M
		ON M.SERVIDOR = E.SERVIDOR
	

	WHERE
		C.CONEXION LIKE '%' + @BUSQUEDA + '%' OR 
		E.BASE_DATOS LIKE '%' + @BUSQUEDA + '%' OR 
		COD_CONEXION LIKE '%' + @BUSQUEDA + '%' OR
		E.SERVIDOR LIKE '%' + @BUSQUEDA + '%' OR
		ALS.SERVIDOR LIKE '%' + @BUSQUEDA + '%'
	AND  ISNULL(M.F_BAJA,GETDATE()+100) >= GETDATE()
	ORDER BY 
		C.ID_CONEXION
END

ELSE

BEGIN
	SELECT 
		C.ID_CONEXION, 
		E.SERVIDOR, 
		E.BASE_DATOS, 
		C.CONEXION
	FROM 
		ICPM.DBO.CONEXIONES C
		INNER JOIN
		ICPM.DBO.ENTORNOS_CONEXIONES E
		ON C.ID_CONEXION = E.ID_CONEXION
	
		LEFT OUTER JOIN ICPM.DBO.ALIAS_SERVIDORES ALS
		ON ALS.ALIAS_SERVIDOR = E.SERVIDOR
	
		LEFT OUTER JOIN 
		(
			SELECT S.SERVIDOR , S.F_BAJA FROM ICPM.DBO.SERVIDORES S
			UNION ALL
			SELECT ALS.ALIAS_SERVIDOR, SS.F_BAJA FROM ICPM.DBO.ALIAS_SERVIDORES ALS 
			INNER JOIN ICPM.DBO.SERVIDORES SS
			ON SS.SERVIDOR = ALS.SERVIDOR
		) M
		ON M.SERVIDOR = E.SERVIDOR
	

	WHERE
		C.CONEXION = @BUSQUEDA OR 
		E.BASE_DATOS = @BUSQUEDA OR
		COD_CONEXION = @BUSQUEDA OR
		E.SERVIDOR = @BUSQUEDA OR
		ALS.SERVIDOR = @BUSQUEDA
	AND  ISNULL(M.F_BAJA,GETDATE()+100) >= GETDATE()
	ORDER BY 
		C.ID_CONEXION
END
GO
/****** Object:  StoredProcedure [dbo].[PAF]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Autor: Edgar García
-- Fecha: 10/04/2018
-- Mapeo: Javier Rodriguez

CREATE PROCEDURE [dbo].[PAF]
(
	@ENTRADA VARCHAR(800) = ''
)
AS


DECLARE @AUX INT = 0
DECLARE @SQLSTRING NVARCHAR(MAX) = N''

DECLARE @SALIDA1 NVARCHAR(800)
DECLARE @SALIDA2 NVARCHAR(800)
DECLARE @SALIDA3 NVARCHAR(800)
DECLARE @SALIDA4 NVARCHAR(800)
DECLARE @SALIDA5 NVARCHAR(800)
DECLARE @SALIDA6 NVARCHAR(800)

CREATE TABLE #FUENTE
(	INDICE INT IDENTITY(1,1),
	COMENTARIO NVARCHAR(2),
	A NVARCHAR(20),
	B NVARCHAR(20),
	C NVARCHAR(20),
	D NVARCHAR(20),
	E NVARCHAR(20),
	F NVARCHAR(20),
	G NVARCHAR(20),
	H NVARCHAR(20),
	I NVARCHAR(20),
	J NVARCHAR(20),
	K NVARCHAR(20),
	L NVARCHAR(20),
	M NVARCHAR(20),
	N NVARCHAR(20),
	Ñ NVARCHAR(20),
	O NVARCHAR(20),
	P NVARCHAR(20),
	Q NVARCHAR(20),
	R NVARCHAR(20),
	S NVARCHAR(20),
	T NVARCHAR(20),
	U NVARCHAR(20),
	V NVARCHAR(20),
	W NVARCHAR(20),
	X NVARCHAR(20),
	Y NVARCHAR(20),
	Z NVARCHAR(20),
	[0] NVARCHAR(20),
	[1] NVARCHAR(20),
	[2] NVARCHAR(20),
	[3] NVARCHAR(20),
	[4] NVARCHAR(20),
	[5] NVARCHAR(20),
	[6] NVARCHAR(20),
	[7] NVARCHAR(20),
	[8] NVARCHAR(20),
	[9] NVARCHAR(20),
	[!] NVARCHAR(20),
	[#] NVARCHAR(20),
	[$] NVARCHAR(20),
	[%] NVARCHAR(20),
	[&] NVARCHAR(20),
	[(] NVARCHAR(20),
	[)] NVARCHAR(20),
	[*] NVARCHAR(20),
	[,] NVARCHAR(20),
	[-] NVARCHAR(20),
	[.] NVARCHAR(20),
	[/] NVARCHAR(20),
	[:] NVARCHAR(20),
	[;] NVARCHAR(20),
	[<] NVARCHAR(20),
	[>] NVARCHAR(20),
	[?] NVARCHAR(20),
	[@] NVARCHAR(20),
	[_] NVARCHAR(20),
	[ ] NVARCHAR(20),
	[=] NVARCHAR(20),
	[^] NVARCHAR(20)
) 

INSERT INTO #FUENTE (COMENTARIO,A,B,C,D,E,F,G,H,I,J,K,L,M,N,[Ñ],O,P,Q,R,S,T,U,V,W,X,Y,Z,[0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[!],[#],[$],[%],[&],[(],[)],[*],[,],[-],[.],[/],[:],[;],[<],[>],[?],[@],[_],[ ],[=], [^]) 
	SELECT N'--', N' █████╗ ' A, N'██████╗ 'B, N' ██████╗' C, N'██████╗ 'D, N'███████╗'E, N'███████╗'F, N' ██████╗ 'G, N'██╗  ██╗'H, N'██╗'I, N'     ██╗'J, N'██╗  ██╗'K, N'██╗     'L, N'███╗   ███╗'M, N'███╗   ██╗'N,N'   ████╗  ' Ñ, N' ██████╗ 'O, N'██████╗ 'P, N' ██████╗ 'Q, N'██████╗ 'R, N'███████╗'S, N'████████╗'T, N'██╗   ██╗'U, N'██╗   ██╗'V, N'██╗    ██╗'W, N'██╗  ██╗'X, N'██╗   ██╗'Y, N'███████╗' Z, N' ██████╗ '[0], N' ██╗'[1], N'██████╗ '[2], N'██████╗ '[3], N'██╗  ██╗'[4], N'███████╗'[5], N' ██████╗ '[6], N'███████╗' [7], N' █████╗ ' [8], N' █████╗ ' [9], N'██╗' [!], N' ██╗ ██╗ ' [#], N'▄▄███▄▄·' [$], N'██╗ ██╗' [%], N'   ██╗   ' [$], N' ██╗' [(], N'██╗ ' [)], N'      ' [*], N'   ' [,], N'      ' [-], N'   ' [.], N'    ██╗' [/], N'   '[:], N'   ' [;], N'  ██╗' [<], N'██╗  '[>], N'██████╗ ' [?], N' ██████╗ '[@],  N'        ' [_], N'		' [ ],N'        ' [=],N'   ██╗   ' [^]
	UNION ALL																																																																																																								    		      	    
	SELECT N'--', N'██╔══██╗' A, N'██╔══██╗'B, N'██╔════╝' C, N'██╔══██╗'D, N'██╔════╝'E, N'██╔════╝'F, N'██╔════╝ 'G, N'██║  ██║'H, N'██║'I, N'     ██║'J, N'██║ ██╔╝'K, N'██║     'L, N'████╗ ████║'M, N'████╗  ██║'N,N'████╗═╝██╗' Ñ, N'██╔═══██╗'O, N'██╔══██╗'P, N'██╔═══██╗'Q, N'██╔══██╗'R, N'██╔════╝'S, N'╚══██╔══╝'T, N'██║   ██║'U, N'██║   ██║'V, N'██║    ██║'W, N'╚██╗██╔╝'X, N'╚██╗ ██╔╝'Y, N'╚══███╔╝' Z, N'██╔═████╗'[0], N'███║'[1], N'╚════██╗'[2], N'╚════██╗'[3], N'██║  ██║'[4], N'██╔════╝'[5], N'██╔════╝ '[6], N'╚════██║' [7], N'██╔══██╗' [8], N'██╔══██╗' [9],	N'██║' [!], N'████████╗' [#], N'██╔════╝' [$], N'╚═╝██╔╝' [%], N'   ██║   ' [$], N'██╔╝' [(], N'╚██╗' [)], N'▄ ██╗▄' [*], N'   ' [,], N'      ' [-], N'   ' [.], N'   ██╔╝' [/], N'██╗'[:], N'██╗' [;], N' ██╔╝' [<], N'╚██╗ '[>], N'╚════██╗' [?], N'██╔═══██╗'[@], N'        ' [_], N'		' [ ],N'███████╗' [=],N' ██╔═██╗ ' [^]
	UNION ALL																																																																																																								    		      	         
	SELECT N'--', N'███████║' A, N'██████╔╝'B, N'██║     ' C, N'██║  ██║'D, N'█████╗  'E, N'█████╗  'F, N'██║  ███╗'G, N'███████║'H, N'██║'I, N'     ██║'J, N'█████╔╝ 'K, N'██║     'L, N'██╔████╔██║'M, N'██╔██╗ ██║'N,N'██╔██╗ ██║' Ñ, N'██║   ██║'O, N'██████╔╝'P, N'██║   ██║'Q, N'██████╔╝'R, N'███████╗'S, N'   ██║   'T, N'██║   ██║'U, N'██║   ██║'V, N'██║ █╗ ██║'W, N' ╚███╔╝ 'X, N' ╚████╔╝ 'Y, N'  ███╔╝ ' Z, N'██║██╔██║'[0], N'╚██║'[1], N' █████╔╝'[2], N' █████╔╝'[3], N'███████║'[4], N'███████╗'[5], N'███████╗ '[6], N'    ██╔╝' [7], N'╚█████╔╝' [8], N'╚██████║' [9],	N'██║' [!], N'╚██╔═██╔╝' [#], N'███████╗' [$], N'  ██╔╝ ' [%], N'████████╗' [$], N'██║ ' [(], N' ██║' [)], N' ████╗' [*], N'   ' [,], N'█████╗' [-], N'   ' [.], N'  ██╔╝ ' [/], N'╚═╝'[:], N'╚═╝' [;], N'██╔╝ ' [<], N' ╚██╗'[>], N'  ▄███╔╝' [?], N'██║██╗██║'[@], N'        ' [_], N'		' [ ],N'╚══════╝' [=],N'██╔╝ ╚██╗' [^]
	UNION ALL																																																																																																								    		      	    
	SELECT N'--', N'██╔══██║' A, N'██╔══██╗'B, N'██║     ' C, N'██║  ██║'D, N'██╔══╝  'E, N'██╔══╝  'F, N'██║   ██║'G, N'██╔══██║'H, N'██║'I, N'██   ██║'J, N'██╔═██╗ 'K, N'██║     'L, N'██║╚██╔╝██║'M, N'██║╚██╗██║'N,N'██║╚██╗██║' Ñ, N'██║   ██║'O, N'██╔═══╝ 'P, N'██║▄▄ ██║'Q, N'██╔══██╗'R, N'╚════██║'S, N'   ██║   'T, N'██║   ██║'U, N'╚██╗ ██╔╝'V, N'██║███╗██║'W, N' ██╔██╗ 'X, N'  ╚██╔╝  'Y, N' ███╔╝  ' Z, N'████╔╝██║'[0], N' ██║'[1], N'██╔═══╝ '[2], N' ╚═══██╗'[3], N'╚════██║'[4], N'╚════██║'[5], N'██╔═══██╗'[6], N'   ██╔╝ ' [7], N'██╔══██╗' [8], N' ╚═══██║' [9],	N'╚═╝' [!], N'████████╗' [#], N'╚════██║' [$], N' ██╔╝  ' [%], N'██╔═██╔═╝' [$], N'██║ ' [(], N' ██║' [)], N'▀╚██╔▀' [*], N'   ' [,], N'╚════╝' [-], N'   ' [.], N' ██╔╝  ' [/], N'██╗'[:], N'▄█╗' [;], N'╚██╗ ' [<], N' ██╔╝'[>], N'  ▀▀══╝ ' [?], N'██║██║██║'[@], N'        ' [_], N'		' [ ],N'███████╗' [=],N'╚═╝   ╚═╝' [^]
	UNION ALL																																																																																																								    		      	         
	SELECT N'--', N'██║  ██║' A, N'██████╔╝'B, N'╚██████╗' C, N'██████╔╝'D, N'███████╗'E, N'██║     'F, N'╚██████╔╝'G, N'██║  ██║'H, N'██║'I, N'╚█████╔╝'J, N'██║  ██╗'K, N'███████╗'L, N'██║ ╚═╝ ██║'M, N'██║ ╚████║'N,N'██║ ╚████║' Ñ, N'╚██████╔╝'O, N'██║     'P, N'╚██████╔╝'Q, N'██║  ██║'R, N'███████║'S, N'   ██║   'T, N'╚██████╔╝'U, N' ╚████╔╝ 'V, N'╚███╔███╔╝'W, N'██╔╝ ██╗'X, N'   ██║   'Y, N'███████╗' Z, N'╚██████╔╝'[0], N' ██║'[1], N'███████╗'[2], N'██████╔╝'[3], N'     ██║'[4], N'███████║'[5], N'╚██████╔╝'[6], N'   ██║  ' [7], N'╚█████╔╝' [8], N' █████╔╝' [9],	N'██╗' [!], N'╚██╔═██╔╝' [#], N'███████║' [$], N'██╔╝██╗' [%], N'██████║  ' [$], N'╚██╗' [(], N'██╔╝' [)], N'  ╚═╝ ' [*], N'▄█╗' [,], N'      ' [-], N'██╗' [.], N'██╔╝   ' [/], N'╚═╝'[:], N'▀═╝' [;], N' ╚██╗' [<], N'██╔╝ '[>], N'  ██╗   ' [?], N'╚█║████╔╝'[@], N'███████╗' [_], N'		' [ ],N'╚══════╝' [=],N'	   ' [^]
	UNION ALL																																																																																																								     		      	
	SELECT N'--', N'╚═╝  ╚═╝' A, N'╚═════╝ 'B, N' ╚═════╝' C, N'╚═════╝ 'D, N'╚══════╝'E, N'╚═╝     'F, N' ╚═════╝ 'G, N'╚═╝  ╚═╝'H, N'╚═╝'I, N' ╚════╝ 'J, N'╚═╝  ╚═╝'K, N'╚══════╝'L, N'╚═╝     ╚═╝'M, N'╚═╝  ╚═══╝'N,N'╚═╝  ╚═══╝' Ñ, N' ╚═════╝ 'O, N'╚═╝     'P, N' ╚══▀▀═╝ 'Q, N'╚═╝  ╚═╝'R, N'╚══════╝'S, N'   ╚═╝   'T, N' ╚═════╝ 'U, N'  ╚═══╝  'V, N' ╚══╝╚══╝ 'W, N'╚═╝  ╚═╝'X, N'   ╚═╝   'Y, N'╚══════╝' Z, N' ╚═════╝ '[0], N' ╚═╝'[1], N'╚══════╝'[2], N'╚═════╝ '[3], N'     ╚═╝'[4], N'╚══════╝'[5], N' ╚═════╝ '[6], N'   ╚═╝  ' [7], N' ╚════╝ ' [8], N' ╚════╝ ' [9],	N'╚═╝' [!], N' ╚═╝ ╚═╝ ' [#], N'╚═▀▀▀══╝' [$], N'╚═╝ ╚═╝' [%], N'╚═════╝  ' [$], N' ╚═╝' [(], N'╚═╝ ' [)], N'      ' [*], N'╚═╝' [,], N'      ' [-], N'╚═╝' [.], N'╚═╝    ' [/], N'   '[:], N'   ' [;], N'  ╚═╝' [<], N'╚═╝  '[>], N'  ╚═╝   ' [?], N' ╚╝╚═══╝ '[@], N'╚══════╝' [_], N'		' [ ],N'	' [=],N'	   ' [^]



SET @AUX = LEN(@ENTRADA)


DECLARE @TOTALCHAR INT = LEN(@ENTRADA)
DECLARE @CONT INT = @TOTALCHAR

BEGIN TRY

WHILE @CONT >= 1
BEGIN

    IF @CONT % 1 = 0 AND @CONT + 1 <= @TOTALCHAR
    BEGIN
	SET @ENTRADA = STUFF(@ENTRADA, @CONT + 1, 0, ']+[')
    END

    SET @CONT = @CONT - 1
END


SET @SQLSTRING = N'SELECT COMENTARIO + ['+ @ENTRADA + '] FROM #FUENTE'
PRINT @SQLSTRING
EXEC SP_EXECUTESQL @SQLSTRING

END TRY
BEGIN CATCH
	SELECT 'ALGUNO DE LOS CARACTERES ESPECIALES NO ESTÁ MAPEADO, PRUEBE A QUITARLOS'
END CATCH


GO
/****** Object:  StoredProcedure [dbo].[PAH]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author: Edgar  
-- Create date: 06/06/2017  
-- Description: PA que devuelve un procedimiento con las líneas sin los fallos de SP_HELPTEXT  
-- =============================================  
  
  
CREATE PROCEDURE [dbo].[PAH](@TEXTO VARCHAR(100))  
AS  
     BEGIN  
       
     SET NOCOUNT ON;  
  
         DECLARE @OBJNAME NVARCHAR(776)= @TEXTO;  
         DECLARE @OBJECTTEXT NVARCHAR(MAX)= '';  
         DECLARE @SYSCOMTEXT NVARCHAR(MAX);  
         DECLARE @LINELEN INT;  
         DECLARE @LINEEND BIT= 0;  
         DECLARE @COMMENTTEXT TABLE  
         (LINEID INT IDENTITY(1, 1),  
          TEXT   NVARCHAR(MAX)  
         );  
   
 IF NOT EXISTS (SELECT 1/0  
  FROM SYS.SYSCOMMENTS  
  WHERE ID = OBJECT_ID(@OBJNAME)  
  AND ENCRYPTED = 0)  
 BEGIN  
  SELECT @TEXTO + ' NO EXISTE EN ' + @@SERVERNAME +'.'+ DB_NAME()  
  RETURN 0  
 END  
            
         DECLARE MS_CRS_SYSCOM CURSOR LOCAL  
         FOR  
             SELECT TEXT  
             FROM SYS.SYSCOMMENTS  
             WHERE ID = OBJECT_ID(@OBJNAME)  
                   AND ENCRYPTED = 0  
             ORDER BY NUMBER,  
                      COLID  
         FOR READ ONLY;  
         OPEN MS_CRS_SYSCOM;  
         FETCH NEXT FROM MS_CRS_SYSCOM INTO @SYSCOMTEXT;  
         WHILE @@FETCH_STATUS >= 0  
             BEGIN  
                 SET @LINELEN = CHARINDEX(CHAR(10), @SYSCOMTEXT);  
                 WHILE @LINELEN > 0  
                     BEGIN  
                         SELECT @OBJECTTEXT+=LEFT(@SYSCOMTEXT, @LINELEN),  
                                @SYSCOMTEXT = SUBSTRING(@SYSCOMTEXT, @LINELEN+1, 4000),  
                                @LINELEN = CHARINDEX(CHAR(10), @SYSCOMTEXT),  
                                @LINEEND = 1;  
                         INSERT INTO @COMMENTTEXT(TEXT)  
                         VALUES(@OBJECTTEXT);  
                         SET @OBJECTTEXT = '';  
                     END;  
                 IF @LINELEN = 0  
                     SET @OBJECTTEXT+=@SYSCOMTEXT;  
                     ELSE  
                 SELECT @OBJECTTEXT = @SYSCOMTEXT,  
                        @LINELEN = 0;  
                 FETCH NEXT FROM MS_CRS_SYSCOM INTO @SYSCOMTEXT;  
             END;  
         CLOSE MS_CRS_SYSCOM;  
         DEALLOCATE MS_CRS_SYSCOM;  
         INSERT INTO @COMMENTTEXT(TEXT)  
                SELECT @OBJECTTEXT;  
           
  SELECT TEXT  
         FROM @COMMENTTEXT  
         ORDER BY LINEID;  
       
     END;  
  
GO
/****** Object:  StoredProcedure [dbo].[PAP]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------------------------------------------------------   
-- PA QUE ME MONTA CADENA DE PRUEBAS DE PAS  
-- AUTOR: JJ   
-- FECHA: 27/3/2007  
------------------------------------------------------------------------------------------------------------------------------------  
-- ROBERTO RAMIRO  
-- 28/01/2015  
-- DEVOLVEMOS MAX SI MAX_LENGTH ES -1. NO DECLARAMOS @RETCODE SI YA ESTA ENTRE LOS PARAMETROS DEL PA  
------------------------------------------------------------------------------------------------------------------------------------  
-- EDGAR
-- 17/09/2020
-- ARREGLOS VARIOS: ENTRE ELLOS YA NO SACARÁ EXEC ' @RETCODE = ' CUANDO HAYA UN PARÁMETRO RETCODE DE SALIDA
------------------------------------------------------------------------------------------------------------------------------------

-- █████╗ ██╗   ██╗██╗███████╗ ██████╗ 		██╗███╗   ███╗██████╗  ██████╗ ██████╗ ████████╗ █████╗ ███╗   ██╗████████╗███████╗
--██╔══██╗██║   ██║██║██╔════╝██╔═══██╗		██║████╗ ████║██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝██╔══██╗████╗  ██║╚══██╔══╝██╔════╝
--███████║██║   ██║██║███████╗██║   ██║		██║██╔████╔██║██████╔╝██║   ██║██████╔╝   ██║   ███████║██╔██╗ ██║   ██║   █████╗  
--██╔══██║╚██╗ ██╔╝██║╚════██║██║   ██║		██║██║╚██╔╝██║██╔═══╝ ██║   ██║██╔══██╗   ██║   ██╔══██║██║╚██╗██║   ██║   ██╔══╝  
--██║  ██║ ╚████╔╝ ██║███████║╚██████╔╝		██║██║ ╚═╝ ██║██║     ╚██████╔╝██║  ██║   ██║   ██║  ██║██║ ╚████║   ██║   ███████╗
--╚═╝  ╚═╝  ╚═══╝  ╚═╝╚══════╝ ╚═════╝ 		╚═╝╚═╝     ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝
--CUALQUIER CAMBIO REALIZADO EN ESTE PA SERÁ AUTOMÁTICAMENTE REEMPLAZADO DESDE ICPM EN ISERVER1, POR LO QUE SE PERDERÁ.
------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[PAP]
	(
		@NOMBRE_PA AS VARCHAR(200)   
	)
AS  
  
DECLARE @ID_PA AS INTEGER  
DECLARE @CADENA_PA AS VARCHAR(8000)  
DECLARE @CADENA_PA2 AS VARCHAR(8000)  
DECLARE @CADENA_PA3 AS VARCHAR(8000)  
DECLARE @CADENA_PA4 AS VARCHAR(8000)  
DECLARE @NOMBRE AS VARCHAR(30)  
DECLARE @TIPO AS VARCHAR(30)  
DECLARE @DIMENSION AS VARCHAR(30)  
DECLARE @VALOR_DEFECTO AS VARCHAR(30)  
DECLARE @OUT AS VARCHAR(30)  
DECLARE @ORDER AS INTEGER  
DECLARE @AUX AS VARCHAR(30)  
DECLARE @TIENE_RETCODE AS BIT  
DECLARE @TIENE_RETCODE_OUTPUT AS BIT = 0
   
  
SET @CADENA_PA = ''  
SET @CADENA_PA2 = ''  
SET @CADENA_PA3 = 'EXEC @RETCODE = ' + @NOMBRE_PA + ' ' + CHAR(10)  
SET @CADENA_PA4 = ''  
  
SET @TIENE_RETCODE = 0  
   
SELECT @ID_PA = OBJECT_ID,   
	@TIPO  =  TYPE  
FROM 
	SYS.ALL_OBJECTS  
WHERE 
	OBJECT_ID = OBJECT_ID(@NOMBRE_PA)  
  
   
SET @NOMBRE = ''  

SELECT  TOP 1  
	@NOMBRE = NAME,  
	@OUT = CASE  
	WHEN IS_OUTPUT = 1 THEN 'OUTPUT'  
		ELSE ''  
	END,  
	@TIPO = UPPER(TYPE_NAME (USER_TYPE_ID)),    
	@DIMENSION = CASE  
	WHEN TYPE_NAME (USER_TYPE_ID) IN ('VARCHAR', 'CHAR', 'NVARCHAR') THEN '(' + CASE WHEN MAX_LENGTH = -1 THEN 'MAX' ELSE CAST(MAX_LENGTH AS VARCHAR(30)) END +')'   
		WHEN TYPE_NAME (USER_TYPE_ID) IN ('VARBINARY') THEN '(MAX)'
		ELSE ''  
	END,  
	@VALOR_DEFECTO = CASE  
	WHEN TYPE_NAME (USER_TYPE_ID) IN ('VARCHAR', 'CHAR', 'NVARCHAR') THEN  CHAR(39) + CHAR(39)       
		WHEN TYPE_NAME (USER_TYPE_ID) IN ('DATETIME', 'SMALLDATETIME') THEN 'NULL'
		WHEN TYPE_NAME (USER_TYPE_ID) IN ('XML') THEN CHAR(39) +'<ROOT></ROOT>'+ CHAR(39)     
		ELSE '0'  
	END,  
	@ORDER = PARAMETER_ID   
FROM 
	SYS.ALL_PARAMETERS   
WHERE 
	OBJECT_ID = @ID_PA  
ORDER BY 
	PARAMETER_ID  
  
  
WHILE @NOMBRE <> ''  
BEGIN  
	IF @NOMBRE like '%RETCODE%' SET @TIENE_RETCODE = 1  
	
	IF @NOMBRE like '%RETCODE%'AND @OUT = 'OUTPUT'
	BEGIN
		SET @TIENE_RETCODE_OUTPUT = 1
	END

	DECLARE @TABULACIONES VARCHAR(MAX) = ''
	DECLARE @LONGITUD_MAX INT = 0
	DECLARE @VUELTAS INT = 0

	SELECT 
		@LONGITUD_MAX = MAX(LEN(NAME))
	FROM 
		SYS.ALL_PARAMETERS   
	WHERE 
		OBJECT_ID = @ID_PA 

	SET @VUELTAS = 0
	SET @TABULACIONES = ''

	WHILE @VUELTAS < @LONGITUD_MAX - LEN(@NOMBRE)
	BEGIN
		SET @TABULACIONES = @TABULACIONES + CHAR(32)
		SET @VUELTAS = @VUELTAS +1
	END

	SET @CADENA_PA = @CADENA_PA + 'DECLARE ' + @NOMBRE +' '+ @TABULACIONES + @TIPO + @DIMENSION + CHAR(10)  
	SET @CADENA_PA2 = @CADENA_PA2 + 'SET ' + @NOMBRE + ' = ' + @VALOR_DEFECTO + CHAR(10)  
	SET @CADENA_PA3 = @CADENA_PA3 + CHAR(9)+@NOMBRE + ' ' + @OUT + ',' + CHAR(10)  
	
	IF @OUT <> ''  
	BEGIN  
		SET @AUX = REPLACE(@NOMBRE, '@', '')  
		SET @AUX = REPLACE(@AUX, '_', ' ')  
		SET @CADENA_PA4 = @CADENA_PA4 + 'PRINT ' + CHAR(39) + @AUX  + ': ' + CHAR(39) + ' + CAST(' +  @NOMBRE + ' AS VARCHAR(MAX))' + CHAR(10)  
	END  
      
  
	SET @NOMBRE = ''  

	SELECT  TOP 1  
		@NOMBRE = NAME,  
		@OUT = CASE  
		WHEN IS_OUTPUT = 1 THEN 'OUTPUT'  
			ELSE ''  
		END,  
		@TIPO = UPPER(TYPE_NAME (USER_TYPE_ID)),  
		@DIMENSION = CASE  
		WHEN TYPE_NAME (USER_TYPE_ID) IN ('VARCHAR', 'CHAR', 'NVARCHAR') THEN '(' + CASE WHEN MAX_LENGTH = -1 THEN 'MAX' ELSE CAST(MAX_LENGTH AS VARCHAR(30)) END +')'   
		WHEN TYPE_NAME (USER_TYPE_ID) IN ('VARBINARY') THEN '(MAX)'		
			ELSE ''  
		END,  
		@VALOR_DEFECTO = CASE  
		WHEN TYPE_NAME (USER_TYPE_ID) IN ('VARCHAR', 'CHAR', 'NVARCHAR') THEN  CHAR(39) + CHAR(39)       
		WHEN TYPE_NAME (USER_TYPE_ID) IN ('DATETIME', 'SMALLDATETIME') THEN 'NULL'
		WHEN TYPE_NAME (USER_TYPE_ID) IN ('XML') THEN CHAR(39) +'<ROOT></ROOT>'+ CHAR(39)
			ELSE '0'  
		END,  
		@ORDER = PARAMETER_ID  
	FROM 
		SYS.ALL_PARAMETERS   
	WHERE 
		OBJECT_ID = @ID_PA  
		AND PARAMETER_ID > @ORDER  
	ORDER BY 
		PARAMETER_ID  
 


END  
 

SET @VUELTAS = 0
SET @TABULACIONES = ''

WHILE @VUELTAS < @LONGITUD_MAX - LEN('@RETCODE')
BEGIN
	SET @TABULACIONES = @TABULACIONES + CHAR(32)
	SET @VUELTAS = @VUELTAS +1
END


IF  @TIENE_RETCODE_OUTPUT = 1
BEGIN
	SET @CADENA_PA3 = REPLACE(@CADENA_PA3,'EXEC @RETCODE = ','EXEC ')
END

IF @TIENE_RETCODE_OUTPUT = 0 SET @CADENA_PA4 = @CADENA_PA4 + 'PRINT ' + CHAR(39) + 'RETCODE: ' + CHAR(39) + ' + CAST(@RETCODE AS VARCHAR(10))' + CHAR(10)  
	SET @CADENA_PA3 = LEFT(@CADENA_PA3, LEN(@CADENA_PA3) - 2)  
IF @TIENE_RETCODE = 0  
	SET @CADENA_PA = @CADENA_PA + 'DECLARE @RETCODE'+' '+ @TABULACIONES+'INT ' + CHAR(10) + CHAR(10)  
ELSE  
	SET @CADENA_PA = @CADENA_PA + CHAR(10)  

SET @CADENA_PA = @CADENA_PA + @CADENA_PA2 + CHAR(10) + @CADENA_PA3 + CHAR(10) + CHAR(10) + @CADENA_PA4  
 
  
PRINT @CADENA_PA  
  


GO
/****** Object:  StoredProcedure [dbo].[PASE]    Script Date: 21/06/2022 22:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-----------------------------------------------------------------------------------------------------------------------------------------------------

	NOMBRE DEL PROCEDIMIENTO:	PASE
	FECHA DE CREACIÓN: 		26/02/2020
	AUTOR:				EDGAR
	VSS:				RUTA VISUAL SOURCESAFE EJ: 

	FUNCIONAMIENTO:			FUNCIONAMIENTO

	PARAMETROS:			(OPCIONAL)
		PARAMETRO1 		INPUT	EXPLICACION
		PARAMETRO2 		OUTPUT	EXPLICACION

-------------------------------------------------------------------------------------------------------------------------------------------------------
--	FECHA DE MODIFICACIÓN:
--	AUTOR:
--	EXPLICACIÓN:	
------------------------------------------------------------------------------------------------------------------------------------------------------*/


CREATE PROCEDURE [dbo].[PASE] (@TABLA VARCHAR(100))
AS
DECLARE @CAMPOS VARCHAR(MAX) = ''

IF OBJECT_ID (N'v_sql', N'V') IS NULL 
BEGIN
	PRINT 'No existe V_SQL'
	RETURN -1
END
ELSE
BEGIN
	SELECT   
		@CAMPOS += CHAR(9)+C.COLUMN_NAME +','+CHAR(10) 

	FROM     
		INFORMATION_SCHEMA.COLUMNS C
		INNER JOIN INFORMATION_SCHEMA.TABLES T
		ON C.TABLE_NAME = T.TABLE_NAME
		AND C.TABLE_SCHEMA = T.TABLE_SCHEMA
		AND T.TABLE_TYPE = 'BASE TABLE'
	WHERE 
		C.TABLE_NAME = @TABLA
		AND C.COLUMN_NAME NOT LIKE '%PASS%' 
		AND C.COLUMN_NAME NOT LIKE '%PWD%' 
		AND C.COLUMN_NAME NOT LIKE '%CONTRASE_A%' 
	ORDER BY 
		ORDINAL_POSITION
	OPTION (RECOMPILE)
END

IF ISNULL(@CAMPOS ,'') = ''
BEGIN
	PRINT 'No existe la tabla '+ @TABLA
	RETURN -1
END

SET @CAMPOS = LEFT(@CAMPOS, LEN(@CAMPOS) - 2) + CHAR(10)

SELECT 'SELECT '+CHAR(10)+@CAMPOS+ 'FROM '+ CHAR(10) +CHAR(9)+@TABLA +' WITH(NOLOCK)' 'SELECT'



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
