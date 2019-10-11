      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1997
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- SED130
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SEED REQUIREMENTS BY REPORT
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *   01/03/03   CHANGED TRAY FROM 84 TO 105.   C.BUCK
      *
     FFLCSTAT   IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFIORDRAL  UF   E           K DISK
     FFMCUST    IF   E           K DISK
RPADDFITEMSUM   IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFPTABLE   IF   E           K DISK
     FFSEDREQ   UF A E           K DISK
     FSED130    O    F  120        PRINTER OFLIND(*INOF)

     D  Order          S              7S 0
     D  ToSow          S              7S 0
     D  SeedCalled     S              7S 0
     D  SeedNeeded     S              7S 0

      * MESSAGE ARRAY
     D MSG             S             40    DIM(10) CTDATA PERRCD(1)             MESSAGES
      * TRAY ARRAYS
     D TRY             S              3    DIM(9) CTDATA PERRCD(1)              TRAY SIZE
     D TFX             S              7  0 DIM(9)                               # TRYS SOLD FX
     D TNF             S              7  0 DIM(9)                               # TRY SLD NOFX
     D FIX             S              7  0 DIM(9)                               # FIXERS NEED
     D TF#             S              7  0 DIM(9)                               # TRAYS NEEDED
     D SD#             S              9  0 DIM(9)                               # SEEDS NEEDED
     D SDT             S              6  0 DIM(9)                               REQ SHIP DATE
     D SDR             S              1    DIM(9)                               Seeder
      * SEED REQ FILE ARRAYS
     D SRT             S              9  0 DIM(9)                               # TRYS SOLD
     D SCF             S              9  0 DIM(9)                               # TRY CALC FIX
     D SFX             S              9  0 DIM(9)                               # NEW FIX TRAY
     D SOW             S              9  0 DIM(9)                               # TRAYS SOWN
     D CHG             S              1    DIM(9)                               CHANGED
      ** PTABLE ARRAYS
     D PMN             S              7  0 DIM(12)                              MINIMUM
     D PMX             S              7  0 DIM(12)                              MAXIMUM
     D PUN             S              5  0 DIM(12)                              FACTOR UNITS
     D PPC             S              5  2 DIM(12)                              FACTOR %
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  CANCEL                 1      1                                         ARC380
      ** TYPE IS REPORT TYPE W=WEEK  S=SEASON
     D  TYPE                   2      2
      ** FROM DATE MDY
     D  FRMDAT                 3      8  0
      ** TO DATE MDY
     D  TODAT                  9     14  0
      ** RESET FLAGS  Y/N
     D  RESET                 15     15
      ** SHOW ALL OR UN-FLAGGED  A/U
     D  SHOWAL                16     16
      ** PRINTER I.D.
     D  PRTID                 17     26
      ** SET FLAGS  Y/N
     D  SETFLG                27     27
      ** FROM DATE YEAR IE 1998
     D  BEGYY                 28     31  0
      ** FROM DATE WEEK #
     D  BEGWW                 32     33  0
      ** TO DATE YEAR IE 1998
     D  ENDYY                 34     37  0
      ** TO DATE WEEK #
     D  ENDWW                 38     39  0
     IRSEDREQ
     I              SRTRY1                      SRT(1)
     I              SRTRY2                      SRT(2)
     I              SRTRY3                      SRT(3)
     I              SRTRY4                      SRT(4)
     I              SRFIX1                      SCF(1)
     I              SRFIX2                      SCF(2)
     I              SRFIX3                      SCF(3)
     I              SRFIX4                      SCF(4)
     I              SRNFX1                      SFX(1)
     I              SRNFX2                      SFX(2)
     I              SRNFX3                      SFX(3)
     I              SRNFX4                      SFX(4)
     I              SRCHG1                      CHG(1)
     I              SRCHG2                      CHG(2)
     I              SRCHG3                      CHG(3)
     I              SRCHG4                      CHG(4)
     I              SRSOW1                      SOW(1)
     I              SRSOW2                      SOW(2)
     I              SRSOW3                      SOW(3)
     I              SRSOW4                      SOW(4)
     IRPTABLE
     I              PTBQ01                      PMN(1)
     I              PTBQ02                      PMN(2)
     I              PTBQ03                      PMN(3)
     I              PTBQ04                      PMN(4)
     I              PTBQ05                      PMN(5)
     I              PTBQ06                      PMN(6)
     I              PTBQ07                      PMN(7)
     I              PTBQ08                      PMN(8)
     I              PTBQ09                      PMN(9)
     I              PTBQ10                      PMN(10)
     I              PTBQ11                      PMN(11)
     I              PTBQ12                      PMN(12)
     I              PTEQ01                      PMX(1)
     I              PTEQ02                      PMX(2)
     I              PTEQ03                      PMX(3)
     I              PTEQ04                      PMX(4)
     I              PTEQ05                      PMX(5)
     I              PTEQ06                      PMX(6)
     I              PTEQ07                      PMX(7)
     I              PTEQ08                      PMX(8)
     I              PTEQ09                      PMX(9)
     I              PTEQ10                      PMX(10)
     I              PTEQ11                      PMX(11)
     I              PTEQ12                      PMX(12)
     I              PTUN01                      PUN(1)
     I              PTUN02                      PUN(2)
     I              PTUN03                      PUN(3)
     I              PTUN04                      PUN(4)
     I              PTUN05                      PUN(5)
     I              PTUN06                      PUN(6)
     I              PTUN07                      PUN(7)
     I              PTUN08                      PUN(8)
     I              PTUN09                      PUN(9)
     I              PTUN10                      PUN(10)
     I              PTUN11                      PUN(11)
     I              PTUN12                      PUN(12)
     I              PTPE01                      PPC(1)
     I              PTPE02                      PPC(2)
     I              PTPE03                      PPC(3)
     I              PTPE04                      PPC(4)
     I              PTPE05                      PPC(5)
     I              PTPE06                      PPC(6)
     I              PTPE07                      PPC(7)
     I              PTPE08                      PPC(8)
     I              PTPE09                      PPC(9)
     I              PTPE10                      PPC(10)
     I              PTPE11                      PPC(11)
     I              PTPE12                      PPC(12)
      ***********************
      ** GET HEADINGS      **
      ***********************
      ** TO CHANGE OVER FACTOR CHG NXT LINE
     C**                   Z-ADD3000      SDFACT  90
     C                   Z-ADD     0             SDFACT            9 0
     C                   SETON                                        OF
     C                   Z-ADD     FRMDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        BCYMD             7 0
     C                   Z-ADD     TODAT         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ECYMD             7 0
     C     TYPE          IFEQ      'W'
     C                   SETON                                        10
     C                   SETOFF                                       11
     C                   ELSE
     C                   SETON                                        11
     C                   SETOFF                                       10
     C                   END
     C     SHOWAL        IFEQ      'A'
     C                   SETON                                        12
     C                   SETOFF                                       13
     C                   ELSE
     C                   SETON                                        13
     C                   SETOFF                                       12
     C                   END
     C     SETKEY        KLIST
     C                   KFLD                    STAT              1
     C                   KFLD                    ITMSRC
     C                   MOVE      *BLANKS       ITMSRC           15
     C                   MOVEL     'A'           STAT
      ** SKIP ALL NON ALPHA ITEMS
     C     SETKEY        SETLL     FIORDRAL
      ** READ IORDR RECORDS
     C     NXTIOR        TAG
     C     STAT          READE     FIORDRAL                               90
     C   90              GOTO      END

     C     OISTAT        IFNE      'A'
     C     OILOTC        OREQ      'Y'
