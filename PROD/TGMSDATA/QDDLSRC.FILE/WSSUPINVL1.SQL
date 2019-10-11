create or replace view Supplier_Inventory for system name WSSUPINVL1 as

SELECT
  SIVENNAM          as Vendor
, SIVENNUM          as Vendor_Number
, SIMATTYP          as Material_Type
, SIITEM            as Vendor_Item_Number
, DESCRIPTION       as Vendor_Description
, cast (date(
    substr(trim(char(SIAVLDAT)),5,2)||'/'||
    substr(trim(char(SIAVLDAT)),7,2)||'/'||
    left(trim(char(SIAVLDAT)),4)) as date)
                    as Available_Date
, SISUPQTY          as Supplier_Quantity_OnHand
, SIALCQTY          as Supplier_Quantity_Allocated
, SIAVLQTY          as Supplier_Quantity_Available
, IMLOOK            as Kube_Pak_Sort
, LOCALITEMNUMBER   as Kube_Pak_Item
, LOCALITEMSIZE     as Kube_Pak_Size
, IMDES1            as Kube_Pak_Description
, '('||trim(IMLOOK)||') '||trim(IMDES1)||' - '||trim(IMITEM)
                    as Kube_Pak_Sort_Description
, SICRTPGM          as LastProgram
, cast ( date(
    left(right('0'||trim(char(SICRTDAT)),6),2)||'/'||
    substr(right('0'||trim(char(SICRTDAT)),6),3,2)||'/20'||
    right(trim(char(SICRTDAT)),2)) as date)
                    as Created_Date
, cast ( time(
    left(right('0'||trim(char(SICRTTIM)),6),2)||':'||
    substr(right('0'||trim(char(SICRTTIM)),6),3,2)||':'||
    right(trim(char(SICRTTIM)),2)) as timestamp)
                    as Created_Time

FROM  WSSUPINVPF
join  XREFINVT     on XREFINVT.FOREIGNKEYVALUE = SIITEM
                  and XREFINVT.PROVIDEDBYID = SIVENNUM
join  FMINVT       on XREFINVT.LOCALITEMNUMBER = FMINVT.IMITEM
                  and XREFINVT.LOCALITEMSIZE   = FMINVT.IMSIZE

union

SELECT
  'Kube-Pak'        as Vendor
, 1679             as Vendor_Number
, 'Extra Cuts'      as Material_Type
, IMITEM            as Vendor_Item_Number
, IMDES1            as Vendor_Description
, cast (date(substr(trim(char(CLSOWD)),4,2)||'/'||
    substr(trim(char(CLSOWD)),6,2)||'/'||
    char(left(trim(char(CLSOWD)),3)+1900)) as date)
                    as Available_Date
, CLQTOH            as Supplier_Quantity_OnHand
, CLQTSL            as Supplier_Quantity_Allocated
, CLQTAV            as Supplier_Quantity_Available
, IMLOOK            as Kube_Pak_Sort
, IMITEM            as Kube_Pak_Item
, 'CUT'             as Kube_Pak_Size
, IMDES1            as Kube_Pak_Description
, '('||trim(IMLOOK)||') '||trim(IMDES1)||' - '||trim(IMITEM)
                    as Kube_Pak_Sort_Description
, 'CUT_SYSTEM'      as LastProgram
, cast (date(current date) as date)
                    as Created_Date
, cast (time(current time) as timestamp)
                    as Created_Time

FROM  FCUTLOT
join  FMINVT       on FCUTLOT.CLITEM = FMINVT.IMITEM
where IMSIZE = 'CUT'
  and CLQTAV > 0;

