-- 3/4/2024
-- Server DB stat check it is a loop for checking all the DB


DECLARE @DBName NVARCHAR(255)
DECLARE @SQL NVARCHAR(MAX)

-- Create a cursor to iterate through each database
DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE state_desc = 'ONLINE'  -- Consider only online databases

-- Open the cursor
OPEN db_cursor

-- Fetch the first database name
FETCH NEXT FROM db_cursor INTO @DBName

-- Loop through each database
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Construct the dynamic SQL script
    SET @SQL = '
        USE ' + QUOTENAME(@DBName) + ';
        SELECT 
            ''' + @DBName + ''' AS dbName,
            T.TABLE_TYPE AS tblType,
            QUOTENAME(T.TABLE_SCHEMA) + ''.'' + QUOTENAME(T.TABLE_NAME) AS tblName,
            ISNULL(SUM(P.[rows]), 0) AS [rowCount]
        FROM INFORMATION_SCHEMA.TABLES T
        LEFT JOIN sys.partitions P ON OBJECT_ID(QUOTENAME(T.TABLE_SCHEMA) + ''.'' + QUOTENAME(T.TABLE_NAME)) = P.OBJECT_ID
        WHERE P.index_id IN (0, 1)  -- Consider only the heap or clustered index
        GROUP BY T.TABLE_TYPE, QUOTENAME(T.TABLE_SCHEMA) + ''.'' + QUOTENAME(T.TABLE_NAME);'

    -- Execute the dynamic SQL
    EXEC sp_executesql @SQL

    -- Fetch the next database name
    FETCH NEXT FROM db_cursor INTO @DBName
END

-- Close and deallocate the cursor
CLOSE db_cursor
DEALLOCATE db_cursor
