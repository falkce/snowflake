# Stored Procedures

## General Info
Stored procedures allow you to extend Snowflake SQL by combining it with JavaScript so that you can include programming constructs such as branching and looping.

## Documentation
https://docs.snowflake.com/en/sql-reference/stored-procedures-overview.html

## Procedures Available
### [RunBatchSQL](RunBatchSQL.sql)
This procedure will accept a string parameter that is a SQL statement designed to generate rows of SQL statements to execute. It will then execute the input SQL statement to generate a list of SQL statements to run and then run all statements identified by the “SQL_COMMAND” column one at a time.

tl;dr: The procedure runs multiple SQL statements.

### Example
This query will return multiple SQL statements as string values:
```sql
select distinct
'insert overwrite into ' || TABLE_SCHEMA || '.' || TABLE_NAME || ' select distinct * from ' || TABLE_SCHEMA || '.' || TABLE_NAME || ';' AS SQL_COMMAND
from INFORMATION_SCHEMA.TABLES
where TABLE_NAME like 'STG_TEST%';
```
We can pass this query as a string value to the stored procedure. It will execute the query to generate the SQL statements and will then proceed to execute each of these statements one after another.
```sql
-- either pass the query text via parameter
set query_text = ('select distinct
''insert overwrite into '' || TABLE_SCHEMA || ''.'' || TABLE_NAME || '' select distinct * from '' || TABLE_SCHEMA || ''.'' || TABLE_NAME || '';'' AS SQL_COMMAND
from INFORMATION_SCHEMA.TABLES
where TABLE_NAME like ''STG_TEST%'';');

Call RunBatchSQL($query_text);


-- or directly pass the query text as string value
Call RunBatchSQL('select distinct
''insert overwrite into '' || TABLE_SCHEMA || ''.'' || TABLE_NAME || '' select distinct * from '' || TABLE_SCHEMA || ''.'' || TABLE_NAME || '';'' AS SQL_COMMAND
from INFORMATION_SCHEMA.TABLES
where TABLE_NAME like ''STG_TEST%'';');
```
This process comes in handy when handling processes via Snowflake Tasks. Since Tasks can only execute a single statement we can use this procedure to execute multiple statements per Task.

