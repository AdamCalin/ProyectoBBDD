USE [DAW]
GO

/****** Object:  StoredProcedure [dbo].[PA_LOGIN]    Script Date: 06/06/2022 16:27:09 ******/
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

