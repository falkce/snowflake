create or replace procedure public.RunBatchSQL(sqlCommand String)
    returns string
    language JavaScript
as
$$
      cmd1_dict = {sqlText: SQLCOMMAND};
      stmt = snowflake.createStatement(cmd1_dict);
      rs = stmt.execute();
      var s = '';
      while (rs.next())  {
          cmd2_dict = {sqlText: rs.getColumnValue("SQL_COMMAND")};
          stmtEx = snowflake.createStatement(cmd2_dict);
          stmtEx.execute();
          s += rs.getColumnValue(1) + "\n";
          }
      return s;
$$
;