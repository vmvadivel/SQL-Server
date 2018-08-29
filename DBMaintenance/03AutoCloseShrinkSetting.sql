/*

 If is_auto_close_on = 1 then it means Auto close is enabled in that DB!
 If is_auto_shrink_on = 1 then it means Auto Shrink is enabled in that DB!

 Both these settings are generally considered to be bad and would decrease the performance of the system!

*/

-- Check if Autoclose is enabled
SELECT [name] AS DBName
FROM   sys.databases
WHERE  is_auto_close_on = 1;

-- Check if Autoshrink is enabled
SELECT [name] AS DBName
FROM   sys.databases
WHERE  is_auto_shrink_on = 1;

-- Both in single query
SELECT  
	[name] AS DBName, 
	is_auto_close_on, 
	is_auto_shrink_on
FROM
	sys.databases
WHERE
	is_auto_close_on = 1 or is_auto_shrink_on = 1;

/*
-- Disable those features

USE [master]
GO

ALTER DATABASE Your_DB_Name SET AUTO_CLOSE OFF;
GO

ALTER DATABASE Your_DB_Name SET AUTO_SHRINK ON WITH NO_WAIT;
GO

*/		
