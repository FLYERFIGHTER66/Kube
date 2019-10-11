     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
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
     FDFTPRTFM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FDFTPRTPF  UF A E           K DISK                                         ?Default Printers
     FDFTPRTTR  UF A E           K DISK                                         ?Dft Prtr Trans File

      *? Program Status Data Structure
     D                SDS                                                       ?OverRide to Printer
     D   ##PGM           *PROC                                                  ?Progride to Printer

      *? Field Definitions
     D   #Printer      S             10A                                        ?OverRide to Printer
     D   Command       S            100A   Inz(*Blanks)                         ?System Command
     D   TypeU         S              1A   Inz('U')                             ?User Printer Type
     D   TypeP         S              1A   Inz('P')                             ?Pgm Printer Type
     D   SaveUsr       S             10A                                        ?Save User Printer
     D   SavePGM       S             10A                                        ?Save Pgm Printer

      *? Function Prototype(s)
     D/Copy QFunctDefn,$isPrinter
     D/Copy QFunctDefn,$Program
     D/Copy QFunctDefn,$User
     D/Copy QFunctDefn,$Job

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

     C                   SELECT                                                 ?
     C     Screen        WhenEq    1                                            ?
     C                   ExSr      Edit01                                       ?
     C     Screen        WhenEq    2                                            ?
     C                   ExSr      Edit02                                       ?
     C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     DFTPRT01                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *? Load the Screen Values

    ?C     UserKey       Chain     DFTPRTPF
     C                   If        not %Found(DFTPRTPF)
     C                   Eval      UsrDft = '*NONE'
     C                   else
     C                   Eval      UsrDft = DPPRTR
     C                   EndIf

     C                   If        #Pgm = *Blanks
     C                   If        UsrDft <> '*NONE'
     C                   Eval      UsePrt = UsrDft
     C                   EndIf
     C                   Eval      *In61 = *On
     C                   Else
    ?C     PgmKey        Chain     DFTPRTPF
     C                   If        not %Found(DFTPRTPF)
     C                   Eval      PgmDft = '*NONE'
     C                   Eval      UsePrt = UsrDft
     C                   else
     C                   Eval      PgmDft = DPPRTR
     C                   Eval      UsePrt = PgmDft
     C                   EndIf
     C                   EndIf

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

    ?C                   SELECT                                                 ?
      *? Check for Cancel Request
    ?C                   When      *In12 = *On                                          ?
     C                   Eval      *InLR = *On
     C                   Return
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
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     DFTPRT02                                     ?
     C                   ExSr      ClrError                                     ?
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
     C                   ExSr      Scrn01
      *? Check for Valid Printers
    ?C                   When         not $isPrinter(UsrDft)                              ?
    ?C                               and  UsrDft <> *Blanks
    ?C                               and  UsrDft <> '*NONE'
    ?C                             or not $isPrinter(PgmDft)                              ?
    ?C                               and  PgmDft <> *Blanks
    ?C                               and  PgmDft <> '*NONE'
     C                   If        not $isPrinter(UsrDft)
     C                             and UsrDft <> *Blanks
    ?C                             and UsrDft <> '*NONE'
     C                   Eval      $#MSID = 'PRT0102'
     C                   Eval      $#MSGD = UsrDft
     C                   Eval      *In51  = *On
     C                   EXSR      SndError
     C                   EndIf
     C                   If        not $isPrinter(PgmDft)
     C                             and PgmDft <> *Blanks
    ?C                             and PgmDft <> '*NONE'
     C                   Eval      $#MSID = 'PRT0102'
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
     C                   Eval      #Printer = UsePrt
     C                   Eval      *InLR = *On
     C                   Return
     C                   Else
     C                   Eval      $#MSID = 'PRT0102'
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
     C                   ExSr      SRMSGF                                       ?
     C                   MoveA     '0000000000'  *In(50)                        ?Error Indicators

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      SndError - Send an Error Message to the PGMMSGQ    :
      *?  :.........................................................:
    ?C     SndError      BegSr                                                  ?

     C                   MOVE      'S'           $#MSFN            1            ?
     C                   ExSr      SRMSGF                                       ?
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
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C*                  MOVE      ##PGM         $#PGMQ                         ?PGM MSG QUEUE
     C                   Eval      $#PGMQ = $Program()                          ?PGM MSG QUEUE
     C                   Eval      $#PGMQ = ##PGM                               ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C                   Eval      DPJOBN = $Job()                              ?Job Name
     C                   Eval      DPUSER = $User()                             ?User Name
     C                   Time                    DPTMST                         ?Time Stamp

     C     *Entry        PList
     C                   Parm                    #User            10
     C                   Parm                    #Pgm             10
     C                   Parm                    #Printer         10

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
