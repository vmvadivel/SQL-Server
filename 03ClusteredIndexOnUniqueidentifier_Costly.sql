/*
Generally having a clustered index on a UniqueIdentifier column would be costly. 
Even if we add 5000 or 10000 records in the table the fragmentation level would be around 95+ % which means we have to very frequently 
REORGANIZE or REBUILD that index. So always double check and be very sure that we need a GUID column and not an INT or BIGINT column.
*/

-----------------------------------------------------
--Demo Table Creation Scripts
-----------------------------------------------------

--Table with UniqueIdentifier as Clusetered Index
CREATE TABLE dbo.TblUID
(
 Sno Uniqueidentifier NOT NULL DEFAULT NEWID(),
 FirstName VARCHAR(100) NOT NULL,
 DOB DATETIME NOT NULL,
 CONSTRAINT pk_tblUid PRIMARY KEY CLUSTERED(sno asc)
);

--Table with UniqueIdentifier as Clusetered Index
CREATE TABLE dbo.TblSEQUID
(
 Sno Uniqueidentifier NOT NULL DEFAULT NEWSEQUENTIALID(),
 FirstName VARCHAR(100) NOT NULL,
 DOB DATETIME NOT NULL,
 CONSTRAINT pk_tblSEQUid PRIMARY KEY CLUSTERED(sno asc)
);

--Table with INTeger column as Clusetered Index
CREATE TABLE dbo.TblInt
(
 Sno INT IDENTITY(1,1) NOT NULL,
 FirstName VARCHAR(100) NOT NULL,
 DOB DATETIME NOT NULL,
 CONSTRAINT pk_tblInt PRIMARY KEY CLUSTERED(sno asc)
);

--Table with BIGINTeger as Clusetered Index
CREATE TABLE dbo.TblBigInt
(
 Sno BIGINT IDENTITY(1,1) NOT NULL,
 FirstName VARCHAR(100) NOT NULL,
 DOB DATETIME NOT NULL,
 CONSTRAINT pk_tblBigInt PRIMARY KEY CLUSTERED(sno asc)
);


-----------------------------------------------------
--Create NON Clustered Index on DOB Column
-----------------------------------------------------
CREATE NONCLUSTERED INDEX nx_tbluid_dob on dbo.tbluid(DOB);
CREATE NONCLUSTERED INDEX nx_tblsequid_dob on dbo.tblSEQUid(DOB);
CREATE NONCLUSTERED INDEX nx_tblInt_dob on dbo.tblInt(DOB);
CREATE NONCLUSTERED INDEX nx_tblBigInt_dob on dbo.tblBigInt(DOB);


/*
Insert dummy records in each of the table. 
Change the number near GO as per your need.
*/

SET NOCOUNT ON;

INSERT INTO dbo.TblUID (FirstName, DOB)
 SELECT REPLICATE('x',100),Getdate();
GO 10000

INSERT INTO dbo.TblSEQUID (FirstName, DOB)
 SELECT REPLICATE('x',100),Getdate();
GO 10000

INSERT INTO dbo.TblInt(FirstName, DOB)
 SELECT REPLICATE('x',100),Getdate();
GO 10000

INSERT INTO dbo.TblBigInt(FirstName, DOB)
 SELECT REPLICATE('x',100),Getdate();
GO 10000


---------------------------------------------------
--Check the Space Used and Fragmentation Level
---------------------------------------------------
EXEC sp_spaceused tblUID, True;
SELECT index_type_desc, avg_fragmentation_in_percent, page_count, record_count
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(N'tblUID'), NULL, NULL, NULL)
OPTION (MAXDOP 1);

EXEC sp_spaceused tblSEQUID, True;
SELECT index_type_desc, avg_fragmentation_in_percent, page_count, record_count
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(N'tblSEQUID'), NULL, NULL, NULL)           
OPTION (MAXDOP 1);
   
EXEC sp_spaceused tblINT, True;
SELECT index_type_desc, avg_fragmentation_in_percent, page_count, record_count 
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(N'tblINT'), NULL, NULL, NULL) 
OPTION (MAXDOP 1);

EXEC sp_spaceused tblBIGINT, True;
SELECT index_type_desc, avg_fragmentation_in_percent, page_count, record_count 
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(N'tblBIGINT'), NULL, NULL, NULL)
OPTION (MAXDOP 1);