WJB  C     OILOT#        andne     'CustomOrdr'
     C     OISTA         OREQ      'Y'
     C     OIITYP        ORNE      ' '
     C                   GOTO      NXTIOR
     C                   END

     C     SHOWAL        IFNE      'A'
     C     OISEDP        ANDEQ     'Y'
     C                   GOTO      NXTIOR
     C                   END

     C                   Z-ADD     OISOW         ##CYMD
     C*                    Z-ADDOISOW     ##MDY
     C     ##CYMD        IFLT      BCYMD
     C     ##CYMD        ORGT      ECYMD
     C                   GOTO      NXTIOR
     C                   END

     C                   Z-ADD     1             X                 1 0
     C     OISIZE        LOOKUP    TRY(X)                                 20
     C  N20              GOTO      NXTIOR

     C     OIITEM        IFNE      OITEM
     C     OISIZE        ORNE      OSIZE
     C     OIRVDT        ORNE      ORVDT

     C     OITEM         IFGT      *BLANKS
     C                   EXSR      NEWITM
     C                   MOVE      *BLANKS       OITEM
     C                   END

     C     ITMKEY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C     ITMKEY        CHAIN     FMINVT                             60
     C   60              GOTO      NXTIOR

     C     REQKEY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    SRSIZE
     C                   KFLD                    SRSOWW
     C                   MOVEL     BEGYY         SRSOWW
     C                   MOVE      BEGWW         SRSOWW
     C                   MOVEL     'SED'         SRSIZE
      ** IF WEEKLY DO NOT POST TO REQUIREMENTS FILE
     C     TYPE          IFEQ      'S'
     C                   GOTO      NOREQ
     C                   END
     C     REQKEY        CHAIN     FSEDREQ                            60
     C  N60              MOVEL     'Y'           SEDREQ            1
     C   60              DO
     C                   CLEAR                   RSEDREQ
     C                   MOVEL     OIITEM        SRITEM
     C                   MOVEL     BEGYY         SRSOWW
     C                   MOVE      BEGWW         SRSOWW
     C                   MOVEL     'SED'         SRSIZE
     C                   MOVEL     'A'           SRSTAT
     C                   MOVEL     'N'           SEDREQ            1
     C                   END
     C     NOREQ         TAG
     C     IMFTAB        IFNE      '**'
     C     IMFTAB        CHAIN     FPTABLE                            60
     C   60              MOVEL     '01'          IMFTAB
     C   60IMFTAB        CHAIN     FPTABLE                            60
     C   60              Z-ADD     0             PMN
     C   60              Z-ADD     0             PMX
     C   60              Z-ADD     0             PUN
     C   60              Z-ADD     0             PPC
     C                   END                                                    IMFTAB><**
     C                   MOVEL     OIITEM        OITEM            12
     C                   MOVEL     OISIZE        OSIZE             3
     C                   Z-ADD     OIDTRQ        OREQD             6 0
     C                   Z-ADD     OIRVDT        ORVDT             7 0
