-- Auto Create Statistics is disabled : Generally considered bad for performance
SELECT [name] AS DBName
FROM   sys.databases
WHERE  is_auto_create_stats_on = 0;

-- Auto Update Statistics is disabled : Generally considered bad for performance
SELECT [name] AS DBName
FROM   sys.databases
WHERE  is_auto_update_stats_on = 0;
