# Comma Delimited Return
CREATE OR REPLACE FUNCTION PUBLIC.array_sort(A array)
  RETURNS string
  LANGUAGE JAVASCRIPT
COMMENT = 'Sort array passed as parameter. Return COMMA delimited string.'
AS
$$
  return A.sort();
$$
;

# Custom Delimited Return
CREATE OR REPLACE FUNCTION PUBLIC.array_sort(A array, DELIM varchar )
  RETURNS string
  LANGUAGE JAVASCRIPT
COMMENT = 'Sort array passed as parameter. Return SPECIFIED delimiter string.'
AS
$$
  return (A.sort()).join(DELIM);
$$
;