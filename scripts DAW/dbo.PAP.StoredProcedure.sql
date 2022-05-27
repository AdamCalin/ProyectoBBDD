USE [DAW]
GO
/****** Object:  StoredProcedure [dbo].[PAP]    Script Date: 27/05/2022 15:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------------------------------------------------------   
-- PA QUE ME MONTA CADENA DE PRUEBAS DE PAS  
-- AUTOR: JJ   
-- FECHA: 27/3/2007  
------------------------------------------------------------------------------------------------------------------------------------  
-- ROBERTO RAMIRO  
-- 28/01/2015  
-- DEVOLVEMOS MAX SI MAX_LENGTH ES -1. NO DECLARAMOS @RETCODE SI YA ESTA ENTRE LOS PARAMETROS DEL PA  
------------------------------------------------------------------------------------------------------------------------------------  
-- EDGAR
-- 17/09/2020
-- ARREGLOS VARIOS: ENTRE ELLOS YA NO SACARÁ EXEC ' @RETCODE = ' CUANDO HAYA UN PARÁMETRO RETCODE DE SALIDA
------------------------------------------------------------------------------------------------------------------------------------

-- █████╗ ██╗   ██╗██╗███████╗ ██████╗ 		██╗███╗   ███╗██████╗  ██████╗ ██████╗ ████████╗ █████╗ ███╗   ██╗████████╗███████╗
--██╔══██╗██║   ██║██║██╔════╝██╔═══██╗		██║████╗ ████║██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝██╔══██╗████╗  ██║╚══██╔══╝██╔════╝
--███████║██║   ██║██║███████╗██║   ██║		██║██╔████╔██║██████╔╝██║   ██║██████╔╝   ██║   ███████║██╔██╗ ██║   ██║   █████╗  
--██╔══██║╚██╗ ██╔╝██║╚════██║██║   ██║		██║██║╚██╔╝██║██╔═══╝ ██║   ██║██╔══██╗   ██║   ██╔══██║██║╚██╗██║   ██║   ██╔══╝  
--██║  ██║ ╚████╔╝ ██║███████║╚██████╔╝		██║██║ ╚═╝ ██║██║     ╚██████╔╝██║  ██║   ██║   ██║  ██║██║ ╚████║   ██║   ███████╗
--╚═╝  ╚═╝  ╚═══╝  ╚═╝╚══════╝ ╚═════╝ 		╚═╝╚═╝     ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝
--CUALQUIER CAMBIO REALIZADO EN ESTE PA SERÁ AUTOMÁTICAMENTE REEMPLAZADO DESDE ICPM EN ISERVER1, POR LO QUE SE PERDERÁ.
------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[PAP]
	(
		@NOMBRE_PA AS VARCHAR(200)   
	)
AS  
  
DECLARE @ID_PA AS INTEGER  
DECLARE @CADENA_PA AS VARCHAR(8000)  
DECLARE @CADENA_PA2 AS VARCHAR(8000)  
DECLARE @CADENA_PA3 AS VARCHAR(8000)  
DECLARE @CADENA_PA4 AS VARCHAR(8000)  
DECLARE @NOMBRE AS VARCHAR(30)  
DECLARE @TIPO AS VARCHAR(30)  
DECLARE @DIMENSION AS VARCHAR(30)  
DECLARE @VALOR_DEFECTO AS VARCHAR(30)  
DECLARE @OUT AS VARCHAR(30)  
DECLARE @ORDER AS INTEGER  
DECLARE @AUX AS VARCHAR(30)  
DECLARE @TIENE_RETCODE AS BIT  
DECLARE @TIENE_RETCODE_OUTPUT AS BIT = 0
   
  
SET @CADENA_PA = ''  
SET @CADENA_PA2 = ''  
SET @CADENA_PA3 = 'EXEC @RETCODE = ' + @NOMBRE_PA + ' ' + CHAR(10)  
SET @CADENA_PA4 = ''  
  
SET @TIENE_RETCODE = 0  
   
SELECT @ID_PA = OBJECT_ID,   
	@TIPO  =  TYPE  
FROM 
	SYS.ALL_OBJECTS  
WHERE 
	OBJECT_ID = OBJECT_ID(@NOMBRE_PA)  
  
   
SET @NOMBRE = ''  

SELECT  TOP 1  
	@NOMBRE = NAME,  
	@OUT = CASE  
	WHEN IS_OUTPUT = 1 THEN 'OUTPUT'  
		ELSE ''  
	END,  
	@TIPO = UPPER(TYPE_NAME (USER_TYPE_ID)),    
	@DIMENSION = CASE  
	WHEN TYPE_NAME (USER_TYPE_ID) IN ('VARCHAR', 'CHAR', 'NVARCHAR') THEN '(' + CASE WHEN MAX_LENGTH = -1 THEN 'MAX' ELSE CAST(MAX_LENGTH AS VARCHAR(30)) END +')'   
		WHEN TYPE_NAME (USER_TYPE_ID) IN ('VARBINARY') THEN '(MAX)'
		ELSE ''  
	END,  
	@VALOR_DEFECTO = CASE  
	WHEN TYPE_NAME (USER_TYPE_ID) IN ('VARCHAR', 'CHAR', 'NVARCHAR') THEN  CHAR(39) + CHAR(39)       
		WHEN TYPE_NAME (USER_TYPE_ID) IN ('DATETIME', 'SMALLDATETIME') THEN 'NULL'
		WHEN TYPE_NAME (USER_TYPE_ID) IN ('XML') THEN CHAR(39) +'<ROOT></ROOT>'+ CHAR(39)     
		ELSE '0'  
	END,  
	@ORDER = PARAMETER_ID   
FROM 
	SYS.ALL_PARAMETERS   
WHERE 
	OBJECT_ID = @ID_PA  
ORDER BY 
	PARAMETER_ID  
  
  
WHILE @NOMBRE <> ''  
BEGIN  
	IF @NOMBRE like '%RETCODE%' SET @TIENE_RETCODE = 1  
	
	IF @NOMBRE like '%RETCODE%'AND @OUT = 'OUTPUT'
	BEGIN
		SET @TIENE_RETCODE_OUTPUT = 1
	END

	DECLARE @TABULACIONES VARCHAR(MAX) = ''
	DECLARE @LONGITUD_MAX INT = 0
	DECLARE @VUELTAS INT = 0

	SELECT 
		@LONGITUD_MAX = MAX(LEN(NAME))
	FROM 
		SYS.ALL_PARAMETERS   
	WHERE 
		OBJECT_ID = @ID_PA 

	SET @VUELTAS = 0
	SET @TABULACIONES = ''

	WHILE @VUELTAS < @LONGITUD_MAX - LEN(@NOMBRE)
	BEGIN
		SET @TABULACIONES = @TABULACIONES + CHAR(32)
		SET @VUELTAS = @VUELTAS +1
	END

	SET @CADENA_PA = @CADENA_PA + 'DECLARE ' + @NOMBRE +' '+ @TABULACIONES + @TIPO + @DIMENSION + CHAR(10)  
	SET @CADENA_PA2 = @CADENA_PA2 + 'SET ' + @NOMBRE + ' = ' + @VALOR_DEFECTO + CHAR(10)  
	SET @CADENA_PA3 = @CADENA_PA3 + CHAR(9)+@NOMBRE + ' ' + @OUT + ',' + CHAR(10)  
	
	IF @OUT <> ''  
	BEGIN  
		SET @AUX = REPLACE(@NOMBRE, '@', '')  
		SET @AUX = REPLACE(@AUX, '_', ' ')  
		SET @CADENA_PA4 = @CADENA_PA4 + 'PRINT ' + CHAR(39) + @AUX  + ': ' + CHAR(39) + ' + CAST(' +  @NOMBRE + ' AS VARCHAR(MAX))' + CHAR(10)  
	END  
      
  
	SET @NOMBRE = ''  

	SELECT  TOP 1  
		@NOMBRE = NAME,  
		@OUT = CASE  
		WHEN IS_OUTPUT = 1 THEN 'OUTPUT'  
			ELSE ''  
		END,  
		@TIPO = UPPER(TYPE_NAME (USER_TYPE_ID)),  
		@DIMENSION = CASE  
		WHEN TYPE_NAME (USER_TYPE_ID) IN ('VARCHAR', 'CHAR', 'NVARCHAR') THEN '(' + CASE WHEN MAX_LENGTH = -1 THEN 'MAX' ELSE CAST(MAX_LENGTH AS VARCHAR(30)) END +')'   
		WHEN TYPE_NAME (USER_TYPE_ID) IN ('VARBINARY') THEN '(MAX)'		
			ELSE ''  
		END,  
		@VALOR_DEFECTO = CASE  
		WHEN TYPE_NAME (USER_TYPE_ID) IN ('VARCHAR', 'CHAR', 'NVARCHAR') THEN  CHAR(39) + CHAR(39)       
		WHEN TYPE_NAME (USER_TYPE_ID) IN ('DATETIME', 'SMALLDATETIME') THEN 'NULL'
		WHEN TYPE_NAME (USER_TYPE_ID) IN ('XML') THEN CHAR(39) +'<ROOT></ROOT>'+ CHAR(39)
			ELSE '0'  
		END,  
		@ORDER = PARAMETER_ID  
	FROM 
		SYS.ALL_PARAMETERS   
	WHERE 
		OBJECT_ID = @ID_PA  
		AND PARAMETER_ID > @ORDER  
	ORDER BY 
		PARAMETER_ID  
 


END  
 

SET @VUELTAS = 0
SET @TABULACIONES = ''

WHILE @VUELTAS < @LONGITUD_MAX - LEN('@RETCODE')
BEGIN
	SET @TABULACIONES = @TABULACIONES + CHAR(32)
	SET @VUELTAS = @VUELTAS +1
END


IF  @TIENE_RETCODE_OUTPUT = 1
BEGIN
	SET @CADENA_PA3 = REPLACE(@CADENA_PA3,'EXEC @RETCODE = ','EXEC ')
END

IF @TIENE_RETCODE_OUTPUT = 0 SET @CADENA_PA4 = @CADENA_PA4 + 'PRINT ' + CHAR(39) + 'RETCODE: ' + CHAR(39) + ' + CAST(@RETCODE AS VARCHAR(10))' + CHAR(10)  
	SET @CADENA_PA3 = LEFT(@CADENA_PA3, LEN(@CADENA_PA3) - 2)  
IF @TIENE_RETCODE = 0  
	SET @CADENA_PA = @CADENA_PA + 'DECLARE @RETCODE'+' '+ @TABULACIONES+'INT ' + CHAR(10) + CHAR(10)  
ELSE  
	SET @CADENA_PA = @CADENA_PA + CHAR(10)  

SET @CADENA_PA = @CADENA_PA + @CADENA_PA2 + CHAR(10) + @CADENA_PA3 + CHAR(10) + CHAR(10) + @CADENA_PA4  
 
  
PRINT @CADENA_PA  
  


GO
