-- Step 1: Create the login at the server level
IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name = 'reportReadOnly')
BEGIN
    CREATE LOGIN [reportReadOnly] WITH PASSWORD = '<CHANGE_ME_STRONG_PASSWORD>';
    PRINT 'Login created.';
END
ELSE
BEGIN
    PRINT 'Login already exists.';
END
GO

-- Step 2: Declare variables to loop through active databases
DECLARE @dbName NVARCHAR(255);
DECLARE @sql NVARCHAR(MAX);

DECLARE db_cursor CURSOR FOR
SELECT dbName FROM admin.dbo.tbl_databaseNames WHERE active = 1;

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @dbName;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Dynamic SQL to switch context and create user & grant SELECT
    SET @sql = '
    USE [' + @dbName + '];

    IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = ''reportReadOnly'')
    BEGIN
        CREATE USER [reportReadOnly] FOR LOGIN [reportReadOnly];
        PRINT ''User created in database: ' + @dbName + ''';
    END
    ELSE
    BEGIN
        PRINT ''User already exists in database: ' + @dbName + ''';
    END

    -- Grant read-only access to all tables and views
    EXEC sp_addrolemember N''db_datareader'', N''reportReadOnly'';
    ';

    EXEC sp_executesql @sql;

    FETCH NEXT FROM db_cursor INTO @dbName;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;