WJB  C                   MOVE      IMTRYC        OTRYC             1
     C                   END
     C                   Z-ADD     1             X
     C     OISIZE        LOOKUP    TRY(X)                                 20
      ** NOW ADD TO NEED
     C     OIQORD        SUB       OIQSHP        NEED             11 1
     C     OICUST        CHAIN     FMCUST                             60
     C     CMCTYP        IFEQ      PTCTYP
     C                   ADD       NEED          TNFCUR            9 0
     C                   ELSE
     C                   ADD       NEED          TFXCUR            9 0
     C                   END
     C     SETFLG        IFEQ      'Y'
     C                   MOVEL     'Y'           OISEDP
     C                   END
     C     RESET         IFEQ      'Y'
     C                   MOVEL     'N'           OISEDP
     C                   END
     C                   UPDATE    RIORDR
     C                   GOTO      NXTIOR
      *** END PROGRAM
     C     END           TAG
     C                   MOVEL     '99999999'    OIITEM
     C                   EXSR      NEWITM
     C                   SETON                                        LR
      *
      ***********************
      ** NEW ITEM          **
      ***********************
     C     NEWITM        BEGSR
      ** GET SIZE BUCKET
     C     OSIZE         IFGT      *BLANKS
     C                   Z-ADD     1             X                 1 0
     C     OSIZE         LOOKUP    TRY(X)                                 20
