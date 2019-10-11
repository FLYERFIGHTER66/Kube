     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:            Truck Chart Selection and Print                 :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  April 2004           ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :  Scrn01   -?Display Screen 01                             ?:
      *? :  Load01   -?Load Screen 01                                ?:
      *? :  Edit01   -?EDIT Screen 01                                ?:
      *? :  ClrError -?Clear Error MEssage Subfile                   ?:
      *? :  SndError -?Send an Error Message to the PGMMSGQ          ?:
      *? :  SRMSGF   -?Clear or send messages to Pgm msg queue       ?:
      *? :  *INZSR   -?Initialization Subroutine                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  01 - 24 ?Return Screen Functions                         ?:
      *? :  03      ?Exit                                            ?:
      *? :  06      ?Restart                                         ?:
      *? :          ?                                                ?:
      *? :  25      ?SFLDSP, SFLDSPCTL, SFLCLR(N)                    ?:
      *? :  26      ?SFLDSP (Subfile has Data)                       ?:
      *? :  27      ?SFLEND                                          ?:
      *? :  28      ?SFLNXTCHG                                       ?:
      *? :  40      ?Lookup Indicator                                ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  70      ?Push Buttone Default 70 = Yes, N70 = No         ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   12/10/18  S.Uthaya      Replaced $NeedDir Function By using
      *                                 $ChkDir
      //--------------------------------------------------------------------
     FTRR570FM  CF   E             WORKSTN
     F                                     SFILE(TRR57001:RRN01)
     F                                     DEVID(WSID)
     F*TRR500FM  CF   E             WORKSTN

     FFMCUST    IF   E           K DISK                                         ?Customer Master
     FFTRHDRH1  IF   E           K DISK                                         ?Truck Schd Header
     FFTRSCHD   IF   E           K DISK                                         ?Truck Schd Details
SUD01 *?File: Order Header Ship-to Logical File
  |   *?Key : Order# : Customer#
SUD01FFHORDRSHTLIF   E           K DISK                                         Order Header Ship-to

      *? Function Prototypes
     D TRR502          PR                  ExtPgm('TRR502')
     D  #Truck                             Const Like(THTRK#)
     D  #Date7@                       7A   Const
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$isDate#
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,QCmdExc
    ?D*/COPY QFunctDefn,$NeedDir
SUD01D/COPY QFunctDefn,$ChkDir

      *? Arrays
     D   Cmd           S            100A   Dim(0002) CtData                     ?System Commands

      *? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

     D LDA_DS          DS                  DTAARA(*LDA)
     D  UDSEXT              1000   1000
     D  UDSDAT              1001   1004P 0
     D  UDSTRK              1005   1008

      *? Field Definitions
     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D   Today         S               D                                        ?Today
     D   SDate         S              6S 0 Inz(0)                               ?Ship Date MDY
     D   SDateYMD7     S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   ThisMonday    S              6S 0 Inz(0)                               ?Monday ( MDY )
     D   ThisMonCYMD   S              7S 0 Inz(0)                               ?Monday ( CYMD )
     D   ErrCount      S              3S 0 Inz(0)                               ?Error Count
     D   Pink          S              1A   Inz('?')                             ?Color Code for?PINK
     D   SavePRTR      S             10A                                        ?Save Curr PRTR
     D   Command       S            100A   Inz(*Blanks)                         ?System Command


     C     *INLR         DOUEQ     *ON                                          ?COMMENT

     C                   SELECT                                                 ?
     C     Screen        WhenEq    1                                            ?
     C                   ExSr      Edit01                                       ?
     C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     TRR57001F                                   ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     TRR57001C                                    ?
     C                   ExSr      ClrError                                     ?
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
    ?C                   Write     TRR57001C                                    ?

      *? Load the Subfile
     C                   Eval      *In28 = *On                                  ?Write w/ SFLNXTCHG
     C     SDateYMD7     SetLL     FTRHDRH1                                     ?
    ?C     SDateYMD7     ReadE     FTRHDRH1                                     ?

     C                   Z-add     *Zero         RRN01                          ?
     C                   DoW       not %EOF(FTRHDRH1)
     C                   Add       1             RRN01                          ?
     C                   Eval      COMPLETE = *Zeros
     C                   Eval      TOTLINES = *Zeros
     C                   Eval      DIRECTIONS = *Zeros
     C                   Eval      NCRORDS    = *Zeros
     C                   Eval      NCRSCAN    = *Zeros
     C                   Eval      NCRVFYD    = *Zeros
     C                   Eval      NCRLEFT    = *Zeros
    ?C     DetailKey     SetLL     FTRSCHD
    ?C     DetailKey     ReadE     FTRSCHD
     C                   DoW       not %EOF(FTRSCHD)
     C                   Eval      TOTLINES = TOTLINES + 1
     C                   If        TRDLVC <> *Blanks
     C                   Eval      COMPLETE = COMPLETE + 1
     C                   EndIf
