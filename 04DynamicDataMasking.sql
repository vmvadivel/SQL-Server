--01 Login in with SA account or an account with all privileges

--02 Test table for demo purpose
CREATE TABLE TableWithSensitiveData02 
(
	Sno INT IDENTITY(1, 1) PRIMARY KEY
	,First_Name VARCHAR(50) NOT NULL
	,Last_Name VARCHAR(50) NOT NULL
	,DOB DATETIME NULL
	,Salary INT NULL
	,Email VARCHAR(250) NULL
	,DOJ DATETIME NULL
)

--03 Sample data Insertion
INSERT INTO TableWithSensitiveData02 (First_Name, Last_Name, DOB, Salary, Email, DOJ) 
VALUES ('Venkatraman','Venkatadri','01/02/1980',20000,'a@b.com','12/10/2009' )
INSERT INTO TableWithSensitiveData02 (First_Name, Last_Name, DOB, Salary, Email, DOJ) 
VALUES ('Govindasamy','Ashwin','06/02/1970',26000,'alpha@c.com','10/06/1999' )
INSERT INTO TableWithSensitiveData02 (First_Name, Last_Name, DOB, Salary, Email, DOJ) 
VALUES ('Shankaran','Appadurai','12/12/1950',1000000,'rajini@superstar.com','08/18/1975' )

--Check for data existance
SELECT * FROM TableWithSensitiveData02

--04 Enable Dynamic data masking for columns
ALTER TABLE TableWithSensitiveData02  ALTER COLUMN Last_Name varchar(50) MASKED WITH (FUNCTION = 'default()');
ALTER TABLE TableWithSensitiveData02  ALTER COLUMN Email varchar(250) MASKED WITH (FUNCTION = 'Email()');
ALTER TABLE TableWithSensitiveData02  ALTER COLUMN Salary int MASKED WITH (FUNCTION='random(100,150)');
ALTER TABLE TableWithSensitiveData02  ALTER COLUMN First_name varchar(50) MASKED WITH (FUNCTION= 'partial(2,"XXXX",2)');
ALTER TABLE TableWithSensitiveData02  ALTER COLUMN DOB DATETIME MASKED WITH (FUNCTION = 'default()');

--05 Check whether data is masked -- Now original data Will be still visible bcoz by default database owner is unmasked
SELECT * FROM TableWithSensitiveData02

--06 Let me create a new non-privileged users! (normal user without admin access) to test DDM
CREATE USER testUser WITHOUT LOGIN;  

--07 Giving permission to see data on our new table to this user
GRANT SELECT ON TableWithSensitiveData02 TO testUser;

--08 Changing the execution context
EXECUTE AS USER = 'testUser';  

--09 Now lets check once again on whether data is masked 
--YES we have impersonanted as a normal user data would be shown as masked
SELECT * FROM TableWithSensitiveData02

--10 Revert back the permission. i.e., you go back to the login you originally used earlier  
REVERT;

--11 After reverting the permission lets check once again on whether data is masked -- NO as we are firing as an admin
SELECT * FROM TableWithSensitiveData02

--12 Assume we want to remove data masking in one column and change the masking rule in another
--Make sure to run REVERT command before trying the below command.
ALTER TABLE TableWithSensitiveData02 ALTER COLUMN Last_Name DROP MASKED
ALTER TABLE TableWithSensitiveData02 ALTER COLUMN Salary int MASKED WITH (FUNCTION='random(1000,9000)');

----Now try step 8 & 9


--13 Steps to show masked data can be breached into
--A. Use LIKE operator to fiter out required records. Time consuming but doable

SELECT * FROM TableWithSensitiveData02 WHERE email like 'a%.com'
SELECT * FROM TableWithSensitiveData02 WHERE email like '%b.com'

--B. Using Math operators you can keep guessing and narrow down to the exact data
SELECT * FROM TableWithSensitiveData02 WHERE salary > 18000
SELECT * FROM TableWithSensitiveData02 WHERE salary > 18000 and Salary <= 25000

--C Using = 
SELECT * FROM TableWithSensitiveData02 WHERE First_Name = 'Shankaran'


--D Some built-in functions disclose the data
SELECT 
	salary + 1 -1,
	salary * 1000 / 10 / 10 / 10,
	FLOOR(salary),
	EXP(LOG(salary)), 
	SQRT(SQUARE(salary))
FROM TableWithSensitiveData02
WHERE first_name = 'Venkatraman';

--Bottomline,  data masking is not the most secure option, so if data needs to be secure, 
--there are other options such as Transparent Data Encryption, Row Level Security and Always Encrypted.


--14 List all columns on which there is a masking function applied.

SELECT tbl.name as [TableName], mc.name as [ColumnName], mc.is_masked, mc.masking_function
FROM sys.masked_columns AS mc
JOIN sys.tables AS tbl 
ON mc.[object_id] = tbl.[object_id]
WHERE is_masked = 1;

--15 Give UNMASK permission to the testUser for testing purpose

REVERT; -- Just in you are still running as a testUser run this line to go back to SA, owner etc., 

GRANT UNMASK TO testUser;
EXEC ('SELECT * FROM TableWithSensitiveData02') AS USER = 'testUser';
REVERT; 

--16 remove the UNMASK permission
REVOKE UNMASK TO testUser;
EXEC ('SELECT * FROM TableWithSensitiveData02') AS USER = 'testUser';
REVERT; 

--Final Step: Post demo clean up
DROP USER testUser;
DROP TABLE TableWithSensitiveData02;