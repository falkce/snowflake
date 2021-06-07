# Python Functions for Snowflake
![Python Version](https://img.shields.io/badge/Python-3.9.5-3776AB.svg)

### [get_df_from_sf](functions.py)
Function will return a Pandas Dataframe after passing a valid Snowflake SQL query.

    Args:
        query (str): Snowflake SQL Query

    Returns:
        df (pandas.DataFrame): Unaltered Pandas DataFrame
### [query_sf](functions.py)
Function will run a valid Snowflake SQL query.

    Args:
        query (str): Snowflake SQL Query
### [s3_csv_to_sf](functions.py)
Function will write a csv file on s3 to Snowflake. It will automatically extract column headers.

    Args:
        sf_stage (str): The Snowflake stage associated to the s3 destination. You can check your stages via "show stages;"
        s3_url (str): S3 URL of your csv file, e.g. "s3://TEST/TEST/test.csv"
        database (str): Target Database
        schema (str): Target Schema
        table (str): Target Table
        field_delimiter (str) [default = ';']: Field delimiter in your csv file