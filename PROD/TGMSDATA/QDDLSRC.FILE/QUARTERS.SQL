CREATE OR REPLACE VIEW TGMSDATA.Mondays AS

SELECT
date(  CLCENT||
       right('00'||CLYEAR,2)||'-'||
     left(right(CLCYMD,4),2)||'-'||
          right(CLCYMD,2)) as MONDAY_DATE
, CLDATE                   as MONDAY_DATE_MDY6
, CLCYMD                   as MONDAY_DATE_CYYMMDD
, CLCENT||right('00'||CLYEAR,2)||'-'||right('00'||CLWEEK,2)
                           as MONDAY_WEEK
FROM fcalen WHERE CL#Y = 1
