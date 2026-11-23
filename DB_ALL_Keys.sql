-- FG
-- 29/04/2024
-- to find all kind of keys
-- Foreign Keys
SELECT 
    fk.name AS KeyName,
    'Foreign Key' AS KeyType,
    SCHEMA_NAME(t.schema_id) + '.' + t.name AS TableName,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ColumnName,
    SCHEMA_NAME(rt.schema_id) + '.' + rt.name AS ReferenceTableName,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ReferenceColumnName
FROM 
    sys.foreign_keys AS fk
INNER JOIN 
    sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN 
    sys.tables AS t ON t.object_id = fk.parent_object_id
INNER JOIN 
    sys.tables AS rt ON rt.object_id = fk.referenced_object_id

UNION ALL

-- Primary Keys
SELECT 
    pk.name AS KeyName,
    'Primary Key' AS KeyType,
    SCHEMA_NAME(t.schema_id) + '.' + t.name AS TableName,
    COL_NAME(ic.object_id, ic.column_id) AS ColumnName,
    NULL AS ReferenceTableName,
    NULL AS ReferenceColumnName
FROM 
    sys.indexes AS pk
INNER JOIN 
    sys.index_columns AS ic ON pk.object_id = ic.object_id AND pk.index_id = ic.index_id
INNER JOIN 
    sys.tables AS t ON t.object_id = pk.object_id
WHERE 
    pk.is_primary_key = 1

UNION ALL

-- Unique Constraints
SELECT 
    uq.name AS KeyName,
    'Unique Constraint' AS KeyType,
    SCHEMA_NAME(t.schema_id) + '.' + t.name AS TableName,
    COL_NAME(ic.object_id, ic.column_id) AS ColumnName,
    NULL AS ReferenceTableName,
    NULL AS ReferenceColumnName
FROM 
    sys.indexes AS uq
INNER JOIN 
    sys.index_columns AS ic ON uq.object_id = ic.object_id AND uq.index_id = ic.index_id
INNER JOIN 
    sys.tables AS t ON t.object_id = uq.object_id
WHERE 
    uq.is_unique_constraint = 1

UNION ALL

-- Default Constraints
SELECT 
    dc.name AS KeyName,
    'Default Constraint' AS KeyType,
    SCHEMA_NAME(t.schema_id) + '.' + t.name AS TableName,
    COL_NAME(c.object_id, c.column_id) AS ColumnName,
    NULL AS ReferenceTableName,
    NULL AS ReferenceColumnName
FROM 
    sys.default_constraints AS dc
INNER JOIN 
    sys.columns AS c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
INNER JOIN 
    sys.tables AS t ON t.object_id = dc.parent_object_id;
