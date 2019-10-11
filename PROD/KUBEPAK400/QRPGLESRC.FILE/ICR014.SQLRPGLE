     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:            Add Vendor Item Cross Reference                 :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Nov. 2009            ? Kube-Pak Corporation ?    :
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
     FICR014FM  CF   E             WORKSTN
     F                                     DEVID(WSID)

     FFMINVTVENDUF A E           K DISK                                         ?Vendor Item X-Ref
     FFMINVT    IF   E           K DISK    Prefix(ITM_)                         ?Item Master
     FFMVEND    IF   E           K DISK                                         ?Vendor Master

      *? Function Prototypes
    ?D*COPY QFunctDefn,$Date

      *? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

     D LDA_DS          DS                  DTAARA(*LDA)
     D  UDSEXT              1000   1000
     D  UDSDAT              1001   1004P 0
     D  UDSTRK              1005   1008

      *? Field Definitions
     D   ErrCount      S              3S 0 Inz(0)                               ?Error Count
     D   X             S              2S 0                                      ?Generic Counter

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
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     ICR01401                                     ?
     C                   ExSr      ClrError                                     ?
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *? Get KP Item Description
    ?C     ITM_IMITEM    Chain     FMINVT
     C                   If        not %Found(FMINVT)
     C                   Eval      ITM_IMDES1 = 'Item Master Record not Created'
     C                   Eval      ITM_IMDES2 = *Blanks
     C                   EndIf

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

    ?C     VIVEND        Chain     FMVEND
    ?C     ItemVend      SetLL     FMINVTVEND                                   ?
    ?C     ItemVend      KList                                                  ?
    ?C                   KFld                    ITM_IMITEM                     ?
    ?C                   KFld                    VIVEND

    ?C                   SELECT                                                 ?
      *? Exit Requested
    ?C                   When      *In03 = *ON                                          ?
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
      *? Lookup Vendor
    ?C                   When      *In04 = *ON                                          ?
     C                   MOVEL     VMNAME        VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    IMCOMP            2 0
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     VMVEND        VIVEND
     C                   ExSr      Scrn01                                       ?
      *? Import Requested
    ?C                   When      *In09 = *ON                                          ?
    ?C     VIITEM        Chain     FMINVT
     C                   Eval      VIDES1 = ITM_IMDES1
     C                   Eval      VIDES2 = ITM_IMDES2
     C                   If        VIVITM = *Blanks
     C                   Eval      VIVITM = %Trim(ITM_IMITEM)+'-CUT'
     C                   EndIf
     C                   ExSr      Scrn01                                       ?
      *? Check for Valid Vendor
    ?C                   When      not %Found(FMVEND)                                   ?
     C                   Eval      $#MSID = 'ICR0141'
     C                   EXSR      SndError
     C                   ExSr      Scrn01                                       ?
      *? Check for Blank Vendor Item Number
    ?C                   When      VIVITM = *Blanks
     C                   Eval      $#MSID = 'ICR0142'
     C                   EXSR      SndError
     C                   ExSr      Scrn01                                       ?
      *? Check for Blank Vendor Item Description
    ?C                   When      VIDES1 = *Blanks and VIDES2 = *Blanks
     C                   Eval      $#MSID = 'ICR0143'
     C                   EXSR      SndError
     C                   ExSr      Scrn01                                       ?
      *? Check for Cross Reference already exists
    ?C                   When      %Equal(FMINVTVEND)                               ?
     C                   Eval      $#MSID = 'ICR0144'
     C                   EXSR      SndError
     C                   ExSr      Scrn01                                       ?
    ?C                   OTHER                                                  ?
     C                   Eval      *InLR = *On
     C                   Eval      VISTAT = 'A'
     C                   Eval      VIITEM = ITM_IMITEM
    ?C                   Write     RMINVTVEND
     C                   LeaveSR                                                ?
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
    ?C                   Parm                    ITM_IMITEM

     C                   MOVE      ##PGM         $#PGMQ                         ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

    ?C                   EndSr                                                  ?
