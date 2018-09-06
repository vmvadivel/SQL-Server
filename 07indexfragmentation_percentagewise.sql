DECLARE @fragment_perc INT = 30 -- change here to see details for different percentage

SELECT 
--	DB_NAME(database_id) AS database_name,
	so.[name] AS table_name,
	ps.index_id,
	si.[name],
	ps.index_type_desc,
	ps.alloc_unit_type_desc,
	ps.index_depth,
	ps.index_level,
	avg_fragmentation_in_percent,
	page_count
FROM 
	sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED') ps
	INNER JOIN sysobjects so
	ON ps.[object_id] = so.id
	INNER JOIN sys.indexes si
	ON ps.object_id = si.object_id
	AND ps.index_id = si.index_id
WHERE ps.avg_fragmentation_in_percent >= @fragment_perc
ORDER BY 
	-- avg_fragmentation_in_percent desc
	table_name, si.name
	;