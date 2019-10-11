      /COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
?     // ?:````````````````````````````````````````````````````````````:?
?     // ?:         Lot Transaction - Not Available   - "N"            :?
?     // ?:............................................................:?
?     //  :````````````````````````````````````````````````````````````:
?     //  : Created:  Sep. 2012            ? Kube-Pak Corporation ?    :
?     //  :      by:  William J. Behr                                  :
?     //  :............................................................:
?     //  :````````````````````````````````````````````````````````````:
?     //  :   Program Description                                      :
?     //  : ```````````````````````                                    :
?     //  :                                                            :
?     //  :............................................................:

       //                                               | 990   990  990 | N990  N990  N990 |FALIT
       //                                               |  OH    AL   AV |  OH    AL    AV  |  AL
       //-----------------------------------------------+----------------+------------------+-----
       //Check for Specific 990 Record Availability     | +Qty NoChg +Qty| -Qty  -Qty  Clcd | -Qty
       //Check for Other 990 Record(s) Availability     | +Qty NoChg +Qty| -Qty  -Qty  Clcd | -Qty
       //Check for Other Customer Record(s) (Start@Zero)| +Qty NoChg +Qty| -Qty  -Qty  Clcd | -Qty
       //-----------------------------------------------+----------------+------------------+-----


      // FALITEM
     FJALITEM990IF   E           K DISK    Prefix(J990_)
     FJALITEM   IF   E           K DISK
      // FDLOTRD
     FFDLOTRD_S UF A E           K DISK    Prefix(S_)
      // FIORDR
     FFIORDR    UF A E           K DISK

      //? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$_OE

      //? Program Prototype
     D LOT_TRN_N       PR                  ExtPgm('LOT_TRN_N')                  Prototype
     D Dim_ORDER                      6  0                                      Order Number
     D Dim_SEQ#                       3  0                                      Order Seq# to Start
     D Dim_990Item                   12                                         990 Item Number
     D Dim_990Size                    3                                         990 Size Code
     D Dim_990CRDY                    7  0                                      990 Current Ready
     D Dim_990SOWD                    7  0                                      990 Sow Date
     D Dim_990SHPD                    7  0                                      990 Ship Date
     D Dim_QTY                        6  0                                      Quantity
     D Dim_COMMENT                     N                                        Include Comment
      //? Program Interface
     D LOT_TRN_N       PI                                                       Procedure Interface
     D KORDER#                        6  0                                      Order Number
     D KSEQ#                          3  0                                      Order Seq# to Start
     D K990Item                      12                                         990 Item Number
     D K990Size                       3                                         990 Size Code
     D K990CRDY                       7  0                                      990 Current Ready
     D K990SOWD                       7  0                                      990 Sow Date
     D K990SHPD                       7  0                                      990 Ship Date
     D Quantity                       6  0                                      Quantity
     D IncComment                      N                                        Include Comment

      //? Field Definitions
     D ThisComment     S                   Like(OIDES1)                         ?N/A Comment Line
     D OrigOIQORD      S                   Like(OIQORD)                         ?Original Order Qty

     D Left2Remove     S              6  0                                       Quantity
     D RemoveThisTime  S              6  0                                       Quantity
     D LotsUpdated     S               N   Inz(*Off)

     D Work_LRDTLA     S                   Like(LRDTLA)
     D Work_LRTIME     S                   Like(LRTIME)
     D Work_LRUSER     S                   Like(LRUSER)

     D SaveOIORD#      S                   Like(OIORD#)                         ?Save OIORD#
     D SaveOIALPH      S                   Like(OIALPH)                         ?Save OIALPH
     D SaveOIDTRQ      S                   Like(OIDTRQ)                         ?Save OIDTRQ
     D SaveOIITEM      S                   Like(OIITEM)                         ?Save OIITEM
     D SaveOIITMA      S                   Like(OIITMA)                         ?Save OIITMA
     D SaveOIRVCD      S                   Like(OIRVCD)                         ?Save OIRVCD
     D SaveOIRVDT      S                   Like(OIRVDT)                         ?Save OIRVDT
     D SaveOISIZE      S                   Like(OISIZE)                         ?Save OISIZE
     D SaveOISTOP      S                   Like(OISTOP)                         ?Save OISTOP
     D SaveOISHPC      S                   Like(OISHPC)                         ?Save OISHPC
     D SaveOICUST      S                   Like(OICUST)                         ?Save OICUST
     D SaveSeq#        S                   Like(OISEQ#)                         ?Save Seq#
     D SaveText        S             15A                                        ?Save Text

     D INSERTLINE      C                   CONST('BIR104')

      /FREE

       Left2Remove = Quantity;
       ExSr Specific990;
       ExSr FindAny990;
       ExSr Positive990;


         //?  Deduct On Order Qty by Quantity on FIORDR record
         Chain (Korder#:KSeq#) FIORDR;
         OrigOIQORD = OIQORD;
         OIQORD = OIQORD - Quantity;
         OIQTAL = OIQTAL - Quantity;
         OIQBOO = OIQBOO - Quantity;
         If OIQBOO < 0;
           OIQBOO = *Zero;
         EndIf;
         OIEXT$ = OIQORD * OIUPRI;
         OIUSER = $User();
         OIUSER = 'LOT_TRN_N4';
         OIDTLA = $MDYDate($Date(0));
         OITIME = $Now();
         If %Found(FIORDR);
           Update RIORDR;

           //?  Insert a blank line in FIORDR after Given Order#/Seq#
           $InsOrdLin(OIORD#:OISEQ#+1:2);

           //?  Create a comment line in FIORDR on the new blank line
           If IncComment <> '0';
             ExSr CrtComment;
           ENDIF;
         EndIf;

       *InLR = *On;


       //?  ...........................................................
       //?  :      Specific990 - Search for specific 990              :
       //?  :.........................................................:
       BegSr Specific990;
       // Check for a 990 record passed in to the "N" transaction
       // This 990 must match Parameters and Have -OH

       Chain (KOrder#:
              KSeq#:
              K990Item:
              K990Size:
              K990SowD:
              K990CRdy) JALITEM990;
       If %Found(JALITEM990) and J990_LRQTOH < 0 ;
         If J990_AIQTOA < %Abs(J990_LRQTOH);
           RemoveThisTime = J990_AIQTOA;
         Else;
           RemoveThisTime = %Abs(J990_LRQTOH);
         ENDIF;
         If RemoveThisTime > Left2Remove;
           RemoveThisTime = Left2Remove;
         ENDIF;
         Left2Remove -= RemoveThisTime;

         Work_LRDTLA  = $MDYDate($Date(0));
         Work_LRTIME  = $Now();
         Work_LRUSER  = 'LOT_TRN_N1';

         Exec SQL
           Update FDLOTRD
              Set LRQTOH =  LRQTOH + :RemoveThisTime
                , LRQTAV =  LRQTAV + :RemoveThisTime
                , LRDTLA = :Work_LRDTLA
                , LRTIME = :Work_LRTIME
                , LRUSER = :Work_LRUSER
            Where LRCUST = :J990_LRCUST
              and LRITEM = :J990_LRITEM
              and LRSIZE = :J990_LRSIZE
              and LRSOWD = :J990_LRSOWD
              and LRGLOC = :J990_LRGLOC
              and LRCRDY = :J990_LRCRDY;

         Exec SQL
           Update FDLOTRD
              Set LRQTOH =  LRQTOH - :RemoveThisTime
                , LRQTAL =  LRQTAL - :RemoveThisTime
                , LRDTLA = :Work_LRDTLA
                , LRTIME = :Work_LRTIME
                , LRUSER = :Work_LRUSER
            Where LRCUST = :J990_AICUST
              and LRITEM = :J990_AIITEM
              and LRSIZE = :J990_AISIZE
              and LRSOWD = :J990_AISOWD
              and LRGLOC = :J990_AIGLOC
              and LRCRDY = :J990_AICRDY;

         Exec SQL
           Update FALITEM
              Set AIQTOA =  AIQTOA - :RemoveThisTime
                , AIDTLA = :Work_LRDTLA
                , AITIME = :Work_LRTIME
                , AIUSER = :Work_LRUSER
            Where AIORD# = :J990_AIORD#
              and AIOSEQ = :J990_AIOSEQ
              and AICUST = :J990_AICUST
              and AIITEM = :J990_AIITEM
              and AISIZE = :J990_AISIZE
              and AISOWD = :J990_AISOWD
              and AIGLOC = :J990_AIGLOC
              and AICRDY = :J990_AICRDY;

         Exec SQL
           Update FDLOT
              Set LDQTAL =  LDQTAL - :RemoveThisTime
                , LDQTAV =  LDQTAV + :RemoveThisTime
                , LDDTLA = :Work_LRDTLA
                , LDTIME = :Work_LRTIME
                , LDUSER = :Work_LRUSER
            Where LDITEM = :J990_AIITEM
              and LDSIZE = :J990_AISIZE
              and LDSOWD = :J990_AISOWD
              and LDCRDY = :J990_AICRDY;

         LotsUpdated = *On;

       ENDIF;

       EndSr;




       //?  ...........................................................
       //?  :      FindAny990 - Search for Any 990                    :
       //?  :.........................................................:
       BegSr FindAny990;
       // Check for additional 990 records to get rid of first

       SetLL (KOrder#: KSeq#) JALITEM990;
       ReadE (KOrder#: KSeq#) JALITEM990;
       DoW not %EOF(JALITEM990) and Left2Remove > *Zero;
         If J990_LRQTOH < 0 and J990_AIQTOA > *Zero;
           If J990_AIQTOA < %Abs(J990_LRQTOH);
             RemoveThisTime = J990_AIQTOA;
           Else;
             RemoveThisTime = %Abs(J990_LRQTOH);
           ENDIF;

           If RemoveThisTime > Left2Remove;
             RemoveThisTime = Left2Remove;
           ENDIF;

           Left2Remove -= RemoveThisTime;

         Work_LRDTLA  = $MDYDate($Date(0));
         Work_LRTIME  = $Now();
         Work_LRUSER  = 'LOT_TRN_N2';

         Exec SQL
           Update FDLOTRD
              Set LRQTOH =  LRQTOH + :RemoveThisTime
                , LRQTAV =  LRQTAV + :RemoveThisTime
                , LRDTLA = :Work_LRDTLA
                , LRTIME = :Work_LRTIME
                , LRUSER = :Work_LRUSER
            Where LRCUST = :J990_LRCUST
              and LRITEM = :J990_LRITEM
              and LRSIZE = :J990_LRSIZE
              and LRSOWD = :J990_LRSOWD
              and LRGLOC = :J990_LRGLOC
              and LRCRDY = :J990_LRCRDY;

         Exec SQL
           Update FDLOTRD
              Set LRQTOH =  LRQTOH - :RemoveThisTime
                , LRQTAL =  LRQTAL - :RemoveThisTime
                , LRDTLA = :Work_LRDTLA
                , LRTIME = :Work_LRTIME
                , LRUSER = :Work_LRUSER
            Where LRCUST = :J990_AICUST
              and LRITEM = :J990_AIITEM
              and LRSIZE = :J990_AISIZE
              and LRSOWD = :J990_AISOWD
              and LRGLOC = :J990_AIGLOC
              and LRCRDY = :J990_AICRDY;

         Exec SQL
           Update FALITEM
              Set AIQTOA =  AIQTOA - :RemoveThisTime
                , AIDTLA = :Work_LRDTLA
                , AITIME = :Work_LRTIME
                , AIUSER = :Work_LRUSER
            Where AIORD# = :J990_AIORD#
              and AIOSEQ = :J990_AIOSEQ
              and AICUST = :J990_AICUST
              and AIITEM = :J990_AIITEM
              and AISIZE = :J990_AISIZE
              and AISOWD = :J990_AISOWD
              and AIGLOC = :J990_AIGLOC
              and AICRDY = :J990_AICRDY;

         Exec SQL
           Update FDLOT
              Set LDQTAL =  LDQTAL - :RemoveThisTime
                , LDQTAV =  LDQTAV + :RemoveThisTime
                , LDDTLA = :Work_LRDTLA
                , LDTIME = :Work_LRTIME
                , LDUSER = :Work_LRUSER
            Where LDITEM = :J990_AIITEM
              and LDSIZE = :J990_AISIZE
              and LDSOWD = :J990_AISOWD
              and LDCRDY = :J990_AICRDY;

         LotsUpdated = *On;

         ENDIF;
       ReadE (KOrder#: KSeq#) JALITEM990;
       EndDo;

       EndSr;



       //?  ...........................................................
       //?  :      Positive990 - Add to 990                           :
       //?  :.........................................................:
       BegSr Positive990;
       // At this point we have removed allocations for all losses documented with 990 records
       // ...and we still have a quantity left 2 remove.
       // Next we need to get rid of more allocations from FALITEM/FDLOTRD customer records

         SetLL (KOrder#: KSeq#: 000000) JALITEM;
         ReadE (KOrder#: KSeq#) JALITEM;
         DoW not %EOF(JALITEM) and Left2Remove > *Zero;
           If LRQTOH > *Zero and AIQTOA > *Zero;
             If AIQTOA < %Abs(LRQTOH);
             RemoveThisTime = AIQTOA;
            Else;
             RemoveThisTime = LRQTOH;
             ENDIF;
           If RemoveThisTime > Left2Remove;
             RemoveThisTime = Left2Remove;
           ENDIF;
             Left2Remove -= RemoveThisTime;

             Work_LRDTLA  = $MDYDate($Date(0));
             Work_LRTIME  = $Now();
           Work_LRUSER  = 'LOT_TRN_N3';

           Exec SQL
             Update FDLOTRD
                Set LRQTOH =  LRQTOH - :RemoveThisTime
                  , LRQTAL =  LRQTAL - :RemoveThisTime
                  , LRDTLA = :Work_LRDTLA
                  , LRTIME = :Work_LRTIME
                  , LRUSER = :Work_LRUSER
              Where LRCUST = :AICUST
                and LRITEM = :AIITEM
                and LRSIZE = :AISIZE
                and LRSOWD = :AISOWD
                and LRGLOC = :AIGLOC
                and LRCRDY = :AICRDY;

           Exec SQL
             Update FALITEM
                Set AIQTOA =  AIQTOA - :RemoveThisTime
                  , AIDTLA = :Work_LRDTLA
                  , AITIME = :Work_LRTIME
                  , AIUSER = :Work_LRUSER
              Where AIORD# = :AIORD#
                and AIOSEQ = :AIOSEQ
                and AICUST = :AICUST
                and AIITEM = :AIITEM
                and AISIZE = :AISIZE
                and AISOWD = :AISOWD
                and AIGLOC = :AIGLOC
                and AICRDY = :AICRDY;

           Exec SQL
             Update FDLOT
                Set LDQTAL =  LDQTAL - :RemoveThisTime
                  , LDQTAV =  LDQTAV + :RemoveThisTime
                  , LDDTLA = :Work_LRDTLA
                  , LDTIME = :Work_LRTIME
                  , LDUSER = :Work_LRUSER
              Where LDITEM = :AIITEM
                and LDSIZE = :AISIZE
                and LDSOWD = :AISOWD
                and LDCRDY = :AICRDY;

             LotsUpdated = *On;

           //?  Add Same Quantity to OH & AV on the LotRD record for Cust # 999990
             Clear RDLOTRD;
             Chain ( LRITEM       :
                   LRSIZE       :
                   LRCRDY       :
                   LRSOWD       :
                   'N  '        :
                   000000       )  FDLOTRD_S;
             S_LRQTOH += RemoveThisTime;
             S_LRQTAV += RemoveThisTime;
             S_LRUSER = 'LOT_TRN_Nn';
             S_LRDTLA = $MDYDate($Date(0));
             S_LRTIME = $Now();
             If %Found(FDLOTRD_S);
               Update RDLOTRD;
             Else;
               S_LRSTAT = LRSTAT    ;
               S_LRITEM = LRITEM    ;
               S_LRSIZE = LRSIZE    ;
               S_LRWHSE = LRWHSE    ;
               S_LRSOWD = LRSOWD    ;
               S_LRGLOC = 'N  '     ;
               S_LRPHYT = LRPHYT    ;
               S_LRCRDY = LRCRDY    ;
               S_LRCPHY = LRCPHY    ;
               S_LRCLOC = '   '     ;
               S_LRCODE = LRCODE    ;
               If LRCUST = 999997   ;
                 S_LRCUST = 999997  ;
                Else;
                 S_LRCUST = 000000  ;
               Endif;
               S_LRAREA = LRAREA    ;
               S_LRCOMP = LRCOMP    ;
               S_LRALPH = LRALPH    ;
               S_LRPRCL = LRPRCL    ;
               S_LRDESC = LRDESC    ;
               S_LRQTCM = LRQTCM    ;
               S_LRQTSL = LRQTSL    ;
               S_LRQADJ = LRQADJ    ;
               Write RDLOTRD;
             EndIf;
           ENDIF;
         ReadE (KOrder#: KSeq#) JALITEM;
         EndDo;

       EndSr;


       //?  ...........................................................
       //?  :      CrtComment - Create the Comment Line               :
       //?  :.........................................................:
       BegSr CrtComment;

       Select;
         When IncComment = '1';
           ThisComment = 'Poor Germ:';
         When IncComment = '2';
           ThisComment = 'Seed N/A:';
         When IncComment = '3';
           ThisComment = 'Cutting N/A: ';
         When IncComment = '4';
           ThisComment = 'N/A Subbed:';
         Other;
           ThisComment = 'Item N/A:';
       ENDSL;
       ThisComment = %trim(ThisComment) + ' ('
       + %Char(OrigOIQORD-OIQORD) + ' of '
       + %Char(OrigOIQORD) + ') N/A';

       Exec SQL  //  Write B2B Comment record
         INSERT INTO FIORDRB2BC
         VALUES(:OIORD#,:OISEQ#,:ThisComment,current timestamp, current user);

       SaveSeq# = OISEQ# + 2;
       SaveOIORD# = OIORD#;
       SaveOIITEM = OIITEM;
       SaveOISIZE = OISIZE;
       SaveOIRVCD = OIRVCD;
       SaveOIDTRQ = OIDTRQ;
       SaveOIRVDT = OIRVDT;
       SaveOIALPH = OIALPH;
       SaveOIITMA = OIITMA;
       SaveOISTOP = OISTOP;
       SaveOISHPC = OISHPC;
       SaveOICUST = OICUST;
       SaveText = OIPLPT
                + OITXCD
                + OITXST
                + OITXCT
                + OITXLC
                + OIROUT
                + ' '
                + OICWT
                + OIPPDC
                + OIPHYT
                + OISCHM
                + OISCHS
                + OIFRQD ;
       Clear RIORDR;
       OIITEM = SaveOIITEM;
       OISIZE = SaveOISIZE;
       OIITMA = SaveOIITMA;
       OISTAT = 'A';
       OIORD# = SaveOIORD#;
       OISEQ# = SaveSeq#;
       OICOMP = 1;
       OISHPC = SaveOISHPC;
       OISHCD = 'N';
       OIOVER = '5';
       OIBOCD = 'Y';
       OISLM1 = '01';
       OICUST = LRCUST;
       OICUST = SaveOICUST;
       OIDTRQ = SaveOIDTRQ;
       OIDTLA = $MDYDate($Date(0));
       OITIME = $Now();
       OIUSER = $User();
       OIITYP = 'C';
       OIPLPT = %SubSt(SaveText:01:1);
       OITXCD = %SubSt(SaveText:02:1);
       OITXST = %SubSt(SaveText:03:1);
       OITXCT = %SubSt(SaveText:04:1);
       OITXLC = %SubSt(SaveText:05:1);
       OIROUT = %SubSt(SaveText:06:1);
       OISTOP = SaveOISTOP;
       OICWT  = %SubSt(SaveText:08:1);
       OIMUL2 = 1;
       OILOTC = 'N';
       OISTA  = 'N';
       OIPPDC = %SubSt(SaveText:09:1);
       OIPHYT = %SubSt(SaveText:10:1);
       OISCHM = %SubSt(SaveText:11:1);
       OISCHS = %SubSt(SaveText:12:1);
       OIRVCD = SaveOIRVCD;
       OIRVDT = SaveOIRVDT;
       OIFRQD = %SubSt(SaveText:13:1);
       OIALPH = SaveOIALPH;
       OIDES1 = ThisComment;
       Write RIORDR;

       EndSr;
