create or replace view MASTER_TAG_FORWARD_SALES as

SELECT  '790100  '                          as CustomerNumber
     ,  'Kube Pak Corporation'              as CustomerName
     ,  Monday_Date + 5 days                as ForwardSalesWeekEndingDate
     ,  OIITEM                              as ItemIdentifier
     ,  OIDES1                              as Description
     ,  sum(int(SZSALE * (OIQORD-OIQSHP)))  as QuantitySold
     ,  substr(digits(OIDTRQ),1,2) ||'-'||
        substr(digits(OIDTRQ),3,2) ||'-20'||
        substr(digits(OIDTRQ),5,2)          as OrderDate
     ,  substr(digits(OIDTRQ),1,2) ||'-'||
        substr(digits(OIDTRQ),3,2) ||'-20'||
        substr(digits(OIDTRQ),5,2)          as ShipDate
     ,  Monday_Date                         as Monday_Date

FROM      FHORDR
join      FIORDR  on  OHORD# =  OIORD#
                  and OHSTAT =  OISTAT
                  and OIITYP =  ' '
join      FMINVT  on  OIITEM =  IMITEM
                  and OISIZE =  IMSIZE
                  and IMFRSZ =  'CUT'
join      FMSIZE  on  OISIZE =  SZCODE
join      MTITEMS on  OIITEM =  MTITEM
                  and OISIZE =  MTSIZE
join      MONDAYS_ALL on OIDTRQ = Monday6MDY

WHERE     OHSTAT =  'A'
  and     OICUST <> 2730
  and     OICUST not in
         (Select CMCUST from FMCUST where CMNAME like '%KUBE%')
  and   OIRVDT >=  date7(most_recent_monday)

GROUP BY OIITEM, OIDES1, OIDTRQ, Monday_Date
