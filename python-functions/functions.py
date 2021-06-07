from sf_config import config as sf_config
from secrets import secrets as sec
import snowflake.connector as sf
import pandas as pd
import boto3
from botocore.exceptions import NoCredentialsError
import logging


def get_df_from_sf(query):
    """Function will return a Pandas Dataframe after passing a valid Snowflake SQL query.

    Args:
        query (str): Snowflake SQL Query

    Returns:
        df (pandas.DataFrame): Unaltered Pandas DataFrame
    """

    try:
        snowflake_connection = sf.connect(account=sf_config.account, user=sf_config.username,
                                          password=sf_config.password, database=sf_config.database,
                                          warehouse=sf_config.warehouse, autocommit=True)
        cursor = snowflake_connection.cursor()

        cursor.execute(f"""{query}""")
        df = cursor.fetch_pandas_all()

        logging.info(f'Success: DF received')
        return df

    except Exception as e:
        logging.error(f'{e}')

    finally:
        cursor.close()
        snowflake_connection.close()

def query_sf(query):
    """Function will run a valid Snowflake SQL query.

    Args:
        query (str): Snowflake SQL Query
    """

    try:
        snowflake_connection = sf.connect(account=sf_config.account, user=sf_config.username,
                                          password=sf_config.password, database=sf_config.database,
                                          warehouse=sf_config.warehouse, autocommit=True)
        cursor = snowflake_connection.cursor()
        cursor.execute(query)
        logging.info(f'Success: Query executed')

    except Exception as e:
        logging.error(f'{e}')

    finally:
        cursor.close()
        snowflake_connection.close()

def s3_csv_to_sf(sf_stage, s3_url, database, schema, table, field_delimiter=';'):
    """Function will write a csv file on s3 to Snowflake. It will automatically extract column headers.

    Args:
        sf_stage (str): The Snowflake stage associated to the s3 destination. You can check your stages via "show stages;"
        s3_url (str): S3 URL of your csv file, e.g. "s3://TEST/TEST/test.csv"
        database (str): Target Database
        schema (str): Target Schema
        table (str): Target Table
        field_delimiter (str) [default = ';']: Field delimiter in your csv file
    """

    try:
        snowflake_connection = sf.connect(account=sf_config.account, user=sf_config.username,
                                          password=sf_config.password, database=sf_config.database,
                                          warehouse=sf_config.warehouse, schema=schema, autocommit=True)

        cursor = snowflake_connection.cursor()

        column_list = df.columns.values.tolist()
        column_list_copy = ", ".join(str(x) for x in column_list)
        number_list_copy = ", ".join(('$' + str((i+1))) for i in range(len(df.columns)))
        s3_url = s3_url.split('/', 3)[-1]

        cursor.execute(f"""copy into {database}.{schema}.{table}
                            ({column_list_copy})
                          from (
                            select 
                                {number_list_copy}
                            from @{sf_stage}/{s3_url}
                                )
                          file_format=(TYPE=CSV 
                                        SKIP_HEADER=1
                                        FIELD_DELIMITER={field_delimiter}
                                        EMPTY_FIELD_AS_NULL=TRUE)
                          ;""")

        logging.info(f'Success: {s3_url} inserted into {database}.{schema}.{table}')

    except Exception as e:
        logging.error(f'{e}')

    finally:
        cursor.close()
        snowflake_connection.close()