SUD01C*                  If        $NeedDir(TRCUST)
  |  C*                  Eval      DIRECTIONS = DIRECTIONS + 1
SUD01C*                  EndIf
      /Free

SUD01 *?  // Get Seq# from Order Header Ship-to File
  |       Chain (TRORD#:TRCUST) FHORDRSHTL;
  |       // If %Found;  wjb
  |       If NOT %Found;
            osseq# = 0;
          EndIf;
  |
  |   *?  // Check Directions found($ChkDir will be on if direction found)
  |       If Not $ChkDir(TRCUST:OSSEQ#);
  |          DIRECTIONS = DIRECTIONS + 1;
  |       Endif;
SUD01    // Endif;     wjb

         //  NOTE: We are using the 'C.O.D.' fields for Verification Process
         NCRORDS += 1;     // Orders
         If TRCODC <> ' '; // Scanned
           NCRSCAN += 1;
         EndIf;
         If TRCODC = 'Y';  // Verified
           NCRVFYD += 1;
          Else;            // Remaining
           NCRLEFT += 1;
         EndIf;
      /End-Free
    ?C     DetailKey     ReadE     FTRSCHD
     C                   EndDo

     C                   IF        TOTLINES > 0
     C                   Eval      LEFT2CONF = TOTLINES - COMPLETE
     C                   EndIf
     C                   IF        LEFT2CONF = 0
     C                   Eval      *In51 = *On
     C                   EndIf
     C                   IF        NCRLEFT = 0
     C                   Eval      *In53 = *On
     C                   EndIf
    ?C                   Write     TRR57001                                     ?
     C                   Eval      *In26 = *On                                  ?
     C                   Eval      *In51 = *Off
     C                   Eval      *In53 = *Off
    ?C     SDateYMD7     ReadE     FTRHDRH1                                     ?
     C                   EndDo                                                  ?

     C                   IF        *In26 = *On                                  ?
    ?C     RRN01         Chain     TRR57001                                     ?
     C                   IF        LEFT2CONF = 0
     C                   Eval      *In51 = *On
     C                   EndIf
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    TRR57001                                     ?
     C                   Eval      *In51 = *Off
     C                   EndIF                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

    ?C                   SELECT                                                 ?
      *? Exit Requested
    ?C                   When      *In03 = *ON                                          ?
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
      *? When Date is invalid
    ?C                   When      not $isDate#(SDATE:'*MDY')                           ?
     C                   Eval      $#MSID = 'TRR5701'
     C                   EXSR      SndError
     C                   Eval      *In26 = *Off                                 ?Do not Display SFL
     C                   ExSr      Scrn01                                       ?
      *? When Date is Changed
    ?C                   When      $DateMDY(SDate) <> $Date(SDateYMD7)             ?
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Previou Day is Requested
    ?C                   When      *In08 = *ON                                  ?
     C                   Eval      SDate=$MDYDate($AddDate($DateMDY(SDate):-1))
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Next Day is Requested
    ?C                   When      *In09 = *ON                                  ?
     C                   Eval      SDate=$MDYDate($AddDate($DateMDY(SDate):1))
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Refresh is Requested
    ?C                   When      *In05 = *ON                                  ?
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? If no Functions, Check for Options and Re-display
    ?C                   OTHER                                                  ?
    ?C                   ReadC     TRR57001
     C                   Eval      *In28 = *On
     C                   DoW       not %EOF(TRR570FM)

    ?C                   Select
    ?C                   When      Sel01 = *Blanks
     C*                  Do Nothing (Skip Subfile Record)
    ?C                   When      Sel01 = '1'
     C                   ExSr      ViewTruck
     C                   Eval      Sel01 = *Blanks
    ?C                   When      Sel01 = '2'
     C                   ExSr      ReCalcTruck
     C                   Eval      Sel01 = *Blanks
    ?C                   Other
     C                   Eval      $#MSGD = Sel01
     C                   Eval      $#MSID = 'TRR5604'
     C                   EXSR      SndError
     C                   Eval      *In52 = *On
    ?C                   ENDSL                                                  ?
     C                   IF        LEFT2CONF = 0
     C                   Eval      *In51 = *On
     C                   EndIf
    ?C                   Update    TRR57001
     C                   Eval      *In51 = *Off
     C                   Eval      *In52 = *Off
    ?C                   ReadC     TRR57001
     C                   EndDo                                                  ?
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ViewTruck - Print Chart for Selected Truck         :
      *?  :.........................................................:
    ?C     ViewTruck     BegSr                                                  ?

     C                   IN        LDA_DS
     C                   Eval      *InU8 = *On
     C                   Eval      UDSTRK = THTRK#
     C                   Eval      UDSDAT = SDateYMD7
     C                   Eval      UDSEXT = 'Y'
     C                   OUT       LDA_DS
     C                   Call      'TRR500'
     C                   Eval      UDSEXT = ' '

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ReCalcTruck - Recalculate Quantities on Truck      :
      *?  :.........................................................:
    ?C     ReCalcTruck   BegSr                                                  ?

      /Free
         CallP TRR502(THTRK#:%Char(THSHDT));
      /End-Free

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ClrError - Clear Error Message Subfile             :
      *?  :.........................................................:
    ?C     ClrError      BegSr                                                  ?

     C                   MOVE      'C'           $#MSFN            1            ?
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrCount = *Zero                             ?
     C                   Eval      *In50 = *Off                                 ?Error Indicator

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      SndError - Send an Error Message to the PGMMSGQ    :
      *?  :.........................................................:
    ?C     SndError      BegSr                                                  ?

     C                   MOVE      'S'           $#MSFN            1            ?
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrCount = ErrCount + 1                      ?
     C                   Eval      *In50 = *On                                  ?Error Indicator

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      * ? :      SRMSGF - Clear or send messages to Pgm msg queue   :
      *?  :.........................................................:
    ?C     SRMSGF        BegSr                                                  ?

      *? Define Parameter List - define variables         ?

     C     PLMSGF        PLIST                                                  ?
     C                   Parm                    $#PGMQ           10            ?Pgm Msg Queue
     C                   Parm                    $#MSGF           10            ?Message File
     C                   Parm                    $#MSGL           10            ?Library
     C                   Parm                    $#MSID            7            ?Message Id
     C                   Parm                    $#MSGD          100            ?Message Data
     C                   Parm                    $#MSKY            4            ?Message Key
     C                   Parm                    $#MSFN            1            ?Send or Clear

      *? Call Msg processing CL                           ?

     C                   CALL      'XAMSFC'      PLMSGF                         ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   MOVE      ##PGM         $#PGMQ                         ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C                   Eval      Today = $Date(0)                             ?Today MDY
     C                   Eval      SDate = $MDYDate($AddDate(Today:1))          ?Ship Date MDY
     C                   Eval      SDateYMD7 = $Date7($AddDate(Today:1))        ?Ship Date YMD7

     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

     C     DetailKey     KList
     C                   KFld                    THTRK#
     C                   KFld                    THSHDT

    ?C                   EndSr                                                  ?
**
OVRPRTF FILE(TRR570P) PAGESIZE(11 8.5 *UOM) FORMTYPE(*NAR) OVRSCOPE(*JOB) PAGRTT(0) OUTQ(|P
OVRPRTF FILE(TRR570P) PAGESIZE(14 8.5 *UOM) FORMTYPE(*LONG) OVRSCOPE(*JOB) PAGRTT(0) OUTQ(|P
