-- Index physical stats for every online user database on the instance.
-- Usage: run in SSMS; results come back as one row set per database.
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'SELECT ''' + name + N''' AS db_name, * FROM sys.dm_db_index_physical_stats(DB_ID(N'''
             + name + N'''), NULL, NULL, NULL, ''DETAILED'') UNION ALL '
FROM sys.databases
WHERE state_desc = 'ONLINE' AND database_id > 4;

IF LEN(@sql) > 0
BEGIN
    SET @sql = LEFT(@sql, LEN(@sql) - LEN(' UNION ALL '));
    EXEC sp_executesql @sql;
END
