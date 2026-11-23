-- 4/4/2024
-- Checking the selected DB's of the

DECLARE @tableName NVARCHAR(255)
DECLARE @schemaName NVARCHAR(255)
DECLARE @sql NVARCHAR(MAX)

DECLARE tableCursor CURSOR FOR
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES

OPEN tableCursor
FETCH NEXT FROM tableCursor INTO @schemaName, @tableName

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = 'SELECT TOP 10 QUOTENAME(''[' + @schemaName + '].[' + @tableName + ']'') as full_table_name, * FROM ' + QUOTENAME(@schemaName) + '.' + QUOTENAME(@tableName)
    EXEC sp_executesql @sql
    FETCH NEXT FROM tableCursor INTO @schemaName, @tableName
END

CLOSE tableCursor
DEALLOCATE tableCursor
