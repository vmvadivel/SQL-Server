/*
	- Check if system databases are on C Drive. 
	- Having system DBs in C drive is risky as well as have performance problems.
	- Would always suggest moving 'master', 'model' and 'msdb' into another drive apart from C drive and 
	- TEMPDB should be moved to another drive where other system DBs aren't saved!
*/

SELECT 
	DB_NAME(database_id) AS System_DBName,
--	[name] AS DB_LogicalName,
	physical_name AS DB_PhysicalName 
--	,*
FROM    
	sys.master_files
WHERE   
	LOWER(LEFT(physical_name, 1)) = 'c'
	AND [type] = 0
	AND DB_NAME(database_id) IN ( 'master', 'model', 'msdb', 'tempdb' );
	-- AND [name] IN ( 'master', 'model', 'msdb', 'tempdb' );


/*
	Check for User DBs now: User Databases also should not be in C drive
*/

SELECT 
	DB_NAME(database_id) AS Users_DBName,
	physical_name AS DB_PhysicalName 
FROM    
	sys.master_files
WHERE   
	LOWER(LEFT(physical_name, 1)) = 'c'
	AND [type] = 0
	AND DB_NAME(database_id) NOT IN ( 'master', 'model', 'msdb', 'tempdb' );
