     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:              Print Setdown for Truck Orders                :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  April 2004           ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This is a re-write of a program of the same name.       ?:
      *? : This program generates a report which shows, by item,     ?:
      *? : how much of the selected item goes on each truck.         ?:
      *? :                                                           ?:
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
      *? :  $JobNbr     -?Return current Job Number                  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  11      ?Overflow indicator                              ?:
      *? :  12      ?First Page indicator                            ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFIORDRL6  UF   E           K DISK
     FFIORDR    IF   E           K DISK    Prefix(Dtl)
     FSCR420    UF A E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFTRSCHL1  IF   E           K DISK
     FFTRSCHDT  IF   E           K DISK
     F                                     RENAME(RTRSCHD:RTRSCHD2)
     FSCR420P   O    E             PRINTER OFLIND(*IN11)


      *?  LDA
     D                UDS
     D  RUNST                  1      1
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  VOUT                 131    131  0
     D  LCANCL               133    133

      *? Fields
     D  CountStops     S              3S 0 INZ(1)
     D  SVTRK#         S              4A                                        ?Saved Truck Number

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Job
    ?D/COPY QFunctDefn,$JobNbr

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

    ?C     LOCKEY        SetLL     FIORDRL6
    ?C     LOCKEY        ReadE     FIORDRL6

     C                   DoW       not %EOF(FIORDRL6)

    ?C     DetailKey     SetLL     FIORDR
     C                   If        not %Equal(FIORDR)
    ?C                   Delete    RIORDRWK
    ?C     LOCKEY        ReadE     FIORDRL6
     C                   Iter
     C                   EndIF

      *? Get Customer Information
    ?C     OICUST        Chain     FMCUST                             92
     C                   MOVEL     CMNAME        NAME

      *? Get Truck Schedule Information
     C                   MOVE      OICUST        CUST              6 0
     C                   Eval      *In91 = *Off
     C                   Reset                   CountStops
     C                   Eval      TRTRK# = *Blanks
     C                   Eval      TRSTOP = *Zeros
    ?C     TRKKEY        Chain     FTRSCHL1                           91
     C                   If        %Found(FTRSCHL1)
     C                   MOVEL     TRTRK#        LOCAT             8
     C                   MOVE      TRSTOP        LOCAT             8
      *? Get Actual Stop Number
    ?C     TRKDAT        SETLL     FTRSCHDT
    ?C     TRKDAT        READE     FTRSCHDT
     C                   DOW       not %EOF(FTRSCHDT)
     C                             and TRCUST <> CUST
     C                   Eval      CountStops = CountStops + 1                  ?COUNT STOPS
    ?C     TRKDAT        READE     FTRSCHDT
     C                   EndDo
     C                   MOVE      CountStops    LOCAT             8
     C                   EndIf

      *? If it's the First Page OR an Overflow, then write the Report Header
     C                   If        *In11 or not *In12
    ?C                   WRITE     HEADER
     C                   Eval      *IN11 = *Off
     C                   Eval      *In12 = *On
     C                   EndIf

      *? Add to Quantities
     C                   Z-ADD     OIQORD        QTYORD            6 0
     C                   ADD       OIQORD        TOTQTY            9 0

      *? Write Details and Update Files
    ?C                   WRITE     TMP_DETAIL
     C                   MOVE      'Y'           OIPRTD
    ?C                   UPDATE    RIORDRWK

      *? Get the Next  Order
    ?C     LOCKEY        ReadE     FIORDRL6
     C                   EndDo

      *? After all details are printed, Print Totals and Bail
     C                   Eval      *In91 = *Off
     C                   If        TOTQTY > 0
    ?C     TempKey       SetLL     SCR420
    ?C     TempKey       ReadE     SCR420
     C                   Eval      SVTRK# = TRTRK#
     C                   DoW       not %EOF(SCR420)
     C                   If        TRTRK# <> SVTRK#
     C                   Eval      *In92 = *On
     C                   Eval      SVTRK# = TRTRK#
     C                   Else
     C                   Eval      *In92 = *Off
     C                   EndIf
    ?C                   WRITE     DETAIL
    ?C                   DELETE    TMP_DETAIL
    ?C     TempKey       ReadE     SCR420
     C                   EndDo

    ?C                   Write     TOTAL
     C                   Else
    ?C                   Write     NODATA
     C                   EndIf

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    STDATE            8
     C                   PARM                    #ITEM#           12
     C                   PARM                    #SIZE#            3

     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0

     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVE      STDATE        CLDATE
     C     CLDATE        MULT      100.0001      CLDATE            6 0
     C                   MOVE      STDATE        STRDAT            7 0
     C                   MOVEL     1             STRDAT
     C                   MOVEL     #ITEM#        ITEM#            12
     C                   MOVEL     #ITEM#        ITEM              6
     C                   MOVEL     #SIZE#        SIZE              3
     C     ITMKEY        Chain     FMINVT

     C                   Eval      UserID = $User()
     C                   Eval      Job    = $Job()
     C                   Eval      JobNbr = $JobNbr()

      * ?KLIST for file - FIORDR  Library - *LIBL     ?
     C     DetailKey     KLIST
     C                   KFLD                    OIORD#
     C                   KFLD                    OISEQ#

      * ?KLIST for file - FMINVT  Library - *LIBL     ?
     C     ITMKEY        KLIST
     C                   KFLD                    ITEM#
     C                   KFLD                    SIZE

      * ?KLIST for file - FMTRUCK Library - *LIBL     ?
     C     TRKKEY        KLIST
     C                   KFLD                    OIRVDT
     C                   KFLD                    OICUST
     C     TRKDAT        KLIST
     C                   KFLD                    TRTRK#
     C                   KFLD                    TRSHDT

      * ?KLIST for file - FIORDRL6 Library - *LIBL     ?
     C     LOCKEY        KLIST
     C                   KFLD                    STRDAT
     C                   KFLD                    ITEM#
     C                   KFLD                    SIZE

      * ?KLIST for file - SCR420   Library - *LIBL     ?
     C     TempKey       KLIST
     C                   KFLD                    USERID
     C                   KFLD                    JOB
     C                   KFLD                    JOBNBR
     C                   KFLD                    TDATE
     C                   KFLD                    ITEM
     C                   KFLD                    IMSIZE

     C                   EndSR
