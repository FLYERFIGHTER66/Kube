Create or Replace view Unavailable_items_400 for system name FUNAVLITM as

-- All unavailable items for the next 400 days
--    due to the ENTIRE item being marked unavailable (eg SIZE=' ')

select  AVITEM
,       DATEFLD

from    FMAVDTE
,       MONDAYS_ALL

Where   DATEFLD > Current date
  and   DATEFLD <= Current date + 400 days
  and   CYMD7 < AVDYMD - 19000000
  and   AVDYMD-19000000 > date7(current date)
  and   AVSIZE = ' ';

