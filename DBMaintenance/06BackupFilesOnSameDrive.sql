/*
	**Microsoft Recommendation**
	
	Make sure you are not storing your backups in the same physical location as the database files. 
	When your physical drive goes bad, you should be able to use the other drive or remote location that stored the backups in order to perform a restore.
*/

--Bad Practice: Backing up the databaes to the same drive where it resides
SELECT
	COUNT(*) AS TotalBackUpFiles,
	LOWER(LEFT(physical_device_name, 3)) AS StorageDrive
FROM    
	msdb.dbo.backupmediafamily		AS b
	INNER JOIN msdb.dbo.backupset	AS s ON b.media_set_id = s.media_set_id
WHERE   
	LOWER(LEFT(physical_device_name, 3)) IN 
	(
		SELECT DISTINCT LOWER(LEFT(physical_name, 3)) FROM sys.master_files
	)
GROUP BY LOWER(LEFT(physical_device_name, 3));
