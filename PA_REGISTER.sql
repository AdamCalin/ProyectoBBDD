USE [DAW]
GO

/****** Object:  StoredProcedure [dbo].[PA_REGISTER]    Script Date: 06/06/2022 16:26:58 ******/
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

