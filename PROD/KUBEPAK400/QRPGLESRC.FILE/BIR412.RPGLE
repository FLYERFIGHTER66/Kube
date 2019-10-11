      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1995
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.      ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES INC.      215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- BIR410  -  OPEN ORDERS BY REQ. SHIP DATE
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT SYSTEM
      **DESCRIPTION--------- OPEN ORDERS LISTED BY REQUESTED SHIP DATE
      **
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  1/19/01 EFD ADD LOCATION RANGE AND PRINT LOCATION
      *
     FFIORDRSL  IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFARHST    IF   E           K DISK
     FBIR412    O    F  132        PRINTER OFLIND(*INOF)
      *
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND
      *** MESSAGE ARRAY
     D MSG             S             30    DIM(3) CTDATA PERRCD(1)              MESSAGE
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
     D                UDS
     D  LCO                    1      2  0
     D  LBDATE                 3      8  0
     D  LEDATE                 9     14  0
     D  LPC1                  15     16
     D  LPC2                  17     18
     D  LBSHFR                19     21
     D  LESHFR                22     24
     D  LBEGDT                25     29  0
     D  LENDDT                30     34  0
     D  LDOS                  35     35
     D  LBSVIA                36     37
     D  LESVIA                38     39
     D  FRMLOC                40     41
     D  TOLOC                 42     43
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
WJB  D  LX1521               172    172
WJB  D  LMASTER              173    174  0

     D  SDateYMD7                     7S 0
     D  Included                       N                                        Included in Master

     C*
      *
MJT01C                   Z-ADD     LBDATE        ##MDY
MJT01C                   CALL      '@DT@A1'
MJT01C                   PARM                    ##MDY             6 0          DATE MDY
MJT01C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
MJT01C                   PARM                    ##ERR             1            ERROR IF = Y
MJT01C                   Z-ADD     ##CYMD        LBDAT7            7 0
MJT01C                   Z-ADD     LEDATE        ##MDY
MJT01C                   CALL      '@DT@A1'
MJT01C                   PARM                    ##MDY             6 0          DATE MDY
MJT01C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
MJT01C                   PARM                    ##ERR             1            ERROR IF = Y
MJT01C                   Z-ADD     ##CYMD        LEDAT7            7 0
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     *ZEROS        KEY               2 0
     C     KEY           CHAIN     FMCOMP                             88
     C                   Z-ADD     1             FIRST             4 0
     C     LBDATE        IFEQ      *ZEROS
     C                   SETON                                        65
     C                   ENDIF
     C     LPC1          IFGT      *BLANKS
     C                   SETON                                        60
     C                   ENDIF
     C     LBSHFR        IFGT      *BLANKS
     C     LESHFR        ORGT      *BLANKS
     C                   SETON                                        62
     C                   ENDIF
      *
     C     FRMLOC        IFGT      *BLANKS
     C     TOLOC         ORGT      *BLANKS
     C                   SETON                                        63
     C                   ENDIF
     C                   MOVE      *BLANKS       OLOC              2
     C                   MOVEL     MSG(1)        LDESC            30
     C                   SETON                                        OF
      *
     C     LBDAT7        SETLL     FIORDRSL
      *
     C     NXT           TAG
     C                   READ      FIORDRSL                               77
     C   77              GOTO      END
      *
     C     BIN           IFNE      OLOC
     C                   SETON                                        OF
     C     BIN           IFEQ      '  '
     C                   MOVEL     MSG(1)        LDESC            30
     C                   END
     C     BIN           IFEQ      ' 1'
     C                   MOVEL     MSG(2)        LDESC
     C                   END
     C     BIN           IFEQ      ' 2'
     C                   MOVEL     MSG(3)        LDESC
     C                   END
     C                   MOVEL     BIN           OLOC              2
     C                   END                                                    BIN >< OLOC
      *
     C   55OIITEM        IFNE      SAVITM
     C     L1OPN         ANDGT     *ZEROS
     C     OISIZE        ORNE      SAVSIZ
     C     L1OPN         ANDGT     *ZEROS
     C   OF              DO
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    DETLS
     C                   ENDIF
      *
      * NEW SHIP DATE
      *
     C   55OIDTRQ        IFNE      SAVDTE
     C     ORDTOT        ANDNE     *ZEROS
     C                   EXCEPT    TL1
     C                   ENDIF
      *
      * ACTIVE ORDER
      *
     C     OISTAT        IFEQ      'D'
     C     OIDTRQ        OREQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
      *  CHECK TO SEE IF COMMENT, FRT CHARGE OR SPECIAL CHARGE
      *
     C     OIITYP        IFEQ      'C'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'S'
     C                   GOTO      NXT
     C                   ENDIF
     C     OISEQ#        IFGT      989
     C                   GOTO      NXT
     C                   ENDIF
     C   65              GOTO      NODT
      *
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        CDATE             7 0
     C*                    CALL '@DT@B1'
     C*                    PARM           ##CYMD  70       DATE MDY
     C*                    PARM           ##DDD   50       DATE CYYMMDD
     C*                    PARM           ##ERR   1        ERROR IF = Y
     C*                    Z-ADD##DDD     ODATE   50
