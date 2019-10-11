     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:              Assign Carts to a Customer Order              :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  June 2011            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program assigns Carts to Orders for the purpose of  :
      *? : printing Cart Charts with Order/Cart information printed. ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? : Subroutine ?-Subroutine Description                  ?  ?:
      *? :  *INZSR      -?Initialization Subroutine                  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? : Function   ?-Function Description                    ?  ?:
      *? :  $User       -?Return current User I.D.                   ?:
      *? :  $Job        -?Return current Job Name                    ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FNCR500FM  CF   E             WORKSTN
     F                                     SFILE(NCR50001:RRN01)
     F                                     DEVID(WSID)
     FFCRTORDORDUF   E           K DISK
     FFCRTORDCRTUF A E           K DISK
     F                                     RENAME(RCRTORD:RCRTORDCRT)
     FFHORDR    IF   E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$isDate#
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$NeedDir

      *? Arrays
     D*  Cmd           S            100A   Dim(0002) CtData                     ?System Commands

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
     D   Sav_COORD#    S                   Like(COORD#)                         ?Save Last Order #


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
    ?C                   Write     NCR50001F                                   ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     NCR50001C                                    ?
     C                   ExSr      ClrError                                     ?
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *? Load the Header Information
    ?C                   Clear                   OHCUST
    ?C                   Clear                   OHNAME
    ?C                   Clear                   OHSHP2
    ?C                   Clear                   OHSHP3
    ?C                   Clear                   OHSHCT
    ?C                   Clear                   OHSHST
    ?C                   Clear                   OHSHZP
    ?C                   Clear                   OHPONO
    ?C                   Clear                   OHDTOR
    ?C                   Clear                   OHDTRQ
    ?C     COORD#        Chain     FHORDR

      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
    ?C                   Write     NCR50001C                                    ?

      *? Load the Subfile
     C                   Eval      *In28 = *Off                                 ?Write w/ SFLNXTCHG
     C     COORD#        SetLL     FCRTORDORD                                   ?
    ?C     COORD#        ReadE     FCRTORDORD                                   ?

     C                   Z-add     *Zero         RRN01                          ?
     C                   DoW       not %EOF(FCRTORDORD)
     C                   Add       1             RRN01                          ?
    ?C                   Write     NCR50001                                     ?
     C                   Eval      *In26 = *On                                  ?
    ?C     COORD#        ReadE     FCRTORDORD                                   ?
     C                   EndDo                                                  ?

     C                   If        RRN01 < 40
     C                             and %found(FHORDR)
     C                   Add       1             RRN01                          ?
     C                   Eval      COCART = *Zero
    ?C                   Write     NCR50001                                     ?
     C                   Eval      *In26 = *On                                  ?
     C                   EndIf

     C                   IF        *In26 = *On                                  ?
    ?C     RRN01         Chain     NCR50001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    NCR50001                                     ?
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
      *? When Refresh is Requested
    ?C                   When      *In05 = *ON                                  ?
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Switch is Requested
    ?C                   When      *In11 = *ON                                  ?
     C                   MOVE      '1'           RTN                            ?Return Code
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
      *? When Cart Delete is Requested
    ?C                   When      *In23 = *ON                                  ?
     C                   If        SFLCSRRRN <> *Zero
     C                   Eval      COCART = *Zero
    ?C     SFLCSRRRN     Chain     NCR50001
    ?C     COCART        Chain     FCRTORDCRT
     C                   If        %Found(FCRTORDCRT)                           ?
    ?C                   Delete    RCRTORDCRT
     C                   EndIf
     C                   EndIf
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Order Delete is Requested
    ?C                   When      *In24 = *ON                                  ?
    ?C     COORD#        SetLL     FCRTORDORD
    ?C     COORD#        ReadE     FCRTORDORD
     C                   DoW       not %EOF(FCRTORDORD)                           ?
    ?C                   Delete    RCRTORD
    ?C     COORD#        ReadE     FCRTORDORD
     C                   EndDo
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Order Number Has Changed
    ?C                   When      COORD# <> Sav_COORD#                         ?
    ?C                   Eval      Sav_COORD# = COORD#
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Order Number is *Zero
    ?C                   When      COORD# = *Zero
    ?C                   Eval      Sav_COORD# = COORD#
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? If no Functions, Check for Options and Re-display
    ?C                   OTHER                                                  ?
    ?C                   ReadC     NCR50001
     C                   Eval      *In28 = *Off
     C                   DoW       not %EOF(NCR500FM)
     C                   If        COCART <> *Zero
    ?C     COCART        Chain     FCRTORDCRT
     C                   DoW       %Found(FCRTORDCRT)
    ?C                   Delete    RCRTORDCRT
    ?C     COCART        Chain     FCRTORDCRT
     C                   EndDo
    ?C     RRN01         Chain     NCR50001
     C                   Eval      COCART = %ABS(COCART)
     C                   Eval      COORD# = %ABS(COORD#)
    ?C                   Write     RCRTORDCRT
     C                   EndIf
    ?C                   Update    NCR50001
    ?C                   ReadC     NCR50001
     C                   EndDo                                                  ?
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01
    ?C                   ENDSL                                                  ?

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

    ?C     *Entry        PList
    ?C                   Parm                    RTN               1

     C                   MOVE      ' '           RTN                            ?Return Code

     C                   MOVE      ##PGM         $#PGMQ                         ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C                   Eval      Today = $Date(0)                             ?Today MDY
     C                   Eval      SDate = $MDYDate($AddDate(Today:1))          ?Ship Date MDY
     C                   Eval      SDateYMD7 = $Date7($AddDate(Today:1))        ?Ship Date YMD7

     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

    ?C                   EndSr                                                  ?
