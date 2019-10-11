CREATE or REPLACE VIEW TGMSDATA.WRITE_BACK_VIEW as

SELECT
upper(trim(OHPONO)) as PO_NUMBER,
ORDER_1 as Order_Number,
COMPANY as Company,
ADDRESS1 as Address_1,
ADDRESS2 as Address_2,
CITY as City,
STATE as State,
ZIP as Zip,
SHIPDATE as Ship_Date,
MASTER# as Master_Tracking#,
'=HYPERLINK("https://www.fedex.com/apps/fedextrack/?tracknumbers='
|| MASTER# || '&cntry_code=us","Track '|| MASTER# ||'")'  AS URL
FROM WRITE_SHP, FHORDR
WHERE ORDER_1 <> 0 and ORDER_1 = OHORD#

  union

SELECT
upper(trim(OHPONO)) as PO_NUMBER,
ORDER_2 as Order_Number,
COMPANY as Company,
ADDRESS1 as Address_1,
ADDRESS2 as Address_2,
CITY as City,
STATE as State,
ZIP as Zip,
SHIPDATE as Ship_Date,
MASTER# as Master_Tracking#,
'=HYPERLINK("https://www.fedex.com/apps/fedextrack/?tracknumbers='
|| MASTER# || '&cntry_code=us","Track '|| MASTER# ||'")' AS URL
FROM WRITE_SHP, FHORDR
WHERE ORDER_2 <> 0 and ORDER_2 = OHORD#

  union

SELECT
upper(trim(OHPONO)) as PO_NUMBER,
ORDER_3 as Order_Number,
COMPANY as Company,
ADDRESS1 as Address_1,
ADDRESS2 as Address_2,
CITY as City,
STATE as State,
ZIP as Zip,
SHIPDATE as Ship_Date,
MASTER# as Master_Tracking#,
'=HYPERLINK("https://www.fedex.com/apps/fedextrack/?tracknumbers='
|| MASTER# || '&cntry_code=us","Track '|| MASTER# ||'")' AS URL
FROM WRITE_SHP, FHORDR
WHERE ORDER_3 <> 0 and ORDER_3 = OHORD#

  union

SELECT
upper(trim(OHPONO)) as PO_NUMBER,
ORDER_4 as Order_Number,
COMPANY as Company,
ADDRESS1 as Address_1,
ADDRESS2 as Address_2,
CITY as City,
STATE as State,
ZIP as Zip,
SHIPDATE as Ship_Date,
MASTER# as Master_Tracking#,
'=HYPERLINK("https://www.fedex.com/apps/fedextrack/?tracknumbers='
|| MASTER# || '&cntry_code=us","Track '|| MASTER# ||'")' AS URL
FROM WRITE_SHP, FHORDR
WHERE ORDER_4 <> 0 and ORDER_4 = OHORD#

  union

SELECT
upper(trim(OHPONO)) as PO_NUMBER,
ORDER_5 as Order_Number,
COMPANY as Company,
ADDRESS1 as Address_1,
ADDRESS2 as Address_2,
CITY as City,
STATE as State,
ZIP as Zip,
SHIPDATE as Ship_Date,
MASTER# as Master_Tracking#,
'=HYPERLINK("https://www.fedex.com/apps/fedextrack/?tracknumbers='
|| MASTER# || '&cntry_code=us","Track '|| MASTER# ||'")' AS URL
FROM WRITE_SHP, FHORDR
WHERE ORDER_5 <> 0 and ORDER_5 = OHORD#
