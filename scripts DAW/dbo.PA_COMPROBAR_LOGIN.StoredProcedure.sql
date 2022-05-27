USE [DAW]
GO
/****** Object:  StoredProcedure [dbo].[PA_COMPROBAR_LOGIN]    Script Date: 27/05/2022 15:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PA_COMPROBAR_LOGIN]
(  
	@USER VARCHAR(100),
	@EMAIL VARCHAR(100),
	@PASS VARCHAR(MAX),
	@PERFIL INT = 4, 

  
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

 IF EXISTS(SELECT EMAIL FROM USUARIOS WHERE @EMAIL = EMAIL)
 BEGIN
	SET @RETCODE = 1
	SET @MENSAJE = 'Este usuario ya existe'
	RETURN 
 END 
  
  
 INSERT INTO USUARIOS  
 (  
	USUARIO,
	EMAIL,
	PASS,
	ID_PERFIL
 )  
 VALUES  
 (  
	@USER,
	@EMAIL,
	@PASS,
	@PERFIL
 )  
   
SET @MENSAJE = 'Operacion register realizada con exito'

END TRY  
  
BEGIN CATCH  
  SET @RETCODE = -1
  SET @MENSAJE = ERROR_MESSAGE()
END CATCH
GO
