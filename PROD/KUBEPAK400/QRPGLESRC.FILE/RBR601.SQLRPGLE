     H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')

     FRBR601FM  CF   E             WORKSTN
     F                                     SFILE(RBR60105S:RRN05)
     FFTRAY     IF   E           K DISK
     FFTRAY_RB  UF A E           K DISK

     FFDLOTRDCLTUF A E           K DISK

     FFDLOTRD_ASUF   E           K DISK    RENAME(RDLOTRD:RDLOTRD_AS)
     FFDLOTRD_AVUF   E           K DISK    RENAME(RDLOTRD:RDLOTRD_AV)
     FFDLOTRD_PLUF   E           K DISK    RENAME(RDLOTRD:RDLOTRD_PL)
     FFDLOTRD_PTUF   E           K DISK    RENAME(RDLOTRD:RDLOTRD_PT)

     FFALITEM_RDUF A E           K DISK

      //  Main procedure prototype & interface
     D RBR601          PR                  ExtPgm('RBR601')
     D RBR601          PI

      *  System Data Structure
     D                SDS
     D $PGM              *PROC

      *  Function Prototypes
     D/COPY QFunctDefn,$_Dates
     D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$Now
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$isPrinter
     D/COPY QFunctDefn,$ErrMsg
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$TimeStamp
     D/COPY QFunctDefn,$RtvMsgD

      *  Field Definitions
     D RRN05           S              4S 0
     D Screen          S              2S 0
     D ReturnCode      S              7A
     D FileCd          S              2A
     DMoveAllocation   S               N
    ? ***********************
    ? ** START HERE        **
    ? ***********************
      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         DoW *InLR <> *On;
           Select;
             When Screen = 01;
               Edit01();
             When Screen = 02;
               Edit02();
             When Screen = 03;
               Edit03();
             When Screen = 04;
               Edit04();
             When Screen = 05;
               Edit05();
             Other;
               $ERR_PROG = $PGM;
               Load01();
               Scrn01();
           ENDSL;
         ENDDO;

         *InLR = *On;

      /End-Free


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 1 SubProcedures                                           :
      // :..................................................................:
     P Load01          B
     D Load01          PI
      /Free
         If PRINTER = *Blanks;
           PRINTER = $dftprt($User():$PGM:'*PGM');
         ENDIF;
         BatchDate6 = $MDYDate($Date(0));
         AUTOBATCH = 'Y';
         AUTOCART  = 'N';
      /End-Free
     P Load01          E
      //_____________________________________________________________________
      //
     P Scrn01          B
     D Scrn01          PI
      /Free
         Screen = 01;
         write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt RBR60101;
         $ClrError();
      /End-Free
     P Scrn01          E
      //_____________________________________________________________________
      //
     P Edit01          B
     D Edit01          PI
      /Free
         Select;
           When *In03;
             *InLR = *On;
           When *In11;
             PRINTER = $ChgPrt($User():'RBR601':PRINTER);
             Scrn01();
           When not $isDate#(BatchDate6:'*MDY');
             $SndError('DATE901':%EditC(BatchDate6:'4'));
             Scrn01();
           When *In06;
             BatchDate6 = $MDYDate($AddDate($DateMDY(BatchDate6):+1));
             Scrn01();
           When *In07;
             BatchDate6 = $MDYDate($AddDate($DateMDY(BatchDate6):-1));
             Scrn01();
           When AUTOBATCH <> 'Y' and AUTOBATCH <> 'N';
             $SndError('YN00001':'Auto Batch');
             Scrn01();
           When AUTOCART  <> 'Y' and AUTOCART  <> 'N';
             $SndError('YN00001':'Auto Cart');
             Scrn01();
           When not $isPrinter(PRINTER);
             $SndError('PRT0102':PRINTER);
             Scrn01();
           Other;
             BatchDate = $DateMDY(BatchDate6);
             Load02();
             Scrn02();
         EndSl;
      /End-Free
     P Edit01          E

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 2 SubProcedures                                           :
      // :..................................................................:
     P Load02          B
     D Load02          PI
      /Free
         BATCH# = *Zero;
      /End-Free
     P Load02          E
      //_____________________________________________________________________
      //
     P Scrn02          B
     D Scrn02          PI
      /Free
         Screen = 02;
         write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt RBR60102;
         $ClrError();
      /End-Free
     P Scrn02          E
      //_____________________________________________________________________
      //
     P Edit02          B
     D Edit02          PI
      /Free
         Select;
           When *In03;
             *InLR = *On;
           When *In06;
             Batch# = NewBatch#(BatchDate);
             Scrn03();
           When *In09;
             RBSBatchReport('Batch');
             Scrn02();
           When *In11;
             PRINTER = $ChgPrt($User():'RBR601':PRINTER);
             Scrn02();
           When *In12;
             PreviousScreen();
           When Batch# = *Zero;
             $SndError('RBR6001':'F6');
             Scrn02();
           When not CheckBatch#($Date7(BatchDate):Batch#);
             $SndError('RBR6002':%EditW(Batch#:'   ') + 'F6 ');
             Scrn02();
           When not $isPrinter(PRINTER);
             $SndError('PRT0102':PRINTER);
             Scrn02();
           Other;
             Load03();
             Scrn03();
         EndSl;
      /End-Free
     P Edit02          E

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 3 SubProcedures                                           :
      // :..................................................................:
     P Load03          B
     D Load03          PI
      /Free
         Cart# = *Zero;
      /End-Free
     P Load03          E
      //_____________________________________________________________________
      //
     P Scrn03          B
     D Scrn03          PI
      /Free
         Screen = 03;
         write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt RBR60103;
         $ClrError();
      /End-Free
     P Scrn03          E
      //_____________________________________________________________________
      //
     P Edit03          B
     D Edit03          PI

      /Free
         Select;
           When *In03;
             *InLR = *On;
           When *In11;
             PRINTER = $ChgPrt($User():'RBR601':PRINTER);
             Scrn03();
           When *In08;
             Cart# = *Zero;
             Load04();
             Scrn04();
           When *In09;
             RBSBatchReport('Batch');
             Scrn03();
           When *In12;
             PreviousScreen();
           When not $isPrinter(PRINTER);
             $SndError('PRT0102':PRINTER);
             Scrn03();
           Other;
             Load04();
             Scrn04();
         EndSl;
      /End-Free
     P Edit03          E

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 4 SubProcedures                                           :
      // :..................................................................:
     P Load04          B
     D Load04          PI
      /Free
         TAG#       = *Zero;
         LastTag#   = *Zero;
       //QtyScan    = *Zero;
         Exec SQL
           Select  Count(*)
           into    :QtyScan
           from    FRBBATCH
           Where   BATCHDATE   = :BatchDate
             and   BATCHNUMBER = :Batch#
             and   CART#       = :Cart#
             and   MSGCODE     < 'RBR6103';
       //QtyExcptns = *Zero;
         Exec SQL
           Select  Count(*)
           into    :QtyExcptns
           from    FRBBATCH
           Where   BATCHDATE   = :BatchDate
             and   BATCHNUMBER = :Batch#
             and   CART#       = :Cart#
             and   MSGCODE     >='RBR6103';
      /End-Free
     P Load04          E
      //_____________________________________________________________________
      //
     P Scrn04          B
     D Scrn04          PI
      /Free
         Screen = 04;
         write ASSUME;
         If QTYEXCPTNS > 0;
           *in51 = *On;
          Else;
           *in51 = *Off;
         EndIf;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt RBR60104;
         $ClrError();
      /End-Free
     P Scrn04          E
      //_____________________________________________________________________
      //
     P Edit04          B
     D Edit04          PI
     D BatchDate7      S               D   DatFmt(*ISO)
      /Free
         Clear RTRAY;
         Select;
           When *In03;
             RBSBatchReport('Cart');
             *InLR = *On;
           When *In06;
             Batch# = NewBatch#(BatchDate);
             Scrn03();
           When *In08;
             RBSBatchReport('Cart');
             Load03();
             Scrn03();
           When *In09;
             RBSBatchReport('Batch');
             Scrn02();
           When *In10 and
             not CheckCart#($Date7(BatchDate):Batch#:Cart#);
             $SndError('RBR6007':'Cart');
             Scrn04();
           When *In10 and
             CheckCart#($Date7(BatchDate):Batch#:Cart#);
             RBSBatchReport('Cart');
             $SndError('RBR6003':'Cart');
             Scrn04();
           When *In11;
             PRINTER = $ChgPrt($User():'RBR601':PRINTER);
             Scrn03();
           When *In12;
             PreviousScreen();
           When not $isPrinter(PRINTER);
             $SndError('PRT0102':PRINTER);
             Scrn04();
           When TAG# = *Zero;
             $SndError('RBR6006':' ');
             TagStatus = *Blanks;
             Scrn04();
           Other;  // Insert Validated Tag Into Batch
             ReturnCode = MovLotInv(Tag#);
             Exec sql
               Insert into FRBBATCH
               values(default, :batchDate, $date7iso(:BatchDate), :Batch#,
                :Cart#, :Tag#, :ReturnCode, USER, default, USER, default);
             QtyScan += 1;
             If ReturnCode >= 'RBR6150';
               QTYEXCPTNS += 1;
              Else;
               If %Found(FTRAY);
                 Write RTRAY_RB;
               EndIf;
             EndIf;
             LastTag# = Tag#;
             Tag# = *Zero;
             TagStatus = $RtvMsgD('*LIBL':'KPMSGF':ReturnCode);
             Scrn04();
         EndSl;
      /End-Free
     P Edit04          E


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 5 SubProcedures                                           :
      // :..................................................................:
     P Load05          B
     D Load05          PI
      /Free
         RRN05 = 1;
         TRAYCOUNT = *Zero;
         Write RBR60105S;
      /End-Free
     P Load05          E
      //_____________________________________________________________________
      //
     P Scrn05          B
     D Scrn05          PI
      /Free
         Screen = 05;
         write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt RBR60105;
         $ClrError();
      /End-Free
     P Scrn05          E
      //_____________________________________________________________________
      //
     P Edit05          B
     D Edit05          PI

      /Free
         ReadC RBR60105S;
         Select;
           When *In03;
             *InLR = *On;
           When *In11;
             PRINTER = $ChgPrt($User():'RBR601':PRINTER);
             Scrn03();
           When *In12;
             PreviousScreen();
           When not $isPrinter(PRINTER);
             $SndError('PRT0102':PRINTER);
             Scrn05();
           When not CheckCart#($Date7(BatchDate):Batch#:Cart#);
             $SndError('RBR6004':'F8');
             Scrn05();
           Other;
             Load05();
             Scrn05();
         EndSl;
      /End-Free
     P Edit05          E


      //_____________________________________________________________________
      //
     P CheckBatch#     B
     D CheckBatch#     PI              N
     D  #BatchDate7                   7S 0 Const
     D  #Batch                        3S 0 Const
     D  #BCount        S             15S 5
      /Free
          exec sql
            Select  Count(*)
            into    :#BCount
            from    FRBBATCH
            Where   BATCHDATE   = :batchDate
              and   BATCHNUMBER = :#Batch   ;
         If #BCount > *Zero;
           Return *On;
          Else;
           Return *Off;
         EndIf;
      /End-Free
     P CheckBatch#     E
      //_____________________________________________________________________
      //
     P CheckCart#      B
     D CheckCart#      PI              N
     D  #BatchDate7                   7S 0 Const
     D  #Batch                        3S 0 Const
     D  #Cart                         5S 0 Const
     D  #CCount        S             15S 5
      /Free
          exec sql
            Select  Count(*)
            into    :#CCount
            from    FRBBATCH
            Where   BATCHDATE   = :batchDate
              and   BATCHNUMBER = :#Batch
              and   CART#       = :#Cart;
         If #CCount > *Zero;
           Return *On;
          Else;
           Return *Off;
         EndIf;
      /End-Free
     P CheckCart#      E
      //_____________________________________________________________________
      //
     P PreviousScreen  B
     D PreviousScreen  PI
      /Free
         Select;
           When Screen = 02;
             Scrn01();
           When Screen = 03;
             Scrn02();
           When Screen = 04;
             Scrn03();
           When Screen = 05;
             Scrn04();
           When Screen = 06;
             Scrn05();
           Other;
             Scrn01();
         ENDSL;
      /End-Free
     P PreviousScreen  E
      //_____________________________________________________________________
      //
     P RBSBatchReport  B
     D RBSBatchReport  PI
     D  #Type                         5A   Const
     D BatchReport     PR                  ExtPgm('RBR602')
     D  SelectedDate                   D   Const
     D  SelectedBatch                 3S 0 Const
     D  SelectedCart                  5S 0 Const
     D  SelPrinter                   10A   Const
      /Free

         If #Type = 'Batch';
           Cart# = 0;
         EndIf;

         BatchReport(BatchDate:BATCH#:CART#:Printer);

         $SndError('RBR6003':#Type);

      /End-Free
     P RBSBatchReport  E
      //_____________________________________________________________________
      //
     P AlreadyScanned  B
     D AlreadyScanned  PI              N
     D  #Tag#                         7S 0 Const
     D  #SCount        S             15S 5
     D  #Logical       S               N
      /Free
         #Logical = *Off;

         //exec sql
         //  Select '1'
         //  into :#Logical
         //  from FRBBATCH
         //  Where TAG#     = :#Tag#
         //    and MSGCODE < 'RBR6150'
         //  Fetch First Row Only;

         exec sql
           Select '1'
           into :#Logical
           from FTRAY_RB
           Where TRTAG#   = :#Tag#
           Fetch First Row Only;

         Return #Logical;

      /End-Free
     P AlreadyScanned  E
      //_____________________________________________________________________
      //
     P isActiveTag#    B
     D isActiveTag#    PI              N
     D  #Tag#                         8S 0 Const
     D  #Logical       S               N
      /Free
         exec sql
           Select '1'
           into :#Logical
           from FTRAY
           Where TRTAG# = :#Tag#
             and TRSTAT in ('A', 'P')
           Fetch First Row Only;

         Return #Logical;
      /End-Free
     P isActiveTag#    E
      //_____________________________________________________________________
      //
     P NewBatch#       B
     D NewBatch#       PI             3S 0
     D  #BatchDate                     D   Const
     D  #NewBatch      S              3S 0
      /Free
          exec sql
            Select  Max(BATCHNUMBER)
            into    :#NewBatch
            from    FRBBATCH
            Where   BATCHDATE = :BATCHDATE;
           Return #NewBatch + 1;
      /End-Free
     P NewBatch#       E
      //_____________________________________________________________________
      //
     P MovLotInv       B
     D MovLotInv       PI             7A
     D KTAG#                          8  0
     D RetCode         S              7A
      /FREE
       // Pecking Order when finding lots to pull from
       //                              Full         Partial
       //   Allocated 'S' Records   FDLOTRD_AS    FDLOTRD_PL
       //   Available 'S' Records   FDLOTRD_AV    FDLOTRD_PT
       //   Available 'N' Records   FDLOTRD_AV    FDLOTRD_PT
       //   Available ' ' Records   FDLOTRD_AV    FDLOTRD_PT

       //   Write out to FDLOTRDCLT: ITEM SIZE WHSE SOWD CRDY CUST GLOC

       // MsgID  Sev Message Text
       //   RBR6100  0 Tag successfully added to Ready Bay inventory. - FULL
       //   RBR6101  0 Tag successfully added to Ready Bay inventory. - PART
       //   RBR6102 10 Tag Added from un(S)elected inventory - FULL TRAY
       //   RBR6103 10 Tag Added from un(S)elected inventory - PARTIAL TRAY
       //   RBR6150 30 Not Added to Ready Bay because no available inventoy

         MoveAllocation = *Off;

         Chain (KTag#) FTRAY;

         If not isActiveTag#(Tag#);
           Return 'RBR6151';
         Endif;

         If AlreadyScanned(TAG#);
           Return 'RBR6152';
         Endif;

         If %Found(FTRAY);
           Select;
           When TRSTAT = 'A';
             RetCode = 'RBR6100';
             FileCd  = 'AS';
             Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM:'S  ') FDLOTRD_AS;  //Allocated 'S'
             If not %Found(FDLOTRD_AS);
               FileCd  = 'AV';
               Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM:'S  ') FDLOTRD_AV;  //Available 'S'
               If not %Found(FDLOTRD_AV);
                 Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM:'N  ') FDLOTRD_AV;  //Available 'N'
                 If not %Found(FDLOTRD_AV);
                   Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM:'   ') FDLOTRD_AV;  //Available ' '
                   If not %Found(FDLOTRD_AV);
                     Return 'RBR6150';
                    Else;
                     RetCode = 'RBR6102';
                   ENDIF;
                 ENDIF;
               ENDIF;
             ENDIF;
           When TRSTAT = 'P';
             RetCode = 'RBR6101';
             FileCd  = 'PL';
             Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM:'S  ') FDLOTRD_PL;  //(P)artial-A(l)located 'S'
             If not %Found(FDLOTRD_PL);
               FileCd  = 'PT';
               Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM:'S  ') FDLOTRD_PT;  //Available 'S'
               If not %Found(FDLOTRD_PT);
                 Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM:'N  ') FDLOTRD_PT;  //Available 'N'
                 If not %Found(FDLOTRD_PT);
                   Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM:'   ') FDLOTRD_PT;  //Available ' '
                   If not %Found(FDLOTRD_PT);
                     Return 'RBR6150';
                    Else;
                     RetCode = 'RBR6103';
                   ENDIF;
                 ENDIF;
               ENDIF;
             ENDIF;
           OTHER;
             Return 'RBR6150';
           ENDSL;
         // We have found the LOT we are going to move to the RB
           LRQTOH -= 1;
           If LRGLOC = 'S' and LRQTAL > 0;
             LRQTAL -= 1;
             MoveAllocation = *On;
            Else;
             LRQTAV -= 1;
           EndIf;
           If FileCd = 'AS';
             Update RDLOTRD_AS;
            Else;
             If FileCd = 'AV';
               Update RDLOTRD_AV;
              Else;
               If FileCd = 'PL';
                 Update RDLOTRD_PL;
                Else;
                 If FileCd = 'PT';
                   Update RDLOTRD_PT;
                  Else;
               //  We screwed something up if we get here...
                 EndIf;
               EndIf;
             EndIf;
           EndIf;
         // If the Lot Inventory is Allocated Move Location in FALITEM
           If FileCd = 'AS' or FileCd = 'PL';
             Chain (LRITEM:LRSIZE:LRCRDY:LRSOWD:LRGLOC:LRCUST) FALITEM_RD;
             If %Found(FALITEM_RD);
               AIQTOA -= 1;
               Update RALITEM;
               AIGLOC = 'R';
               Chain (AIITEM:AISIZE:AICRDY:AISOWD:AIGLOC:AICUST) FALITEM_RD;
               If %Found(FALITEM_RD);
                 AIQTOA += 1;
                 Update RALITEM;
                Else;
                 AIQTOA  = 1;
                 Write RALITEM;
               EndIf;
             EndIf;
           EndIf;
         // Now write/update the Ready Bay Lot Inventory
           LRCLOC = 'R  ';
           LRGLOC = 'R  ';
           Chain (LRITEM:LRSIZE:LRWHSE:LRSOWD:LRCRDY:LRCUST:LRGLOC) FDLOTRDCLT;
           LRDTLA = $MDYDate($Date(0));
           LRTIME = $Now();
           LRUSER = $User();
           LRUSER = $PGM;
           If %Found(FDLOTRDCLT);
             LRQTOH += 1;
             If MoveAllocation;
               LRQTAL += 1;
              Else;
               LRQTAV += 1;
             EndIf;
             Update RDLOTRD;
            Else;
             LRQTOH  = 1;
             If MoveAllocation;
               LRQTAV  = 0;
               LRQTAL = 1;
              Else;
               LRQTAV  = 1;
               LRQTAL = 0;
             EndIf;
             Write RDLOTRD;
           ENDIF;
           Return RetCode;
         ENDIF;
         Return 'RBR6150';

      /END-FREE
     P MovLotInv       E

      //_____________________________________________________________________
      //
     P/COPY QFunctDefn,$ErrMsgSP