WJB  C                   Move      OTRYC         SDR(X)
     C     IMFTAB        IFEQ      '**'
     C     TFXCUR        ADD       TNFCUR        WRKQ              9 0
     C                   ADD       WRKQ          TF#(X)
     C                   ELSE
     C                   EXSR      GETFIX
     C                   ADD       FIXCUR        TF#(X)
     C                   ADD       TFXCUR        TF#(X)
     C                   ADD       TNFCUR        TF#(X)
     C                   END

     C     SCF(X)        IFNE      SFX(X)
     C     SFX(X)        SUB       SCF(X)        SCDIF             9 0
     C                   ADD       SCDIF         TF#
     C                   END

     C     SEDREQ        IFEQ      'Y'
     C     TFX(X)        ADD       TNF(X)        TST#              9 0

     C     SRT(X)        IFNE      TST#
     C                   MOVEL     'Y'           CHG(X)
     C                   END
     C     SRT(X)        IFLE      0
     C                   Z-ADD     FIX(X)        SFX(X)
     C                   END

     C                   ELSE
     C                   Z-ADD     FIX(X)        SFX(X)
     C                   MOVEL     'Y'           CHG(X)
     C                   END

     C     TFX(X)        ADD       TNF(X)        SRT(X)
     C                   Z-ADD     FIX(X)        SCF(X)
     C                   Z-ADD     OREQD         SDT(X)
      ** GET SEED COUNT
     C     OSIZE         CHAIN     FMSIZE                             81
     C     IM#SED        IFLE      0
     C                   Z-ADD     1             IM#SED
     C     70            ADD       X             ID                2 0
     C                   MOVEL     '1'           *IN(ID)
     C                   END
     C     TF#(X)        MULT      SZCELL        WRKS              9 0
     C                   If        IMFRSZ <> 'SED' and IMFRSZ <> ' '
     C                   Eval      IM#SED = *Zero
     C                   EndIf
     C     IM#SED        MULT      WRKS          SD#(X)
WJB ?C                   Call      '#OVERSOW'
WJB ?C                   Parm                    IMITEM
WJB ?C                   Parm                    IMSIZE
WJB ?C                   Parm      SD#(X)        SeedCalled
WJB ?C     SD#(X)        Parm                    SeedNeeded
     C                   END
     C                   Z-ADD     0             TFXCUR
     C                   Z-ADD     0             TNFCUR
     C                   Z-ADD     0             FIXCUR            9 0
     C     OIITEM        IFEQ      OITEM
     C                   GOTO      SAMITM
     C                   END
      ** IF HERE DO WE NEED TO PRINT
     C                   XFOOT     SD#           TST1              9 0
     C**         TST1      IFLE 0
     C**                   GOTO SAMITM
     C**                   END
      ** NEED TO PRINT
     C     SEDKEY        KLIST
     C                   KFLD                    OITEM
     C                   KFLD                    SIZE
     C                   MOVEL     'SED'         SIZE              3
     C     SEDKEY        CHAIN     FMINVT                             60
     C                   XFOOT     SD#           TOTSED            9 0
     C     IMQTOH        SUB       IMQTAL        QTOH              9 0
     C   60              Z-ADD     0             QTOH
      ** GET PREV ALLOCATED BACK IN
     C     SRQTND        SUB       SRQTIS        SRLEFT            9 0
     C**                   ADD  SRLEFT    QTOH
     C     TOTSED        ADD       SDFACT        TOTNED            9 0
     C     TOTNED        SUB       QTOH          LEFT              9 0
     C     LEFT          IFGT      0
     C                   SETON                                        61
     C                   ELSE
     C                   SETOFF                                       61
     C                   END
      ** PRINT LINE
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C     SD#(1)        COMP      0                                  51
     C     SD#(2)        COMP      0                                  52
     C     SD#(3)        COMP      0                                  53
     C     SD#(4)        COMP      0                                  54
     C     SD#(5)        COMP      0                                  55
     C     SD#(6)        COMP      0                                  56
     C     SD#(7)        COMP      0                                  57
     C     SD#(8)        COMP      0                                  58
     C     SD#(9)        COMP      0                                  59
