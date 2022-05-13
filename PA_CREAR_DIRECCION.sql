USE [DAW]
GO
/****** Object:  StoredProcedure [dbo].[PA_CREAR_DIRECCION]    Script Date: 09/05/2022 13:44:50 ******/
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