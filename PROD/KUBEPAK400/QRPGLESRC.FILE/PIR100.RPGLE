      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- PIR100
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- WEEKLY POINSETTIA REPORTS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFPOIWCTL  UF   E           K DISK
     FFPOIITMA  UF   E           K DISK
     FFPOISOWA  UF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFMIX      IF   E           K DISK
     FFCALEN    IF   E           K DISK
     FFCALENCY  IF   E           K DISK
     F                                     RENAME(RCALEN:ICALEN)
     FFPOICTL   IF   E           K DISK
     FPIR100    O    F  120        PRINTER OFLIND(*INOF)
      *
      * CONTROL FILE DATE ARRAY
     D PCW             S              6  0 DIM(12)                              WEEK DATES
      * BALANCE FILE DATE ARRAY
     D OH              S              7  0 DIM(12)                              ON-HAND
     D ND              S              7  0 DIM(12)                              NEED
     D SL              S              7  0 DIM(12)                              SOLD
     D PT              S              7  0 DIM(12)                              PRINTED
      *
      * MIX FILE ARRAYS
     D IT              S             12    DIM(10)                              FILE  ITEM #
     D QT              S              2  0 DIM(10)                              FILE  QTYS
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10
      ** RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      ** SOURCE LIBRARY
     D  SLIBR                314    323
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LCO                    1      2  0                                      ARC380
     D  LOPT                   3      3  0                                      ARC380
     D  BEGYY                  4      7  0                                      ARC380
     D  BEGWW                  8      9  0                                      ARC380
     D  FRMDAT                10     15  0                                      ARC380
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133                                         ARC380
      *
      * RENAME CONTROL FILE
     IRPOICTL
     I              PCW1D                       PCW(1)
     I              PCW2D                       PCW(2)
     I              PCW3D                       PCW(3)
     I              PCW4D                       PCW(4)
     I              PCW5D                       PCW(5)
     I              PCW6D                       PCW(6)
     I              PCW7D                       PCW(7)
     I              PCW8D                       PCW(8)
     I              PCW9D                       PCW(9)
     I              PCW10D                      PCW(10)
     I              PCW11D                      PCW(11)
     I              PCW12D                      PCW(12)
      *
      * RENAME BALANCE FILE
     IRPOIITM
      * ON-HAND
     I              PIOH1                       OH(1)
     I              PIOH2                       OH(2)
     I              PIOH3                       OH(3)
     I              PIOH4                       OH(4)
     I              PIOH5                       OH(5)
     I              PIOH6                       OH(6)
     I              PIOH7                       OH(7)
     I              PIOH8                       OH(8)
     I              PIOH9                       OH(9)
     I              PIOH10                      OH(10)
     I              PIOH11                      OH(11)
     I              PIOH12                      OH(12)
      * NEED
     I              PIND1                       ND(1)
     I              PIND2                       ND(2)
     I              PIND3                       ND(3)
     I              PIND4                       ND(4)
     I              PIND5                       ND(5)
     I              PIND6                       ND(6)
     I              PIND7                       ND(7)
     I              PIND8                       ND(8)
     I              PIND9                       ND(9)
     I              PIND10                      ND(10)
     I              PIND11                      ND(11)
     I              PIND12                      ND(12)
      * SOLD
     I              PISL1                       SL(1)
     I              PISL2                       SL(2)
     I              PISL3                       SL(3)
     I              PISL4                       SL(4)
     I              PISL5                       SL(5)
     I              PISL6                       SL(6)
     I              PISL7                       SL(7)
     I              PISL8                       SL(8)
     I              PISL9                       SL(9)
     I              PISL10                      SL(10)
     I              PISL11                      SL(11)
     I              PISL12                      SL(12)
      * PRINTED ON LAST REPORT
     I              PIPT1                       PT(1)
     I              PIPT2                       PT(2)
     I              PIPT3                       PT(3)
     I              PIPT4                       PT(4)
     I              PIPT5                       PT(5)
     I              PIPT6                       PT(6)
     I              PIPT7                       PT(7)
     I              PIPT8                       PT(8)
     I              PIPT9                       PT(9)
     I              PIPT10                      PT(10)
     I              PIPT11                      PT(11)
     I              PIPT12                      PT(12)
      * REDEFINE FILE
     IRMIX
     I              MIITM1                      IT(1)
     I              MIITM2                      IT(2)
     I              MIITM3                      IT(3)
     I              MIITM4                      IT(4)
     I              MIITM5                      IT(5)
     I              MIITM6                      IT(6)
     I              MIITM7                      IT(7)
     I              MIITM8                      IT(8)
     I              MIITM9                      IT(9)
     I              MIIT10                      IT(10)
     I              MIQTY1                      QT(1)
     I              MIQTY2                      QT(2)
     I              MIQTY3                      QT(3)
     I              MIQTY4                      QT(4)
     I              MIQTY5                      QT(5)
     I              MIQTY6                      QT(6)
     I              MIQTY7                      QT(7)
     I              MIQTY8                      QT(8)
     I              MIQTY9                      QT(9)
     I              MIQT10                      QT(10)
      ** GET CUTTINGS 1ST
      ***********************
     C                   Z-ADD     0             REV               6 0
     C                   EXSR      GETCUT
      ** GET ITEMS
      ***********************
     C                   EXSR      GETITM
      ** UPDATE CONTROL FILE
      ***********************
     C     REV           IFGT      0
     C                   Z-ADD     REV           PWRVNM
     C   01              Z-ADD     TDATE         PWSCH
     C   02              Z-ADD     TDATE         PWUPD
     C   04              Z-ADD     TDATE         PWRCP
     C                   Z-ADD     TDATE         PWDTLA
     C                   Z-ADD     TIMOD         PWTIME
     C                   MOVEL     USERID        PWUSER
     C                   UPDATE    RPOIWCTL
     C                   END                                                    REV>0
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** GET CUTTINGS      **
      ***********************
     C     GETCUT        BEGSR
     C     BEGYY         SETLL     FPOIITMA
     C                   Z-ADD     0             OUT               6 0
     C                   Z-ADD     0             TOTCUT            7 0
     C     NXTCUT        TAG
     C     BEGYY         READE     FPOIITMA                               90
     C   90              GOTO      ENDCUT
     C     ND(WK)        ADD       SL(WK)        TSTND             7 0
      ** IF RECAP DO NOT PRINT IF SAME AS LAST PRINT
     C   02              DO
     C     TSTND         IFEQ      PT(WK)
     C     TSTND         OREQ      0
     C                   GOTO      NXTCUT
     C                   END
     C                   ENDDO                                                   02  DO
      ** DO NOT PRINT IF NONE NEEDED  ON SCHEDULE
     C   01ND(WK)        IFEQ      0
     C                   GOTO      NXTCUT
     C                   END
      ** DO NOT PRINT IF NONE NEEDED  ON RECAP
     C   04TSTND         IFEQ      0
     C                   GOTO      NXTCUT
     C                   END
      ** GET MINVT
     C     MINKEY        KLIST
     C                   KFLD                    PIITEM
     C                   KFLD                    SIZE
     C                   MOVEL     'CUT'         SIZE              3
     C     MINKEY        CHAIN     FMINVT                             89
     C   89              MOVE      *BLANKS       IMDES1
     C     REV           IFLE      0
     C                   ADD       1             PWRVNM
     C                   Z-ADD     PWRVNM        REV
     C                   END                                                    REV=0
      ** IF HERE PRINT
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    CUTHD
     C                   SETOFF                                       OF
     C                   ENDDO
      ** PRINT AND UPDATE
     C** 02      ND,WK     SUB  PT,WK     NEED    70
     C   02TSTND         SUB       PT(WK)        NEED              7 0
     C  N02              Z-ADD     ND(WK)        NEED
     C   04              Z-ADD     TSTND         NEED
     C                   ADD       NEED          TOTCUT
     C                   EXCEPT    CUTDET
     C                   ADD       1             OUT
     C   02              ADD       NEED          PT(WK)
     C  N02              Z-ADD     NEED          PT(WK)
     C                   UPDATE    RPOIITM
     C                   GOTO      NXTCUT
     C     ENDCUT        TAG
     C                   EXCEPT    CUTTOT
     C                   SETON                                        OF
     C                   ENDSR
      ***********************
      ** GET ITEMS         **
      ***********************
     C     GETITM        BEGSR
     C     SOWCYM        SETLL     FPOISOWA
     C                   Z-ADD     0             TOTORD            7 0
     C                   Z-ADD     0             TOTNED            7 0
     C                   Z-ADD     0             TOTCUT            7 0
     C                   Z-ADD     0             FITORD            7 0
     C                   Z-ADD     0             FITNED            7 0
     C                   Z-ADD     0             FITCUT            7 0
     C                   MOVE      *BLANKS       OSIZE             3
     C     NXTITM        TAG
     C     SOWCYM        READE     FPOISOWA                               90
     C   90              GOTO      ENDITM
     C     PSQORD        ADD       PSQFIX        PSTOTN
     C     PSQSHP        ADD       PSTOTN        TSTNED            7 0
      ** IF RECAP DO NOT PRINT IF SAME AS LAST PRINT
     C** 02      PSTOTN    IFEQ PSTOTP
     C   02TSTNED        IFEQ      PSTOTP
     C     TSTNED        OREQ      0
     C                   GOTO      NXTITM
     C                   END
      ** DO NOT PRINT IF NONE NEEDED ON SCHEDULE
     C   01PSTOTN        IFEQ      0
     C                   GOTO      NXTITM
     C                   END
      ** DO NOT PRINT IF NONE NEEDED ON SCHEDULE
     C   04TSTNED        IFEQ      0
     C                   GOTO      NXTITM
     C                   END
      ** SEE IF SIZE CHANGED
     C     PSSIZE        IFNE      OSIZE
     C     OSIZE         IFGT      *BLANKS
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    ITMHED
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    SIZTOT
     C                   END                                                    OSIZE>" "
     C                   MOVEL     PSSIZE        OSIZE
     C                   SETON                                        OF
     C     OSIZE         CHAIN     FMSIZE                             90
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    ITMHED
     C                   SETOFF                                       OF
     C                   ENDDO
     C     PSSHPD        CHAIN     FCALENCY                           90
     C                   Z-ADD     CLDATE        REQDAT            6 0
     C                   EXCEPT    SIZHED
     C                   ADD       TOTORD        FITORD
     C                   ADD       TOTNED        FITNED
     C                   ADD       TOTCUT        FITCUT
     C                   Z-ADD     0             TOTORD            7 0
     C                   Z-ADD     0             TOTNED            7 0
     C                   Z-ADD     0             TOTCUT            7 0
     C                   END                                                    PSSIZE><OSIZ
      ** GET MINVT
     C     MINKY1        KLIST
     C                   KFLD                    PSITEM
     C                   KFLD                    PSSIZE
     C     MINKY1        CHAIN     FMINVT                             89
     C   89              MOVE      *BLANKS       IMDES1
     C     IM#SED        IFEQ      99
     C                   SETON                                        15
     C                   ELSE
     C                   SETOFF                                       15
     C                   END
      ** IF HERE PRINT
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    ITMHED
     C                   SETOFF                                       OF
     C                   ENDDO
     C     REV           IFLE      0
     C                   ADD       1             PWRVNM
     C                   Z-ADD     PWRVNM        REV
     C                   END                                                    REV=0
      ** PRINT AND UPDATE
     C   02              DO
     C     PSTOTP        SUB       PSQSHP        WRKPRT            7 0
     C     WRKPRT        IFLE      0
     C                   Z-ADD     0             WRKPRT
     C                   END
     C     PSTOTN        SUB       WRKPRT        NEED              7 0
     C                   ENDDO                                                  02  DO
     C   01              Z-ADD     PSTOTN        NEED
     C   04              Z-ADD     TSTNED        NEED
     C  N15NEED          MULT      IM#SED        CUTS              7 0
     C  N15              ADD       CUTS          TOTCUT
     C                   ADD       NEED          TOTNED
     C                   ADD       PSQORD        TOTORD
     C                   EXCEPT    ITMDET
     C   02              ADD       NEED          PSTOTP
     C  N02              Z-ADD     NEED          PSTOTP
     C                   UPDATE    RPOISOW
     C   15              EXSR      GETMIX
     C                   GOTO      NXTITM
     C     ENDITM        TAG
     C     OSIZE         IFGT      *BLANKS
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    ITMHED
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    SIZTOT
     C                   END                                                    OSIZE>" "
     C                   ADD       TOTORD        FITORD
     C                   ADD       TOTNED        FITNED
     C                   ADD       TOTCUT        FITCUT
     C                   EXCEPT    FINTOT
     C                   ENDSR
      ***********************
      ** GET MIX CUTS      **
      ***********************
     C     GETMIX        BEGSR
     C     MINKY1        CHAIN     FMIX                               90
     C   90              GOTO      ENDMIX
     C                   Z-ADD     1             M                 2 0
     C     NXTMIX        TAG
     C     IT(M)         IFGT      *BLANKS
     C     NEED          MULT      QT(M)         CUTS
     C                   ADD       CUTS          TOTCUT
     C     MINKY2        KLIST
     C                   KFLD                    IT(M)
     C                   KFLD                    SIZE
     C                   MOVEL     'CUT'         SIZE
     C     MINKY2        CHAIN     FMINVT                             89
     C   89              MOVE      *BLANKS       IMDES1
     C                   EXCEPT    MIXDET
     C                   END                                                      IT,M>' '
     C                   ADD       1             M
     C     M             IFLE      10
     C                   GOTO      NXTMIX
     C                   END
     C     ENDMIX        TAG
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      ** GET WEEK NUMBER AND REVISION #
     C     WCTKEY        KLIST
     C                   KFLD                    BEGYY
     C                   KFLD                    BEGWW
     C     WCTKEY        CHAIN     FPOIWCTL                           LR
     C     BEGYY         CHAIN     FPOICTL                            LR
     C                   Z-ADD     1             WK                2 0
     C     FRMDAT        LOOKUP    PCW(WK)                                91
     C     FRMDAT        CHAIN     FCALEN                             90
     C                   Z-ADD     CLCYMD        SOWCYM            7 0
      ** DETERMINE TYPE
     C                   MOVEA     '0000'        *IN(1)
     C                   Z-ADD     LOPT          L                 2 0
     C                   MOVE      '1'           *IN(L)
     C                   SETON                                        OF
     C                   ENDSR
      ****
      ******************
      * OUTPUT SPECS   *
      ******************
     OPIR100    E            HEAD           1 03
     O                                            6 'PIR100'
     O                                           20 'Requested by:'
     O                       USERID              31
     O                                           40 'Poinsettia'
     O               01                          49 'Schedule'
     O               02                          49 'Update  '
     O               04                          49 'Re-Cap  '
     O                                           59 'For Week:'
     O                       FRMDAT        Y     68
     O                       PAGE          Z     80
     O                                           77 'Page:'
     O          E            HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                       REV           4     60
     O                                           56 'Revision Number:'
     O                                           71 'Time:'
     O                       TIMOD               80 '  :  :  '
     O          E   N01      HEAD           1
     O                                           20 'Last Schedule Run:'
     O                       PWSCH               29 '  /  /  '
     O                                           51 'Last Update Run:'
     O                       PWUPD               60 '  /  /  '
      ** THE FOLLOWING IS TO GET A SPACE
     O          E            HEAD           1
     O          E            CUTHD          1
     O                                           24 'Cutting Report'
     O**               02                60 'Previous'
     O                                           71 'Cuttings'
     O          E            CUTHD          0
     O                                           14 'Item'
     O                                           31 'Description'
     O               02                          60 ' Report '
     O                                           70 'Needed'
     O          E            CUTHD          1
     O                                           30 '____________________'
     O                                           50 '____________________'
     O                                           70 '____________________'
     O          EF           CUTDET         1
     O                       PIITEM              22
     O              N89      IMDES1              50
     O               89                          42 '*** Item Not Found ***'
     O**               02      PT,WK J   60
     O                       NEED          J     70
     O***                                80 '________'
     O          EF           CUTTOT         1
     O                                           70 '--------'
     O          EF           CUTTOT         1
     O                                           55 '*** Total Cuttings ***'
     O                       TOTCUT        J     70
     O          EF           ITMHED         1
     O                                           21 '         Pre-Finished'
     O          EF           ITMHED         1
     O**               02                65 'Previous'
     O                                           75 '-Cuttings-'
     O          EF           ITMHED         0
     O                                            4 'Item'
     O                                           21 'Description'
     O**               02                64 'Report'
     O**                                 57 'Need'
     O                                           52 'Ordered'
     O                                           63 'Need'
     O                                           75 'Total'
     O                                           67 'Ea'
     O          EF           ITMHED         1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           75 '_______________'
     O**                                 85 '_____'
     O          EF           ITMDET      1  1
     O                       PSITEM              12
     O              N89      IMDES1              40
     O               89                          32 '*** Item Not Found ***'
     O**               02      PSTOTP1   63
     O**                       PSTOTN1   57
     O                       PSQORD        1     50
     O                       NEED          J     63
     O              N15      CUTS          J     75
     O              N15      IM#SED        4     67
     O               15                          67 '**'
     O          EF           SIZHED      1  0
     O                                           10 'Size Code:'
     O                       SZCODE              14
     O                       SZDESC              25
     O                                           37 'Ship Date:'
     O                       REQDAT        Y     46
     O          EF           SIZHED         1
     O                                           23 '_______________________'
     O                                           46 '_______________________'
     O          EF           SIZTOT         1
     O                                           50 '--------'
     O                                           63 '--------'
     O                                           75 '--------'
     O          EF           SIZTOT         1
     O                                           32 'Total for size:'
     O                       OSIZE               36
     O                       TOTORD        1     50
     O                       TOTNED        J     63
     O                       TOTCUT        J     75
     O          EF           MIXDET         1
     O                       IT(M)               32
     O              N89      IMDES1              55
     O               89                          52 '*** Item Not Found ***'
     O*                        NEED  J   63
     O                       CUTS          J     75
     O                       QT(M)         4     67
     O          EF           FINTOT      1  1
     O                                           50 '========'
     O                                           63 '========'
     O                                           75 '========'
     O          EF           FINTOT         1
     O                                           32 '*** Report Total=======>'
     O                       FITORD        1     50
     O                       FITNED        J     63
     O                       FITCUT        J     75
