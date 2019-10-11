create or replace view Fifty_three_weeks for system name F53weeks as

Select

ready_bay_week                  as WK00,
ready_bay_week + (01*7) days    as WK01,
ready_bay_week + (02*7) days    as WK02,
ready_bay_week + (03*7) days    as WK03,
ready_bay_week + (04*7) days    as WK04,
ready_bay_week + (05*7) days    as WK05,
ready_bay_week + (06*7) days    as WK06,
ready_bay_week + (07*7) days    as WK07,
ready_bay_week + (08*7) days    as WK08,
ready_bay_week + (09*7) days    as WK09,

ready_bay_week + (10*7) days    as WK10,
ready_bay_week + (11*7) days    as WK11,
ready_bay_week + (12*7) days    as WK12,
ready_bay_week + (13*7) days    as WK13,
ready_bay_week + (14*7) days    as WK14,
ready_bay_week + (15*7) days    as WK15,
ready_bay_week + (16*7) days    as WK16,
ready_bay_week + (17*7) days    as WK17,
ready_bay_week + (18*7) days    as WK18,
ready_bay_week + (19*7) days    as WK19,

ready_bay_week + (20*7) days    as WK20,
ready_bay_week + (21*7) days    as WK21,
ready_bay_week + (22*7) days    as WK22,
ready_bay_week + (23*7) days    as WK23,
ready_bay_week + (24*7) days    as WK24,
ready_bay_week + (25*7) days    as WK25,
ready_bay_week + (26*7) days    as WK26,
ready_bay_week + (27*7) days    as WK27,
ready_bay_week + (28*7) days    as WK28,
ready_bay_week + (29*7) days    as WK29,

ready_bay_week + (30*7) days    as WK30,
ready_bay_week + (31*7) days    as WK31,
ready_bay_week + (32*7) days    as WK32,
ready_bay_week + (33*7) days    as WK33,
ready_bay_week + (34*7) days    as WK34,
ready_bay_week + (35*7) days    as WK35,
ready_bay_week + (36*7) days    as WK36,
ready_bay_week + (37*7) days    as WK37,
ready_bay_week + (38*7) days    as WK38,
ready_bay_week + (39*7) days    as WK39,

ready_bay_week + (40*7) days    as WK40,
ready_bay_week + (41*7) days    as WK41,
ready_bay_week + (42*7) days    as WK42,
ready_bay_week + (43*7) days    as WK43,
ready_bay_week + (44*7) days    as WK44,
ready_bay_week + (45*7) days    as WK45,
ready_bay_week + (46*7) days    as WK46,
ready_bay_week + (47*7) days    as WK47,
ready_bay_week + (48*7) days    as WK48,
ready_bay_week + (49*7) days    as WK49,

ready_bay_week + (50*7) days    as WK50,
ready_bay_week + (51*7) days    as WK51,
ready_bay_week + (52*7) days    as WK52,
ready_bay_week + (53*7) days    as WK53

from SYSIBM.SYSDUMMY1;

