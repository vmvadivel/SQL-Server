USE [master]
GO

-- Move the TempDB files to the 
ALTER DATABASE tempdb MODIFY FILE (NAME = 'tempdev', FILENAME = N'E:\MSSQL\Data\tempdb.mdf', SIZE = 1000MB , FILEGROWTH = 50MB);
ALTER DATABASE tempdb MODIFY FILE (NAME = 'templog', FILENAME = N'E:\MSSQL\Log\templog.ldf', SIZE = 500MB , FILEGROWTH = 50MB);

-- Chek how many CPUs do we have
SELECT cpu_count FROM sys.dm_os_sys_info

/*
**********NOTE**********
1. Number of Files == Number of Logical Cores
2. If it's more than 8 then to start with 8 equally sized tempdb data files
3. If it's < 8 say 3 then set 3 equally sized tempdb data files
4. TempDB files has to be equally sized to avoid Page Contention issues

*/

ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev2', FILENAME = N'E:\MSSQL\DATA\tempdb2.ndf', SIZE = 1000MB, FILEGROWTH = 50MB);																									  					   
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev3', FILENAME = N'E:\MSSQL\DATA\tempdb3.ndf', SIZE = 1000MB, FILEGROWTH = 50MB);
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev4', FILENAME = N'E:\MSSQL\DATA\tempdb4.ndf', SIZE = 1000MB, FILEGROWTH = 50MB);
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev5', FILENAME = N'E:\MSSQL\DATA\tempdb5.ndf', SIZE = 1000MB, FILEGROWTH = 50MB);
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev6', FILENAME = N'E:\MSSQL\DATA\tempdb6.ndf', SIZE = 1000MB, FILEGROWTH = 50MB);
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev7', FILENAME = N'E:\MSSQL\DATA\tempdb7.ndf', SIZE = 1000MB, FILEGROWTH = 50MB);
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev8', FILENAME = N'E:\MSSQL\DATA\tempdb8.ndf', SIZE = 1000MB, FILEGROWTH = 50MB);
