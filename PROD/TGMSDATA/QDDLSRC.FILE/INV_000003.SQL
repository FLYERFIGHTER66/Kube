CREATE OR REPLACE VIEW
PHPDATA.Inv_Plugs_Ready_Windows_w_holdback AS

SELECT  IMLOOK as Sort
        ,LRITEM                 as Item_Number
        ,LRSIZE                 as Item_Size
        ,IMDES1                 as Item_Description
        ,case    when dayofweek_iso(current date) <= 2
                then (current date) - ((dayofweek_iso(current date)-1)-0) days
                when dayofweek_iso(current date) > 2
                then (current date) - ((dayofweek_iso(current date)-1)-7) days
        end                     as Base_Week
        ,int(sum(LRQTAV))       as Quantity_Available_Ready
        ,0                      as Quantity_Available_Spec0
        ,0                      as Quantity_Available_Spec1
        ,0                      as Quantity_Available_Spec2
        ,0                      as Quantity_Available_Spec3
        ,0                      as Quantity_Available_Spec4
        ,0                      as Quantity_Available_Spec5
        ,current Timestamp      as Retreived_Time
FROM    TGMSDATA.FDLOTRD
   ,    TGMSDATA.FMINVT
WHERE   LRITEM=IMITEM
  and   LRSIZE=IMSIZE
  and   IMSOWC <> 'K'
  and   LRCUST < 999990
  and   LRGLOC = 'R'
  and   LRQTAV > 0

GROUP BY IMLOOK, LRITEM, LRCRDY, LRSIZE, IMDES1
HAVING sum( LRQTAV ) > 0

UNION
-- Partials
SELECT  IMLOOK as Sort
        ,trim(LRITEM)||'P'      as Item_Number
        ,LRSIZE                 as Item_Size
        ,IMDES1                 as Item_Description
        ,case    when dayofweek_iso(current date) <= 2
                then (current date) - ((dayofweek_iso(current date)-1)-0) days
                when dayofweek_iso(current date) > 2
                then (current date) - ((dayofweek_iso(current date)-1)-7) days
        end                     as Base_Week
        ,sum(LDPRTT)            as Quantity_Available_Ready
        ,0                      as Quantity_Available_Spec0
        ,0                      as Quantity_Available_Spec1
        ,0                      as Quantity_Available_Spec2
        ,0                      as Quantity_Available_Spec3
        ,0                      as Quantity_Available_Spec4
        ,0                      as Quantity_Available_Spec5
        ,current Timestamp      as Retreived_Time
FROM    TGMSDATA.FDLOTRD
   ,    TGMSDATA.FMINVT
   ,    TGMSDATA.FLOSSLOT
WHERE   LRITEM=IMITEM
  and   LRSIZE=IMSIZE
  and   FDLOTRD.LRITEM= FLOSSLOT.LDITEM
  and   FDLOTRD.LRSIZE= FLOSSLOT.LDSIZE
  and   FDLOTRD.LRSOWD= FLOSSLOT.LDSOWD
  and   FDLOTRD.LRCRDY= FLOSSLOT.LDREDY
  and   IMSOWC <> 'K'
  and   LRCUST = 999997
  and   LRGLOC = 'R'
  and   LRQTAV > 0

GROUP BY IMLOOK, LRITEM, LRCRDY, LRSIZE, IMDES1
HAVING sum( LDPRTT ) > 0

UNION
-- Spec 0
SELECT   IMLOOK                 as Sort
        ,LRITEM                 as Item_Number
        ,LRSIZE                 as Item_Size
        ,IMDES1                 as Item_Description
        ,case    when dayofweek_iso(current date) <= 2
                then (current date) - ((dayofweek_iso(current date)-1)-0) days
                when dayofweek_iso(current date) > 2
                then (current date) - ((dayofweek_iso(current date)-1)-7) days
        end                     as Base_Week
        ,0                      as Quantity_Available_Ready
        ,int(sum(LRQTAV)-1)     as Quantity_Available_Spec0
        ,0                      as Quantity_Available_Spec1
        ,0                      as Quantity_Available_Spec2
        ,0                      as Quantity_Available_Spec3
        ,0                      as Quantity_Available_Spec4
        ,0                      as Quantity_Available_Spec5
        ,current Timestamp      as Retreived_Time
FROM    TGMSDATA.FDLOTRD
   ,    TGMSDATA.FMINVT
   ,    TGMSDATA.FCALEN_ALL
