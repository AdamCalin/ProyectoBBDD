USE [DAW]
GO
/****** Object:  View [dbo].[V_SQL_FICHEROS]    Script Date: 27/05/2022 15:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-----------------------------------------------------------------------------------------------------------------------------------------------------

	NOMBRE DE AL VISTA:		V_SQL_FICHEROS
	FECHA DE CREACIÓN: 		20/10/2019
	AUTOR:				OSCAR RODRIGO

	FUNCIONAMIENTO:			NOS DA DATOS SOBRE EL TAMAÑO Y PORCENTAJE DE OCUPACIÓN

	

-------------------------------------------------------------------------------------------------------------------------------------------------------
--	FECHA DE MODIFICACIÓN:
--	AUTOR:
--	EXPLICACIÓN:	
------------------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE VIEW [dbo].[V_SQL_FICHEROS] AS

SELECT	
	DB_NAME(mf.database_id) AS BBDD , 
	mf.Name COLLATE SQL_Latin1_General_CP1_CI_AS AS FICHERO , 
	mf.Physical_Name RUTA_FICHERO, 
	sfg.GROUPNAME COLLATE SQL_Latin1_General_CP1_CI_AS GRUPO_FICHERO,
	(mf.size * 8 )/ 1024 TOTAL_MB,
	convert(int, sf.size/128.0 -CAST(FILEPROPERTY(sf.name, 'SpaceUsed' )AS int)/128.0) AS LIBRE_MB,
	CASE  (( mf.size * 8 )/ 1024 )
		WHEN 0 THEN 0 
		ELSE  convert(int, sf.size/128.0 -CAST(FILEPROPERTY(sf.name, 'SpaceUsed' )AS int)/128.0) * 100 / (( mf.size * 8 ) / 1024 ) 
	END PORCENTAJE_LIBRE

FROM	
	sys.master_files mf

	LEFT OUTER JOIN
	sys.SYSFILES sf
	ON mf.Name COLLATE SQL_Latin1_General_CP1_CI_AS = sf.name COLLATE SQL_Latin1_General_CP1_CI_AS

	LEFT OUTER JOIN 
	sys.sysfilegroups sfg
	on sf.groupid = sfg.groupid
			
WHERE	
	DB_NAME (mf.database_id ) = DB_NAME()


/*----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------               PRUEBAS              ------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


SELECT 
	*
FROM
	V_SQL_FICHEROS WHERE FICHERO <> GRUPO_FICHERO
ORDER BY 
	1


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------             FIN PRUEBAS            ------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------*/

GO
