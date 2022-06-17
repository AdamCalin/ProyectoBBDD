USE [DAW]
GO

/****** Object:  StoredProcedure [dbo].[PA_BORRAR_ROPA]    Script Date: 17/06/2022 14:34:27 ******/
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

 IF ISNULL (@ID_ROPA, 0) <= 0  
  
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
