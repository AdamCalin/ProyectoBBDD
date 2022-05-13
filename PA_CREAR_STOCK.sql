USE [DAW]
GO
/****** Object:  StoredProcedure [dbo].[PA_CREAR_STOCK]    Script Date: 11/05/2022 10:44:18 ******/
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
	ID_ARTICULO
	CANTIDAD_STOCK,
	CANTIDAD_PEDIDO,
	CANTIDAD_ENVIO
 )  
 VALUES  
 (  
	@CANTIDAD_STOCK,
	@CANTIDAD_PEDIDO,
	@CANTIDAD_ENVIO
	 
 )  
   
 RETURN   
  
END TRY  
  
BEGIN CATCH  
  
END CATCH