WHERE   LRITEM=IMITEM
  and   LRSIZE=IMSIZE
  and   LRCRDY=CYMD7
  and   IMSOWC <> 'K'
  and   LRCUST < 999990
  and   LRGLOC = ' '
  and   LRQTAV > 0
  and   DATEFLD =
        case    when dayofweek_iso(current date) <= 2
                then (current date) - ((dayofweek_iso(current date)-1)-0) days
                when dayofweek_iso(current date) > 2
                then (current date) - ((dayofweek_iso(current date)-1)-7) days
        end

GROUP BY IMLOOK, LRITEM, LRSIZE, IMDES1
HAVING sum( LRQTAV-1 ) > 0


UNION
-- Spec 1
SELECT   IMLOOK                 as Sort
        ,LRITEM                 as Item_Number
        ,LRSIZE                 as Item_Size
        ,IMDES1                 as Item_Description
        ,case    when dayofweek_iso(current date) <= 2
                then (current date) - ((dayofweek_iso(current date)-1)-0) days
                when dayofweek_iso(current date) > 2
                then (current date) - ((dayofweek_iso(current date)-1)-7) days
        end                     as Base_Week
        ,0                      as Quantity_Available_Ready
        ,0                      as Quantity_Available_Spec0
        ,int(sum(LRQTAV)-1)     as Quantity_Available_Spec1
        ,0                      as Quantity_Available_Spec2
        ,0                      as Quantity_Available_Spec3
        ,0                      as Quantity_Available_Spec4
        ,0                      as Quantity_Available_Spec5
        ,current Timestamp      as Retreived_Time
FROM    TGMSDATA.FDLOTRD
   ,    TGMSDATA.FMINVT
   ,    TGMSDATA.FCALEN_ALL
WHERE   LRITEM=IMITEM
  and   LRSIZE=IMSIZE
  and   LRCRDY=CYMD7
  and   IMSOWC <> 'K'
  and   LRCUST < 999990
  and   LRGLOC = ' '
  and   LRQTAV > 0
  and   DATEFLD =
        case    when dayofweek_iso(current date) <= 2
                then (current date) - ((dayofweek_iso(current date)-1)-0) days
                when dayofweek_iso(current date) > 2
                then (current date) - ((dayofweek_iso(current date)-1)-7) days
        end                     + 7 days

GROUP BY IMLOOK, LRITEM, LRSIZE, IMDES1
HAVING sum( LRQTAV-1 ) > 0


UNION
-- Spec 2
SELECT   IMLOOK                 as Sort
        ,LRITEM                 as Item_Number
        ,LRSIZE                 as Item_Size
        ,IMDES1                 as Item_Description
        ,case    when dayofweek_iso(current date) <= 2
                then (current date) - ((dayofweek_iso(current date)-1)-0) days
                when dayofweek_iso(current date) > 2
                then (current date) - ((dayofweek_iso(current date)-1)-7) days
        end                     as Base_Week
        ,0                      as Quantity_Available_Ready
        ,0                      as Quantity_Available_Spec0
        ,0                      as Quantity_Available_Spec1
        ,int(sum(LRQTAV)-1)     as Quantity_Available_Spec2
        ,0                      as Quantity_Available_Spec3
        ,0                      as Quantity_Available_Spec4
        ,0                      as Quantity_Available_Spec5
        ,current Timestamp      as Retreived_Time
FROM    TGMSDATA.FDLOTRD
   ,    TGMSDATA.FMINVT
   ,    TGMSDATA.FCALEN_ALL
WHERE   LRITEM=IMITEM
  and   LRSIZE=IMSIZE
  and   LRCRDY=CYMD7
  and   IMSOWC <> 'K'
  and   LRCUST < 999990
  and   LRGLOC = ' '
  and   LRQTAV > 0
  and   DATEFLD =
        case    when dayofweek_iso(current date) <= 2
                then (current date) - ((dayofweek_iso(current date)-1)-0) days
                when dayofweek_iso(current date) > 2
                then (current date) - ((dayofweek_iso(current date)-1)-7) days
        end                     + 14 days

GROUP BY IMLOOK, LRITEM, LRSIZE, IMDES1
HAVING sum( LRQTAV-1 ) > 0


UNION
-- Spec 3
SELECT   IMLOOK                 as Sort
        ,LRITEM                 as Item_Number
        ,LRSIZE                 as Item_Size
        ,IMDES1                 as Item_Description
        ,case    when dayofweek_iso(current date) <= 2
                then (current date) - ((dayofweek_iso(current date)-1)-0) days
                when dayofweek_iso(current date) > 2
                then (current date) - ((dayofweek_iso(current date)-1)-7) days
        end                     as Base_Week
        ,0                      as Quantity_Available_Ready
        ,0                      as Quantity_Available_Spec0
        ,0                      as Quantity_Available_Spec1
        ,0                      as Quantity_Available_Spec2
        ,int(sum(LRQTAV)-1)     as Quantity_Available_Spec3
        ,0                      as Quantity_Available_Spec4
        ,0                      as Quantity_Available_Spec5
        ,current Timestamp      as Retreived_Time
