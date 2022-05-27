USE [DAW]
GO
/****** Object:  StoredProcedure [dbo].[PA_CREAR_PEDIDO_ARTICULO]    Script Date: 27/05/2022 15:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PA_CREAR_PEDIDO_ARTICULO]
(  
 @ID_ARTICULO INT,
 @CANTIDAD INT,
 @PRECIO DECIMAL,

  
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

  
  
 INSERT INTO PEDIDOS_ARTICULOS 
 (  
	ID_ARTICULO,
	CANTIDAD,
	PRECIO
 )  
 VALUES  
 (  
	@ID_ARTICULO,
	@CANTIDAD,
	@PRECIO
	 
 )  
   
 RETURN   
  
END TRY  
  
BEGIN CATCH  
  
END CATCH
GO
