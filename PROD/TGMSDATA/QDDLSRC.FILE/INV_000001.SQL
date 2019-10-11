CREATE or REPLACE VIEW
INV_PLUGS_READY_UNION_SPEC_W_HOLDBACK for SYSTEM NAME INV_P00001 AS
    (
SELECT  IMLOOK as Sort,
        case    when dayofweek_iso(current date) <= 2
                then (current date) - ((dayofweek_iso(current date)-1)-0) days
                when dayofweek_iso(current date) > 2
                then (current date) - ((dayofweek_iso(current date)-1)-7) days
        end                     as Ready_Date
        ,LRITEM                 as Item_Number
        ,LRSIZE                 as Item_Size
        ,IMDES1                 as Item_Description
        ,int(sum(LRQTAV))       as Quantity_Available
        ,current Timestamp      as Retreived_Time
FROM    FDLOTRD
   ,    FMINVT
WHERE   LRITEM=IMITEM
  and   LRSIZE=IMSIZE
--and   IMSOWC <> 'K'
  and   IMSOWC = ' '
  and   LRCUST < 999990
  and   LRGLOC = 'R'
  and   LRQTAV > 0

GROUP BY IMLOOK, LRITEM, LRCRDY, LRSIZE, IMDES1
HAVING sum( LRQTAV ) > 0

UNION

SELECT   IMLOOK                 as Sort
        ,trim(char(int(left(LRCRDY,3))+1900))||'-'||
                     substr(LRCRDY,4,2)||'-'||
                      right(LRCRDY,2)
                                as Ready_Date
        ,LRITEM                 as Item_Number
        ,LRSIZE                 as Item_Size
        ,IMDES1                 as Item_Description
        ,int(sum(LRQTAV)-1)     as Quantity_Available
        ,current Timestamp      as Retreived_Time
FROM    FDLOTRD
   ,    FMINVT
WHERE   LRITEM=IMITEM
  and   LRSIZE=IMSIZE
--and   IMSOWC <> 'K'
  and   IMSOWC = ' '
  and   LRCUST < 999990
  and   LRGLOC = ' '
  and   LRQTAV > 0

GROUP BY IMLOOK, LRITEM, LRCRDY, LRSIZE, IMDES1
HAVING sum( LRQTAV-1 ) > 0
    )
