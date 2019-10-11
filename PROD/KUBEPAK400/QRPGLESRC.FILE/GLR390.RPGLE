      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      *PROGRAM NAME-------- GLR390
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- POST ALLOCATED G/L RECORDS
      *
      * OUTPUT ONE DETAIL RECORD TO THE ALLOCATED FROM ACCOUNT WITH THE
      *        TOTAL ALLOCATED AMOUNT
      *
      *        AND ONE DETAIL RECORD TO EACH ALLOCATED TO ACCOUNT WITH
      *        THE AMOUNT ALLOCATED TO THAT ACCOUNT.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFGLALOIN  IF   E           K DISK
     F                                     RENAME(RGLALO:GLALOI)
     FFGLALO    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFGLBAL    UF A E           K DISK
     FFGLCTL    UF   E           K DISK
     FFGLDET    O  A E             DISK
     FGLR390    O    F  120        PRINTER OFLIND(*INOF)
      *
      * GLBAL ARRAYS
     D GLP             S             11  2 DIM(13)
     D GLN             S             11  2 DIM(13)
      * WHAT MONTHS WRER POSTED ARRAY
      * MAPER ARRAYS
     D ST              S              6  0 DIM(13)
     D EN              S              6  0 DIM(13)
      *
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LCO                    1      2  0
     D  LACTP                  3      4  0
     D  LBCYMD                 5     11  0
     D  LECYMD                12     18  0
     D  LBDATE                19     24  0
     D  LEDATE                25     30  0
     D  CON                   31     43
     D                                     DIM(13)
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     D TODES           DS            30    OCCURS(1) INZ
     D  J1                     1     16    INZ('Allocated from: ')
     D  FRAC1                 17     20
     D  J2                    21     21    INZ('-')
     D  FRAC2                 22     25
     D  J3                    26     30    INZ('     ')
     D FRDES           DS            30    OCCURS(1) INZ
     D  F1                     1     18    INZ('Allocation Offset ')
     D  F2                    19     30    INZ('Entry       ')
      *
     IRGLBAL
     I              GLT01                       GLP(1)
     I              GLT02                       GLP(2)
     I              GLT03                       GLP(3)
     I              GLT04                       GLP(4)
     I              GLT05                       GLP(5)
     I              GLT06                       GLP(6)
     I              GLT07                       GLP(7)
     I              GLT08                       GLP(8)
     I              GLT09                       GLP(9)
     I              GLT10                       GLP(10)
     I              GLT11                       GLP(11)
     I              GLT12                       GLP(12)
     I              GLT13                       GLP(13)
     I              GLL01                       GLN(1)
     I              GLL02                       GLN(2)
     I              GLL03                       GLN(3)
     I              GLL04                       GLN(4)
     I              GLL05                       GLN(5)
     I              GLL06                       GLN(6)
     I              GLL07                       GLN(7)
     I              GLL08                       GLN(8)
     I              GLL09                       GLN(9)
     I              GLL10                       GLN(10)
     I              GLL11                       GLN(11)
     I              GLL12                       GLN(12)
     I              GLL13                       GLN(13)
      *
     IRMAPER
     I              ACST01                      ST(01)
     I              ACST02                      ST(02)
     I              ACST03                      ST(03)
     I              ACST04                      ST(04)
     I              ACST05                      ST(05)
     I              ACST06                      ST(06)
     I              ACST07                      ST(07)
     I              ACST08                      ST(08)
     I              ACST09                      ST(09)
     I              ACST10                      ST(10)
     I              ACST11                      ST(11)
     I              ACST12                      ST(12)
     I              ACST13                      ST(13)
     I              ACEN01                      EN(01)
     I              ACEN02                      EN(02)
     I              ACEN03                      EN(03)
     I              ACEN04                      EN(04)
     I              ACEN05                      EN(05)
     I              ACEN06                      EN(06)
     I              ACEN07                      EN(07)
     I              ACEN08                      EN(08)
     I              ACEN09                      EN(09)
     I              ACEN10                      EN(10)
     I              ACEN11                      EN(11)
     I              ACEN12                      EN(12)
     I              ACEN13                      EN(13)
      *****************
      ** START HERE  **
      *****************
     C   99              GOTO      END
     C                   MOVE      *BLANKS       ANY               1
     C                   Z-ADD     0             P                 2 0
     C                   Z-ADD     0             OPR               2 0
      ************************
      ** GET POSTED PERIODS **
      ************************
     C     NXTPR         TAG
     C                   ADD       1             P
     C     P             IFGT      #P
     C                   GOTO      END
     C                   END
     C                   MOVE      ST(P)         YY                2 0
     C                   MOVEL     YY            GTAPER
     C                   MOVE      P             GTAPER
     C                   Z-ADD     TDATE         GTDTLA
     C                   Z-ADD     ST(P)         GTTDAT
     C                   Z-ADD     ST(P)         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        GTCYMD
     C                   Z-ADD     TIMOD         GTTIME
     C                   MOVEL     USERID        GTUSER
     C                   MOVEL     'A/L'         GTSRCE
     C                   MOVEL     'G/L'         GTAPPL
     C                   MOVEL     'Y'           GTPOST
     C                   Z-ADD     P             PR                2 0
     C     LCO           SETLL     FGLALOIN
     C     NXT           TAG
     C                   READ      FGLALOIN                               90
     C   90              GOTO      NXTPR
     C     GACOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   END
     C     BALKEY        KLIST
     C                   KFLD                    GACOMP
     C                   KFLD                    GAFRAC
     C     BALKEY        CHAIN     FGLBAL                             91
     C   91              GOTO      NXT
     C     GLP(PR)       IFEQ      0.00
     C                   GOTO      NXT
     C                   END
     C   OF              DO
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    DETLH
      ** VERIFY ALL ALLOCATION RECS OK AND GET COUNT
     C                   EXSR      CHKALO
     C   99              GOTO      NXT
      ** IF HERE WE NEED TO ALLOCATE A BALANCE
     C     BALKEY        CHAIN     FMGLCH                             90
     C                   Z-ADD     GLP(P)        WRKBAL           11 2
      ** GET GLDET COMMON FIELDS FOR THIS ALLOCATION
     C                   MOVEL     GAJEPR        GTJEPR
     C                   Z-ADD     GAJENM        GTJENM
     C                   MOVEL     GAJESF        GTJESF
     C                   MOVEL     GAFRAC        FRAC1
     C                   MOVE      GAFRAC        FRAC2
     C                   MOVEL     GAJEDS        GTSRDS
     C                   MOVEL     FRDES         GTJEDS
      ** BUILD REVERSE ENTRY AND UPDAT GLBAL
     C                   Z-SUB     WRKBAL        GTDOL$
     C                   Z-ADD     GAFRAC        GTACCT
     C                   WRITE     RGLDET
     C                   ADD       GTDOL$        GLP(PR)
     C                   MOVEL     USERID        GLUSER
     C                   Z-ADD     TDATE         GLDTLA
     C                   Z-ADD     TIMOD         GLTIME
     C                   UPDATE    RGLBAL
     C                   MOVEL     'Y'           ANY
     C   OF              DO
     C                   EXCEPT    HDG
     C                   EXCEPT    HDGPR
     C                   SETOFF                                       OF
     C                   Z-ADD     PR            OPR
     C                   ENDDO
     C     PR            IFNE      OPR
     C                   EXCEPT    HDGPR
     C                   Z-ADD     PR            OPR
     C                   END
     C                   EXCEPT    DETLF
      ** GET DETAIL RECORDS
     C     ALOKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GTJEPR
     C                   KFLD                    GTJENM
     C                   KFLD                    GTJESF
     C     ALOKEY        SETLL     FGLALO
     C                   Z-ADD     0             APPLED           11 2
     C                   Z-ADD     0             AMOUNT           11 2
     C                   Z-ADD     GTDOL$        TOTAL            11 2
     C     NXTALO        TAG
     C     ALOKEY        READE     FGLALO                                 90
     C   90              GOTO      ENDALO
     C     COUNT         IFGT      1
     C     GAPCT         DIV       100           PCT               8 4
     C     WRKBAL        MULT(H)   PCT           AMOUNT
     C                   ELSE
     C     WRKBAL        SUB       APPLED        AMOUNT
     C                   ENDIF
     C                   ADD       AMOUNT        APPLED
     C                   MOVEL     GAJEDS        GTSRDS
     C                   MOVEL     TODES         GTJEDS
      ** BUILD REVERSE ENTRY AND UPDAT GLBAL
     C                   Z-ADD     AMOUNT        GTDOL$
     C                   Z-ADD     GATOAC        GTACCT
     C                   ADD       AMOUNT        TOTAL
     C                   WRITE     RGLDET
     C     BALKY2        KLIST
     C                   KFLD                    GACOMP
     C                   KFLD                    GATOAC
     C     BALKY2        CHAIN     FMGLCH                             91
     C     BALKY2        CHAIN     FGLBAL                             91
     C   91              DO
     C                   CLEAR                   RGLBAL
     C                   MOVEL     'A'           GLSTAT
     C                   Z-ADD     GACOMP        GLCOMP
     C                   Z-ADD     GATOAC        GLGLNO
     C                   ENDDO
     C                   ADD       AMOUNT        GLP(PR)
     C                   MOVEL     USERID        GLUSER
     C                   Z-ADD     TDATE         GLDTLA
     C                   Z-ADD     TIMOD         GLTIME
     C  N91              UPDATE    RGLBAL
     C   91              WRITE     RGLBAL
     C   OF              DO
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    DETLT
     C                   SUB       1             COUNT
     C                   GOTO      NXTALO
     C     ENDALO        TAG
     C   OF              DO
     C                   EXCEPT    HDG
     C                   EXCEPT    HDGPR
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    TOTL
     C                   GOTO      NXT
      ** END PROGRAM
     C     END           TAG
     C     ANY           IFEQ      'Y'
     C     LCO           CHAIN     FGLCTL                             91
     C                   Z-ADD     TDATE         GZALLP
     C  N91              UPDATE    RGLCTL
     C                   ENDIF
     C                   SETON                                        LR
      ***************************
      ** CHECK ALLOCATION RECS **
      ***************************
     C     CHKALO        BEGSR
     C                   Z-ADD     0             COUNT             5 0
     C                   SETOFF                                       9998
     C     NXTCHK        TAG
     C     MGLKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GATOAC
     C     MGLKEY        CHAIN     FMGLCH                             99
     C  N99GCSTAT        IFEQ      'D'
     C                   SETON                                        9998
     C                   END
     C   99              GOTO      ENDCHK
     C                   ADD       1             COUNT
     C     BALKEY        READE     FGLALOIN                               90
     C  N90              GOTO      NXTCHK
     C     ENDCHK        TAG
     C   99
     CAN OF              DO
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO
     C   99              EXCEPT    DETER
      ** START INPUT AT NEXT RECORD
     C     GAFRAC        ADD       1             NXTACT            8 0
     C     GAKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    NXTACT
     C     GAKEY         SETLL     FGLALOIN
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   SETOFF                                       99
     C     LCO           CHAIN     FMCORG                             91
     C     LCO           CHAIN     FMAPER                             91
      * BUILD COMMON G/L DETAIL FIELDS
     C                   MOVEL     'A'           GTSTAT
     C                   Z-ADD     LCO           GTCOMP
     C                   Z-ADD     LCO           CONO              2 0
     C                   Z-ADD     LACTP         #P                2 0
     C     #P            IFEQ      99
     C                   SETON                                        99
     C                   ELSE
     C                   SETON                                        OF
     C                   END
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OGLR390    E            HDG            1 03
     O                                            6 'GLR390'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           68 'G/L Allocations Posting'
     O                                           75 'Report'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            0
     O                                           11 'J/E Number'
     O                                           25 'Description'
     O****                               65 'From Account'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           44 '____________________'
     O*                                  72 '________________________'
     O*                                  96 '________________________'
     O*                                 120 '________________________'
     O          E            HDGPR       1  0
     O                                           52 'For Period:'
     O                       PR                  55
     O                       ST(PR)        Y     66
     O                                           69 '-'
     O                       EN(PR)        Y     79
     O          E            HDGPR          1
     O                                           65 '________________________'
     O                                           79 '______________'
     O          EF           DETLH          1
     O                       GAJEPR               3
     O                       GAJENM        4     10
     O                       GAJESF              13
     O                       GAJEDS              44
     O          EF           DETER          2
     O                                           25 'NOT Posted Allocation'
     O                                           45 'Contains an Invaild'
     O                                           61 'Account Number.'
     O               98                          79 'Account Number Deleted.'
     O          EF           DETLF          0
     O                                           44 'Account #'
     O                                           57 'Description'
     O                                           89 'Amount'
     O          EF           DETLF          1
     O                                           44 '_________'
     O                                           57 '___________'
     O                                           89 '______'
     O          EF           DETLF          1
     O                                           34 'From:'
     O                       GAFRAC              44 '    -    '
     O                       GCDESC              75
     O                       GTDOL$        J     90
     O          EF           DETLT          1
     O                                           34 'To:'
     O                       GATOAC              44 '    -    '
     O                       GCDESC              75
     O                       AMOUNT        J     90
     O          EF           TOTL           1
     O                                           90 '__________'
     O          EF           TOTL           2
     O                                           74 'Total =====>'
     O                       TOTAL         J     90
