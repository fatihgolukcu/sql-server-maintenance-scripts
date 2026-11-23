# SQL Server Maintenance Scripts

A small toolbox of T-SQL scripts for health-checking and documenting SQL Server instances with many databases.

| Script | What it does |
|---|---|
| `DB_Stats.sql` | Index fragmentation (physical stats) for every online user database, built dynamically |
| `DB_Check.sql`, `Server_DB_Check.sql` | Table/view inventory per database and a server-wide loop |
| `CHECK_BIG_TABLES_LOOP.SQL`, `TBL_Check_Cursor.sql`, `VIEW_CHECK.sql` | Find large tables and validate views |
| `SQL_SCAN*.SQL`, `SQL_TABLE_VIEW_SCAN.SQL`, `Search_DB_Keywords.sql` | Search table/column names and definitions across databases |
| `DB_ALL_Keys.sql` | List primary and foreign keys across databases |
| `databaseAccess.sql` | Create a read-only reporting login and grant `db_datareader` in every active database |

Set your own password in `databaseAccess.sql` before running, and keep real credentials out of version control.

License: MIT