RPADDC                   Z-ADD     0             FUTURE            9 0
RPADDC     IMITEM        CHAIN     ITEMSUM                            99
RPADDC     *IN99         IFEQ      *OFF
RPADDC                   Z-ADD     QTY           FUTURE
RPADDC                   ENDIF
     C                   If        *In51 or
     C                             *In52 or
     C                             *In53 or
     C                             *In54 or
     C                             *In55 or
     C                             *In56 or
     C                             *In57 or
     C                             *In58 or
     C                             *In59
     C                   EXCEPT    DETL
     C                   EndIf
      ** OUTPUT SEDREQ FILE
     C     TYPE          IFNE      'S'
     C                   MOVEL     USERID        SRUSER
     C                   Z-ADD     TDATE         SRDTLA
     C                   Z-ADD     TIMOD         SRTIME
     C                   Z-ADD     TOTSED        SRQTND
     C                   MOVEL     IMLOOK        SRALPH
     C     SEDREQ        IFEQ      'Y'
     C                   UPDATE    RSEDREQ
     C                   ELSE
     C                   WRITE     RSEDREQ
     C                   END
     C                   END                                                    TYPE = S
      ** ZERO ARRAYS
     C                   Z-ADD     0             TFX
     C                   Z-ADD     0             TNF
     C                   Z-ADD     0             TF#
     C                   Z-ADD     0             SD#
     C                   Z-ADD     0             SDT
     C                   Z-ADD     0             FIX
     C                   SETOFF                                       717273
     C                   SETOFF                                       747576
     C                   SETOFF                                       777879
     C     SAMITM        TAG
     C                   ENDSR
      *
      ***********************
      ** GET FIXERS        **
      ***********************
     C     GETFIX        BEGSR
     C                   Z-ADD     0             FIXCUR
     C                   Eval      Order = TFXCUR
     C     TFXCUR        IFLE      0
     C                   GOTO      ENDFIX
     C                   END
     C                   Z-ADD     1             Y                 3 0
     C     NXTY          TAG
     C     TFXCUR        IFGE      PMN(Y)
     C     TFXCUR        ANDLE     PMX(Y)
     C                   GOTO      FOUND
     C                   END
     C                   ADD       1             Y
     C     Y             IFLE      12
     C                   GOTO      NXTY
     C                   ELSE
     C                   GOTO      ENDFIX
     C                   END
     C     FOUND         TAG
     C     PUN(Y)        IFGT      0
     C                   Z-ADD     PUN(Y)        FIXCUR
     C                   ELSE
     C     PPC(Y)        DIV       100           WRKPCT            5 4
     C     TFXCUR        MULT      WRKPCT        WRKQTY           11 1
     C                   MOVE      WRKQTY        TSTQTY            1 1
     C                   MOVE      WRKQTY        TSTQTY2           9 9
     C     TSTQTY2       IFGT      0
     C     1.0           SUB       TSTQTY        NEWTST            1 1
     C     WRKQTY        ADD       NEWTST        FIXCUR
     C                   ELSE
     C                   Z-ADD     WRKQTY        FIXCUR
     C                   END
     C                   END
     C     ENDFIX        TAG
WJB ?C                   Call      '#SOWFACTOR'
WJB ?C                   Parm                    IMITEM
WJB ?C                   Parm                    IMSIZE
WJB ?C                   Parm                    IMFTAB
WJB ?C                   Parm                    Order
WJB ?C                   Parm                    ToSow
     C                   Eval      FIXCUR = ToSow - Order
     C                   ADD       FIXCUR        FIX(X)
     C                   ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     01            CHAIN     FLCSTAT                            10
     C   10              SETOFF                                       10
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OSED130    E            HEAD           1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O               10      MSG(1)              76
     O               11      MSG(2)              76
     O                                           82 'From:'
     O                       FRMDAT        Y     91
     O                                           96 'To:'
     O                       TODAT         Y    106
     O                       PAGE          Z    120
     O                                          117 'Page:'
     O          E            HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O               12      MSG(3)              76
     O               13      MSG(4)              76
     O                                           82 'Week:'
     O                       BEGYY               86
     O                                           87 '-'
     O                       BEGWW         4     89
     O                                           98 'To Week:'
     O                       ENDYY              103
     O                                          104 '-'
     O                       ENDWW         4    106
     O                                          112 'Time:'
     O                       TIMOD              120 '  :  :  '
     O          E            HEAD           2
     O                                           10 'Set Flags:'
     O                       SETFLG              12
     O                                          118 'Reset Flags:'
     O                       RESET              120
     O          E            HEAD           1
     O                                            7 'Item #'
     O                                           25 'Description'
     O***                                53 'Ship Date'
     O**                                 64 'Required'
     O**                                 76 'Factor'
     O                                           68 'Total Need'
     O                                           80 'On-Hand'
     O                                           91 'Order'
