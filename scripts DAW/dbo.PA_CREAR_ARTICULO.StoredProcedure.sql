USE [DAW]
GO
/****** Object:  StoredProcedure [dbo].[PA_CREAR_ARTICULO]    Script Date: 27/05/2022 15:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PA_CREAR_ARTICULO]
(  
 @DESCRIPCION VARCHAR(50),  
 @FABRICANTE VARCHAR(50),
 @PESO INT,  
 @ALTO INT,
 @LARGO INT,  
 @ANCHO INT,
 @PRECIO DECIMAL(10, 2),  
 @N_REGISTRO VARCHAR(50),
 @IMAGEN image,

  
 @MENSAJE VARCHAR(100) OUTPUT,  
 @RETCODE INT OUTPUT  
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
	ALTO,
	LARGO,
	ANCHO,
	PRECIO,
	N_REGISTRO,
	IMAGEN
 )  
 VALUES  
 (  
	@DESCRIPCION,
	@FABRICANTE,
	@PESO,
	@ALTO,
	@LARGO,
	@ANCHO,
	@PRECIO,
	@N_REGISTRO,
	@IMAGEN
	 
 )  
   
 RETURN   
  
END TRY  
  
BEGIN CATCH  
  
END CATCH
GO
