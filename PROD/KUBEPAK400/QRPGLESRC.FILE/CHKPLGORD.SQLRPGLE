**Free

       Exec SQL
         Declare OrdersCursor Cursor for

         SELECT
           FHORDR.OHSHPC as SVia,
           FMSVIA.SVDESC as Ship_Via,
           FHORDR.OHORD# as Order#,
           FHORDR.OHCUST as Customer,
           FHORDR.OHBLCU as Bill_To,
           FHORDR.OHNAME as Customer_Name,
           FHORDR.OHDTOR as Order_Date,
           FHORDR.OHSHCT as City,
           FHORDR.OHSHST as State,
           Sum(FIORDR.OIQORD) as #_Trays

         FROM   S105R9YM.TGMSDATA.FHORDR FHORDR
           Join S105R9YM.TGMSDATA.FIORDR on FIORDR.OIORD# = FHORDR.OHORD# as FIORDR,
           Join S105R9YM.TGMSDATA.FMSVIA FMSVIA on FHORDR.OHSHPC = FMSVIA.SVCODE,
           Left Outer Join S105R9YM.TGMSDATA.XATABBR XATABBR on XATABBR.TBC6 = FHORDR.OHBABB

         WHERE
           FHORDR.OHSHPC = FMSVIA.SVCODE AND
           FIORDR.OIORD# = FHORDR.OHORD# AND
           FHORDR.OHSTAT='A' AND
           FHORDR.OHDTRY
               between int((year(current date)-1900)||'1218')
               and     int((year(current date)-1900)||'1231')

         GROUP BY
           FHORDR.OHSHPC,
           FMSVIA.SVDESC,
           FHORDR.OHORD#,
           FHORDR.OHCUST,
           FHORDR.OHBLCU,
           FHORDR.OHNAME,
           FHORDR.OHDTOR,
           FHORDR.OHSHCT,
           FHORDR.OHSHST

         ORDER BY
           FHORDR.OHSHPC,
           FHORDR.OHDTOR

         For Read Only;