RPADDO                                          115 'Future'
     O          EF           DETL           1
     O                       IMITEM              13
     O                       IMDES1              44
     O***                      OREQD Y   53
     O***                      TOTSED1   64
     O**                       SDFACT1   76
     O**                                 66 '+'
     O                       TOTNED        1     68
     O                       QTOH          1     80
     O               61      LEFT          1     91
     O                                          100 '________'
RPADDO                       FUTURE        1    115
     O          EF           DETL           1
     O                                           15 'Size'
     O                                           30 '# of Trays'
     O                                           45 '# of Seeds'
     O               10                          55 'Ship Date'
     O          EF   51      DETL           1
WJB  O                       SDR(1)              10
     O                       TRY(1)              15
     O                       TF#(1)        1     30
     O                       SD#(1)        1     45
     O               10      SDT(1)        Y     55
     O               71                          80 '***Seeds Per Cell is 0**'
     O               71                         120 '*****'
     O          EF   52      DETL           1
WJB  O                       SDR(2)              10
     O                       TRY(2)              15
     O                       TF#(2)        1     30
     O                       SD#(2)        1     45
     O               10      SDT(2)        Y     55
     O               72                          80 '***Seeds Per Cell is 0**'
     O               72                         120 '*****'
     O          EF   53      DETL           1
WJB  O                       SDR(3)              10
     O                       TRY(3)              15
     O                       TF#(3)        1     30
     O                       SD#(3)        1     45
     O               10      SDT(3)        Y     55
     O               73                          80 '***Seeds Per Cell is 0**'
     O               73                         120 '*****'
     O          EF   54      DETL           1
WJB  O                       SDR(4)              10
     O                       TRY(4)              15
     O                       TF#(4)        1     30
     O                       SD#(4)        1     45
     O               10      SDT(4)        Y     55
     O               74                          80 '***Seeds Per Cell is 0**'
     O               74                         120 '*****'
     O          EF   55      DETL           1
WJB  O                       SDR(5)              10
     O                       TRY(5)              15
     O                       TF#(5)        1     30
     O                       SD#(5)        1     45
     O               10      SDT(5)        Y     55
     O               75                          80 '***Seeds Per Cell is 0**'
     O               75                         120 '*****'
     O          EF   56      DETL           1
WJB  O                       SDR(6)              10
     O                       TRY(6)              15
     O                       TF#(6)        1     30
     O                       SD#(6)        1     45
     O               10      SDT(6)        Y     55
     O               76                          80 '***Seeds Per Cell is 0**'
     O               76                         120 '*****'
     O          EF   57      DETL           1
WJB  O                       SDR(7)              10
     O                       TRY(7)              15
     O                       TF#(7)        1     30
     O                       SD#(7)        1     45
     O               10      SDT(7)        Y     55
     O               77                          80 '***Seeds Per Cell is 0**'
     O               77                         120 '*****'
     O          EF   58      DETL           1
WJB  O                       SDR(8)              10
     O                       TRY(8)              15
     O                       TF#(8)        1     30
     O                       SD#(8)        1     45
     O               10      SDT(8)        Y     55
     O               78                          80 '***Seeds Per Cell is 0**'
     O               78                         120 '*****'
     O          EF   59      DETL           1
WJB  O                       SDR(9)              10
     O                       TRY(9)              15
     O                       TF#(9)        1     30
     O                       SD#(9)        1     45
     O               10      SDT(9)        Y     55
     O               79                          80 '***Seeds Per Cell is 0**'
     O               79                         120 '*****'
     O          EF           DETL           1
** MESSAGE ARRAY
Weekly Seed Requirements Report                            1
Season Seed Requirements Report                            2
Complete Report Flagged and Unflagged.                     3
      Unflagged Orders Only                                4
** TRAY SIZE ARRAY
72                           1
50                           2
50V                          3
105                          4
128                          5
162                          6
288                          7
512                          8
G62                          9
