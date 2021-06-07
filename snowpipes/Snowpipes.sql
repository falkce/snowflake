-- Setup
CREATE STAGE public.sf_stage
  url='s3://test/'
  credentials=(AWS_KEY_ID='...' AWS_SECRET_KEY='...');

CREATE FILE FORMAT
    public.AVRO_FORMAT
    type = 'avro'
    compression = 'auto';

GRANT USAGE ON FILE FORMAT AVRO_FORMAT TO ROLE USER;
GRANT USAGE ON FILE FORMAT AVRO_FORMAT TO ROLE SYSTEMUSER;

ALTER STAGE
    public.sf_stage
SET
    file_format = public.AVRO_FORMAT;


-- Create Table for Input
create or replace table TEST.PIPE_USERS_INPUT
(
    app_id STRING,
    device_id STRING,
    device_model STRING,
    external_user_id STRING,
    inserted_at timestamp_ntz
    );


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
