     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:            Truck Chart Selection and Print                 :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  April 2004           ? Kube-Pak Corporation ?    :
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
     FMMR010FM  CF   E             WORKSTN
     F                                     SFILE(MMR01001:RRN01)
     F                                     DEVID(WSID)
     F*TRR500FM  CF   E             WORKSTN

     FFMMASTSQ  IF   E           K DISK                                         ?Multiple Master

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$isDate#
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$NeedDir

      *? Arrays
     D   Cmd           S            100A   Dim(0002) CtData                     ?System Commands
     D   DAYS          S             10A   Dim(0007) CtData                     ?Days of the Week
     D   WeekDay       S              6S 0 Dim(0007)                            ?Week Days

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
     D   Friday        S               D                                        ?Today
     D   SDate         S              6S 0 Inz(0)                               ?Ship Date MDY
     D   SDateYMD7     S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   ThisMonday    S              6S 0 Inz(0)                               ?Monday ( MDY )
     D   ThisMonCYMD   S              7S 0 Inz(0)                               ?Monday ( CYMD )
     D   ErrCount      S              3S 0 Inz(0)                               ?Error Count
     D   Pink          S              1A   Inz('?')                             ?Color Code for?PINK
     D   SavePRTR      S             10A                                        ?Save Curr PRTR
     D   Command       S            100A   Inz(*Blanks)                         ?System Command
     D   Orders        S                   Like(MMOrders)                       ?Count Orders
     D   X             S              2S 0                                      ?Generic Counter
     D   SavMMName     S                   Like(MMName)                         ?Save Name
     D   MM1Orders     S                   Like(MMOrders)                       ?Total 1 Orders
     D   MM2Orders     S                   Like(MMOrders)                       ?Total 2 Orders
     D   MM1Trays      S                   Like(MMTrays )                       ?Total 1 Trays
     D   MM2Trays      S                   Like(MMTrays )                       ?Total 2 Trays


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
    ?C                   Write     MMR01001F                                   ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     MMR01001C                                    ?
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
    ?C                   Write     MMR01001C                                    ?

      *? Load the Subfile
     C                   Eval      *In28 = *On                                  ?Write w/ SFLNXTCHG
     C                   Z-add     *Zero         RRN01                          ?
RED |C     *LoVal        SetLL     FMMASTSQ                                     ?
    ?C                   Read      FMMASTSQ                                     ?
     C                   Eval      SavMMNAME = MMNAME
PNK |C                   DoW       not %EOF(FMMASTSQ)
     C                   Eval      *In51 = *Off
     C                   Eval      *In52 = *Off
     C                   If        MMNUMB = 99
PNK |C                   ExSr      SQLCount
     C                   Eval      TotalOrd = MMOrders
     C                   Eval      TotalPlg = MMTrays
     C                   Else
     C                   Add       1             RRN01                          ?
     C                   If        RRN01 > 1
     C                   If        MMNAME = SavMMNAME
     C                   Eval      *In51 = *On
     C                   Else
     C                   Eval      *In52 = *On
     C                   Eval      MMTrays  = MM1Trays
     C                   Eval      MMOrders = MM1Orders
     C                   Eval      MM1Trays  = *Zeros
     C                   Eval      MM1Orders = *Zeros
     C                   Eval      SavMMNAME = MMNAME
    ?C                   Write     MMR01001                                     ?
     C                   Eval      *In52 = *Off
     C                   Add       1             RRN01                          ?
     C                   EndIf
     C                   EndIf
PNK |C                   ExSr      SQLCount
    ?C                   Write     MMR01001                                     ?
     C                   Eval      MM1Trays  = MM1Trays  + MMTrays
     C                   Eval      MM1Orders = MM1Orders + MMOrders
     C                   Eval      MM2Trays  = MM2Trays  + MMTrays
     C                   Eval      MM2Orders = MM2Orders + MMOrders
     C                   EndIf
     C                   Eval      *In26 = *On                                  ?
     C                   Eval      *In51 = *Off
    ?C                   Read      FMMASTSQ                                     ?
