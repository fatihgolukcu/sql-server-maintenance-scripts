with search as (SELECT 
    SCHEMA_NAME(o.schema_id) AS SchemaName,
    o.name AS RoutineName,
    o.type_desc AS RoutineType,
    STRING_AGG(
        CAST(
            p.name + ' ' + TYPE_NAME(p.user_type_id) +
            CASE 
                WHEN TYPE_NAME(p.user_type_id) IN ('varchar', 'nvarchar', 'char', 'nchar') 
                THEN '(' + 
                    CASE 
                        WHEN p.max_length = -1 THEN 'MAX'
                        ELSE CAST(p.max_length AS VARCHAR)
                    END + ')'
                ELSE ''
            END
        AS NVARCHAR(MAX)), ', '
    ) WITHIN GROUP (ORDER BY p.parameter_id) AS Parameters
FROM 
    sys.objects o
LEFT JOIN 
    sys.parameters p ON o.object_id = p.object_id
WHERE 
    o.type IN ('P', 'FN', 'IF', 'TF')  -- Procedures and functions
GROUP BY 
    o.schema_id, o.name, o.type_desc
)

select * from search 
where RoutineName like '%managera%'

ORDER BY 
    SchemaName, RoutineName
