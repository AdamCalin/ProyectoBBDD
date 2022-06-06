USE [DAW]
GO

/****** Object:  StoredProcedure [dbo].[PA_CREAR_USUARIO]    Script Date: 06/06/2022 16:27:23 ******/
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