PNK |C                   EndDo                                                  ?

     C                   Eval      *In52 = *On
     C                   Eval      MMTrays  = MM1Trays
     C                   Eval      MMOrders = MM1Orders
     C                   Eval      MM1Trays  = *Zeros
     C                   Eval      MM1Orders = *Zeros
     C                   Add       1             RRN01                          ?
    ?C                   Write     MMR01001                                     ?
     C                   Eval      MMTrays  = MM2Trays
     C                   Eval      MMOrders = MM2Orders
     C                   Eval      MM2Trays  = *Zeros
     C                   Eval      MM2Orders = *Zeros
     C                   Eval      MMWANTED  = 'GRAND TOT:'
     C                   Eval      *In53 = *On
     C                   Add       1             RRN01                          ?
    ?C                   Write     MMR01001                                     ?
     C                   IF        *In26 = *On                                  ?
    ?C     RRN01         Chain     MMR01001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    MMR01001                                     ?
     C                   Eval      *In53 = *Off
     C                   Eval      *In52 = *Off
     C                   EndIF                                                  ?

     C

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
      *? When Date is invalid
    ?C                   When      not $isDate#(SDATE:'*MDY')                           ?
     C                   Eval      $#MSID = 'MMR0101'
     C                   EXSR      SndError
     C                   Eval      *In26 = *Off                                 ?Do not Display SFL
     C                   ExSr      Scrn01                                       ?
      *? When Date is Changed
    ?C                   When      $DateMDY(SDate) <> $Date(SDateYMD7)             ?
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Previous Week is Requested
    ?C                   When      *In08 = *ON                                  ?
     C                   Eval      SDate=$MDYDate($AddDate($DateMDY(SDate):-7))
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Next Week is Requested
    ?C                   When      *In09 = *ON                                  ?
     C                   Eval      SDate=$MDYDate($AddDate($DateMDY(SDate):7))
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Refresh is Requested
    ?C                   When      *In05 = *ON                                  ?
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? If no Functions, Check for Options and Re-display
    ?C                   OTHER                                                  ?
    ?C                   ReadC     MMR01001
     C                   Eval      *In28 = *On
     C                   DoW       not %EOF(MMR010FM)

    ?C                   Update    MMR01001
     C                   Eval      *In51 = *Off
     C                   Eval      *In52 = *Off
    ?C                   ReadC     MMR01001
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
      *?  :      SQLCount - Record Count Subroutine                 :
      *?  :.........................................................:
    ?C     SQLCount      BegSr                                                  ?

     C                   Z-Add     1             X
     C     MMWANTED      LookUp    DAYS(X)                                90
     C                   Z-add     WeekDAY(X)    MMWANTED#         6 0

     C                   Z-add     *Zero         MMOrders
     C                   Z-add     *Zero         MMTrays

    ?c/exec sql
    ?c+
    ?c+    SELECT  count(OHCUST)
    ?c+    INTO   :MMOrders
    ?c+    FROM    FHORDR
    ?c+    WHERE   OHDTRY = :SDateYMD7
    ?c+      and   OHSTAT = 'A'
    ?c+      and  (OHDTCN = :MMWANTED# or  :MMWANTED  = '*ANY' )
    ?c+      and  (OHCUST between :MMFRCUST and :MMTOCUST
    ?c+                or :MMFRCUST = 0     )
    ?c+      and  (OHSHPC between :MMFRSVIA and :MMTOSVIA
    ?c+                or :MMFRSVIA = ' '   )
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+    SELECT  sum(OIQORD - OIQSHP)
    ?c+    INTO   :MMTrays
    ?c+    FROM    FHORDR, FIORDR
    ?c+    WHERE   OHDTRY = :SDateYMD7
    ?c+      and   OHSTAT = 'A'
    ?c+      and   OIORD# = OHORD#
    ?c+      and   OIDTRQ = OHDTRY
    ?c+      and   OISTAT = 'A'
    ?c+      and  (OHDTCN = :MMWANTED# or  :MMWANTED  = '*ANY' )
    ?c+      and  (OHCUST between :MMFRCUST and :MMTOCUST
    ?c+                or :MMFRCUST = 0     )
    ?c+      and  (OHSHPC between :MMFRSVIA and :MMTOSVIA
    ?c+                or :MMFRSVIA = ' '   )
    ?c+
    ?c/end-exec

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   MOVE      ##PGM         $#PGMQ                         ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C                   Eval      Today = $Date(0)                             ?Today MDY
     C                   Eval      SDate = $MDYDate($Monday(Today:'TUE'))       ?Ship Date MDY
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))          ?Ship Date YMD7

     C                   Eval      Friday = $AddDate($DateMDY(SDate):-3)        ?Friday
     C                   Eval      X = 1
     C                   DoW       X <= 7
     C                   Eval      WeekDay(x) = $MDYDate($AddDate(Friday:X))    ?Populate  MDY
     C                   Eval      X = X + 1
     C                   EndDo

     C                   ExSr      Load01                                       ?
     C                   Eval      $#MSID = 'CPY0000'
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn01                                       ?

    ?C                   EndSr                                                  ?
**
OVRPRTF FILE(MMR010P) PAGESIZE(11 8.5 *UOM) FORMTYPE(*NAR) OVRSCOPE(*JOB) PAGRTT(0) OUTQ(|P
OVRPRTF FILE(MMR010P) PAGESIZE(14 8.5 *UOM) FORMTYPE(*LONG) OVRSCOPE(*JOB) PAGRTT(0) OUTQ(|P
**
&SATURDAY 1
&SUNDAY   2
&MONDAY   3
&TUESDAY  4
&WEDNESDAY5
&THURSDAY 6
&FRIDAY   7
