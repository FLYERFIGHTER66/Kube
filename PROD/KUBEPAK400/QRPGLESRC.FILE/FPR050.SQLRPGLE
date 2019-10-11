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
     FFPR050FM  CF   E             WORKSTN
     F                                     SFILE(FPR05001:RRN01)
     F                                     DEVID(WSID)

     FFFINLOC01 UF A E           K DISK
     FFFINLOC   UF   E           K DISK    Rename(RFINLOC:NEXTSEQR)
     F                                     Prefix(SEQ_)
     F*FFINSCH   UF A E           K DISK                                         ?Item by Item/Size
     FFMSIZE    IF   E           K DISK                                         ?Size Code Master
     FFMINVT    IF   E           K DISK                                         ?Item Master
     FFCSECTL1  IF   E           K DISK                                         ?Greenhouse Descript

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$DftPrt
     D PLANTING        PR                  ExtPgm('FCR500CL')
     D  #SelTag#                      8P 0 const
     D  #SelSect                      2P 0 const
     D  #SelBay                       2P 0 const
     D  #SelNorS                      1A   const
     D  #SelEorW                      1A   const
     D  #Printer                     10A   const
     D BAYSHEET        PR                  ExtPgm('FPR102CL')
     D  #SelSect                      2P 0 const
     D  #SelBay                       2P 0 const
     D  #SelNorS                      1A   const
     D  #SelEorW                      1A   const
     D  #Printer                     10A   const

      *? Arrays
     D   Cmd           S            100A   Dim(0002) CtData                     ?System Commands

      *? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

     D*LDA_DS          DS                  DTAARA(*LDA)
     D* UDSEXT              1000   1000
     D* UDSDAT              1001   1004P 0
     D* UDSTRK              1005   1008

     D Location        DS                  INZ
     D   SSECT
     D   SBAY
     D   SNORS
     D   SEORW

      *? Field Definitions
     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D   ErrCount      S              3S 0 Inz(0)                               ?Error Count
     D   Command       S            100A   Inz(*Blanks)                         ?System Command
     D   FirstTime     S               N   Inz(*On)                             ?First Time Screen
     D   SaveLocation  S                   Like(Location)                       ?Saved Location
     D   ItemSize      S             15A                                        ?SQL: Item || Size

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
     C                   Eval      SaveLocation = Location
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     FPR05001F                                   ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FPR05001C                                    ?
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
    ?C                   Write     FPR05001C                                    ?

      *? Load the Subfile
     C                   Eval      *In28 = *On                                  ?Write w/ SFLNXTCHG
     C                   If        FirstTime
    ?C     *LoVal        SetLL     FFINLOC01                                    ?
    ?C                   Read(N)   FFINLOC01
     C                   Eval      FirstTime = *Off
     C                   Eval      SSECT = FLSECT
     C                   Eval      SBAY  = FLBAY
     C                   Eval      SNORS = FLNORS
     C                   Eval      SEORW = FLEORW
     C                   Else
    ?C     LocKey        KList
    ?C                   KFld                    SSECT
    ?C                   KFld                    SBAY
    ?C                   KFld                    SNORS
    ?C                   KFld                    SEORW
    ?C     LocKey        SetLL     FFINLOC01                                    ?
    ?C     LocKey        ReadE(N)  FFINLOC01
     C                   EndIf

     C                   Z-add     *Zero         RRN01                          ?
     C                   DoW       not %EOF(FFINLOC01)

      *? Load Items
     C                   Eval      FLITEM5 = %SubSt(FLITEM:1:5)
     C                   Add       1             RRN01                          ?
    ?C     ItemKey       Chain     FMINVT
     C                   If        %Found(FMINVT)
     C                   Eval      DESC = IMDES1
     C                   Else
     C                   Eval      DESC = 'Item Not Found on Master.'
     C                   EndIf
    ?C                   Write     FPR05001                                     ?
     C                   Eval      *In26 = *On                                  ?
    ?C     LocKey        ReadE(N)  FFINLOC01
     C                   EndDo                                                  ?

      *? Load Empty Lines for on the fly additions
     C                   Clear                   FPR05001
     C                   Eval      *In62 = *On
     C                   Do        18
     C                   Add       1             RRN01                          ?
    ?C                   Write     FPR05001                                     ?
     C                   Eval      *In26 = *On                                  ?
     C                   EndDo                                                  ?
     C                   Eval      *In62 = *Off

     C                   IF        *In26 = *On                                  ?
     C                   Eval      *In62 = *On
    ?C     RRN01         Chain     FPR05001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    FPR05001                                     ?
     C                   Eval      *In62 = *Off
     C                   EndIF                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When      *In03
     C                   MOVE      *ON           *INLR                          ?
      *? Reposition
    ?C                   When      *In07 or *In08 or *In09 or *IN10
      *? Plus or Minus Bay
    ?C   07BAYKEY        SetLl     FFINLOC01
    ?C   07              ReadP     FFINLOC01
    ?C   08BAYKEY        SetGt     FFINLOC01
    ?C   08              Read      FFINLOC01
      *? Plus or Minus Section
    ?C   09SECKEY        SetLl     FFINLOC01
    ?C   09              ReadP     FFINLOC01
    ?C   10SECKEY        SetGt     FFINLOC01
    ?C   10              Read      FFINLOC01
     C                   If        not %EOF(FFINLOC01)
     C                   Eval      SSECT = FLSECT
     C                   Eval      SBAY  = FLBAY
     C                   Eval      SNORS = FLNORS
     C                   Eval      SEORW = FLEORW
     C                   ExSr      Load01
     C                   EndIf
     C                   ExSr      Scrn01
      *? Delete Current Record
    ?C                   When      *In23
    ?C     SFLCSRRRN     Chain     FPR05001
    ?C     FLTAG#        Chain     FFINLOC
     C                   If        %Found(FFINLOC)
    ?C                   Delete    NEXTSEQR
    ?C                   Clear                   FPR05001
    ?C                   Update    FPR05001
     C                   EndIf
     C                   ExSr      Scrn01
      *? Print Bay Location Tags
    ?C                   When      *In05
      /Free
         PLANTING(0:SSECT:SBAY:SNORS:SEORW:PRINTTAG);
         ExSr Scrn01;
      /End-Free
      *? Print Bay Sheet
    ?C                   When      *In17
      /Free
         BAYSHEET(SSECT:SBAY:SNORS:SEORW:PRINTBAY);
         ExSr Scrn01;
      /End-Free
      *? Print Individual Location Tag
    ?C                   When      *In06
      /Free
    ?    Chain SFLCSRRRN FPR05001;
         If FLTAG# <> 0;
           PLANTING(FLTAG#:0:0:*Blank:*Blank:PRINTTAG);
         EndIf;
         ExSr Scrn01;
      /End-Free
      *? Change Printer Requested
    ?C                   When      *In11
      /Free
         PRINTTAG = $ChgPrt($User():'FPR050_1  ':PRINTTAG);
         ExSr Scrn01;
      /End-Free
    ?C                   When      *In12
      /Free
         PRINTBAY = $ChgPrt($User():'FPR050_2  ':PRINTBAY);
         ExSr Scrn01;
      /End-Free
      *? If no Functions, Check for GoTo, Update FFINLOC and Redisplay.
    ?C                   OTHER                                                  ?
      *? If enter pressed without GoTo Change then bail out
     C                   If        SaveLocation <> Location
     C                   ExSr      CheckLocation
     C                   ExSr      Load01
     C                   ExSr      Scrn01
     C                   Else
     C                   ExSr      UpdSize
     C                   ExSr      Load01
     C                   ExSr      Scrn01
     C                   EndIf
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      UpdSize  - Update FFINLOC and Subfile              :
      *?  :.........................................................:
    ?C     UpdSize       BegSr                                                  ?

    ?C                   ReadC     FPR05001
     C                   DoW       not %EOF(FPR050FM)
      /Free
         If FLTOTP = 0;
           Exec SQL
             SELECT ( SZCUBF * :FLQTY ) / 200
             INTO   :FLTOTP
             FROM    FMSIZE
             WHERE   SZCODE = :FLSIZE;
           Update FPR05001;
           Chain RRN01 FPR05001;
         EndIf;
         If FLITEM5 = ' ' and UPCSCAN <> 0;
           Exec SQL
             SELECT  UPCITEM||UPCSIZE
             INTO   :ITEMSIZE
             FROM    FMUPC
             WHERE   UPCCODE = :UPCSCAN;
             FLITEM5 = %SubSt(ITEMSIZE:01:5);
             FLSIZE  = %SubSt(ITEMSIZE:13:3);
           Update FPR05001;
           Chain RRN01 FPR05001;
         EndIf;
      /End-Free
     C                   Eval      FLITEM = FLITEM5
    ?C     FINKEY        Chain     FFINLOC01
    ?C     RRN01         Chain     FPR05001
     C                   If        %found(FFINLOC01)
     C                   Eval      FLITEM = FLITEM5
    ?C                   Update    RFINLOC
     C                   Else
    ?C     ItemKey       Chain     FMINVT
     C                   If        %Found(FMINVT)
     C                   Eval      DESC   = IMDES1
     C                   Eval      FLGHSE = %INT((SSECT+4)/5)
     C                   Eval      FLSECT = SSECT
     C                   Eval      FLBAY  = SBAY
     C                   Eval      FLNORS = SNORS
     C                   Eval      FLEORW = SEORW
     C     *HiVal        SetGt     FFINLOC
     C                   ReadP     FFINLOC
     C                   Eval      FLTAG# = SEQ_FLTAG# + 1
    ?C                   Write     RFINLOC
    ?C                   Unlock    FFINLOC
     C                   Else
     C                   Eval      DESC   = 'Item not Found, not added'
     C                   EndIF
     C                   EndIF
    ?C                   Update    FPR05001
     C                   Eval      *In51 = *Off
     C                   Eval      *In52 = *Off
    ?C                   ReadC     FPR05001
     C                   EndDo                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      CheckLocation - Validate Greenhouse Location       :
      *?  :.........................................................:
    ?C     CheckLocation BegSr

    ?C     BAYKEY        Chain     FCSECTL1
     C                   If        not %Found(FCSECTL1)
     C                   Eval      Location = SaveLocation
     C                   Eval      $#MSID = 'FPR0001'
     C                   ExSr      SndError
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
      /Free
          PRINTTAG = $DftPrt('*NONE':'FPR050_1':'*PGM');
          PRINTBAY = $DftPrt('*NONE':'FPR050_2':'*PGM');
      /End-Free

     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

     C     SECKEY        KList
     C                   KFld                    FLSECT

     C     BAYKEY        KList
     C                   KFld                    sSECT
     C                   KFld                    sBAY
     C                   KFld                    sNORS
     C                   KFld                    sEORW

     C     FINKEY        KList
     C                   KFld                    FLSECT
     C                   KFld                    FLBAY
     C                   KFld                    FLNORS
     C                   KFld                    FLEORW
     C                   KFld                    FLSRTP
     C                   KFld                    FLENDP
     C                   KFld                    FLITEM
     C                   KFld                    FLSIZE
     C                   KFld                    FLCUST
     C                   KFld                    FLPLTG

     C     ItemKey       KList
     C                   KFld                    FLITEM
     C                   KFld                    FLSIZE

    ?C                   EndSr                                                  ?
**
  Put commands here if we need them

