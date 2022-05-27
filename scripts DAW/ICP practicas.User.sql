USE [DAW]
GO
/****** Object:  User [ICP\practicas]    Script Date: 27/05/2022 15:00:56 ******/
CREATE USER [ICP\practicas] FOR LOGIN [ICP\practicas] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_executor] ADD MEMBER [ICP\practicas]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [ICP\practicas]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ICP\practicas]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [ICP\practicas]
GO
