--Script to change the File Growth and set the max growth as Unlimited to Master & MSDB
DECLARE @BuildAlterStmt VARCHAR(100), @SystemDBName VARCHAR(100);

/*
	name = db name, file_id (1 = data, 2 = log), database_id (1=master, 2=tempdb, 3=model, 4=msdb)
*/
--SELECT * FROM master.sys.master_files

--master
SET @SystemDBName = (SELECT [name] FROM master.sys.master_files WHERE file_id = 1 AND DB_NAME(database_id) = 'master');
SET @BuildAlterStmt = 'ALTER DATABASE [master] MODIFY FILE (name =' + @SystemDBName + ', maxsize = unlimited, filegrowth = 1024MB);';

PRINT (@BuildAlterStmt);
--EXEC (@@BuildAlterStmt);

--msdb
SET @SystemDBName = (SELECT [name] FROM master.sys.master_files WHERE file_id = 1 AND DB_NAME(database_id) = 'msdb');
SET @BuildAlterStmt = 'ALTER DATABASE [msdb] MODIFY FILE (name =' + @SystemDBName + ', maxsize = unlimited, filegrowth = 1024MB);';

PRINT (@BuildAlterStmt);
--EXEC (@@BuildAlterStmt);

