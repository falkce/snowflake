# User-Defined Tasks

## General Info
User-defined tasks allow scheduled execution of SQL statements. Tasks run according to a specified execution configuration, using any combination of a set interval and/or a flexible schedule using a subset of familiar cron utility syntax. Tasks currently run in user-specified warehouses but will eventually run in a serverless environment using Snowflake-supplied compute resources.
## Documentation
https://docs.snowflake.com/en/user-guide/tasks-intro.html
## Example
[Test Task with Stored Procedure](tasks.sql)
```sql
-- Create Task
create task PUBLIC.Test
    warehouse = TEST_CWH
    schedule = 'USING CRON 0 * * * * Europe/Berlin'
    comment = 'Refresh Snowpipes for Test Tables'
as
    Call RunBatchSQL('
        select ''update CTRL.MONITORING
            set status = 1
              , LAST_UPDATE = current_timestamp()
            where monitor_id = 1;'' as SQL_COMMAND

        union

        select distinct
            ''alter pipe '' || PIPE_SCHEMA || ''.'' || PIPE_NAME || '' refresh;'' AS SQL_COMMAND
            from INFORMATION_SCHEMA.PIPES
            where PIPE_NAME like ''PIPE_TESTS%''

        union

        select ''update CTRL.MONITORING
            set status = 0
              , LAST_UPDATE = current_timestamp()
            where monitor_id = 1;'' as SQL_COMMAND');

-- Autocommit has to be set to true, otherwise the task will fail
alter task PUBLIC.Test set autocommit = True;

-- After creation a task is set to 'suspended' by default - in order to activate the task we have to initially resume it.
alter task PUBLIC.Test resume;

-- Monitoring
select *
  from table(information_schema.task_history())
  where name = 'Test'
  order by scheduled_time desc;
```