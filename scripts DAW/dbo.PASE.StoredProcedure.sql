USE [DAW]
GO
/****** Object:  StoredProcedure [dbo].[PASE]    Script Date: 27/05/2022 15:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-----------------------------------------------------------------------------------------------------------------------------------------------------

	NOMBRE DEL PROCEDIMIENTO:	PASE
	FECHA DE CREACIÓN: 		26/02/2020
	AUTOR:				EDGAR
	VSS:				RUTA VISUAL SOURCESAFE EJ: 

	FUNCIONAMIENTO:			FUNCIONAMIENTO

	PARAMETROS:			(OPCIONAL)
		PARAMETRO1 		INPUT	EXPLICACION
		PARAMETRO2 		OUTPUT	EXPLICACION

-------------------------------------------------------------------------------------------------------------------------------------------------------
--	FECHA DE MODIFICACIÓN:
--	AUTOR:
--	EXPLICACIÓN:	
------------------------------------------------------------------------------------------------------------------------------------------------------*/


CREATE PROCEDURE [dbo].[PASE] (@TABLA VARCHAR(100))
AS
DECLARE @CAMPOS VARCHAR(MAX) = ''

IF OBJECT_ID (N'v_sql', N'V') IS NULL 
BEGIN
	PRINT 'No existe V_SQL'
	RETURN -1
END
ELSE
BEGIN
	SELECT   
		@CAMPOS += CHAR(9)+C.COLUMN_NAME +','+CHAR(10) 

	FROM     
		INFORMATION_SCHEMA.COLUMNS C
		INNER JOIN INFORMATION_SCHEMA.TABLES T
		ON C.TABLE_NAME = T.TABLE_NAME
		AND C.TABLE_SCHEMA = T.TABLE_SCHEMA
		AND T.TABLE_TYPE = 'BASE TABLE'
	WHERE 
		C.TABLE_NAME = @TABLA
		AND C.COLUMN_NAME NOT LIKE '%PASS%' 
		AND C.COLUMN_NAME NOT LIKE '%PWD%' 
		AND C.COLUMN_NAME NOT LIKE '%CONTRASE_A%' 
	ORDER BY 
		ORDINAL_POSITION
	OPTION (RECOMPILE)
END

IF ISNULL(@CAMPOS ,'') = ''
BEGIN
	PRINT 'No existe la tabla '+ @TABLA
	RETURN -1
END

SET @CAMPOS = LEFT(@CAMPOS, LEN(@CAMPOS) - 2) + CHAR(10)

SELECT 'SELECT '+CHAR(10)+@CAMPOS+ 'FROM '+ CHAR(10) +CHAR(9)+@TABLA +' WITH(NOLOCK)' 'SELECT'



GO
