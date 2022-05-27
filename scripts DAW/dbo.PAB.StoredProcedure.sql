USE [DAW]
GO
/****** Object:  StoredProcedure [dbo].[PAB]    Script Date: 27/05/2022 15:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================  
-- Author: Bruno Ramos Silva  
-- CREACION date: 03/03/2015  
-- Description: PA que devuelve todos los objetos que tengan parametro de entrada TEXTO_BUSCAR  
  
-- Modificacion: Edgar  
-- Fecha: 11/05/2017  
-- Descripcion: Reestructuración del PA para que nos muestre los JOBS y el TEXTO_ICPL (si procede).  
  
-- Modificación: Edgar  
-- Fecha: 27/06/2017  
-- Descripción: Ahora se puede hacer búsquedas de hasta 2 elementos:  
-- Ejemplo:  PAB '@TEXTO_BUSCAR','ID__TEMPORAL__OBJECT_ID'  
  
-- Modificación: Javier Rod  
-- Fecha: 07/02/2018  
-- Descripción: Unificación de ambos PAB y búsquedas de hasta 5 elementos  
  
-- Modificación: Cecilia N.Pri  
-- Fecha: 04/10/2018  
-- Descripción: Añado Replace para que en la búsqueda el guíon bajo no sea un comodín  
  
-- Modificación: Edgar  
-- Fecha: 13/04/2021  
-- Descripción: Impementación del invoker 99 para revisar todas las bases de datos  
-- =================================================================================================  
  
CREATE PROCEDURE [dbo].[PAB]  
 @TEXTO_BUSCAR AS VARCHAR (1000),  
 @TEXTO_BUSCAR_2 AS VARCHAR (1000) = @TEXTO_BUSCAR,  
 @TEXTO_BUSCAR_3 AS VARCHAR (1000) = @TEXTO_BUSCAR,  
 @TEXTO_BUSCAR_4 AS VARCHAR (1000) = @TEXTO_BUSCAR,  
 @TEXTO_BUSCAR_5 AS VARCHAR (1000) = @TEXTO_BUSCAR,  
 @INVOKER INT = 0  
  
AS  
BEGIN  
 SET NOCOUNT ON;  
 --VARIABLE PARA CONTROLAR LA BÚSQUEDA SEGÚN LA BASE DE DATOS TENGA LA TABLA 'N_TAREAS_PROGRAMADAS' O NO  
 DECLARE @TAREAS AS BIT = 0  
 DECLARE @TEXTO_ORIGINAL VARCHAR(1000) = @TEXTO_BUSCAR  
 IF EXISTS (SELECT [NAME] FROM SYS.tables WHERE [NAME] = 'N_TAREAS_PROGRAMADAS') SET @TAREAS = 1  
  
  
 SET @TEXTO_BUSCAR = REPLACE(@TEXTO_BUSCAR,'_','[_]')  
 SET @TEXTO_BUSCAR_2 = REPLACE(@TEXTO_BUSCAR_2,'_','[_]')  
 SET @TEXTO_BUSCAR_3 = REPLACE(@TEXTO_BUSCAR_3,'_','[_]')  
 SET @TEXTO_BUSCAR_4 = REPLACE(@TEXTO_BUSCAR_4,'_','[_]')  
 SET @TEXTO_BUSCAR_5 = REPLACE(@TEXTO_BUSCAR_5,'_','[_]')  
   
    
 IF @INVOKER = 99   
 BEGIN  
  CREATE TABLE #AUXILIAR_PAB  
    (  
     TIPO  VARCHAR(10),  
     BBDD  VARCHAR(50),  
     ELEMENTO VARCHAR(100),  
     [SP_HELPTEXT]   VARCHAR(150),  
     CODIGO  VARCHAR(MAX),  
     ACTUALIZADO BIT DEFAULT(0)  
    )  
  
  DECLARE @command varchar(4000)   
  SELECT @command = 'USE ?   
  
      
    BEGIN TRY   
     INSERT INTO #AUXILIAR_PAB (TIPO, ELEMENTO, [SP_HELPTEXT], CODIGO)  
     EXEC PAB '''+@TEXTO_ORIGINAL+''', @INVOKER = 98   
     IF EXISTS (SELECT 1 FROM #AUXILIAR_PAB)  
     BEGIN  
      UPDATE #AUXILIAR_PAB SET BBDD = DB_NAME(), ACTUALIZADO = 1  WHERE ACTUALIZADO = 0  
        
      --SELECT DB_NAME()   
      --SELECT * FROM #AUXILIAR_PAB  
     END  
    END TRY   
    BEGIN CATCH   
     --PRINT DB_NAME()   
     --PRINT ERROR_MESSAGE()   
    END CATCH'   
  
  EXEC sp_MSforeachdb @command   
  
  --SET @INVOKER = 98  
 END  
  
-- Creamos una tabla temporal y le añadimos un índice para acelerar el pab, ya que ahora es más grande que antes.  
  CREATE TABLE #T  
  (  
   ID  INTEGER ,  
   [OBJECT_ID] INTEGER,  
   TIPO  VARCHAR(10),  
   ELEMENTO VARCHAR(100),  
   [SP_HELPTEXT]   VARCHAR(150),  
   CODIGO  VARCHAR(MAX)  
  )  
  
   
  CREATE TABLE #T2  
  (  
   ID  INTEGER ,  
   [OBJECT_ID] INTEGER,  
   TIPO  VARCHAR(10),  
   ELEMENTO VARCHAR(100),  
   [SP_HELPTEXT]   VARCHAR(150),  
   CODIGO  VARCHAR(MAX)  
  )  
  
  
  
-- METO PRIMERO EN UNA TEMPORAL LOS RESULTADOS QUE SIEMPRE HA DADO EL PAB:  
 INSERT INTO #T2(TIPO,ELEMENTO,[SP_HELPTEXT],CODIGO,[OBJECT_ID],ID)  
  SELECT   
   B.TIPO,   
   B.ELEMENTO,   
   B.SP_HELPTEXT,   
   B.CODIGO,   
   B.object_id,   
   B.ID   
  FROM  
   (  
   SELECT   
          SYSOBJ.XTYPE             [TIPO] ,  
          SYSOBJ.NAME              [ELEMENTO],  
          'USE '+DB_NAME()+CHAR(10) +'GO'+CHAR(10)+'PAH ' + '''' + SYSOBJ.NAME + ''''  [SP_HELPTEXT] ,  
          MODU.DEFINITION   [CODIGO],  
          MODU.OBJECT_ID,  
          SYSOBJ.ID            
   FROM   
    SYSOBJECTS  AS SYSOBJ WITH(NOLOCK)  
  
    INNER JOIN   
    SYS.OBJECTS AS SYS_OBJ WITH (NOLOCK)   
    ON SYSOBJ.ID = SYS_OBJ.OBJECT_ID  
  
    INNER JOIN   
    SYS.SQL_MODULES AS MODU WITH (NOLOCK)   
    ON SYS_OBJ.OBJECT_ID = MODU.OBJECT_ID  
  
    INNER JOIN   
    SYS.SYSUSERS AS USERS WITH (NOLOCK)   
    ON SYSOBJ.UID = USERS.UID  
   WHERE   
    MODU.OBJECT_ID = SYSOBJ.ID  
  
   GROUP BY   
    SYSOBJ.XTYPE,  
    SYSOBJ.NAME,  
    MODU.DEFINITION,  
       SYS_OBJ.OBJECT_ID,  
    USERS.NAME,  
    MODU.OBJECT_ID,  
    SYSOBJ.ID  
   ) B --OPTION (RECOMPILE)  
 --PRINT 'A1'     
 INSERT INTO #T(TIPO,ELEMENTO,[SP_HELPTEXT],CODIGO,[OBJECT_ID],ID)  
 SELECT   
   TIPO,   
   ELEMENTO,   
   SP_HELPTEXT,   
   CODIGO,  
   object_id,   
   ID   
 FROM #T2  
 WHERE   CODIGO  LIKE '%' + @TEXTO_BUSCAR + '%'  
    AND CODIGO LIKE '%' + @TEXTO_BUSCAR_2 + '%'  
    AND CODIGO LIKE '%' + @TEXTO_BUSCAR_3 + '%'  
    AND CODIGO LIKE '%' + @TEXTO_BUSCAR_4 + '%'  
    AND CODIGO LIKE '%' + @TEXTO_BUSCAR_5 + '%'  
--PRINT 'A2'P  
 INSERT INTO #T(TIPO,ELEMENTO,[SP_HELPTEXT],CODIGO,[OBJECT_ID],ID)  
 select 'CLR',assembly_method,'CLR','CLR',-1,-1 from sys.assembly_modules where assembly_method LIKE '%' + @TEXTO_BUSCAR + '%'  
    AND assembly_method LIKE '%' + @TEXTO_BUSCAR_2 + '%'  
    AND assembly_method LIKE '%' + @TEXTO_BUSCAR_3 + '%'  
    AND assembly_method LIKE '%' + @TEXTO_BUSCAR_4 + '%'  
    AND assembly_method LIKE '%' + @TEXTO_BUSCAR_5 + '%'  
--PRINT 'A3'   
--LO CONSULTO Y LE AÑADO LOS JOBS:  
  
  
 IF @INVOKER = 98  
 BEGIN    
   
  SELECT * FROM   
  (  
   SELECT   
    TIPO   [TIPO] ,  
    --DB_NAME()  BBDD,  
    ELEMENTO  [ELEMENTO],  
    'USE '+DB_NAME()+CHAR(10) +'GO'+CHAR(10)+'PAH ' + '''' + ELEMENTO + ''''  [SP_HELPTEXT] ,  
    LEFT(CODIGO,100) +'....................USA PAH PARA VER MÁS' [CODIGO]    
   FROM   
    #T   
   --UNION ALL  
   --SELECT TIPO, BBDD, ELEMENTO, [SP_HELPTEXT], CODIGO FROM #AUXILIAR_PAB  
  ) TT   
   ORDER BY   
   --BBDD,  
   CASE   
    WHEN TIPO = 'P' THEN 1  
    WHEN TIPO = 'FN' THEN 2  
    WHEN TIPO = 'TR' THEN 3  
    WHEN TIPO = 'V' THEN 4  
    WHEN TIPO = 'JOB' THEN 5  
    WHEN TIPO = 'ICPL' THEN 6  
    ELSE 7   
   END ASC-- ORDENO PARA QUE APAREZCA LO QUE YO QUIERA PRIMERO  
  
   RETURN 0  
 END  
  
 --IF @INVOKER = 98  
 --BEGIN  
 -- RETURN 0  
 --END  
  
 IF @INVOKER <> 99   
 BEGIN  
  IF @TAREAS = 1   
   BEGIN  
    SELECT   
     TIPO,   
     ELEMENTO, [SP_HELPTEXT],  
     CODIGO  
    FROM   
     (  
      SELECT   
       TIPO             [TIPO] ,  
       ELEMENTO              [ELEMENTO],  
       'USE '+DB_NAME()+CHAR(10) +'GO'+CHAR(10)+'PAH ' + '''' + ELEMENTO + ''''  [SP_HELPTEXT] ,  
       LEFT(CODIGO,100) +'....................USA PAH PARA VER MÁS' [CODIGO]    
      FROM   
       #T   
        
      UNION  
      SELECT   
       C1.TIPO,   
       C1.ELEMENTO,   
       C1.[SP_HELPTEXT],   
       C1.CODIGO   
      FROM   
       --JOBS  
       (  
        SELECT DISTINCT  
         'JOB' TIPO,  
         ISNULL(SYSJOBS.NAME,'') ELEMENTO,  
         '' SP_HELPTEXT,  
         SYSJOBSS.COMMAND CODIGO  
        FROM    
         MSDB.DBO.SYSJOBSTEPS AS SYSJOBSS WITH(NOLOCK)   
  
         INNER JOIN   
         MSDB.DBO.SYSJOBS AS SYSJOBS WITH(NOLOCK)   
         ON SYSJOBS.JOB_ID = SYSJOBSS.JOB_ID  
        WHERE    
         SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR  + '%'  
         AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_2 + '%'  
         AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_3 + '%'  
         AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_4 + '%'  
         AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_5 + '%'  
         OR (  
          SYSJOBS.NAME  LIKE '%' +  @TEXTO_BUSCAR  + '%'  
         AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_2  + '%'  
         AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_3  + '%'  
         AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_4  + '%'  
         AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_5  + '%'  
         )  
       )C1       
  
      UNION   
        
      SELECT   
       ICPL1.TIPO,   
       ICPL1.ELEMENTO,   
       ICPL1.[SP_HELPTEXT],   
       ICPL1.CODIGO   
      FROM  
       -- AÑADO TEXTO_ICPL  
       (  
        SELECT DISTINCT  
         'ICPL' TIPO,  
         CONVERT(VARCHAR,ID_TAREA) +' - '+ ISNULL(PROGRAMADAS.DESCRIPCION_TAREA,'') ELEMENTO,  
         '' SP_HELPTEXT,  
         PROGRAMADAS.TEXTO_ICPL CODIGO  
        FROM    
         N_TAREAS_PROGRAMADAS AS PROGRAMADAS WITH(NOLOCK)   
        WHERE   
         TEXTO_ICPL LIKE '%' +  @TEXTO_BUSCAR  + '%'  
         AND TEXTO_ICPL LIKE '%' + @TEXTO_BUSCAR_2  + '%'  
         AND TEXTO_ICPL LIKE '%' + @TEXTO_BUSCAR_3  + '%'  
         AND TEXTO_ICPL LIKE '%' + @TEXTO_BUSCAR_4  + '%'  
         AND TEXTO_ICPL LIKE '%' + @TEXTO_BUSCAR_5  + '%'  
          
       ) ICPL1  
     ) T  
    ORDER BY   
     CASE   
      WHEN TIPO = 'P' THEN 1  
      WHEN TIPO = 'FN' THEN 2  
      WHEN TIPO = 'TR' THEN 3  
      WHEN TIPO = 'V' THEN 4  
      WHEN TIPO = 'JOB' THEN 5  
      WHEN TIPO = 'ICPL' THEN 6  
      ELSE 7   
     END ASC-- ORDENO PARA QUE APAREZCA LO QUE YO QUIERA PRIMERO  
     --PRINT 'A4'  
   END  
  ELSE  
   BEGIN  
    SELECT   
     TIPO,   
     ELEMENTO, [SP_HELPTEXT],  
     CODIGO  
    FROM   
     (  
      SELECT   
       TIPO             [TIPO] ,  
       ELEMENTO              [ELEMENTO],  
       'USE '+DB_NAME()+CHAR(10) +'GO'+CHAR(10)+'PAH ' + '''' + ELEMENTO + ''''  [SP_HELPTEXT] ,  
       LEFT(CODIGO,100) +'....................USA PAH PARA VER MÁS' [CODIGO]    
       FROM   
       #T   
        
      UNION  
      SELECT   
       C1.TIPO,   
       C1.ELEMENTO,   
       C1.[SP_HELPTEXT],   
       C1.CODIGO   
      FROM   
       --JOBS  
       (  
        SELECT DISTINCT  
         'JOB' TIPO,  
         ISNULL(SYSJOBS.NAME,'') ELEMENTO,  
         '' SP_HELPTEXT,  
         SYSJOBSS.COMMAND CODIGO  
        FROM    
         MSDB.DBO.SYSJOBSTEPS AS SYSJOBSS WITH(NOLOCK)  
  
         INNER JOIN   
         MSDB.DBO.SYSJOBS AS SYSJOBS WITH(NOLOCK)  
         ON SYSJOBS.JOB_ID = SYSJOBSS.JOB_ID  
        WHERE    
         SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR + '%'  
         AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_2 + '%'  
         AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_3 + '%'  
         AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_4 + '%'  
         AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_5 + '%'  
         OR  
         (  
         SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR  + '%'  
         AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_2  + '%'  
         AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_3  + '%'  
         AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_4  + '%'  
         AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_5  + '%'  
         )  
       )C1       
     ) T   
    ORDER BY   
     CASE   
      WHEN TIPO = 'P' THEN 1  
      WHEN TIPO = 'FN' THEN 2  
      WHEN TIPO = 'TR' THEN 3  
      WHEN TIPO = 'V' THEN 4  
      WHEN TIPO = 'JOB' THEN 5  
      WHEN TIPO = 'ICPL' THEN 6  
      ELSE 7   
     END ASC-- ORDENO PARA QUE APAREZCA LO QUE YO QUIERA PRIMERO  
     --PRINT 'A5'  
  END  
 END  
 ELSE  
 BEGIN  
  IF @TAREAS = 1   
  BEGIN  
   INSERT INTO #AUXILIAR_PAB (TIPO, BBDD, ELEMENTO, [SP_HELPTEXT], CODIGO)  
   --SELECT 'JOBS+ICPL'  
   SELECT * FROM (  
   SELECT   
    C1.TIPO,   
    '' BBDD,  
    C1.ELEMENTO,   
    C1.[SP_HELPTEXT],   
    C1.CODIGO   
   FROM   
    --JOBS  
    (  
     SELECT DISTINCT  
      'JOB' TIPO,  
      ISNULL(SYSJOBS.NAME,'') ELEMENTO,  
      '' SP_HELPTEXT,  
      SYSJOBSS.COMMAND CODIGO  
     FROM    
      MSDB.DBO.SYSJOBSTEPS AS SYSJOBSS WITH(NOLOCK)   
  
      INNER JOIN   
      MSDB.DBO.SYSJOBS AS SYSJOBS WITH(NOLOCK)   
      ON SYSJOBS.JOB_ID = SYSJOBSS.JOB_ID  
     WHERE    
      SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR  + '%'  
      AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_2 + '%'  
      AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_3 + '%'  
      AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_4 + '%'  
      AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_5 + '%'  
      OR (  
       SYSJOBS.NAME  LIKE '%' +  @TEXTO_BUSCAR  + '%'  
      AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_2  + '%'  
      AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_3  + '%'  
      AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_4  + '%'  
      AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_5  + '%'  
      )  
    )C1       
  
   UNION   
     
   SELECT   
    ICPL1.TIPO,   
    '' BBDD,  
    ICPL1.ELEMENTO,   
    ICPL1.[SP_HELPTEXT],   
    ICPL1.CODIGO   
   FROM  
    -- AÑADO TEXTO_ICPL  
    (  
     SELECT DISTINCT  
      'ICPL' TIPO,  
      CONVERT(VARCHAR,ID_TAREA) +' - '+ ISNULL(PROGRAMADAS.DESCRIPCION_TAREA,'') ELEMENTO,  
      '' SP_HELPTEXT,  
      PROGRAMADAS.TEXTO_ICPL CODIGO  
     FROM    
      N_TAREAS_PROGRAMADAS AS PROGRAMADAS WITH(NOLOCK)   
     WHERE   
      TEXTO_ICPL LIKE '%' +  @TEXTO_BUSCAR  + '%'  
      AND TEXTO_ICPL LIKE '%' + @TEXTO_BUSCAR_2  + '%'  
      AND TEXTO_ICPL LIKE '%' + @TEXTO_BUSCAR_3  + '%'  
      AND TEXTO_ICPL LIKE '%' + @TEXTO_BUSCAR_4  + '%'  
      AND TEXTO_ICPL LIKE '%' + @TEXTO_BUSCAR_5  + '%'  
       
    ) ICPL1 ) TT    
   ORDER BY   
   CASE   
    WHEN TIPO = 'P' THEN 1  
    WHEN TIPO = 'FN' THEN 2  
    WHEN TIPO = 'TR' THEN 3  
    WHEN TIPO = 'V' THEN 4  
    WHEN TIPO = 'JOB' THEN 5  
    WHEN TIPO = 'ICPL' THEN 6  
    ELSE 7   
   END ASC-- ORDENO PARA QUE APAREZCA LO QUE YO QUIERA PRIMERO  
   --PRINT 'A4'  
  END  
  ELSE  
  BEGIN  
   INSERT INTO #AUXILIAR_PAB(TIPO, BBDD, ELEMENTO, [SP_HELPTEXT], CODIGO)  
   --SELECT 'JOBS'  
   SELECT   
    C1.TIPO,   
    '' BBDD,  
    C1.ELEMENTO,   
    C1.[SP_HELPTEXT],   
    C1.CODIGO   
   FROM   
   --JOBS  
   (  
    SELECT DISTINCT  
     'JOB' TIPO,  
     ISNULL(SYSJOBS.NAME,'') ELEMENTO,  
     '' SP_HELPTEXT,  
     SYSJOBSS.COMMAND CODIGO  
    FROM    
     MSDB.DBO.SYSJOBSTEPS AS SYSJOBSS WITH(NOLOCK)  
  
     INNER JOIN   
     MSDB.DBO.SYSJOBS AS SYSJOBS WITH(NOLOCK)  
     ON SYSJOBS.JOB_ID = SYSJOBSS.JOB_ID  
    WHERE    
     SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR + '%'  
     AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_2 + '%'  
     AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_3 + '%'  
     AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_4 + '%'  
     AND SYSJOBSS.COMMAND LIKE '%' + @TEXTO_BUSCAR_5 + '%'  
     OR  
     (  
     SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR  + '%'  
     AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_2  + '%'  
     AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_3  + '%'  
     AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_4  + '%'  
     AND SYSJOBS.NAME  LIKE '%' + @TEXTO_BUSCAR_5  + '%'  
     )  
   )C1       
     
   ORDER BY   
    CASE   
     WHEN TIPO = 'P' THEN 1  
     WHEN TIPO = 'FN' THEN 2  
     WHEN TIPO = 'TR' THEN 3  
     WHEN TIPO = 'V' THEN 4  
     WHEN TIPO = 'JOB' THEN 5  
     WHEN TIPO = 'ICPL' THEN 6  
     ELSE 7   
    END ASC-- ORDENO PARA QUE APAREZCA LO QUE YO QUIERA PRIMERO  
    --PRINT 'A5'  
  END  
 END  
  
   
 IF @INVOKER = 99 AND EXISTS (select OBJECT_ID('tempdb..#AUXILIAR_PAB'))  
 BEGIN    
   
   
   SELECT TIPO, BBDD, ELEMENTO, [SP_HELPTEXT], CODIGO FROM #AUXILIAR_PAB  
   ORDER BY  
   CASE  
    WHEN BBDD = '' THEN 99  
    ELSE 0  
   END ASC,  
   BBDD ASC,  
   CASE   
    WHEN TIPO = 'P' THEN 1  
    WHEN TIPO = 'FN' THEN 2  
    WHEN TIPO = 'TR' THEN 3  
    WHEN TIPO = 'V' THEN 4  
    WHEN TIPO = 'JOB' THEN 5  
    WHEN TIPO = 'ICPL' THEN 6  
    ELSE 7   
   END ASC,-- ORDENO PARA QUE APAREZCA LO QUE YO QUIERA PRIMERO  
   ELEMENTO ASC  
 END  
   
  
  
END
GO
