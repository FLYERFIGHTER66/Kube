create or replace view Next_five_weeks for system name F05weeks as

Select

ready_bay_week                  as WK00,
ready_bay_week + (01*7) days    as WK01,
ready_bay_week + (02*7) days    as WK02,
ready_bay_week + (03*7) days    as WK03,
ready_bay_week + (04*7) days    as WK04,
ready_bay_week + (05*7) days    as WK05

from SYSIBM.SYSDUMMY1;

