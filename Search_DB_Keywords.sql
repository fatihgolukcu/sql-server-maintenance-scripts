--FG
--30/04/2024


-- Create a temporary table to store the results
CREATE TABLE #Results (SchemaName NVARCHAR(255), TableName NVARCHAR(255), ColumnName NVARCHAR(255), ObjectType NVARCHAR(50))

-- Declare variables to hold column data and SQL commands
DECLARE @TableName NVARCHAR(255), @ColumnName NVARCHAR(255), @SchemaName NVARCHAR(255), @ObjectType NVARCHAR(50)
DECLARE @SqlQuery AS NVARCHAR(MAX)

-- Cursor to select table schema, name, column names, and differentiate between tables and views
DECLARE db_cursor CURSOR FOR 
SELECT t.name, c.name, s.name, 'Table' AS Type
FROM sys.tables t
INNER JOIN sys.columns c ON t.object_id = c.object_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE c.system_type_id IN (167, 175, 231, 239)  -- char, varchar, nchar, nvarchar
UNION ALL
SELECT v.name, c.name, s.name, 'View' AS Type
FROM sys.views v
INNER JOIN sys.columns c ON v.object_id = c.object_id
INNER JOIN sys.schemas s ON v.schema_id = s.schema_id
WHERE c.system_type_id IN (167, 175, 231, 239)  -- char, varchar, nchar, nvarchar

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @TableName, @ColumnName, @SchemaName, @ObjectType

WHILE @@FETCH_STATUS = 0  
BEGIN  
    -- Generate SQL to look for the search term in current column of table or view
    SET @SqlQuery = 'IF EXISTS (SELECT 1 FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) 
                    + ' WHERE ' + QUOTENAME(@ColumnName) + ' LIKE ''%B4B3AA21-56EF-4FB8-AD44-C69D7D40E98F%'') 
                     INSERT INTO #Results (SchemaName, TableName, ColumnName, ObjectType) VALUES (''' + @SchemaName + ''',''' + @TableName + ''',''' + @ColumnName + ''', ''' + @ObjectType + ''')'

    -- Execute the dynamic SQL
    EXEC sp_executesql @SqlQuery

    FETCH NEXT FROM db_cursor INTO @TableName, @ColumnName, @SchemaName, @ObjectType
END 

CLOSE db_cursor  
DEALLOCATE db_cursor

-- Display the results
SELECT * FROM #Results

-- Drop the temporary table
DROP TABLE #Results
