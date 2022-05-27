USE [DAW]
GO
/****** Object:  StoredProcedure [dbo].[PA_CREAR_USUARIO]    Script Date: 27/05/2022 15:00:56 ******/
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
   
 RETURN   
  
END TRY  
  
BEGIN CATCH  
  
END CATCH
GO
