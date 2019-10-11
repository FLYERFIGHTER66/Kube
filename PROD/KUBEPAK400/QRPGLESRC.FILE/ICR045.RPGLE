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
     FICR045FM  CF   E             WORKSTN
     F                                     SFILE(ICR04501:RRN01)
     F                                     DEVID(WSID)

     FFMSIZE    UF   E           K DISK                                         ?Size Code Master
     FFMSIZC    UF A E           K DISK                                         ?Size Category

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCmdExc

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
     D   GoToSize      S              3                                         ?Go To Size
     D   SaveGoTo      S                   Like(GoToSize)                       ?Saved Go To Size
     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D   ErrCount      S              3S 0 Inz(0)                               ?Error Count
     D   Command       S            100A   Inz(*Blanks)                         ?System Command

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
    ?C                   Write     ICR04501F                                   ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     ICR04501C                                    ?
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
    ?C                   Write     ICR04501C                                    ?

      *? Load the Subfile
     C                   Eval      *In28 = *On                                  ?Write w/ SFLNXTCHG
    ?C     GoToSize      SetLL     FMSIZE                                       ?
    ?C                   Read(N)   FMSIZE

     C                   Z-add     *Zero         RRN01                          ?
     C                   DoW       not %EOF(FMSIZE )
    ?C                   Clear                   RMSIZC
    ?C     SZCODE        Chain(N)  FMSIZC
     C                   Add       1             RRN01                          ?
    ?C                   Write     ICR04501                                     ?
     C                   Eval      *In26 = *On                                  ?
    ?C                   Read      FMSIZE
     C                   EndDo                                                  ?

     C                   IF        *In26 = *On                                  ?
    ?C     RRN01         Chain     ICR04501                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    ICR04501                                     ?
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
      *? If no Functions, Check for GoTo, Update FMSIZE and Redisplay.
    ?C                   OTHER                                                  ?
      *? If enter pressed without GoTo Change then bail out
     C                   ExSr      UpdSize
     C                   If        GoToSize <> SaveGoTo
     C                   Eval      SaveGoTo = GoToSize
     C                   ExSr      Load01
     C                   ExSr      Scrn01
     C                   else
     C                   Eval      *InLr = *On
     C                   EndIf
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      UpdSize  - Update FMSIZE and Subfile               :
      *?  :.........................................................:
    ?C     UpdSize       BegSr                                                  ?

    ?C                   ReadC     ICR04501
     C                   DoW       not %EOF(ICR045FM)
    ?C     SZCODE        Chain     FMSIZE
    ?C     SZCODE        Chain     FMSIZC
    ?C     RRN01         Chain     ICR04501
     C                   If        %found(FMSIZE)
    ?C                   Update    RMSIZE
     C                   EndIF
    ?C                   Select                                                 ?
    ?C                   When      %found(FMSIZC) and SCCATG =  *Blanks          ?
    ?C                   Delete    RMSIZC
    ?C                   When      %found(FMSIZC) and SCCATG <> *Blanks          ?
    ?C                   Update    RMSIZC
    ?C                   When      Not %found(FMSIZC) and SCCATG <> *Blanks          ?
     C                   Eval      SCSIZE = SZCODE
    ?C                   Write     RMSIZC
    ?C                   EndSl
    ?C                   Update    ICR04501
     C                   Eval      *In51 = *Off
     C                   Eval      *In52 = *Off
    ?C                   ReadC     ICR04501
     C                   EndDo                                                  ?

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

    ?C                   EndSr                                                  ?
**
  Put commands here if we need them

