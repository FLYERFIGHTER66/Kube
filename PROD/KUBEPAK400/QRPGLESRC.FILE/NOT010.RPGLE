     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:                      Notes Application                     :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May 2004             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :  This is the NOTES handler program.  It allows the user   ?:
      *? :  to enter/modify notes.  It is a called program with      ?:
      *? :  parameters to identify the NOTE I.D. and mode.  The      ?:
      *? :  NOTE I.D. is a unique I.D. number that identifies the    ?:
      *? :  note.  This I.D. is stored with the the data the note    ?:
      *? :  refers to.  I.E. If it is a vendor note, the NOTE I.D.   ?:
      *? :  would be stored on the Vendor Master or another file     ?:
      *? :  that cross references Vendors to Notes.  The storage of  ?:
      *? :  this association is external to this program and is the  ?:
      *? :  responsibility of the calling program to maintain.  If   ?:
      *? :  the calling program does not pass in a Note I.D., a new  ?:
      *? :  one will be created and passed back in the parameter.    ?:
      *? :  The Mode parameter will direct this program to present   ?:
      *? :  the note data in (C)hange, (I)nquiry, (P)rint, or        ?:
      *? :  "Print & (R)emove blank lines" modes.                    ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :  Scrn01   -?Display Screen 01                             ?:
      *? :  Load01   -?Load Screen 01                                ?:
      *? :  Edit01   -?EDIT Screen 01                                ?:
      *? :  ClrError -?Clear Error Message Subfile                   ?:
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
      *? :  02      ?Change Print Mode                               ?:
      *? :  03      ?Exit                                            ?:
      *? :  05      ?Refresh                                         ?:
      *? :  08      ?Delete Line                                     ?:
      *? :  09      ?Insert Line                                     ?:
      *? :  10      ?Print                                           ?:
      *? :  11      ?Change Printer                                  ?:
      *? :          ?                                                ?:
      *? :  25      ?SFLDSP, SFLDSPCTL, SFLCLR(N)                    ?:
      *? :  26      ?SFLDSP (Subfile has Data)                       ?:
      *? :  27      ?SFLEND                                          ?:
      *? :  28      ?SFLNXTCHG                                       ?:
      *? :  29      ?Overflow for NOT010P                            ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     FNOT010FM  CF   E             WORKSTN
     F                                     SFILE(NOT01001:RRN01)
     F                                     DEVID(WSID)
     FNOT010P   O    E             PRINTER OFLIND(*IN29) USROPN

     FNoteFlPF  IF   E           K DISK                                         ?Notes Files Support
     FNoteKyPF  UF A E           K DISK                                         ?Notes Key File
     FNoteKyNt  IF   E           K DISK    ReName(NoteKey:NoteKeyNt)            ?Notes Key by Note
     FNoteHdPF  UF A E           K DISK                                         ?Note Header
     FNoteDtPF  UF A E           K DISK                                         ?Note Details
     F*NoteTrPF  IF   E           K DISK                                         ?Note Transactions

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Center
    ?D/COPY QFunctDefn,$DftPrt
      *? External Program Prototypes
    ?D/COPY QFunctDefn,QCmdExc

      *? Arrays
     D   Cmd           S            100A   Dim(0001) CtData                     ?System Commands

      *? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

     D  NoteDtl        DS
     D  NoteRcd                      80A   Dim(0320)
     D  NotePage                   1280A   Dim(0020) Overlay(NoteDtl)
     D  NoteChar                      1A   Dim(25600) Overlay(NoteDtl)
     D   Rest          S          25600A                                        ?Balance of Note

      *? Field Definitions
     D   #File         S             10A                                        ?File Note is for
     D   #FileKey      S             25A                                        ?File Key

     D   #NoteID       S              9S 0 Inz(66)                              ?Note ID
     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D   Today         S               D                                        ?Today
     D   ErrCount      S              3S 0 Inz(0)                               ?Error Count
     D   PrtChart      S              3S 0 Inz(0)                               ?Chart Cells Printed
     D   Pink          S              1A   Inz('?')                             ?Color Code for?PINK
     D   #Printer      S             10A                                        ?OverRide to Printer
     D   PrtToUse      S             10A                                        ?OverRide to Printer
     D   PRTDefault    S             10A                                        ?OverRide to Printer
     D   Command       S            100A   Inz(*Blanks)                         ?System Command
     D   HasDetails    S               N   Inz(*Off)                            ?Note Detail Record
     D   NoteLine      S              3S 0 Inz(0)                               ?Work Note Line #
     D   TargetLine    S              3S 0 Inz(0)                               ?Work Note Line #
     D   LPP           S              2S 0 Inz(0)                               ?Lines Per Page Dsp
     D   NoteLine01    S              2S 0 Inz(5)                               ?Dsp line start SFL
     D   #Desc         S             30A                                        ?Header Dft Descript
     D   Char          S              4S 0 Inz(0)                               ?Char Pos in Array
     D   Line          S              3S 0 Inz(0)                               ?Line# being Printed
     D   LastDetail    S                   Like(NoteRcd)                        ?Last Line Printed


     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    1                                            ?
     C                   ExSr      Edit01                                       ?
    ?C     Screen        WhenEq    2                                            ?
     C                   ExSr      Edit02                                       ?
    ?C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
     C                   ExSr      LoadNtSfl                                    ?Load Note Subfile
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     NOT01001F                                   ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     NOT01001C                                    ?
     C                   ExSr      WhereAmI                                     ?Find Cursor
     C                   ExSr      LoadNtAraS                                   ?Load Note Arrays
     C                   ExSr      ClrError                                     ?
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
    ?C                   ExFmt     NOT01002                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *? Load the Note Key Info
     C     NtKey_Key     Chain     NoteKyPF
     C                   If        %Found(NoteKyPF)
     C                   Else
    ?C     *HiVal        SetGT     NoteKyNt                                     ?Note Key by Note
    ?C                   ReadP     NoteKyNt                                     ?
     C                   Eval      NKFILE  = #File
     C                   Eval      NKFKEY  = #FileKey
     C                   Eval      NKNOTE  = NkNote + 1
    ?C                   Write     NoteKey
     C                   Eval      NtNote = NKNOTE
     C                   Eval      NtNote = NKNOTE
     C                   EndIf
     C                   Eval      #NoteID = NkNote                             ?Note I.D. #

      *? Load the Note Header Info
    ?C     #NoteID       Chain     NoteHdPF                                     ?Note Header File
     C                   If        %Found(NoteHdPF)
     C                   Eval      NTITLE = $Center(NTITLE:%Len(NTITLE))
     C                   Else
     C                   Call      'NOT015'
     C                   Parm                    #File
     C                   Parm                    #FileKey
     C                   Parm                    #Desc
     C                   Eval      NTITLE = $Center(%trim(NFHEAD) + ' ' +
     C                               #Desc       :%Len(NTITLE))
     C                   EndIf

    ?C                   ExSr      LoadNtAraF                                   |Load Array fm File

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

    ?C                   SELECT                                                 ?
      *? Change Print Mode
    ?C                   When      *In02 = *ON                                          ?
     C                   ExSr      Scrn02
      *? Exit Requested
    ?C                   When      *In03 = *ON                                          ?
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
      *? Delete Line Requested
    ?C                   When      *In08 = *ON                                          ?
    ?C                   SELECT                                                 ?
    ?C                   When      CSRFLD <> 'NOTE'
     C                   Eval      $#MSID = 'NOT5002'                           ?
     C                   ExSr      SndError                                     ?
    ?C                   Other
     C                   ExSr      DeleteLine
    ?C                   EndSl
     C                   ExSr      Scrn01                                      ?
      *? Insert Line Requested
    ?C                   When      *In09 = *ON                                          ?
    ?C                   SELECT                                                 ?
    ?C                   When      NoteRcd(%elem(NoteRcd)) <> *Blanks                   ?
     C                   Eval      $#MSID = 'NOT5001'                           ?
     C                   ExSr      SndError                                     ?
    ?C                   When      CSRFLD <> 'NOTE'
     C                   Eval      $#MSID = 'NOT5003'                           ?
     C                   ExSr      SndError                                     ?
    ?C                   Other
     C                   ExSr      InsertLine
    ?C                   EndSl
     C                   ExSr      Scrn01                                      ?
      *? Change Printer Requested
    ?C                   When      *In11 = *ON                                          ?
     C                   Call      '#CHGPRT'     #ChgPrt
     C                   If        #Printer <> '*LAST'
     C                   Eval      PrtToUse = #Printer
     C                   EndIf
     C                   ExSr      Scrn01
      *? Refresh Screen Requested
    ?C                   When      *In05 = *ON                                          ?
     C                   ExSr      Load01
     C                   ExSr      Scrn01
      *? When Print is Requested
    ?C                   When      *In10 = *ON                                  ?
     C                   ExSr      PrintAll                                     ?
     C                   ExSr      Scrn01                                       ?
      *? If no Functions, Check for Options and Re-display
    ?C                   OTHER                                                  ?
     C                   ExSr      Update01
     C                   Eval      *InLr = *On
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

     C                   ExSr      Scrn01

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Update01 - Update files with note info             :
      *?  :.........................................................:
    ?C     Update01      BegSr                                                  ?

     C                   Eval      NTITLE = %trim(NTITLE)

     C                   If        %found(NoteHdPF)
    ?C                   Update    NoteHd
     C                   else
     C                   Eval      NtNote = #NoteID
     C                   Eval      NtUser = $User()
     C                   Time                    NtDate
    ?C                   Write     NoteHd
     C                   EndIf

     C                   ExSr      LoadNtAraS

      *? Update the file from the Page Array
     C     Detail_Key    KList
     C                   KFld                    NTNote
     C                   KFld                    NTLine

     C                   Eval      NTLine = 1
     C                   DoW       NTLine <= %elem(NoteRcd)
    ?C     Detail_Key    SetLL     NoteDtPF
     C                   Eval      HasDetails = %equal(NoteDtPF)
    ?C                   SELECT                                                 ?
      *? If the note detail for this line is blank, but a detail record exists, delete it
    ?C                   When      NoteRcd(NTline) = *Blank                      ?
    ?C                             and HasDetails
    ?C     Detail_Key    Chain     NoteDtPF
    ?C                   Delete    NoteDt
      *? If there is detail for this line, but a detail record doesn't exist, write it
    ?C                   When      NoteRcd(NTline) <> *Blank                      ?
    ?C                             and not HasDetails
     C                   Eval      NTDATA = NoteRcd(NTLine)
    ?C                   Write     NoteDt
      *? If there is detail for this line and a detail record exists, update it
    ?C                   When      NoteRcd(NTline) <> *Blank                      ?
    ?C                             and HasDetails
    ?C     Detail_Key    Chain     NoteDtPF
     C                   Eval      NTDATA = NoteRcd(NTLine)
    ?C                   Update    NoteDt
    ?C                   EndSl

     C                   Eval      NTLine = NTLine + 1
    ?C                   EndDo                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      WhereAmI - Figure out where the cursor is          :
      *?  :.........................................................:
    ?C     WhereAmI      BegSr                                                  ?

     C                   If        CSRFLD <> 'NOTE'
temp C                   Z-Add     5             PUTCSRLIN
temp C                   Z-Add     1             PUTCSRPOS
temp C                   Z-Add     1             PUTSFLRRN
     C                   Else
     C                   Eval      PUTCSRLIN = %int(CSRPOS/80) + 5              ?Cursor on Line
     C                   Eval      PUTCSRPOS = 80 * (((CSRPOS/80)               ?Cursor in Position
     C                                       - (%int(CSRPOS/80))))
     C                   Eval      PUTSFLRRN = SFLCSRRRN                        ?Subfile on Page
    ?C                   EndIf                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      LoadNtAraF - Load Note Array from File             :
      *?  :.........................................................:
    ?C     LoadNtAraF    BegSr                                                  ?

      *? Load the Note Arrays
    ?C     #NoteID       SetLL     NOTEDTPF                                     ?Note Details File
    ?C     #NoteID       ReadE(N)  NOTEDTPF                                     ?
     C                   DoW       not %EOF(NOTEDTPF)
     C                   Eval      NoteRcd(NTLine) = NTData
    ?C     #NoteID       ReadE(N)  NOTEDTPF                                     ?
     C                   EndDo

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      LoadNtAraS - Load Note Array from Subfile          :
      *?  :.........................................................:
    ?C     LoadNtAraS    BegSr                                                  ?

      *? Load the Page Array from the Subfile
     C                   ReadC     NOT01001
     C                   DoW       not %eof(NOT010FM)                           ?
     C                   Eval      NotePage(RRN01) = Note
     C                   ReadC     NOT01001
     C                   EndDo                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      LoadNtSfl - Load Note Subfile from Array           :
      *?  :.........................................................:
    ?C     LoadNtSfl     BegSr                                                  ?

      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
    ?C                   Write     NOT01001C                                    ?

      *? Load the Subfile from the Page Array
     C                   Eval      *In28 = *On                                  ?Write w/ SFLNXTCHG

     C                   Z-add     *Zero         RRN01                          ?
     C                   DoW       RRN01 < %elem(NotePage)
     C                   Add       1             RRN01                          ?
     C                   Eval      Note = NotePage(RRN01)
    ?C                   Write     NOT01001                                     ?
     C                   Eval      *In26 = *On                                  ?
     C                   EndDo                                                  ?

    ?C     RRN01         Chain     NOT01001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    NOT01001                                     ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      InsertLine - Insert a blank line at the cursor     :
      *?  :.........................................................:
    ?C     InsertLine    BegSr                                                  ?

     C                   Eval      NoteLine = (SFLCSRRRN * LPP) - LPP + 1       ?First Line / Screen
     C                                          + %int(CSRPOS/80)               ?#Lines down

     C                   Eval      TargetLine = %elem(NoteRcd)
     C                   DoW       TargetLine > NoteLine
     C                   Eval      NoteRcd(TargetLine) = NoteRcd(TargetLine - 1)
     C                   Eval      TargetLine = TargetLine - 1
     C                   EndDo
     C                   Eval      NoteRcd(NoteLine) = *Blanks
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      DeleteLine - Delete the line at the cursor         :
      *?  :.........................................................:
    ?C     DeleteLine    BegSr                                                  ?

     C                   Eval      NoteLine = (SFLCSRRRN * LPP) - LPP + 1       ?First Line / Screen
     C                                          + %int(CSRPOS/80)               ?#Lines down

     C                   DoW       NoteLine < %elem(NoteRcd)
     C                   Eval      NoteRcd(NoteLine) = NoteRcd(NoteLine + 1)
     C                   Eval      NoteLine = NoteLine + 1
     C                   EndDo
     C                   Eval      NoteRcd(%elem(NoteRcd)) = *Blanks
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      PrintAll - Print all Truck Charts                  :
      *?  :.........................................................:
    ?C     PrintAll      BegSr                                                  ?

    ?C                   Eval      *In99 = *Off

     C                   Eval      Command = Cmd(1)
     C                   ExSr      $Command

     C                   If        not %Open(NOT010P)
    ?C                   Open      NOT010P
     C                   EndIf

      *? Set Print Mode
      *?  PtMode = 1 ==> set on *In40 = Print all Lines
      *?  PtMode = 2 ==> set on *In41 = Remove Multiple Blank Lines
      *?  PtMode = 3 ==> set on *In42 = Remove all Blanks
     C                   MoveA     '000'         *In(40)
     C                   Eval      *In(39+PtMode) = *On

      *? Read through Details and Print as appropriate
     C                   Eval      Line = 1
     C                   Eval      Rest = 'First Record'

     C                   DoW       Line <= %elem(NoteRcd)
     C                             and Rest <> *Blanks

      *? Print Header on first detail or on Overflow
     C                   If        not *In99 or *In29
    ?C                   Eval      *In99 = *On
    ?C                   Eval      *In29 = *Off
    ?C                   Write     Header
     C                   EndIf

      *? Print Detail if Appropriate
     C                   If           NoteRcd(Line) <> *Blanks                  ?
     C                             or *In40                                     ?
     C                             or *In41 and LastDetail <> *Blanks           ?
     C                   Eval      DetailLine = NoteRcd(Line)
    ?C                   Write     Detail
     C                   Eval      LastDetail = DetailLine
     C                   EndIf

      *? Check if rest is blank
     C                   Eval      Line = Line + 1
     C                   If        Line <= %elem(NoteRcd)
     C                   Eval      Char = (Line * %len(NoteRcd(1)))
     C                                    - %len(NoteRcd(1)) + 1
     C                   Eval      Rest = *Blanks
     C                   MoveA     NoteChar(Char)Rest
     C                   EndIf

     C                   EndDo

     C                   If        %Open(NOT010P)
    ?C                   Close     NOT010P
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
     C                   Eval      #Printer = PrtToUse
     C                   DoW       %Scan('|P':Command) <> 0
     C                   Eval      Command = %REPLACE
     C                             (%Trim(#Printer): Command :
     C                               %SCAN('|P': Command))
     C                   EndDo

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

     C     *Entry        PList
     C                   Parm                    #File
     C                   Parm                    #FileKey

     C     NtKey_Key     KList
     C                   KFld                    #File
     C                   KFld                    #FileKey

     C     #File         Chain     NoteFlPF
     C                   If        %Found(NoteFlPF)
     C                   Eval      Note01 = $Center(NfTitl:%Len(NfTitl))                 ?
     C                   Else
     C                   Eval      Note01 = 'Notes Application'                 ?
     C                   EndIf

     C     #ChgPrt       PList
     C                   Parm                    User
     C                   Parm                    ##Pgm
     C                   Parm      '*LAST'       #Printer

     C                   MOVE      ##PGM         $#PGMQ                         ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C                   Eval      Today = $Date(0)                             ?Today MDY

     C                   Eval      LPP = %Len(Note) / 80                        ?Lines per Page
temp C                   Z-Add     1             PUTSFLRRN

      *? Get the Current Default Printer
     C                   Eval      PRTDefault = $DftPrt($User():##PGM:'*LAST')
     C                   Eval      PRTToUse = PRTDefault
     C                   Eval      PtMode = 1

     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

    ?C                   EndSr                                                  ?
**
OVRPRTF FILE(NOT010P) PAGESIZE(66) CPI(10) FORMTYPE(*NAR) PAGRTT(0) OVRSCOPE(*JOB) OUTQ(|P~~~~~~~~)
