-- Auto Create Statistics is disabled : Generally considered bad for performance
SELECT [name] AS DBName
FROM   sys.databases
WHERE  is_auto_create_stats_on = 0;

-- Auto Update Statistics is disabled : Generally considered bad for performance
SELECT [name] AS DBName
FROM   sys.databases
WHERE  is_auto_update_stats_on = 0;

/*
-- Generally for better performance I would suggest to keep these 2 features enabled!

USE [master]
GO

ALTER DATABASE Your_DB_Name SET AUTO_CREATE_STATISTICS ON WITH NO_WAIT;
GO

ALTER DATABASE Your_DB_Name SET AUTO_UPDATE_STATISTICS ON WITH NO_WAIT;
GO

*/