MJT01C     CDATE         IFGT      LEDAT7
     C                   GOTO      END
     C                   ENDIF
     C     NODT          TAG
      *
      * CHECK FROM LOCATIONS
      *
     C   62OISHFR        IFLT      LBSHFR
     C     OISHFR        ORGT      LESHFR
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK PUT DOWN LOCATIONS
      *
     C                   MOVE      OIBIN#        BIN               2
     C   63BIN           IFLT      FRMLOC
     C     BIN           ORGT      TOLOC
     C                   GOTO      NXT
     C                   ENDIF
      *
      ****** CHECK IF QTY SHIPPED >= QTY ORDERED, DO NOT PRINT
      *
     C     OIQSHP        IFGE      OIQORD
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OIORD#        CHAIN     FHORDR                             11
      *
      * CHECK IF THIS IS A QUOTE, IF SO, DO NOT PRINT
      *
     C     OHQUOT        IFEQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
    ? *  -  Check Multiple Master
     C                   SetOff                                       8182
     C                   If        LMASTER <> 0
    ?C                   Call      'MMR015'
    ?C                   Parm      OHORD#        ORDER             6 0
    ?C                   Parm      LMASTER       PMASTER           2 0
    ?C                   Parm      OIRVDT        SDateYMD7         7 0
    ?C                   Parm                    Included
     C                   If        not Included
     C                   GOTO      NXT
     C                   EndIf
     C                   Eval      *In(80 + LMASTER) = *On
     C                   EndIf

      *
     C     OHCUST        IFEQ      1521
WJB  C     LX1521        ANDEQ     'Y'
     C     OHCUST        OREQ      2730
     C     OHCUST        OREQ      6461
WJB  C     OHCUST        OREQ      1990
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK IF CLOSED ORDER OR DELETED ORDER, IF SO, DO NOT PRINT
      *
     C     OHCOFL        IFEQ      'Y'
     C     OHSTAT        OREQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C*          LINCL     IFEQ 1
     C*          OHOLST    ANDEQ'TAG   '
     C*                    GOTO NXT
     C*                    ENDIF
      *
     C*          LINCL     IFEQ 3
     C*          OHOLST    ANDNE'TAG   '
     C*                    GOTO NXT
     C*                    ENDIF
      *
      * DO NOT INCLUDE INTERNAL ORDERS
      *
     C     OHCUST        CHAIN     FARHST                             57
