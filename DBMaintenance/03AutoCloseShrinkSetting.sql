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

