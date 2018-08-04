--Created Date: 21/04/2017
--Author: Vadivel

--Dummy Table with 4 records
Create table LoanApplicationMaster
(
	TranID int primary key not null,
	FName varchar(20) not null,
	Age int not null,
	AnnualSalary money not null,
	CibilScore int not null,
	MaritalStatus char(1) not null
)
GO

--Truncate table LoanApplicationMaster
Insert into LoanApplicationMaster values (1, 'Vadivel', 26, '350000.00','792','Y')
Insert into LoanApplicationMaster values (2, 'Senthil', 25, '145000.00','690','Y')
Insert into LoanApplicationMaster values (3, 'Dinesh', 69, '400000.00','760','N')
Insert into LoanApplicationMaster values (4, 'Siddharth', 64, '645000.00','800','Y')
GO

--Sample Rules Table with 4 rules
Create table OurBusinessRules
(
	RuleID int Primary key not null,
	ColName varchar(20) not null,
	Operator varchar(2) not null,
	ColValue varchar(10) not null,
	RuleOrder int not null
)
GO

--Truncate table OurBusinessRules
Insert into OurBusinessRules values (1, 'CibilScore', '>=', '725', 1)
Insert into OurBusinessRules values (2, 'Age', '>=', '25', 2)
Insert into OurBusinessRules values (3, 'Age', '<', '65', 3)
Insert into OurBusinessRules values (4, 'AnnualSalary', '>', '250000.00', 4)
GO

--Query with hardcoded values
--Based on the rules only record 'Vadivel' and 'Siddharth' should be returned

Select * from LoanApplicationMaster
where 
		CibilScore >=725 and
		age >=25 and 
		age < 65 and 
		AnnualSalary > '250000.00'

--Dynamically building the query based on the rules mentioned in the rules table
DECLARE @sql nvarchar(max), @where nvarchar(max);

SELECT  @where = stuff((
  SELECT '  and '+colname +' '+operator +' ' + colvalue+char(10)
    FROM OurBusinessRules
    ORDER BY RuleOrder
  FOR XML PATH (''), type).value('.','nvarchar(max)')
  ,1,6,'');

SET @sql = 'SELECT * ' + CHAR(10) + 'FROM LoanApplicationMaster' + CHAR(10) + 'WHERE ' + @where;

--select @sql as CodeGenerated;
EXEC sp_executesql @sql;
