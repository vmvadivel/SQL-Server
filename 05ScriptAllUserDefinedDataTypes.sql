/*
-- Scripts all the user defined data types in the current database (through a single query)
*/

SET NOCOUNT ON

SELECT 'USE ' + QUOTENAME(DB_NAME(), '[') + '
GO';

SELECT '
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N''' + st.[name] + ''' AND ss.name = N''' + ss.[name] + ''')
    DROP TYPE ' + QUOTENAME(ss.name, '[') + '.' + QUOTENAME(st.name, '[') + '
GO

CREATE TYPE ' + QUOTENAME(ss.name, '[') + '.' + QUOTENAME(st.name, '[') + ' FROM ' + 
QUOTENAME(bs.[name], '[') + 
    CASE bs.[name]
        WHEN 'char' THEN (CASE ISNULL(st.max_length, 0) WHEN 0 THEN '' WHEN -1 THEN '(MAX)' ELSE '(' + convert(varchar(10), st.max_length) + ')' END)
        WHEN 'nchar' THEN (CASE ISNULL(st.max_length, 0) WHEN 0 THEN '' WHEN -1 THEN '(MAX)' ELSE '(' + convert(varchar(10), st.max_length/2) + ')' END)
        WHEN 'varchar' THEN (CASE ISNULL(st.max_length, 0) WHEN 0 THEN '' WHEN -1 THEN '(MAX)' ELSE '(' + convert(varchar(10), st.max_length) + ')' END)
        WHEN 'nvarchar' THEN (CASE ISNULL(st.max_length, 0) WHEN 0 THEN '' WHEN -1 THEN '(MAX)' ELSE '(' + convert(varchar(10), st.max_length/2) + ')' END)
        WHEN 'numeric' THEN (CASE ISNULL(st.[precision], 0) WHEN 0 THEN '' ELSE '(' + convert(varchar(10), st.[precision]) + ', ' + convert(varchar(10), st.[scale]) + ')' END)
        WHEN 'decimal' THEN (CASE ISNULL(st.[precision], 0) WHEN 0 THEN '' ELSE '(' + convert(varchar(10), st.[precision]) + ', ' + convert(varchar(10), st.[scale]) + ')' END)
        WHEN 'varbinary' THEN (CASE st.max_length WHEN -1 THEN '(max)' ELSE '(' + convert(varchar(10), st.max_length) + ')' END)
        ELSE ''
    END + 
'
GO
'
FROM sys.types st 
    INNER JOIN sys.schemas ss ON st.[schema_id] = ss.[schema_id]
    INNER JOIN sys.types bs ON bs.[user_type_id] = st.[system_type_id]
WHERE st.[is_user_defined] = 1 -- exclude system types
ORDER BY st.[name], ss.[name]