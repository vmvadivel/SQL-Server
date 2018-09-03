/*

By default, Rention period of Job history is (One can see this by right clicking on SQL Server Agent > Properties > History):
- Maximum job history log size(in rows): 1000
- Maximum job history rows per job: 100

Use the below script if there is a business reasons to increase the settings to retain more history data

*/

SELECT * FROM sys.dm_server_registry 
WHERE value_name IN ('JobHistoryMaxRows','JobHistoryMaxRowsPerJob')
GO

EXEC msdb.dbo.sp_set_sqlagent_properties	@jobhistory_max_rows = 5000, 
											@jobhistory_max_rows_per_job = 500
GO

SELECT * FROM sys.dm_server_registry 
WHERE value_name IN ('JobHistoryMaxRows','JobHistoryMaxRowsPerJob')
GO