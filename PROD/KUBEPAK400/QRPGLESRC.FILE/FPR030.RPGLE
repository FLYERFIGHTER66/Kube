     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:            Lookup - All Sizes for Given Item               :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  June 2004            ? Kube-Pak Corporation ?    :
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
      *? :  07      ?Old Exit                                        ?:
      *? :          ?                                                ?:
      *? :  25      ?SFLDSP, SFLDSPCTL, SFLCLR(N)                    ?:
      *? :  26      ?SFLDSP (Subfile has Data)                       ?:
      *? :  27      ?SFLEND                                          ?:
      *? :  28      ?SFLNXTCHG                                       ?:
      *? :  40      ?Lookup Indicator                                ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     FFPR030FM  CF   E             WORKSTN
     F                                     SFILE(FPR03001:RRN01)
     F                                     DEVID(WSID)

     FFFINSCH03 UF A E           K DISK                                         ?Item by Item/Size
     F*FFINSCH   UF A E           K DISK                                         ?Item by Item/Size
     FFMSIZE    IF   E           K DISK                                         ?Size Code Master
     FFMINVT    IF   E           K DISK                                         ?Item Master

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY

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
     D   SaveDate      S                   Like(GotoDate  )                     ?Saved Go to Date
     D   GotoDate7     S                   Like( FLSOWD   )                     ?Saved Go to Date
     D   SaveDate7     S                   Like( FLSOWD   )                     ?Saved Go to Date
     D   SaveItem      S                   Like(GotoItem  )                     ?Saved Go to Item
     D   SaveSize      S                   Like(GotoSize  )                     ?Saved Go to Size
     D   SaveFLSIZE    S                   Like(FLSIZE    )                     ?Saved FLSIZE
     D   SavePLNTNG    S                   Like(GotoPLNTNG)                     ?Saved Go to PLNTNG
     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D   ErrCount      S              3S 0 Inz(0)                               ?Error Count
     D   Command       S            100A   Inz(*Blanks)                         ?System Command

      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    1                                            ?
     C                   ExSr      Edit01                                       ?
    ?C*    Screen        WhenEq    2                                            ?
     C*                  ExSr      Edit02                                       ?
    ?C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     FPR03001F                                   ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FPR03001C                                    ?
     C                   ExSr      ClrError                                     ?
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   Eval      SaveFLSIZE =  *Blanks
      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
    ?C                   Write     FPR03001C                                    ?

      *? Load the Subfile
     C                   Eval      *In28 = *On                                  ?Write w/ SFLNXTCHG
    ?C     GoToKEY       SetLL     FFINSCH03                                    ?
    ?C                   Read(N)   FFINSCH03

     C                   Z-add     *Zero         RRN01                          ?
     C                   DoW       not %EOF(FFINSCH03)

     C                   If        FLSOWD <= GotoDate7 or
     C                             GotoDate = *Zeros
      *? New Size Code
     C                   If        FLSIZE  <>  SaveFLSIZE
     C                   Eval      SaveFLSIZE = FLSIZE
     C                   Add       1             RRN01                          ?
     C                   Eval      FLSOWD6 = $MDYDate($Date(FLSOWD))
    ?C     FLSIZE        Chain     FMSIZE
     C                   Eval      DESC = SZDESC
     C                   Eval      *In61 = *On
    ?C                   Write     FPR03001                                     ?
     C                   Eval      *In61 = *Off
     C                   Eval      *In26 = *On                                  ?
     C                   EndIf

      *? Load Items
     C                   Eval      FLITEM5 = %SubSt(FLITEM:1:5)
     C                   Add       1             RRN01                          ?
    ?C     ItemKey       Chain     FMINVT
     C                   If        %Found(FMINVT)
     C                   Eval      DESC = IMDES1
     C                   Else
     C                   Eval      DESC = 'Item Not Found on Master.'
     C                   EndIf
    ?C                   Write     FPR03001                                     ?
     C                   Eval      *In26 = *On                                  ?
    ?C                   Read      FFINSCH03
     C                   EndIf                                                  ?
     C                   EndDo                                                  ?

      *? Load Empty Lines for on the fly additions
     C                   Clear                   FPR03001
     C                   Eval      *In62 = *On
     C                   Do        10
     C                   Add       1             RRN01                          ?
    ?C                   Write     FPR03001                                     ?
     C                   Eval      *In26 = *On                                  ?
     C                   EndDo                                                  ?
     C                   Eval      *In62 = *Off

     C                   IF        *In26 = *On                                  ?
    ?C     RRN01         Chain     FPR03001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    FPR03001                                     ?
     C                   EndIF                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When      *In03 or *In07
     C                   MOVE      *ON           *INLR                          ?
      *? Select with Mouse Requested
    ?C*                  When      *In10
    ?C*                  If        SFLCSRRRN <> 0
    ?C*    SFLCSRRRN     Chain     FPR03001
     C*                  MOVE      *ON           *INLR                          ?
     C*                  Else
     C*                  Eval      $#MSGD = 'A'
     C*                  Eval      $#MSID = 'MOU0001'
     C*                  EXSR      SndError
     C*                  Eval      *In52 = *On
     C*                  EXSR      Scrn01
     C*                  EndIf
      *? Toggle Edit all Fields indicator (*In30)
    ?C                   When      *In11 and *In30
     C                   Eval      *In30 = *Off
     C                   ExSr      UpdSize
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      *In11 and not *In30
     C                   Eval      *In30 = *On
     C                   ExSr      UpdSize
     C                   ExSr      Load01
     C                   ExSr      Scrn01
      *? If no Functions, Check for GoTo, Update FFINSCH03 and Redisplay.
    ?C                   OTHER                                                  ?
      *? If enter pressed without GoTo Change then bail out
     C                   ExSr      UpdSize
     C*                  If        GotoDate    <> SaveDate   or
     C                   If        GotoItem    <> SaveItem   or
     C                             GotoSize    <> SaveSize   or
     C                             GotoPLNTNG  <> SavePLNTNG
     C                   If        GotoDate   = *Zero
     C                   Eval      GotoDate7  = *Zero
     C                   Else
     C                   Eval      GotoDate7  = $Date7($DateMDY(GotoDate))
     C                   EndIf
     C                   Eval      SaveDate   = GotoDate
     C                   Eval      SaveDate7  = GotoDate7
     C                   Eval      SaveItem   = GotoItem
     C                   Eval      SaveSize   = GotoSize
     C                   Eval      SavePLNTNG = GotoPLNTNG
     C                   ExSr      Load01
     C                   ExSr      Scrn01
     C                   else
     C                   ExSr      Load01
     C                   ExSr      Scrn01
     C                   EndIf
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      UpdSize  - Update FFINSCH03 and Subfile            :
      *?  :.........................................................:
    ?C     UpdSize       BegSr                                                  ?

    ?C                   ReadC     FPR03001
     C                   DoW       not %EOF(FPR030FM)
     C                   Eval      FLITEM = FLITEM5
    ?C     FINKEY        Chain     FFINSCH03
    ?C     RRN01         Chain     FPR03001
     C                   If        %found(FFINSCH03)
     C                   Eval      FLITEM = FLITEM5
     C                   If        FLSOWD6 = *Zeros
     C                   Eval      FLSOWD = *Zeros
     C                   Else
     C                   Eval      FLSOWD = $Date7($DateMDY(FLSOWD6))
     C                   EndIf
    ?C                   ExSr      Confirm                                      ?
    ?C                   Update    RFINSCH
     C                   Else
    ?C     ItemKey       Chain     FMINVT
     C                   If        %Found(FMINVT)
     C                   Eval      DESC   = IMDES1
     C                   Eval      FLSTAT = 'S'
     C                   Eval      FLLOOK = IMLOOK
     C                   Eval      FLORDQ = IMQTAL
     C                   Eval      FLDTLA = $MDYDate($Date(0))
     C                   Eval      FLTIME = $Now()
     C                   Eval      FLUSER = $User()
     C                   Eval      FLPROG = 'FPR030'
    ?C                   ExSr      Confirm                                      ?
     C                   Write     RFINSCH
     C                   Else
     C                   Eval      DESC   = 'Item not Found, not added'
     C                   EndIF
     C                   EndIF
    ?C                   Update    FPR03001
     C                   Eval      *In51 = *Off
     C                   Eval      *In52 = *Off
    ?C                   ReadC     FPR03001
     C                   EndDo                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Confirm  - Confirm Production                      :
      *?  :.........................................................:
    ?C     Confirm       BegSr                                                  ?

     C                   If        FLSOWQ <> *Zero
    ?C                   ExFmt     FPR03002
     C                   If        not *In03
     C                   Eval      FLSTAT = 'C'
     C                   EndIf
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
      *? Format the command String.  Put variable in place in the string.

      *?   |P?=Printer ID?    ?Put the Printer Name in the Override command?
     C*                  Eval      #Printer = PrtToUse
     C*                  DoW       %Scan('|P':Command) <> 0
     C*                  Eval      Command = %REPLACE
     C*                            (%Trim(#Printer): Command :
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

     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

     C     FINKEY        KList
     C                   KFld                    FLSIZE
     C                   KFld                    FLITEM
     C                   KFld                    FLPLT#
     C                   KFld                    FLSOWD

     C     GotoKEY       KList
     C                   KFld                    GotoSize
     C                   KFld                    GotoItem
     C                   KFld                    GotoPLNTNG
     C*                  KFld                    GotoDate7

     C     ItemKey       KList
     C                   KFld                    FLITEM
     C                   KFld                    FLSIZE

    ?C                   EndSr                                                  ?
**
  Put commands here if we need them

