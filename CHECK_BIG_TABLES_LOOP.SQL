DECLARE @tblName NVARCHAR(MAX);
DECLARE @sql NVARCHAR(MAX);

-- Declare the cursor for the dynamic tables
DECLARE db_cursor CURSOR FOR 
    SELECT 
        QUOTENAME(T.TABLE_SCHEMA) + '.' + QUOTENAME(T.TABLE_NAME) AS tblName
    FROM INFORMATION_SCHEMA.TABLES T
    LEFT JOIN sys.partitions P ON OBJECT_ID(QUOTENAME(T.TABLE_SCHEMA) + '.' + QUOTENAME(T.TABLE_NAME)) = P.OBJECT_ID
    WHERE P.index_id IN (0, 1)  -- Consider only the heap or clustered index
    GROUP BY T.TABLE_CATALOG, T.TABLE_TYPE, QUOTENAME(T.TABLE_SCHEMA) + '.' + QUOTENAME(T.TABLE_NAME)
    HAVING ISNULL(SUM(P.[rows]), 0) > 0;

-- Open the cursor
OPEN db_cursor;

-- Fetch the first row
FETCH NEXT FROM db_cursor INTO @tblName;

-- Loop through all table names
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Construct the dynamic SQL for SELECT * from each table, placing tableName as the first column
    SET @sql = 'SELECT ''' + @tblName + ''' AS tableName, * FROM ' + @tblName;

    -- Execute the dynamic SQL
    EXEC sp_executesql @sql;

    -- Fetch the next row
    FETCH NEXT FROM db_cursor INTO @tblName;
END

-- Close and deallocate the cursor
CLOSE db_cursor;
DEALLOCATE db_cursor;

