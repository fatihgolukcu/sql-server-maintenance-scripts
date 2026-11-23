-- FG
-- 29/04/2024
-- This script is showing views with row numbers and showing the SQL Codes of each view

DECLARE @ViewName AS NVARCHAR(128)
DECLARE @SchemaName AS NVARCHAR(128)
DECLARE @SQL AS NVARCHAR(MAX)
DECLARE @Definition AS NVARCHAR(MAX)  -- Variable to store view definition
DECLARE @Count AS INT

-- Table to store the results
CREATE TABLE #ViewInfo (
    SchemaName NVARCHAR(128),
    ViewName NVARCHAR(128),
    ViewDefinition NVARCHAR(MAX),
    NumRows INT
)

-- Cursor to go through each view, including schema names
DECLARE view_cursor CURSOR FOR 
SELECT SCHEMA_NAME(v.schema_id) AS SchemaName, OBJECT_NAME(m.object_id) AS ViewName, m.definition
FROM sys.sql_modules m
JOIN sys.views v ON m.object_id = v.object_id

OPEN view_cursor

-- Fetch the first view
FETCH NEXT FROM view_cursor INTO @SchemaName, @ViewName, @Definition

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Create a dynamic SQL to count rows in each view, including schema name
    SET @SQL = 'SELECT @RowCount = COUNT(*) FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ViewName)
    
    -- Execute the dynamic SQL, with error handling
    BEGIN TRY
        EXEC sp_executesql @SQL, N'@RowCount INT OUTPUT', @Count OUTPUT
    END TRY
    BEGIN CATCH
        SET @Count = -1 -- Set count to -1 to indicate an error or inaccessible view
    END CATCH

    -- Insert results into the table
    INSERT INTO #ViewInfo (SchemaName, ViewName, ViewDefinition, NumRows)
    VALUES (@SchemaName, @ViewName, @Definition, @Count)

    -- Fetch next view
    FETCH NEXT FROM view_cursor INTO @SchemaName, @ViewName, @Definition
END

CLOSE view_cursor
DEALLOCATE view_cursor

-- Select results from the table
SELECT SchemaName, ViewName, ViewDefinition, NumRows
FROM #ViewInfo

-- Clean up
DROP TABLE #ViewInfo
