     H CopyRight('(C) Copyright Kube-Pak Corporation 2004')                     ?Copyright Info.
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:        Printer Selection and Default Maintenance           :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May 2004             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :  This program is used to select which printer to use for  ?:
      *? :  the current program and also as Maintenance for the      ?:
      *? :  Default Printer File (DFTPRTPF)                          ?:
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
      *? :  51      ?Error: *USR Printer not Valid                   ?:
      *? :  52      ?Error: *PGM Printer not Valid                   ?:
      *? :  70      ?Push Buttone Default 70 = Yes, N70 = No         ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

      *? Files
     F$CHGPRTFM CF   E             WORKSTN USROPN
     FDFTPRTPF  UF A E           K DISK    USROPN                               ?Default Printers
     FDFTPRTTR  UF A E           K DISK    USROPN                               ?Dft Prtr Trans File
     FDFTPRTLUPFUF A E           K DISK    USROPN                               ?Prtr Last Used

      *? Program Status Data Structure
     D                SDS                                                       ?OverRide to Printer
     D   ##PGM           *PROC                                                  ?Progride to Printer

      *? Field Definitions
     D   Command       S            100A   Inz(*Blanks)                         ?System Command
     D   TypeU         S              1A   Inz('U')                             ?User Printer Type
     D   TypeP         S              1A   Inz('P')                             ?Pgm Printer Type
     D   SaveUsr       S             10A                                        ?Save User Printer
     D   SavePGM       S             10A                                        ?Save Pgm Printer
     D   #User         S             10A
     D   #Pgm          S             10A
     D   #Printer      S             10A

      *? Function Prototype(s)
     D/Copy QFunctDefn,$isPrinter
     D/Copy QFunctDefn,$User
     D/Copy QFunctDefn,$Job
     D/Copy QFunctDefn,$ChgPrt

     P $ChgPrt         B                   Export
     D $ChgPrt         PI            10A
     D   #User                       10A   Const
     D   #Pgm                        10A   Const
     D   #Printer                    10A   Const

     C                   If        not %Open($CHGPRTFM)
     C                   Open      $CHGPRTFM
     C                   EndIf
     C                   If        not %Open(DFTPRTPF)
     C                   Open      DFTPRTPF
     C                   EndIf
     C                   If        not %Open(DFTPRTTR)
     C                   Open      DFTPRTTR
     C                   EndIf
     C                   If        not %Open(DFTPRTLUPF)
     C                   Open      DFTPRTLUPF
     C                   EndIf

     C                   EXSR      First                                        ?*INZSR
     C                   Eval      *InLR = *Off
     C     *INLR         DOUEQ     *ON                                          ?COMMENT

     C                   SELECT                                                 ?
     C     Screen        WhenEq    1                                            ?
     C                   ExSr      Edit01                                       ?
     C     Screen        WhenEq    2                                            ?
     C                   ExSr      Edit02                                       ?
     C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

     C                   Eval      *InLR = *On
     C                   Close     $CHGPRTFM
     C                   Close     DFTPRTPF
     C                   Close     DFTPRTTR
     C                   Close     DFTPRTLUPF
     C                   Return    UsePrt

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C*                  Write     MSGCTL                                       ?
    ?C                   ExFmt     $CHGPRT01                                     ?
     C*                  ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *? Load the Screen Values

     C                   If        UsePrt = '*LAST'
