     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      //? :````````````````````````````````````````````````````````````:?
      //? :   Title:  Upload Finished Production Schedule Info         :?
      //? :............................................................:?
      //? :````````````````````````````````````````````````````````````:
      //? : Created:  February 2016        ? Kube-Pak Corporation ?    :
      //? :      by:  William J. Behr                                  :
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :   Program Description                                     ?:
      //? : ```````````````````````                                   ?:
      //? :                                                           ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Edit Log                                                ?:
      //? :                                                           ?:
      //? :  WJB    -? 2/01/16 - Initial Programming                  ?:
      //? :         -?  /  /   - _____________________________________?:
      //? :............................................................:
     FFIORDR    UF   E           K DISK
     FFDLOTRD   UF A E           K DISK
     FFALITEML  UF A E           K DISK

      //? Main procedure prototype & interface
     D FX1160201A      PR                  ExtPgm('FX1160201A')
     D FX1160201A      PI

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCMDEXC
    ?D/COPY QFunctDefn,$_Dates
    ?D/COPY QFunctDefn,$Now

      *? Data Structures
     D  SelOrdSeq      DS
     D  SelOrder                      6S 0
     D  SelSeq#                       3S 0
     D  SelOrdSeq#                    9S 0 OverLay(SelOrdSeq)

      *? Fields
     D  SowDate7       S              7S 0 inz(1160125)
     D  LastOrdSeq#    S              9S 0 inz(*Zeros)
     D  MoveQty        S             11S 1 inz(*Zeros)

      /Free

         SQLState = '00000';

         DoW SQLState = '00000';

           Exec SQL
             SELECT    OIORD#*1000+OISEQ#
             INTO     :SelOrdSeq#
             FROM      FIORDR left outer join FALITEM
                       on OIORD#=AIORD# and OISEQ#=AIOSEQ
             WHERE     OISOW = :SowDate7
               and     OIORD#*1000+OISEQ# > :LastOrdSeq#
               and     OISTAT <> 'D'
               and     OISIZE in
                         ('50','51','72','102','105','162','288','512')
               and     AIORD# is null
             ORDER BY OIORD#, OISEQ#
             Fetch First Row Only;

           If SQLState = '00000';
             LastOrdSeq# = SelOrdSeq#;

             // Chain to Order Detail
             Chain (SelOrder : SelSeq#) FIORDR;

             // Get Inventory from FIXERS
             Chain ( OIITEM
                   : OISIZE
                   : OISOW
                   : OIRVDT
                   : '  '
                   : '  '
                   : 'A'
                   : 999999 ) FDLOTRD;
             //If Found, continue
             If %Found(FDLOTRD);
               If LRQTAL >= OIQORD;
                 MoveQty = OIQORD;
                Else;
                 MoveQty = LRQTAL;
               EndIf;

               LRQTAL -= MoveQty;
               LRQTOH -= MoveQty;
               LRDTLA  = $MDYDate($Date(0));
               LRTIME  = $Now();
               LRUSER  = 'FX1160201A';

               Update RDLOTRD;

               LRCUST  = OICUST;
               Chain ( LRITEM
                     : LRSIZE
                     : LRSOWD
                     : LRCRDY
                     : LRGLOC
                     : LRCLOC
                     : LRCODE
                     : LRCUST ) FDLOTRD;
               If %Found(FDLOTRD);
                 LRQTAL += MoveQty;
                 LRQTOH += MoveQty;
                 Update RDLOTRD;
                Else;
                 LRQTAL  = MoveQty;
                 LRQTOH  = MoveQty;
                 Write RDLOTRD;
               EndIf;

               Chain (999999
                     :0
                     :OIITEM
                     :OISIZE
                     :OISOW
                     :' '
                     :999999) FALITEML;
               If %Found(FALITEML);
                 If AIQTOA < MoveQty;
                   AIQTOA = 0;
                  Else;
                   AIQTOA -= MoveQty;
                 EndIf;
                 AIDTLA = $MDYDate($Date(0));
                 AITIME = $Now();
                 AIUSER = 'FX1160201A';
                 Update RALITEM;

                 AIORD# = OIORD# ;
                 AIOSEQ = OISEQ# ;
                 AIITEM = OIITEM ;
                 AISIZE = OISIZE ;
                 AISOWD = OISOW  ;
                 AIGLOC = ' '    ;
                 AICUST = OICUST ;
                 AIQTOA = MoveQty;
                 Write  RALITEM;

                 OILOT# = 'CustomOrdr';
                 OIPOST = 'Y';
                 OIQTAL = OIQORD;
                 OIDTLA = $MDYDate($Date(0));
                 OITIME = $Now();
                 OIUSER = 'FX1160201A';
                 Update RIORDR;

               EndIf;
             EndIf;
           EndIf;
         EndDo;

         *InLR = *On;

       /End-Free