FROM    TGMSDATA.FDLOTRD
   ,    TGMSDATA.FMINVT
   ,    TGMSDATA.FCALEN_ALL
WHERE   LRITEM=IMITEM
  and   LRSIZE=IMSIZE
  and   LRCRDY=CYMD7
  and   IMSOWC <> 'K'
  and   LRCUST < 999990
  and   LRGLOC = ' '
  and   LRQTAV > 0
  and   DATEFLD =
        case    when dayofweek_iso(current date) <= 2
                then (current date) - ((dayofweek_iso(current date)-1)-0) days
                when dayofweek_iso(current date) > 2
                then (current date) - ((dayofweek_iso(current date)-1)-7) days
        end                     + 21 days

GROUP BY IMLOOK, LRITEM, LRSIZE, IMDES1
HAVING sum( LRQTAV-1 ) > 0


UNION
-- Spec 4
SELECT   IMLOOK                 as Sort
        ,LRITEM                 as Item_Number
        ,LRSIZE                 as Item_Size
        ,IMDES1                 as Item_Description
        ,case    when dayofweek_iso(current date) <= 2
                then (current date) - ((dayofweek_iso(current date)-1)-0) days
                when dayofweek_iso(current date) > 2
                then (current date) - ((dayofweek_iso(current date)-1)-7) days
        end                     as Base_Week
        ,0                      as Quantity_Available_Ready
        ,0                      as Quantity_Available_Spec0
        ,0                      as Quantity_Available_Spec1
        ,0                      as Quantity_Available_Spec2
        ,0                      as Quantity_Available_Spec3
        ,int(sum(LRQTAV)-1)     as Quantity_Available_Spec4
        ,0                      as Quantity_Available_Spec5
        ,current Timestamp      as Retreived_Time
FROM    TGMSDATA.FDLOTRD
   ,    TGMSDATA.FMINVT
   ,    TGMSDATA.FCALEN_ALL
WHERE   LRITEM=IMITEM
  and   LRSIZE=IMSIZE
  and   LRCRDY=CYMD7
  and   IMSOWC <> 'K'
  and   LRCUST < 999990
  and   LRGLOC = ' '
  and   LRQTAV > 0
  and   DATEFLD =
        case    when dayofweek_iso(current date) <= 2
                then (current date) - ((dayofweek_iso(current date)-1)-0) days
                when dayofweek_iso(current date) > 2
                then (current date) - ((dayofweek_iso(current date)-1)-7) days
        end                     + 28 days

GROUP BY IMLOOK, LRITEM, LRSIZE, IMDES1
HAVING sum( LRQTAV-1 ) > 0


UNION
-- Spec 5
SELECT   IMLOOK                 as Sort
        ,LRITEM                 as Item_Number
        ,LRSIZE                 as Item_Size
        ,IMDES1                 as Item_Description
        ,case    when dayofweek_iso(current date) <= 2
                then (current date) - ((dayofweek_iso(current date)-1)-0) days
                when dayofweek_iso(current date) > 2
                then (current date) - ((dayofweek_iso(current date)-1)-7) days
        end                     as Base_Week
        ,0                      as Quantity_Available_Ready
        ,0                      as Quantity_Available_Spec0
        ,0                      as Quantity_Available_Spec1
        ,0                      as Quantity_Available_Spec2
        ,0                      as Quantity_Available_Spec3
        ,0                      as Quantity_Available_Spec4
        ,int(sum(LRQTAV)-1)     as Quantity_Available_Spec5
        ,current Timestamp      as Retreived_Time
FROM    TGMSDATA.FDLOTRD
   ,    TGMSDATA.FMINVT
   ,    TGMSDATA.FCALEN_ALL
WHERE   LRITEM=IMITEM
  and   LRSIZE=IMSIZE
  and   LRCRDY=CYMD7
  and   IMSOWC <> 'K'
  and   LRCUST = 999997
  and   LRGLOC = ' '
  and   LRQTAV > 0
  and   DATEFLD =
        case    when dayofweek_iso(current date) <= 2
                then (current date) - ((dayofweek_iso(current date)-1)-0) days
                when dayofweek_iso(current date) > 2
                then (current date) - ((dayofweek_iso(current date)-1)-7) days
        end                     + 35 days

GROUP BY IMLOOK, LRITEM, LRSIZE, IMDES1
HAVING sum( LRQTAV-1 ) > 0
