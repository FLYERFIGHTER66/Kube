CREATE OR REPLACE VIEW
TGMSDATA.Inv_Plugs_Ready                       AS

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