WJB  C     OHCUST        IFEQ      1521
WJB  C     LX1521        ANDEQ     'Y'
WJB  C     OHCUST        ORNE      1521
WJB  C     HSINCL        ANDEQ     'N'
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK PRODUCT CLASS RANGE
      *
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     KEY18         CHAIN     FMINVT                             50
      *
     C   60IMPCL1        IFLT      LPC1
     C     IMPCL1        ORGT      LPC2
     C                   GOTO      NXT
     C                   ENDIF
     C     NOPC          TAG
      *
     C                   EXSR      GETDES
      *
     C     OHSTA         IFEQ      'Y'
     C     OIQORD        SUB       OIQSHP        #WRFRQ           11 1
     C                   ADD       #WRFRQ        L1SHP            11 1
     C                   ADD       #WRFRQ        SPDTOT           11 1
     C                   ELSE
     C     OIQORD        SUB       OIQSHP        #WRFRQ
     C                   ADD       #WRFRQ        SORD             11 1
     C                   ADD       #WRFRQ        ORDTOT           11 1
     C                   ENDIF
     C                   ADD       #WRFRQ        L1OPN            11 1
     C                   ADD       #WRFRQ        OPDTOT           11 1
      *
     C                   Z-ADD     OIDTRQ        SAVDTE            6 0
     C                   MOVEL     OISHFR        SAVLOC            3
     C                   MOVEL     OIITEM        SAVITM           12
     C                   MOVEL     OISIZE        SAVSIZ            3
     C                   MOVEL     DESP          SAVDES           30
     C                   MOVEL     OIUUOM        SAVUM             2
     C                   SETON                                        55
     C                   ADD       1             FIRST
     C                   GOTO      NXT
      *
     C     END           TAG
     C     ORDTOT        IFGT      *ZEROS
     C                   EXCEPT    TL1
     C                   ENDIF
     C                   SETON                                        LR
      *
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             40
     C                   ENDSR
      *
     C     @DT@B2        BEGSR                                                                 @DT@B
      ********************************************************************@DT@B2
      * CONVERT MMDDYY TO DAY OF CENTURY DDDDD. INDICATOR 90 NEGATIVE DATE@DT@B2
      * ##MDY INPUT DATE MMDDYY                                           @DT@B2
      * ##DDD OUTPUT DAY OF CENTURY DDDDD. BASE DATE IS 01/01/1900        @DT@B2
      * INDICATORS USED 90-92                                             @DT@B2
      ********************************************************************@DT@B2
     C                   Z-ADD     ##MDY         ##MDY             6 0  90      NEG DATE       @DT@B
      * CONVERT YEAR TO DAYS                                              @DT@B2
     C                   MOVE      ##MDY         #02               2 0          YY             @DT@B
     C     #02           MULT      365           ##DDD             5 0          FIRST LEAP     @DT@B
     C     #02           DIV       4             #02                  91        # OF LEAPS -1  @DT@B
     C   91              MVR                     #02A              2 0    91    LEAP YEAR      @DT@B
     C     #02           ADD       ##DDD         ##DDD                          DAYS FOR LEAP  @DT@B
      * CONVERT MONTH TO DAYS                                             @DT@B2
     C                   MOVEL     ##MDY         #04               4 0          MMDD           @DT@B
     C                   MOVEL     #04           #02A                           MM             @DT@B
     C     #DY(#02A)     ADD       ##DDD         ##DDD                          DAY OF YEAR    @DT@B
     C     #02A          COMP      02                                 92        GT FEB         @DT@B
     C   91
     CANN92##DDD         SUB       1             ##DDD                          LEAP MM 03-12  @DT@B
      * ADD DAY OF MONTH                                                  @DT@B2
     C                   MOVE      #04           #02                            DD             @DT@B
     C     #02           ADD       ##DDD         ##DDD                          ADD DAYS       @DT@B
     C   90              Z-ADD     0             ##DDD                                         @DT@B
     C                   SETOFF                                         9192                   @DT@B
     C                   ENDSR                                                                 @DT@B
      *
     OBIR412    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       MCNAME              75
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           52 'Open Items by'
     O                                           72 'Requested Ship Date'
     O              N81N82                       82 ' - Summary'
     O               81                          85 ' - THU Master'
     O                  82                       85 ' - MON Master'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O              N65                          20 'Requested Ship Dates'
     O              N65      LBDATE        Y     29
     O              N65                          31 '-'
     O              N65      LEDATE        Y     39
     O               60                          62 'Product Classes'
     O               60      LPC1                65
     O               60                          67 '-'
     O               60      LPC2                70
     O          E            HDG            1
     O                                            9 'Requested'
     O**                                 84 'Ship'
     O                                           93 'Qty'
     O                                          108 'STA Qty'
     O                                          119 'Total'
     O          E            HDG            1
     O                                            9 'Ship Date'
     O                                           21 'Item'
     O                                           56 'D e s c r i p t i o n'
     O**                                 84 'From'
     O                                           79 'UM'
     O                                           95 'Ordered'
     O                                          108 'Ordered'
     O                                          120 'Ordered'
     O          E            HDG            0
     O                                           14 'Loc'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            HDG            1
     O                       LDESC               73
     O                                           43 'Location:'
     O          EF           DETLS          1
     O                       L1OPN         MB   120
     O                       L1SHP         MB   108
     O                       SORD          MB    96
     O                       SAVDTE        Y      8
     O                       SAVITM              29
     O                       BIN                 13
     O                       SAVSIZ              30
     O                       SAVDES              65
     O                       SAVUM               79
     O**                       SAVLOC    84
     O          E            TL1            1
     O                                          120 '--------'
     O                                          108 '--------'
     O                                           96 '--------'
     O          E            TL1            2
     O                                           17 'Total Ship Date:'
     O                       SAVDTE        YB    76
     O                       OPDTOT        MB   120
     O                       SPDTOT        MB   108
     O                       ORDTOT        MB    96
      *
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
** MESSAGE
  *** Normal Location ***
  *** Warm Cart ***
  *** Warm Floor ***
