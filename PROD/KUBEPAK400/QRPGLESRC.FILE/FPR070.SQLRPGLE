     H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')

      //?                                                              ?
      //??|                                                            |?
      //??|       Finished Crop Inventory                              |?
      //?|                                                            |?

      //?PROGRAM NAME-------- FPR070
      //?PROGRAMMER---------- WJB
      //?APPLICATION--------- SCAN GREENHOUSE FINISHED CROP FOR INVENTORY

      //?           CHANGE--DATE-------DESCRIPTION
      //?  1/25/16  WJB  Initial Programming

     FFPR070FM  CF   E             WORKSTN
     FFFINPPDTAGUF   E           K DISK    Rename(FFINPPDTAG:RFINPPDTAG)


     D  OvrTags        S               N

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
     D  User           S             10A
     D  Today          S              6S 0
     D  Now            S              6S 0
     D  x              S              3S 0

      //? Copy Books
     D/COPY QFunctDefn,$ErrMsg

      //? Function Prototypes
     D/COPY QFunctDefn,$_Dates
     D/COPY QFunctDefn,$Monday
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$Now
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$isCust
     D TableLookup     PR                  ExtPgm('XATABLE')
     D  #TABID                        2A   const
     D  ##KEYP#                       2A   const
     D  ##EELM#                       6A   const
     D GetCusName      PR            70A
     D  #SelCust                      6P 0 const

      /FREE
       DoW *InLR <> *On;
         Select;
         When Screen = 01;
           ExSr Edit01;
         Other;
           *InLR = *On;
         EndSL;
       EndDo;

       Return;


       //?  ...........................................................
       //?  :      Load01 - Load Screen 01                            :
       //?  :.........................................................:
       BegSr Load01;

         If PPD# = 0;
           Clear RFINPPDTAG;
           *In10 = *Off;
          Else;
           *In10 = *On;
         EndIf;

       EndSr;

       //?  ...........................................................
       //?  :      Scrn01 - Display Screen 01                         :
       //?  :.........................................................:
       BegSr Scrn01;
         Screen = 01;
         Write ASSUME;
         Write MSGCTL;
         If not *In11;
           ExFmt FPR07001;
          Else;
           ExFmt FPR07002;
         EndIf;
         ExSr $ClrError;
       EndSr;

       //?  ...........................................................
       //?  :      Edit01 - Edit Screen 01                            :
       //?  :.........................................................:
       BegSr Edit01;                                                          //?Enter Date

         Chain PPD# FFINPPDTAG;
         //? CHK F KEYS
         Select;
         When *InKC;
           *InLR = *On;
           Return;
         When *InKJ and *In11;
           *In11 = *Off;
           ExSr Scrn01;
         When *InKJ and not *In11;
           *In11 = *On;
           ExSr Scrn01;
           //? CHECK INPUT
         When PPD# = *Zeros;                                               //?No Date Entered
           $ERR_MsgID = 'FPR0002';
           //$ERR_MsgData = '..Data..';
           Clear RFINPPDTAG;
           ExSr $SndError;
           ExSr Scrn01;
         When PPD# <> *Zeros and not %Found(FFINPPDTAG);                   //?No Date Entered
           $ERR_MsgID = 'FPR0003';
           $ERR_MsgData = %Char(PPD#);
           ExSr $SndError;
           ExSr Scrn01;
         When *In10 and COUNTED = *Zero;
           ExSr Scrn01;
         When not *In10 and %Found(FFINPPDTAG);
           ExSr Load01;
           ExSr Scrn01;
         Other;
           FPQTYACTL = Counted;
           Update RFINPPDTAG;
           LASTTAG# = PPD#;
           PPD# = *Zero;
           Counted = *Zero;
           ExSr Load01;
           ExSr Scrn01;
         EndSl;

       EndSr;

       //?  ...........................................................
       //?  :      WriteRecs - Write / Update output files            :
       //?  :.........................................................:
       BegSr WriteRecs;

         Now   = $Now();
         LastTag# = PPD#;

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

       //?  ...........................................................
       //?  :      *INZSR - Initialization Subroutine                 :
       //?  :.........................................................:

       BegSr *InzSR;

         Today = $MDYDate($Date(0));
         User  = $User();

         $ERR_PROG  = 'FPR070    ';                                           //?Pgm Msg Queue
         $ERR_MSGF  = 'KPMSGF';                                               //?Message File
         $ERR_LIBR  = '*LIBL';                                                //?Library

         ExSr $ClrError;
         ExSr Load01;
         ExSr Scrn01;

       EndSr;


      /END-FREE
     P GetCusName      B
     D GetCusName      PI            70A
     D  #SelCust                      6P 0 const
     D  #CusName       S             70A
         Exec SQL
           SELECT   Trim(Char(int(:#SelCust))) || ' (' ||
                    Trim( TBSHRT)||') '||Trim(TBLONG)
           INTO    :#CusName
           FROM     XATABL
           WHERE    TBTBCD = 'AB'||right('00000'||int( :#SelCust ),5);
         If SQLState = '00000';
           Return #CusName;
          Else;
           Return '***No Customer***';
         EndIf;
     P GetCusName      E
