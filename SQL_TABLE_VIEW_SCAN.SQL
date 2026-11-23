SELECT 
    c.TABLE_SCHEMA AS SchemaName,
    c.TABLE_NAME AS TableName,
    c.COLUMN_NAME AS ColumnName,
    c.DATA_TYPE AS DataType,
    c.CHARACTER_MAXIMUM_LENGTH AS MaxLength,
    c.IS_NULLABLE AS IsNullable,
    c.COLUMN_DEFAULT AS DefaultValue,
    CASE 
        WHEN t.TABLE_TYPE = 'BASE TABLE' THEN 'Table'
        WHEN t.TABLE_TYPE = 'VIEW' THEN 'View'
    END AS ObjectType
FROM 
    INFORMATION_SCHEMA.COLUMNS c
JOIN 
    INFORMATION_SCHEMA.TABLES t 
ON 
    c.TABLE_NAME = t.TABLE_NAME
    AND c.TABLE_SCHEMA = t.TABLE_SCHEMA
where COLUMN_NAME like '%h_raport_managera_nagl%'
ORDER BY 
    c.TABLE_SCHEMA, c.TABLE_NAME, c.COLUMN_NAME;
