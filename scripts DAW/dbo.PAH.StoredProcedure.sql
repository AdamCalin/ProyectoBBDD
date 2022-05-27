USE [DAW]
GO
/****** Object:  StoredProcedure [dbo].[PAH]    Script Date: 27/05/2022 15:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author: Edgar  
-- Create date: 06/06/2017  
-- Description: PA que devuelve un procedimiento con las líneas sin los fallos de SP_HELPTEXT  
-- =============================================  
  
  
CREATE PROCEDURE [dbo].[PAH](@TEXTO VARCHAR(100))  
AS  
     BEGIN  
       
     SET NOCOUNT ON;  
  
         DECLARE @OBJNAME NVARCHAR(776)= @TEXTO;  
         DECLARE @OBJECTTEXT NVARCHAR(MAX)= '';  
         DECLARE @SYSCOMTEXT NVARCHAR(MAX);  
         DECLARE @LINELEN INT;  
         DECLARE @LINEEND BIT= 0;  
         DECLARE @COMMENTTEXT TABLE  
         (LINEID INT IDENTITY(1, 1),  
          TEXT   NVARCHAR(MAX)  
         );  
   
 IF NOT EXISTS (SELECT 1/0  
  FROM SYS.SYSCOMMENTS  
  WHERE ID = OBJECT_ID(@OBJNAME)  
  AND ENCRYPTED = 0)  
 BEGIN  
  SELECT @TEXTO + ' NO EXISTE EN ' + @@SERVERNAME +'.'+ DB_NAME()  
  RETURN 0  
 END  
            
         DECLARE MS_CRS_SYSCOM CURSOR LOCAL  
         FOR  
             SELECT TEXT  
             FROM SYS.SYSCOMMENTS  
             WHERE ID = OBJECT_ID(@OBJNAME)  
                   AND ENCRYPTED = 0  
             ORDER BY NUMBER,  
                      COLID  
         FOR READ ONLY;  
         OPEN MS_CRS_SYSCOM;  
         FETCH NEXT FROM MS_CRS_SYSCOM INTO @SYSCOMTEXT;  
         WHILE @@FETCH_STATUS >= 0  
             BEGIN  
                 SET @LINELEN = CHARINDEX(CHAR(10), @SYSCOMTEXT);  
                 WHILE @LINELEN > 0  
                     BEGIN  
                         SELECT @OBJECTTEXT+=LEFT(@SYSCOMTEXT, @LINELEN),  
                                @SYSCOMTEXT = SUBSTRING(@SYSCOMTEXT, @LINELEN+1, 4000),  
                                @LINELEN = CHARINDEX(CHAR(10), @SYSCOMTEXT),  
                                @LINEEND = 1;  
                         INSERT INTO @COMMENTTEXT(TEXT)  
                         VALUES(@OBJECTTEXT);  
                         SET @OBJECTTEXT = '';  
                     END;  
                 IF @LINELEN = 0  
                     SET @OBJECTTEXT+=@SYSCOMTEXT;  
                     ELSE  
                 SELECT @OBJECTTEXT = @SYSCOMTEXT,  
                        @LINELEN = 0;  
                 FETCH NEXT FROM MS_CRS_SYSCOM INTO @SYSCOMTEXT;  
             END;  
         CLOSE MS_CRS_SYSCOM;  
         DEALLOCATE MS_CRS_SYSCOM;  
         INSERT INTO @COMMENTTEXT(TEXT)  
                SELECT @OBJECTTEXT;  
           
  SELECT TEXT  
         FROM @COMMENTTEXT  
         ORDER BY LINEID;  
       
     END;  
  
GO
