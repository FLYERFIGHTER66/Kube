Create or Replace view Unavailable_item_Size_400 for system name FUNAVLITSZ as

Select AVITEM, AVSIZE, DATEFLD
From   FMAVDTE, MONDAYS_ALL
Where  DATEFLD > Current date
  and  DATEFLD <= Current date + 400 days
  and  CYMD7 < AVDYMD - 19000000
  and  AVDYMD-19000000 > date7(current date)
  and  AVSIZE <> ' ';
