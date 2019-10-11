     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:            Truck Chart Selection and Print                 :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  April 2004           ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
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

     FPSR305FM  CF   E             WORKSTN
     F                                     SFILE(PSR30502:RRN02)
     F                                     DEVID(WSID)

     FFPSECT    UF   E           K DISK                                         ?P/S G/H Avail.

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$isDate#
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,QCmdExc

      *? Arrays
     D   Cmd           S            100A   Dim(0002) CtData                     ?System Commands
     D   Categ         S              4A   Dim(0006) CtData PerRcd(01)          ?Categories

      *? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

      *? Data Areas
     D LDA_DS          DS                  DTAARA(*LDA)
     D  UDSEXT              1000   1000
     D  UDSDAT              1001   1004P 0
     D  UDSTRK              1005   1008

      *? Screen Fields
     D CartsDS         DS
     D  L01A
     D  L01B
     D  L02A
     D  L02B
     D  L03A
     D  L03B
     D  L04A
     D  L04B
     D  L05A
     D  L05B
     D  L06A
     D  L06B
     D  L07A
     D  L07B
     D  L08A
     D  L08B
     D  L09A
     D  L09B
     D  L10A
     D  L10B
     D  L11A
     D  L11B
     D  L12A
     D  L12B
     D  R01B
     D  R01A
     D  R02B
     D  R02A
     D  R03B
     D  R03A
     D  R04B
     D  R04A
     D  R05B
     D  R05A
     D  R06B
     D  R06A
     D  R07B
     D  R07A
     D  R08B
     D  R08A
     D  R09B
     D  R09A
     D  R10B
     D  R10A
     D  R11B
     D  R11A
     D  R12B
     D  R12A
     D Carts                          1A   Dim(48) Overlay(CartsDS)

      *? Field Definitions
     D   RRN02         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D   RRN03         S              4  0 Inz(0)                               ?SFLRRN Screen 03
     D   Today         S               D                                        ?Today
     D   SDate         S              6S 0 Inz(0)                               ?Ship Date MDY
     D   SDateYMD7     S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   ErrCount      S              3S 0 Inz(0)                               ?Error Count
     D   Pink          S              1A   Inz('?')                             ?Color Code for?PINK
     D   Command       S            100A   Inz(*Blanks)                         ?System Command
     D   X             S              4S 0                                      ?# of Good Reads
     D   Offset        S              2S 0                                      ?Offset Amount
     D   Left          S             10A   Inz('   Left   ')                    ?'Left' Literal
     D   Right         S             10A   Inz('   Right  ')                    ?'Right' Literal
     D   ToggleTo      S                   Like(GHUSED)                         ?Togggle GHUSED to ?

    ?C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    1                                            ?
    ?C                   ExSr      Edit01                                       ?
    ?C     Screen        WhenEq    2                                            ?
    ?C                   ExSr      Edit02                                       ?
    ?C                   ENDSL                                                  ?

    ?C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     PSR30501                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *? Load Screen 1 stuff here
     C                   Eval      X     = X                                    ?Ship Date MDY

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

      *? Edit Screen 1 here
    ?C                   SELECT                                                 ?
      *? Exit Requested
    ?C                   When      *In03 = *ON                                          ?
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
      *? Refresh Requested
    ?C                   When      *In05 = *ON                                          ?
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? If no Functions and all Edits passed, load and display next screen.
    ?C                   OTHER                                                  ?
     C                   ExSr      Load02
     C                   ExSr      Scrn02
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?



      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
     C                   If        SFLPOSTO1 <= *Zero
     C                   Eval      SFLPOSTO1 = 1
     C                   EndIf
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     PSR30502F                                   ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     PSR30502C                                    ?
     C                   If        SFLCSRRRN > 0
     C                   Eval      SFLPOSTO1 = SFLCSRRRN
     C                   EndIf
     C                   ExSr      ClrError                                     ?
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load02 - Load Screen 02                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

      *? Clear the Subfile
     C                   Eval      RRN02 = *Zero
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
    ?C                   Write     PSR30502C                                    ?
     C                   Eval      Capacity = *Zero

      *? Load the Subfile
     C                   Eval      GHBay = *Zero
    ?C     BayKey        KList
    ?C                   KFld                    GHSECT
    ?C                   KFld                    GHNORS
    ?C                   KFld                    GHBAY
    ?C     BayKey        SetLL     FPSECT
    ?C                   Read      FPSECT
    ?C                   DoW       not %EOF(FPSECT)
     C                   Eval      ThisBay = 'Bay ' + %EditW(GHBAY:'  ')
      *? Process Single Bay
    ?C                   DoW       not %EOF(FPSECT)
     C                   If        GHUSED <> 'N'
     C                   Eval      Capacity = Capacity + 1
     C                   EndIf
      *? Calculate the Reference Value
     C                   If        GHLORR = 'L'
     C                   Eval      Offset = *Zero
     C                   Eval      Offset = Offset + ((GHPOLE-1)*2)
     C                   If        GHCART = 'A'
     C                   Eval      Offset = Offset + 1
     C                   Else
     C                   Eval      Offset = Offset + 2
     C                   EndIf
     C                   Else
     C                   Eval      Offset = 24
     C                   Eval      Offset = Offset + ((GHPOLE-1)*2)
     C                   If        GHCART = 'B'
     C                   Eval      Offset = Offset + 1
     C                   Else
     C                   Eval      Offset = Offset + 2
     C                   EndIf
     C                   EndIf
     C                   Eval      Carts(Offset) = GHCART
     C                   If        GHUSED = 'N'
     C                   Eval      *In(40+Offset) = *On
     C                   Else
     C                   Eval      *In(40+Offset) = *Off
     C                   EndIf
      *? Read Next Cart Record in the Bay
    ?C     BayKey        ReadE     FPSECT
    ?C                   EndDo                                                  ?
      *? Write Setup Record
     C                   Eval      RRN02 = RRN02 + 1
    ?C                   Write     PSR30502                                     ?
     C                   Eval      *In26 = *On                                  ?
    ?C     BayKey        SetGT     FPSECT
    ?C                   Read      FPSECT
    ?C                   EndDo                                                  ?

     C                   IF        *In26 = *On                                  ?
    ?C     RRN02         Chain     PSR30502                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    PSR30502                                     ?
     C                   EndIF                                                  ?


    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

    ?C                   SELECT                                                 ?
      *? Exit Requested
    ?C                   When      *In03 = *ON                                          ?
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
      *? Refresh Requested
    ?C                   When      *In05 = *ON                                          ?
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
      *? Mouse Click
    ?C                   When      *In22 = *ON                                          ?
    ?C                   ExSr      Mouse
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
      *? If no Functions, Check for Options and Re-display
    ?C                   OTHER                                                  ?
     C                   Eval      *In63 = *Off
    ?C                   ReadC     PSR30502
     C                   DoW       not %EOF(PSR305FM)
     C                   Eval      *In63 = *On

    ?C     RRN02         Chain     PSR30502
     C                   Eval      *In28 = *Off
    ?C                   Update    PSR30502
    ?C                   ReadC     PSR30502
     C                   EndDo                                                  ?
     C                   ExSr      Scrn02
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Mouse    - Interpret Mouse Click                   :
      *?  :.........................................................:
    ?C     Mouse         BegSr                                                  ?

    ?C                   Select                                                 ?
    ?C                   When      CSRRCD <> 'PSR30502'                           ?
      *?                           Do Nothing

    ?C                   When      CSRFLD = *Blanks
      *?                           Do Nothing

    ?C                   When      CSRFLD =  'THISBAY'                          ?
    ?C                   ExSr      ToggleBay

    ?C                   When      CSRFLD =  'LEFT'
     C                   Eval      GHLORR =  'L'
    ?C                   ExSr      ToggleSide

    ?C                   When      CSRFLD =  'RIGHT'                            ?
     C                   Eval      GHLORR =  'R'
    ?C                   ExSr      ToggleSide

    ?C                   Other
    ?C                   ExSr      ToggleCart

    ?C                   EndSl

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ToggleBay    - Toggle On / Off                     :
      *?  :.........................................................:
    ?C     ToggleBay     BegSr                                                  ?

    ?C     SFLCSRRRN     Chain     PSR30502
    ?C     BayKey        SetLL     FPSECT
    ?C     BayKey        ReadE     FPSECT
     C                   If        GHUSED = 'Y'
     C                   Eval      ToggleTo = 'N'
     C                   Else
     C                   Eval      ToggleTo = 'Y'
     C                   EndIf
    ?C                   DoW       not %EOF(FPSECT)
     C                   Eval      GHUSED = ToggleTo
    ?C                   Update    RPSECT
    ?C     BayKey        ReadE     FPSECT
    ?C                   EndDo                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ToggleSide   - Toggle On / Off                     :
      *?  :.........................................................:
    ?C     ToggleSide    BegSr                                                  ?

    ?C     SideKey       KList
    ?C                   KFld                    GHSECT
    ?C                   KFld                    GHNORS
    ?C                   KFld                    GHBAY
    ?C                   KFld                    GHLORR

    ?C     SFLCSRRRN     Chain     PSR30502
    ?C     SideKey       SetLL     FPSECT
    ?C     SideKey       ReadE     FPSECT
     C                   If        GHUSED = 'Y'
     C                   Eval      ToggleTo = 'N'
     C                   Else
     C                   Eval      ToggleTo = 'Y'
     C                   EndIf
    ?C                   DoW       not %EOF(FPSECT)
     C                   Eval      GHUSED = ToggleTo
    ?C                   Update    RPSECT
    ?C     SideKey       ReadE     FPSECT
    ?C                   EndDo                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ToggleCart   - Toggle On / Off                     :
      *?  :.........................................................:
    ?C     ToggleCart    BegSr                                                  ?

      *?  Figure Our Where we are...
     C                   Eval      GHLORR = %Subst(CSRFLD:1:1)
     C                   Eval      GHPOLE = %Int(%Subst(CSRFLD:2:2))
     C                   Eval      GHCART = %Subst(CSRFLD:4:1)

    ?C     CartKey       KList
    ?C                   KFld                    GHSECT
    ?C                   KFld                    GHNORS
    ?C                   KFld                    GHBAY
    ?C                   KFld                    GHLORR
    ?C                   KFld                    GHPOLE
    ?C                   KFld                    GHCART

    ?C     SFLCSRRRN     Chain     PSR30502
    ?C     CartKey       Chain     FPSECT
     C                   If        GHUSED = 'Y'
     C                   Eval      ToggleTo = 'N'
     C                   Else
     C                   Eval      ToggleTo = 'Y'
     C                   EndIf
     C                   Eval      GHUSED = ToggleTo
     C                   If        %Found(FPSECT)
    ?C                   Update    RPSECT
     C                   EndIf

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

      *?  ..........................................................
      *?  :   Run system command                                   :
      *?  :........................................................:
     C     $Command      BegSR
      *? Format the command String.  Put vaiable in place in the string.

      *?   |P?=Printer ID?    ?Put the Printer Name in the Override command?
     C*                  Eval      #Printer = PrtToUse
     C*                  DoW       %Scan('|P':Command) <> 0
     C*                  Eval      Command = %REPLACE
     C*                            (%Trim(#Printer) + ')': Command :
     C*                              %SCAN('|P': Command))
     C*                  EndDo

      *?   ~ ?=Blank that needs to be removed??Replace with nothing?
     C                   DoW       %Scan('~':Command) <> 0
     C                   Eval      Command =
     C                               %SubSt(Command:1:%Scan('~':Command)-1)
     C                             + %SubSt(Command:%Scan('~':Command)+1:
     C                               %Len(Command) - %Scan('~':Command))
     C                   EndDo

      *? Execute the Command using QCMDEXC.
     C                   CALLP     QCmdExc(Command:%len(%Trim(Command)))

     C                   EndSR


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   MOVE      ##PGM         $#PGMQ                         ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C                   Eval      Today = $Date(0)                             ?Today MDY

     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?

    ?C                   EndSr                                                  ?
**
OVRPRTF FILE(PSR305P) PAGESIZE(11 8.5 *UOM) FORMTYPE(*NAR) OVRSCOPE(*JOB) PAGRTT(0) OUTQ(|P
OVRPRTF FILE(PSR305P) PAGESIZE(14 8.5 *UOM) FORMTYPE(*LONG) OVRSCOPE(*JOB) PAGRTT(0) OUTQ(|P
