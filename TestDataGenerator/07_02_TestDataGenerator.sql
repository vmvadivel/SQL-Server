/*
  Now make use of the fucntions created using 07_01_TestDataGenerator.sql
  and populate some test/dummy data into a table
*/

CREATE TABLE tblEmployee 
(
	EmpID INT,
	EmpName VARCHAR(25),
	DOB DATETIME,
	Salary MONEY,
	Password VARCHAR(8)
)
GO

--Usage: Lets populate some random 10000 records into this table
INSERT INTO tblEmployee 
	SELECT CAST(RAND(CHECKSUM(NEWID())) * 10000 AS INT),
	dbo.udf_StringGenerator('A', 25),
	GETDATE() - ((21 * 365) + RAND()* (39 * 365)),
	Round(CAST(25000 + RAND(CHECKSUM(NEWID())) * 1000000 AS Money),2),
	dbo.udf_StringGenerator('P', 8)
GO 10000

--Check
SELECT * FROM tblEmployee 
GO

--Clean Up
DROP TABLE tblEmployee 
GO