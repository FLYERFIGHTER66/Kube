      *--------------------------------------------------------------     ARR380
      *                                                                   ARR380
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999                          ARR380
      *                                                                   ARR380
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO         ARR380
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE         ARR380
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED      ARR380
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR         ARR380
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT      ARR380
      *       BY EXPRESS WRITTEN PERMISSION OF                            ARR380
      *            EFD ENTERPRISES, INC.     215-643-5352                 ARR380
      *                                                                   ARR380
      *--------------------------------------------------------------     ARR380
      *PROGRAM NAME-------- ARR380                                        ARR380
      *SYSTEM-------------- MASTER FILES                                  ARR380
      *APPLICATION--------- CUSTOMER LABELS                               ARR380
      *                                                                   ARR380
      *                                                                   ARR380
      *            CHANGE--DATE-------DESCRIPTION                         ARR380
      *                                                                   ARR380
      *                                                                   ARR380
     FFMCUST    IF   E           K DISK
     FFMCUSTAL  IF   E           K DISK
     F                                     RENAME(RMCUST:MCUST)
     FFMCUSTZC  IF   E           K DISK
     F                                     RENAME(RMCUST:MCUSTZ)
     FARR380    O    F   40        PRINTER OFLIND(*INOF)                        ARR380
     F                                     FORMLEN(6)                           ARR380
     F                                     FORMOFL(6)
     FARR381    O    F   40        PRINTER OFLIND(*INOV)                        ARR380
     F                                     FORMLEN(18)                          ARR380
     F                                     FORMOFL(17)
     FARR383    O    F  132        PRINTER OFLIND(*INOD)                        ARR380
     F                                     FORMLEN(66)                          ARR380
     F                                     FORMOFL(60)
      *                                                                   ARR380
     D #CU             S             32    DIM(6)
      * 3 UP ARRAYS
     D LN1             S             32    DIM(3)
     D LN2             S             32    DIM(3)
     D LN3             S             32    DIM(3)
     D LN4             S             32    DIM(3)
     D LN5             S             32    DIM(3)
      *                                                                   ARR380
      *
     D                UDS
     D  LCO                    1      2  0
     D  LSIZE                  3      3  0
     D  LSEQ                   4      4  0
     D  LBTYPE                 5      6
     D  LETYPE                 7      8
     D  LBZIP                  9     13  0
     D  LEZIP                 14     18  0
     D  LSLSM                 19     20
     D  LTERR                 21     22
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *                                                                   ARR380
      * RENAME MCUST FIELDS
     IRMCUST
     I              CMNAME                      #WCUS1
     I              CMADD2                      #WCUS2
     I              CMADD3                      #WCUS3
     I              CMADD4                      #WCUS4
     I              CMCITY                      #WCUCT
     I              CMSTST                      #WCUST
     I              CMZIP                       #WCUZP
     IMCUST
     I              CMNAME                      #WCUS1
     I              CMADD2                      #WCUS2
     I              CMADD3                      #WCUS3
     I              CMADD4                      #WCUS4
     I              CMCITY                      #WCUCT
     I              CMSTST                      #WCUST
     I              CMZIP                       #WCUZP
     IMCUSTZ
     I              CMNAME                      #WCUS1
     I              CMADD2                      #WCUS2
     I              CMADD3                      #WCUS3
     I              CMADD4                      #WCUS4
     I              CMCITY                      #WCUCT
     I              CMSTST                      #WCUST
     I              CMZIP                       #WCUZP
      *                                                                   ARR380
      * LDASIZ  1 = 3" X 15/16" LABELS
      *         2 = 4" X 2-15/16" LABELS
      *
     C                   Z-ADD     1             X                 1 0
     C                   Z-ADD     0             L                 2 0
      *
     C     LSIZE         IFEQ      1                                                           ARR38
     C                   SETON                                        50                       ARR38
     C                   ENDIF
      *
     C     LSIZE         IFEQ      2                                                           ARR38
     C                   SETON                                        60                       ARR38
     C                   ENDIF
      *
     C     LSIZE         IFEQ      3                                                           ARR38
     C                   SETON                                        70                       ARR38
     C                   ENDIF
      *
     C     LSEQ          IFEQ      1                                                           ARR38
     C                   SETON                                        40                       ARR38
     C                   ENDIF
      *
     C     LSEQ          IFEQ      2                                                           ARR38
     C                   SETON                                        41                       ARR38
     C                   ENDIF
      *
     C     LSEQ          IFEQ      3                                                           ARR38
     C                   SETON                                        42                       ARR38
     C                   ENDIF
      *
     C     NXT           TAG
     C                   SETOFF                                       303132
     C   40              READ      FMCUST                                 95
     C   41              READ      MCUSTZ                                 95
     C   42              READ      MCUST                                  95
     C   95              GOTO      END
      *
     C     CMSTAT        IFEQ      'D'                                                         ARR38
     C                   GOTO      NXT                                                         ARR38
     C                   ENDIF
      *
     C     LBTYPE        IFEQ      *BLANKS
     C                   GOTO      NOTYPE
     C                   ENDIF
      *
     C     CMCTYP        IFLT      LBTYPE
     C     CMCTYP        ORGT      LETYPE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     NOTYPE        TAG
      *
     C     LBZIP         IFEQ      0
     C                   GOTO      NOZIP
     C                   ENDIF
      *
     C                   MOVEL     #WCUZP        ZIP               5 0
     C     ZIP           IFLT      LBZIP
     C     ZIP           ORGT      LEZIP
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     NOZIP         TAG
      *
     C     LSLSM         IFEQ      *BLANKS
     C                   GOTO      NOSLSM
     C                   ENDIF
      *
     C     CMSLSM        IFNE      LSLSM
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     NOSLSM        TAG
      *
     C     LTERR         IFEQ      *BLANKS
     C                   GOTO      NOTERR
     C                   ENDIF
      *
     C     CMTERR        IFNE      LTERR
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     NOTERR        TAG
      *
     C                   EXSR      #CUS
      *
     C   50              EXCEPT    LABS
     C   60              EXCEPT    LABB
     C   70              EXSR      LAB3
     C                   GOTO      NXT
      *                                                                   ARR380
     C     END           TAG                                                                   ARR38
     C                   SETON                                        LR
      *
      ***********
      * #CUS    *
      ***********
      *
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE SOLD TO
      *  ADDRESS.  WORK FIELDS ARE DEFINED AS:
      *
      *                 WORK  = CITY,STATE,ZIP(9 DIGIT)
      *                 WORK1 = CITY, STATE
      *                 WORK2 = ZIP CODE(XXXXX-XXXX)
      *                 WORK3 = STANDARD ZIP CODE(XXXXX)
      *                 WORK4 = ADDITIONAL ZIP CODE(-XXXX)
      *
      *  THE SUBROUTINE REQUIRES MOVING NAME AND ADDRESS INFORMATION TO
      *  BE CONDENSED TO A DATA STRUCTURE
      *
     C     #CUS          BEGSR
      *
     C                   MOVE      *BLANKS       #CU
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WCUS1        #CU(#X)
     C                   ADD       1             #X
     C     #WCUS2        COMP      *BLANKS                            929291
     C   91              GOTO      #CUS1
     C                   MOVEL     #WCUS2        #CU(#X)
     C                   ADD       1             #X
     C     #CUS1         TAG
     C     #WCUS3        COMP      *BLANKS                            929291
     C   91              GOTO      #CUS2
     C                   MOVEL     #WCUS3        #CU(#X)
     C                   ADD       1             #X
     C     #CUS2         TAG
     C     #WCUS4        COMP      *BLANKS                            929291
     C   91              GOTO      #CUS3
     C                   MOVEL     #WCUS4        #CU(#X)
     C                   ADD       1             #X
     C     #CUS3         TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WCUCT        CAT       #WCUST:1      WORK1
     C                   MOVEL     #WCUZP        WORK3
     C                   MOVE      #WCUZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #CU(#X)
     C                   ADD       1             #X
     C                   MOVEL     CMCOUN        #CU(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *
      *  ***************
      *  * 3 UP LABELS *
      *  ***************
     C     LAB3          BEGSR
     C                   ADD       1             L
     C                   MOVEL     #CU(1)        LN1(L)
     C                   MOVEL     #CU(2)        LN2(L)
     C                   MOVEL     #CU(3)        LN3(L)
     C                   MOVEL     #CU(4)        LN4(L)
     C                   MOVEL     #CU(5)        LN5(L)
     C     L             IFEQ      3
     C                   EXCEPT    LABL3
     C                   MOVE      *BLANKS       LN1
     C                   MOVE      *BLANKS       LN2
     C                   MOVE      *BLANKS       LN3
     C                   MOVE      *BLANKS       LN4
     C                   MOVE      *BLANKS       LN5
     C                   Z-ADD     0             L
     C                   END
     C                   ENDSR
      *
     OARR380    E            LABS           1 01                                ARR380
     O                       #CU(1)              35                             ARR380
     O          E            LABS           1                                   ARR380
     O                       #CU(2)              35                             ARR380
     O          E            LABS           1                                   ARR380
     O                       #CU(3)              35                             ARR380
     O          E            LABS           1                                   ARR380
     O                       #CU(4)              35                             ARR380
     O          E            LABS           1                                   ARR380
     O                       #CU(5)              35                             ARR380
     O          E            LABS           1                                   ARR380
     O                       #CU(6)              35                             ARR380
     OARR381    E            LABB           1 11                                ARR380
     O                       #CU(1)              38                             ARR380
     O          E            LABB           1                                   ARR380
     O                       #CU(2)              38                             ARR380
     O          E            LABB           1                                   ARR380
     O                       #CU(3)              38                             ARR380
     O          E            LABB           1                                   ARR380
     O                       #CU(4)              38                             ARR380
     O          E            LABB           1                                   ARR380
     O                       #CU(5)              38                             ARR380
     O          E            LABB           1                                   ARR380
     O                       #CU(6)              38                             ARR380
     OARR383    E            LABL3       1  1                                   ARR380
     O                       LN1(1)              34                             ARR380
     O                       LN1(2)              70                             ARR380
     O                       LN1(3)             105                             ARR380
     O          E            LABL3          1                                   ARR380
     O                       LN2(1)              34                             ARR380
     O                       LN2(2)              70                             ARR380
     O                       LN2(3)             105                             ARR380
     O          E            LABL3          1                                   ARR380
     O                       LN3(1)              34                             ARR380
     O                       LN3(2)              70                             ARR380
     O                       LN3(3)             105                             ARR380
     O          E            LABL3          1                                   ARR380
     O                       LN4(1)              34                             ARR380
     O                       LN4(2)              70                             ARR380
     O                       LN4(3)             105                             ARR380
     O          E            LABL3          1                                   ARR380
     O                       LN5(1)              34                             ARR380
     O                       LN5(2)              70                             ARR380
     O                       LN5(3)             105                             ARR380
