    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

     FSCR600P   O    E             PRINTER OFLIND(*IN25) USROPN
     FRB_ROTATE1IF   E           K DISK

      //  Main program interface
     D SCR600          PI
     D  ShipDate                      7S 0
     D  Master                        2S 0
     D  Printer                      10

     D FirstPage       S               N   Inz(*On)
     D OvrPrtf         S            256A

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$_Dates

      /Free

    ?   /COPY QFunctDefn,LASTUSEDCB

         If not %Open(SCR600P);
           OVRPRTF = 'OVRPRTF FILE(SCR600P)' +
                            ' FORMTYPE(*NAR)' +
                            ' OUTQ(' + %Trim(PRINTER) + ')' +
                            ' CPI(10) ' +
                            ' PAGRTT(0)' +
                            ' PAGESIZE(66 80)' +
                            ' OPNSCOPE(*JOB)';
           QCmdExc(OVRPRTF : %len(%trim(OVRPRTF)));
           Open SCR600P;
         EndIf;

         SHIPDATE6 = $MDYDate($Date(ShipDate));

         Exec SQL
           Delete From RB_ROTATE
           Where RTSHPD = :ShipDate
             and RTMAST = :Master;

         Exec SQL                                                    // Only Rotate Whole Trays
           Insert   into RB_ROTATE                                   // Leave all customer allo-
           SELECT   :ShipDate     as RTSHPD                          // cated Trays off list.
                ,   :Master       as RTMAST
                ,   LRITEM        as RTITEM
                ,   LRSIZE        as RTSIZE
                ,   max(LRALPH)   as RTALPH
                ,   max(LRDESC)   as RTDESC
                ,   sum(LRQTAV)   as RTRBOH
                ,   0             as RTPSUS
                ,   0             as RTRQTY
                ,   current_date  as RTDTLA
                ,   current_time  as RTTIME
                ,   user          as RTUSER
                ,   'SCR600'      as RTPROG
           FROM     fdlotrd_ar
           WHERE    LRCUST in
             (SELECT RCCUST FROM FROTATECUS WHERE RCTOFR = 'F')
           GROUP BY LRITEM, LRSIZE
           ORDER BY LRITEM, LRSIZE;

         Exec SQL
           update  RB_ROTATE as RT
           set     RT.RTPSUS = RT.RTPSUS + Coalesce(
           (SELECT Sum(PDQORD-PDQSCH) FROM FPUTORD
            Where  PDSHPD = :ShipDate
              and  PDMAST = :Master
              and  PDSHPD = RTSHPD
              and  PDCUST < 900000
              and  PDCUST not in
                  (SELECT RCCUST FROM FROTATECUS WHERE RCTOFR = 'T')  // Rotate not Authorized
              and  PDMAST = RTMAST
              and  PDITEM = RTITEM
              and  PDSIZE = RTSIZE )  , 0);

         Exec SQL
           update  RB_ROTATE
           set     RTRQTY =
                   Case When RTPSUS < RTRBOH then RTPSUS else RTRBOH end
           Where   RTSHPD = :ShipDate
             and   RTMAST = :Master;

         Setll (ShipDate:Master) RB_ROTATE1;
         ReadE (ShipDate:Master) RB_ROTATE1;
         DoW not %EOF(RB_ROTATE1);
           If *In25 or FirstPage;
             Write Header;
             FirstPage = *Off;
             *In25 = *Off;
           EndIf;

           RPT_ITEM = %Subst(RTITEM:1:5);
           RPT_SIZE = RTSIZE;
           RPT_RBOH = RTRBOH;
           RPT_PSUS = RTPSUS;
           RPT_RQTY = RTRQTY;
           if RTRQTY <> 0;
             Write Detail;
           EndIf;
           ReadE (ShipDate:Master) RB_ROTATE1;
         EndDo;

         If %Open(SCR600P);
           Close SCR600P;
         EndIf;

         *InLR = *On;
      /End-Free
