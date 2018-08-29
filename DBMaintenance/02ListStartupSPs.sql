/*
	List all Stored Procedures which Runs automatically when SQL Server starts up

	For testing:
		
		Create a SP in Master DB and then use the below scripts to enable it to run automatically on startup
	
		EXEC SP_PROCOPTION Your_SP_Name, 'STARTUP', 'ON' ---To setup your SP to run automatically when SQL Server starts up
		GO

		EXEC SP_PROCOPTION Your_SP_Name, 'STARTUP', 'OFF' ---Disable it
		GO
*/

SELECT  
	Specific_Catalog,
	Specific_Schema,
	Specific_Name,
	Created		
FROM  
	master.INFORMATION_SCHEMA.ROUTINES
WHERE 
	OBJECTPROPERTY(OBJECT_ID(ROUTINE_NAME), 'ExecIsStartup') = 1;