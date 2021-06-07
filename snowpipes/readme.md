# Snowpipes
## General Info
Snowpipe is Snowflake’s continuous data ingestion service. Snowpipe loads data within minutes after files are added to a stage and submitted for ingestion. With Snowpipe’s serverless compute model, Snowflake manages load capacity, ensuring optimal compute resources to meet demand. In short, Snowpipe provides a “pipeline” for loading fresh data in micro-batches as soon as it’s available.
## Documentation
https://docs.snowflake.com/en/user-guide/data-load-snowpipe-intro.html

## Snowpipes Available
### [Test Snowpipe](Snowpipes.sql)
Test generates new event exports on S3 (s3://url/) in AVRO format. After being triggered via AWS SNS (using SQS Notifications) the Snowpipes pick up new files and save the content to Snowflake.
### Example
```sql
-- Create Pipe
CREATE OR REPLACE PIPE TEST.PIPE_USERS
auto_ingest=TRUE 
AS COPY INTO TEST.PIPE_USERS_INPUT

FROM
  (SELECT $1:app_id::STRING,
             $1:device_id::STRING,
                $1:device_model::STRING,
                   $1:external_user_id::STRING,
                     current_timestamp() AS inserted_at
   FROM @public.sf_stage/s3key/);

-- Monitoring
select SYSTEM$PIPE_STATUS('TEST.PIPE_USERS');

-- Pipe Refresh (if SQS notifications failed)
alter pipe TEST.PIPE_USERS refresh;
```
