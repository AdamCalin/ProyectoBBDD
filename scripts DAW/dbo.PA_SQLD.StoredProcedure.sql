USE [DAW]
GO
/****** Object:  StoredProcedure [dbo].[PA_SQLD]    Script Date: 27/05/2022 15:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
####################################################################################################################################################################################################

	FECHA DE CREACIÓN: 		30/09/2021		
	AUTOR:				JJ
	FUNCIONAMIENTO:			DEVUELVE TEXTO SQL DINÁMICO DADO UN PA

####################################################################################################################################################################################################

	FECHA DE MODIFICACIÓN: 
	AUTOR:
	EXPLICACIÓN:	

####################################################################################################################################################################################################
*/

CREATE PROCEDURE [dbo].[PA_SQLD]
	@NOMBRE_PA		VARCHAR(200)
AS

	DECLARE @SQLSTRING0	VARCHAR(8000) = ''
	DECLARE @SQLSTRING1	VARCHAR(8000) = ''
	DECLARE @SQLSTRING2	VARCHAR(8000) = ''
	DECLARE @SQLSTRING3	VARCHAR(8000) = ''
	DECLARE @SERVIDOR	VARCHAR(50) = ''	
	DECLARE @BBDD		VARCHAR(50) = ''



	SET @SQLSTRING0 = 'DECLARE @PARAMDEFINITION NVARCHAR(4000)' + CHAR(10) +
	'DECLARE @SQLSTRING	NVARCHAR(4000)' + CHAR(10) +
	'DECLARE @NOMBRE_PA	VARCHAR(200)' + CHAR(10) + 
	'DECLARE @SERVIDOR	VARCHAR(200)' + CHAR(10) + 
	'DECLARE @BBDD		VARCHAR(200)' + CHAR(10) + CHAR(10)

	SELECT	@SQLSTRING1 =	@SQLSTRING1 + 

				-- NOMBRE DEL PARÁMETRO
				CASE
					WHEN IS_OUTPUT = 1 THEN name + '_OUT'
					ELSE name + '_IN'
				END  + 
			
				-- TIPO DEL PARÁMETRO
				' ' + TYPE_NAME(USER_TYPE_ID) + 

				-- DIMENSIÓN DEL PARÁMETRO
				CASE  
					WHEN TYPE_NAME (USER_TYPE_ID) IN ('VARCHAR', 'CHAR', 'NVARCHAR') THEN '(' + CASE WHEN MAX_LENGTH = -1 THEN 'MAX' ELSE CAST(MAX_LENGTH AS VARCHAR(30)) END +')'   
					WHEN TYPE_NAME (USER_TYPE_ID) IN ('VARBINARY') THEN '(MAX)'		
					ELSE ''  
				END +

				-- OUTPUT
				CASE
					WHEN IS_OUTPUT = 1 THEN ' OUTPUT'
					ELSE ''
				END +

				-- COMA
				CASE
					WHEN parameter_id = (SELECT MAX(parameter_id) FROM SYS.ALL_PARAMETERS SP WHERE OBJECT_ID = OBJECT_ID(@NOMBRE_PA)) THEN ''
					ELSE ',' + CHAR(10)
				END ,

		@SQLSTRING2 =	@SQLSTRING2 + 

				-- NOMBRE DEL PARÁMETRO
				CASE
					WHEN IS_OUTPUT = 1 THEN name + '_OUT'
					ELSE name + '_IN'
				END + 			

				-- OUTPUT
				CASE
					WHEN IS_OUTPUT = 1 THEN ' OUTPUT'
					ELSE ''
				END +

				-- COMA
				CASE
					WHEN parameter_id = (SELECT MAX(parameter_id) FROM SYS.ALL_PARAMETERS SP WHERE OBJECT_ID = OBJECT_ID(@NOMBRE_PA)) THEN ''
					ELSE ',' + CHAR(10)
				END,

		@SQLSTRING3 =	@SQLSTRING3 + 
				-- NOMBRE DEL PARÁMETRO
				CASE
					WHEN IS_OUTPUT = 1 THEN name + '_OUT'
					ELSE name + '_IN'
				END + ' = ' + name + 

				-- OUTPUT
				CASE
					WHEN IS_OUTPUT = 1 THEN ' OUTPUT'
					ELSE ''
				END +

				-- COMA
				CASE
					WHEN parameter_id = (SELECT MAX(parameter_id) FROM SYS.ALL_PARAMETERS SP WHERE OBJECT_ID = OBJECT_ID(@NOMBRE_PA)) THEN ''
					ELSE ',' + CHAR(10)
				END 


	FROM	SYS.ALL_PARAMETERS SP
	WHERE	OBJECT_ID = OBJECT_ID(@NOMBRE_PA)   
	ORDER	BY PARAMETER_ID  

	SET @SQLSTRING1 = 'SET @PARAMDEFINITION = N' + CHAR(39) + @SQLSTRING1 + CHAR(39)
	SET @SQLSTRING2 = 'SET @SQLSTRING = N''EXEC '' + @SERVIDOR + ''.'' + @BBDD + ''.dbo.' + ''' + @NOMBRE_PA + ''' + CHAR(10) + @SQLSTRING2 + CHAR(39)

	SET @SQLSTRING3 = 'EXECUTE SP_EXECUTESQL ' + CHAR(10) + '@SQLSTRING,' + CHAR(10) + '@PARAMDEFINITION,' + CHAR(10) + @SQLSTRING3

	PRINT @SQLSTRING0 + CHAR(10) + CHAR(10) + @SQLSTRING1 + CHAR(10) + CHAR(10) + @SQLSTRING2 + CHAR(10) + CHAR(10) + @SQLSTRING3






GO
