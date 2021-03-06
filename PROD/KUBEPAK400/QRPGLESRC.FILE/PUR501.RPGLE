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
     FPUR501FM  CF   E             WORKSTN
     F                                     SFILE(PUR50101:RRN01)
     F                                     DEVID(WSID)

     FFPUHDRH1  UF A E           K DISK                                         ?Item by Item/Size

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$AddDate
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

      *? Buttons
     D BDateDS         DS
     D BDate1                         5A
     D BDate2                         5A
     D BDate3                         5A
     D BDate4                         5A
     D BDate5                         5A
     D BDate6                         5A
     D BDate7                         5A
     D BDateARA                       5A   DIM(7) Overlay(BDateDS )             Button Dates
     D BDates          S               D   DIM(7)                               Button Dates
     D WkD             S               D
     D ShpWeek         S               D

      *? Field Definitions
     D   GotoDate7     S                   Like( THSHDT   )                     ?Go to Date 7
     D   SaveDate      S                   Like(GotoDate  )                     ?Saved Go to Date
     D   SaveTHTRK#    S                   Like(GotoTHTRK#)                     ?Saved Go to Route
     D   X             S              1S 0                                      ?Generic Counter

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
    ?C                   Write     PUR50101F                                   ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     PUR50101C                                    ?
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
    ?C                   Write     PUR50101C                                    ?

      *? Load the Subfile
     C                   Eval      *In28 = *On                                  ?Write w/ SFLNXTCHG
     C                   ExSr      Buttons
    ?C     GoToKEY       SetLL     FPUHDRH1
    ?C     GotoDate7     ReadE(N)  FPUHDRH1

      *? Load Schedules
     C                   Z-add     *Zero         RRN01                          ?
     C                   DoW       not %EOF(FPUHDRH1)
     C                   Add       1             RRN01                          ?
    ?C                   Write     PUR50101                                     ?
     C                   Eval      *In26 = *On                                  ?
    ?C     GotoDate7     ReadE(N)  FPUHDRH1
     C                   EndDo                                                  ?

      *? Set Last Record
     C                   IF        *In26 = *On                                  ?
    ?C     RRN01         Chain     PUR50101                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    PUR50101                                     ?
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
      *? If no Functions, Check for GoTo, Update FPUHDRH1 and Redisplay.
    ?C                   OTHER                                                  ?
      *? If enter pressed without GoTo Change then bail out
     C                   ExSr      UpdSize

     C                   If        *In10 and SFLCSRRRN <> 0
    ?C     SFLCSRRRN     Chain     PUR50101
    ?C                   ExSr      ViewTruck                                    ?
     C                   EndIf

     C                   If        SelDate <> 0
     C                   Eval      GotoDate = $MDYDate(BDates(SelDate))
     C                   EndIf

     C                   If        WeekMinus <> 0
     C                   Eval      GotoDate =
     C                             $MDYDate($AddDate($DateMDY(GotoDate):-7))
     C                   EndIf

     C                   If        WeekPlus  <> 0
     C                   Eval      GotoDate =
     C                             $MDYDate($AddDate($DateMDY(GotoDate): 7))
     C                   EndIf

     C                   If        GotoDate    <> SaveDate   or
     C                             GotoTHTRK#  <> SaveTHTRK#
     C                   Eval      SaveDate   = GotoDate
     C                   Eval      SaveTHTRK# = GotoTHTRK#
     C                   Eval      GotoDate7 = $Date7($DateMDY(GotoDate))
     C                   EndIf

     C                   ExSr      Load01
     C                   ExSr      Scrn01

    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      UpdSize  - Update FPUHDRH1 and Subfile             :
      *?  :.........................................................:
    ?C     UpdSize       BegSr                                                  ?

     C                   If        *In26
    ?C                   ReadC     PUR50101
     C                   DoW       not %EOF(PUR501FM)
    ?C     FINKEY        Chain     FPUHDRH1
    ?C     RRN01         Chain     PUR50101
    ?C                   Update    RPUHDRH
     C                   Eval      *In51 = *Off
     C                   Eval      *In52 = *Off
    ?C                   ReadC     PUR50101
     C                   EndDo                                                  ?
     C                   EndIf                                                  ?

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
      *?  :      Buttons - Populate Buttons Subroutine              :
      *?  :.........................................................:
    ?C     Buttons       BegSr                                                  ?

     C                   Eval      ShpWeek = $Monday($DateMDY(GOTODATE):'MON')
     C                   Eval      WkD = $AddDate(ShpWeek:-1)

     C                   Eval      X = 0
     C                   DoU       X >= 7
     C                   Eval      X = X + 1
     C                   Eval      BDateARA(x) = %Subst(%EditW($MDYDate
     C                                   ($AddDate(WkD:x)):'  /  /  '):1:5)
     C                   Eval      BDates(x) = $AddDate(WkD:x)
     C                   EndDo

     C                   ENDSR

      *?  ...........................................................
      *?  :      ViewTruck - Print Chart for Selected Truck         :
      *?  :.........................................................:
    ?C     ViewTruck     BegSr                                                  ?

     C                   IN        LDA_DS
     C                   Eval      *InU8 = *On
     C                   Eval      UDSTRK = THTRK#
     C                   Eval      UDSDAT = GotoDate7
     C                   Eval      UDSEXT = 'Y'
     C                   OUT       LDA_DS
     C                   Call      'PUR500'
     C                   Eval      UDSEXT = ' '

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   MOVE      ##PGM         $#PGMQ                         ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C     FINKEY        KList
     C                   KFld                    THSHDT
     C                   KFld                    THTRK#

     C     GotoKEY       KList
     C                   KFld                    GotoDate7
     C                   KFld                    GotoTHTRK#

     C                   Eval      GotoDate7 = $Date7($AddDate($Date(0):1))
     C                   Eval      GotoDate  = $MDYDate($AddDate($Date(0):1))

     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

    ?C                   EndSr                                                  ?
**
  Put commands here if we need them

