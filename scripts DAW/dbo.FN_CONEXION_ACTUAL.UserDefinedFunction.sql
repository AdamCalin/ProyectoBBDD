USE [DAW]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_CONEXION_ACTUAL]    Script Date: 27/05/2022 15:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-----------------------------------------------------------------------------------------------------------------------------------------------------

	NOMBRE DE LA FUNCIÓN		FN_CONEXION_ACTUAL
	FECHA DE CREACIÓN: 		16/07/2020		
	AUTOR:				O.RODRIGO
	VSS:				ICP/CODIGO_SQL/ICPM/02. FUNCIONES

	FUNCIONAMIENTO:			NOS DEVUELVE LA CONEXIÓN ACTUAL 
		
					A NIVEL GENERAL, LO RECOMENDABLE SERÍA TRABAJAR SIEMPRE CON LAS TABLAS:
						ENTORNOS
						CONEXIONES 
						ENTORNOS_CONEXIONES

------------------------------------------------------------------------------------------------------------------------------------------------------*/

-- ██████╗ ███████╗███████╗████████╗██╗ ██████╗ ███╗   ██╗		██████╗ ███████╗███████╗██████╗ ███████╗		██╗███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗  ██╗   ██╗ ██████╗██████╗ ███╗   ███╗
--██╔════╝ ██╔════╝██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║		██╔══██╗██╔════╝██╔════╝██╔══██╗██╔════╝		██║██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗███║   ██║██╔════╝██╔══██╗████╗ ████║
--██║  ███╗█████╗  ███████╗   ██║   ██║██║   ██║██╔██╗ ██║		██║  ██║█████╗  ███████╗██║  ██║█████╗  		██║███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝╚██║   ██║██║     ██████╔╝██╔████╔██║
--██║   ██║██╔══╝  ╚════██║   ██║   ██║██║   ██║██║╚██╗██║		██║  ██║██╔══╝  ╚════██║██║  ██║██╔══╝  		██║╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗ ██║   ██║██║     ██╔═══╝ ██║╚██╔╝██║
--╚██████╔╝███████╗███████║   ██║   ██║╚██████╔╝██║ ╚████║		██████╔╝███████╗███████║██████╔╝███████╗		██║███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║ ██║██╗██║╚██████╗██║     ██║ ╚═╝ ██║
-- ╚═════╝ ╚══════╝╚══════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝		╚═════╝ ╚══════╝╚══════╝╚═════╝ ╚══════╝		╚═╝╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝ ╚═╝╚═╝╚═╝ ╚═════╝╚═╝     ╚═╝     ╚═╝

-- ¡¡¡ LOS CAMBIOS QUE SE REALICEN EN ESTA FUNCIÓN TENDRAN EFECTO EN VARIOS SERVIDORES !!!

CREATE FUNCTION [dbo].[FN_CONEXION_ACTUAL]()
RETURNS INT
BEGIN

	DECLARE	@ID_CONEXION INT
	
	SELECT 
		@ID_CONEXION = ID_CONEXION --NO DEBERÍA DEVOLVER NUNCA 2 RESULTADOS. SI ES EL CASO MAL ASUNTO, DE MOMENTO PREFIERO QUE FALLE.
	FROM 
		ICPM.DBO.ENTORNOS_CONEXIONES 
	WHERE 
		ENTORNO = DBO.FN_ENTORNO() 
		AND SERVIDOR = @@SERVERNAME 
		AND BASE_DATOS = DB_NAME() 


	RETURN @ID_CONEXION

END

GO