WHT  C     Last_Key      Chain(N)  DFTPRTLUPF                                   |Printer Last Use
     C                   If        not %found(DFTPRTLUPF)
     C                   If        #Pgm <> *Blanks
     C                   Eval      UsePrt = '*PGM'
     C                   Else
     C                   Eval      UsePrt = '*USER'
     C                   EndIf
     C                   Else
     C                   Eval      UsePrt = DLPRTR
     C                   EndIf
     C                   EndIf

     C                   If        #User = *Blanks
     C                             or #User = '*NONE'
     C                   Eval      *In62 = *On
     C                   Eval      UsrDft = '*NONE'
     C                   Else
    ?C     UserKey       Chain     DFTPRTPF
     C                   If        not %Found(DFTPRTPF)
     C                   Eval      UsrDft = '*NONE'
     C                   else
     C                   Eval      UsrDft = DPPRTR
     C                   EndIf
     C                   EndIf

     C                   If        #Pgm = *Blanks
     C                             or #Pgm = '*NONE'
     C                   Eval      *In61 = *On
     C                   Eval      PgmDft = '*NONE'
     C                   Else
    ?C     PgmKey        Chain     DFTPRTPF
     C                   If        not %Found(DFTPRTPF)
     C                   Eval      PgmDft = '*NONE'
     C                   else
     C                   Eval      PgmDft = DPPRTR
     C                   EndIf
     C                   EndIf

    ?C                   Select                                                 ?
     C                   When      UsePrt = '*USER' and UsrDft <> '*None'
     C                   eval      UsePrt = UsrDft

     C                   When      UsePrt = '*PGM'  and PgmDft <> '*None'
     C                   eval      UsePrt = PgmDft

     C                   When      UsePrt = '*USER' and UsrDft =  '*None'
     C                   eval      UsePrt = PgmDft

     C                   When      UsePrt = '*PGM'  and PgmDft =  '*None'
     C                   eval      UsePrt = UsrDft

    ?C                   EndSl                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

    ?C                   SELECT                                                 ?
      *? Check for Cancel Request
    ?C                   When      *In12 = *On                                          ?
     C                   Eval      UsePrt = #Printer
     C                   Eval      *InLR = *On
      *? Check for "Use my Printer"
    ?C                   When      *In11 = *ON                                          ?
     C                   Eval      UsePrt = UsrDft
     C                   ExSr      CheckPrtr
      *? Check for "Use Pgm Default"
    ?C                   When      *In10 = *ON                                          ?
     C                   Eval      UsePrt = PgmDft
     C                   ExSr      CheckPrtr
      *? When Default Printer Change is requested
    ?C                   When      *In13 = *ON
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
      *? If no Functions, Check for "Printer to Use" for validity
    ?C                   OTHER                                                  ?
     C                   ExSr      CheckPrtr
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
    ?C*                  Write     MSGCTL                                       ?
    ?C                   ExFmt     $CHGPRT02                                    ?
     C*                  ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load02 - Load Screen 02                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

      *? Save the Current Default Printers
     C                   Eval      SavePGM = PgmDft
     C                   Eval      SaveUSR = UsrDft

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

    ?C                   SELECT                                                 ?
      *? Check for Cancel Request
    ?C                   When      *In12 = *ON                                          ?
     C                   Eval      PgmDft = SavePGM
     C                   Eval      UsrDft = SaveUSR
     C                   ExSr      Scrn01
      *? Check for Valid Printers
    ?C                   When         UsrDft = *Blanks and not *In62
    ?C                             or PgmDft = *Blanks and not *In61
     C                   Eval      *In50 = *On                                  ?Error Indicator
     C                   Eval      $#MSID = 'PRT0102'
      *                                     Printer &1 is not valid.
     C                   If        UsrDft = *Blanks
     C                   Eval      $#MSGD = UsrDft
     C                   Eval      *In51 = *On                                  ?User Printer Bad
     C                   EndIf
     C                   If        PgmDft = *Blanks
     C                   Eval      $#MSGD = PgmDft
     C                   Eval      *In52 = *On                                  ?Program Printer Bad
     C                   EndIf
     C                   EXSR      SndError
     C                   ExSr      Scrn02                                       ?
    ?C                   When         not $isPrinter(UsrDft)                              ?
    ?C                               and  UsrDft <> *Blanks
    ?C                               and  UsrDft <> '*NONE'
    ?C                             or not $isPrinter(PgmDft)                              ?
    ?C                               and  PgmDft <> *Blanks
    ?C                               and  PgmDft <> '*NONE'
     C                   If        not $isPrinter(UsrDft)
     C                             and UsrDft <> *Blanks
     C                             and UsrDft <> '*NONE'
     C                   Eval      $#MSID = 'PRT0102'
      *                                     Printer &1 is not valid.
     C                   Eval      *In50 = *On                                  ?Error Indicator
     C                   Eval      *In51 = *On                                  ?User Printer Bad
     C                   Eval      $#MSGD = UsrDft
     C                   EXSR      SndError
     C                   EndIf
     C                   If        not $isPrinter(PgmDft)
     C                             and PgmDft <> *Blanks
     C                             and PgmDft <> '*NONE'
     C                   Eval      $#MSID = 'PRT0102'
      *                                     Printer &1 is not valid.
     C                   Eval      *In50 = *On                                  ?Error Indicator
     C                   Eval      *In52 = *On                                  ?Program Printer Bad
     C                   Eval      $#MSGD = PgmDft
     C                   EXSR      SndError
     C                   EndIf
     C                   ExSr      Scrn02                                       ?
      *? When Default Printer Update is requested
    ?C                   When      *In13 = *ON
      *?           User Printer
     C                   If        SaveUSR <> UsrDft
     C                   Clear                   DFTPRT
     C                   Eval      DPTYPE = 'U'
     C                   Eval      DPNAME = #User
     C                   ExSr      UpdatePRTR                                   ?
     C                   EndIF
      *?           Prog Printer
     C                   If        SavePGM <> PgmDft
     C                   Clear                   DFTPRT
     C                   Eval      DPTYPE = 'P'
     C                   Eval      DPNAME = #Pgm
     C                   ExSr      UpdatePRTR                                   ?
     C                   EndIF
     C                   ExSr      Scrn01                                       ?
      *? When Printer(s) is/are Changed w/o using F13... send Message
    ?C                   When         SavePGM <> PgmDft
    ?C                             or SaveUSR <> UsrDft
     C                   Eval      $#MSID = 'PRT0101'
      *                                     Use F13 to change Defaults
     C                   Eval      *In50 = *On                                  ?Error Indicator
     C                   EXSR      SndError
     C                   ExSr      Scrn02                                       ?
      *? If no Functions, and the Printers haven't changed, go back to screen 01
    ?C                   OTHER                                                  ?
     C                   ExSr      Scrn01                                       ?
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      UpdatePRTR - Update Printer File                   :
      *?  :.........................................................:
    ?C     UpdatePRTR    BegSr                                                  ?

     C     UpdtKey       Chain     DFTPRTPF
    ?C                   Write     DFTPRTT
    ?C                   Select
    ?C                   When      DPTYPE = 'U'
     C                   Eval      DPPRTR = UsrDFT
    ?C                   When      DPTYPE = 'P'
     C                   Eval      DPPRTR = PgmDFT
    ?C                   EndSl                                                  ?
     C                   If        %Found(DFTPRTPF)
    ?C                   Update    DFTPRT
     C                   Else
    ?C                   Write     DFTPRT
     C                   EndIF

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      CheckPrtr - Check that Printer selected is valid   :
      *?  :.........................................................:
    ?C     CheckPrtr     BegSr                                                  ?

     C                   If        $isPrinter(UsePrt)
     C                   Eval      *InLR = *On
     C     Last_Key      Chain     DFTPRTLUPF
     C                   Eval      DLPRTR = UsePrt
     C                   If        %found(DFTPRTLUPF)
     C                   Update    DFTPRTLU
     C                   Else
     C                   If        #User <> *Blanks and #Pgm <> *Blanks
     C                   Eval      DLUSER = #User
     C                   Eval      DLPGM  = #Pgm
     C                   Write     DFTPRTLU
     C                   EndIf
     C                   EndIf
     C                   Eval      *InLR = *On
     C                   Close     $CHGPRTFM
     C                   Close     DFTPRTPF
     C                   Close     DFTPRTTR
     C                   Close     DFTPRTLUPF
     C                   Return    UsePrt
     C                   Else
     C                   Eval      $#MSID = 'PRT0102'
      *                                     Printer &1 is not valid.
     C                   Eval      *In50 = *On                                  ?Error Indicator
     C                   Eval      *In52 = *On                                  ?Program Printer Bad
     C                   Eval      $#MSGD = PgmDft
     C                   EXSR      SndError
     C                   ExSr      Scrn01                                       ?
     C                   EndIf

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ClrError - Clear Error Message Subfile             :
      *?  :.........................................................:
    ?C     ClrError      BegSr                                                  ?

     C                   MOVE      'C'           $#MSFN            1            ?
     C*                  ExSr      SRMSGF                                       ?
     C                   MoveA     '0000000000'  *In(50)                        ?Error Indicators

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      SndError - Send an Error Message to the PGMMSGQ    :
      *?  :.........................................................:
    ?C     SndError      BegSr                                                  ?

     C                   MOVE      'S'           $#MSFN            1            ?
     C*                  ExSr      SRMSGF                                       ?
     C                   Eval      *In50 = *On                                  ?Error Alarm Indicat

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
      *?  :      FIRST  - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     FIRST         BegSr                                                  ?

     C*    *Entry        PList
     C*                  Parm                    #User
     C*                  Parm                    #Pgm
     C*    UsePrt        Parm      UsePrt        #Printer

     C                   Eval      $#PGMQ = ##PGM                               ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C                   Eval      DPJOBN = $Job()                              ?Job Name
     C                   Eval      DPUSER = $User()                             ?User Name
     C                   Time                    DPTMST                         ?Time Stamp

     C     Last_Key      KList
     C                   KFld                    #User
     C                   KFld                    #Pgm

     C     UserKey       KList
     C                   KFld                    TypeU
     C                   KFld                    #User

     C     PgmKey        KList
     C                   KFld                    TypeP
     C                   KFld                    #Pgm

     C     UpdtKey       KList
     C                   KFld                    DPTYPE
     C                   KFld                    DPNAME

     C                   ExSr      Load01
     C                   ExSr      Scrn01

    ?C                   EndSr                                                  ?
     P   $ChgPrt       E
