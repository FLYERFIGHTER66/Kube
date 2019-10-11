     H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')

      //?                                                              ?
      //??|                                                            |?
      //??|       Finished Crop Inventory                              |?
      //?|                                                            |?

      //?PROGRAM NAME-------- FRC010
      //?PROGRAMMER---------- WJB
      //?APPLICATION--------- SCAN GREENHOUSE FINISHED CROP FOR INVENTORY

      //?           CHANGE--DATE-------DESCRIPTION
      //?  1/25/16  WJB  Initial Programming

     FFRC010FM  CF   E             WORKSTN
     FXATABE1   IF   E           K DISK

      //? CONTROL FILE ARRAYS

     d pIndicators     s               *   Inz(%Addr(*In))
     d indicatorNames  ds                  Based(pIndicators)
     d  Using_PPD                      N   Overlay(indicatorNames: 10)

     d RMUPC         E ds                  ExtName(FMUPC)

      //? Ready Color Code
     D RCCDDS          DS                  INZ
     D  RCCD01
     D  RCCD02
     D  RCCD03
     D  RCCD04
     D  RCCD05
     D  RCCD06
     D  RCCD07
     D  RCCD08
     D  RCCD09
     D  RCCD10
     D  RCCD11
     D  RCCD12
     D* RCCD13
     D* RCCD14
     D* RCCD15
     D* RCCD16
     D* RCCD17
     D* RCCD18
     D* RCCD19
     D* RCCD20
     D* RCCD21
     D* RCCD22
     D* RCCD23
     D* RCCD24
     D* RCCD00                        2A   DIM(24) OVERLAY(RCCDDS)
     D  RCCD00                        5A   DIM(12) OVERLAY(RCCDDS)
     D                 DS
     D  CSRFLD                 1     10
     D  CSRFL#                 4      5  0

     D                SDS
     D  PROGID                 1     10                                         PROGRAM NAME
     D  RLIBR                 81     90                                         RUN LIBRARY
     D  @JOB                 244    253
     D  USERID               254    263                                         USER I.D.
     D  SLIBR                314    323                                         SOURCE LIBRARY

      //? Field Definitions
     D  Screen         S              2S 0
     D  RCCD           S              2S 0
     D  NoSX           S              2S 0
     D  User           S             10A
     D  Today          S              6S 0
     D  Now            S              6S 0
     D  CLWKTR         S              3S 0
     D  STRDAT         S              7S 0
     D  x              S              3S 0

      //? Copy Books
     D/COPY QFunctDefn,$ErrMsg

      //? Function Prototypes
     D/COPY QFunctDefn,$_Dates
     D/COPY QFunctDefn,$Monday
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$Now
     D/COPY QFunctDefn,$TimeStamp

      /FREE
       DoW *InLR <> *On;
         Select;
         When Screen = 01;
           ExSr Edit01;
         When Screen = 02;
           ExSr Edit02;
         When Screen = 03;
           ExSr Edit03;
         Other;
           Today = $MDYDate($Date(0));
           User  = $User();
           $ERR_PROG  = 'FRC010    ';                                           //?Pgm Msg Queue
           $ERR_MSGF  = 'KPMSGF';                                               //?Message File
           $ERR_LIBR  = '*LIBL';                                                //?Library
           ScanDT  = $MDYDate($Date(0));
           ExSr $ClrError;
           ExSr InzS03;
           ExSr Load01;
           ExSr Scrn01;
         EndSL;
       EndDo;

       Return;


       //?  ...........................................................
       //?  :      Load01 - Load Screen 01                            :
       //?  :.........................................................:
       BegSr Load01;

         *IN50 = *OFF;

       EndSr;

       //?  ...........................................................
       //?  :      Load02 - Load Screen 02                            :
       //?  :.........................................................:
       BegSr Load02;

         Clear UPC;

       EndSr;

       //?  ...........................................................
       //?  :      Load03 - Load Screen 03                            :
       //?  :.........................................................:
       BegSr Load03;

         Clear RCCODE;

       EndSr;
       //?  ...........................................................
       //?  :      InzS03 - Init Screen 03                            :
       //?  :.........................................................:
       BegSr InzS03;

         Clear RCCD00;
         Clear RCCODE;
         x = 0;
         SetLL 'RC' XATABE1;
         ReadE 'RC' XATABE1;
         DoW not %EOF(XATABE1) and x+1 < %Elem(RCCD00);
           x += 1;
           RCCD00(x) = %SubSt(TBC6:1:5);
           ReadE 'RC' XATABE1;
         EndDo;

       EndSr;

       //?  ...........................................................
       //?  :      Scrn01 - Display Screen 01                         :
       //?  :.........................................................:
       BegSr Scrn01;
         Screen = 01;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FRC01001;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn02 - Display Screen 02                         :
       //?  :.........................................................:
       BegSr Scrn02;
         Screen = 02;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FRC01002;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Scrn03 - Display Screen 03                         :
       //?  :.........................................................:
       BegSr Scrn03;
         Screen = 03;
         Write ASSUME;
         Write MSGCTL;
         ExFmt FRC01003;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Edit01 - Edit Screen 01                            :
       //?  :.........................................................:
       BegSr Edit01;                                                          //?Enter Date

         Select;
         When *InKB or *InKF;
           ExSr Load01;
           ExSr Scrn01;
         When *InKC;
           *InLR = *On;
           Return;
         When ScanDT  = *Zeros;                                               //?No Date Entered
           $ERR_MsgID = 'DATE902';
           $ERR_MsgData = 'Scan';
           ScanDT = $MDYDate($Date(0));
           ExSr $SndError;
           ExSr Scrn01;
         When not $isDate#(ScanDT:'*MDY');
           $ERR_MsgID = 'DATE901';
           $ERR_MsgData = %Char(ScanDT);
           ExSr $SndError;
           ExSr Scrn01;
         Other;
           ExSr Load02;
           ExSr Scrn02;
         EndSl;

       EndSr;

       //?  ...........................................................
       //?  :      Edit02 - Edit Screen 02                            :
       //?  :.........................................................:
       BegSr Edit02;                                                          //?Check UPC

         If UPC <> 0;
           Exec SQL  // Get UPC Information from UPC
             Select * into :RMUPC from FMUPC
             where UPCCODE = :UPC and UPCSTAT = 'A';
          Else;
           Exec SQL  // Get UPC Information from Item /  Size
             Select * into :RMUPC from FMUPC
             where UPCITEM = :ITEM and UPCSIZE = :SIZE and UPCSTAT = 'A';
         EndIf;

         Select;

         When *InKB;
           ExSr Scrn01;

         When *InKC;
           *InLR = *On;

         When UPC = *Zero and (ITEM = ' ' or SIZE = ' ');
           $ERR_MsgID = 'FRC0101';
           ExSr $SndError;
           ExSr Scrn02;

         When SQLState <> '00000' and UPC <> 0;
           $ERR_MsgID = 'UPC0001';
           $ERR_MsgData = %Editw(UPC:' -     -     - ');
           ExSr $SndError;
           ExSr Scrn02;

         When SQLState <> '00000' and UPC = 0;
           $ERR_MsgID = 'ITM0001';
           $ERR_MsgData = %Trim(ITEM) + '-' +%Trim(SIZE);
           ExSr $SndError;
           ExSr Scrn02;

         Other;

           ExSr Load03;
           ExSr Scrn03;

         EndSl;
       EndSr;

       //?  ...........................................................
       //?  :      Edit03 - Edit Screen 03                            :
       //?  :.........................................................:
       BegSr Edit03;                                                          //?Ready Color

         Select;

         When *InKB;
           ExSr Scrn03;

         When *InKC;
           *InLR = *On;

         When RCCODE = *Blanks and RCCD = *Zero;
           $ERR_MsgID = 'FCR0101';
           ExSr $SndError;
           ExSr Scrn03;

         When RCCODE  <> *Blanks and RCCD  <> *Zero;
           $ERR_MsgID = 'FRC0102';
           ExSr $SndError;
           ExSr Scrn03;

         Other;

           If RCCODE = *Blanks;
             RCCODE = RCCD00(RCCD);
           EndIf;
           ExSr WriteRecs;
           ExSr Load02;
           ExSr Scrn02;

         EndSl;
       EndSr;

       //?  ...........................................................
       //?  :      WriteRecs - Write / Update output files            :
       //?  :.........................................................:
       BegSr WriteRecs;

         Now   = $Now();
         Exec SQL  //  Write RC History File
           INSERT INTO FTRC VALUES(
               :UPCITEM
             , :UPCSIZE
             , :RCCODE
             ,  current TimeStamp
             ,  user ) ;
         Exec SQL  // Update Ready Color File
           UPDATE  FMORLSQ
           SET     OLRDYC = :RCCODE
           WHERE   OLITEM = :UPCITEM
             and   OLSIZE = :UPCSIZE ;

       EndSr;

       //?  ...........................................................
       //?  :      ERRMSG - Error Message Handling Subroutines        :
       //?  :.........................................................:
      /COPY QFunctDefn,$ErrMsgSr

       //?  ...........................................................
       //?  :      ExitSR - Exit Subroutine                           :
       //?  :.........................................................:

       BegSr ExitSR;

         *InLr = *On;
         Return;

       EndSr;

      /END-FREE
