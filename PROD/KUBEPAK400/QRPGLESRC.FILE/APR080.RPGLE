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
      *PROGRAM NAME-------- APR080
      *COMPANY------------- EFD ENTERPRISES, INC.
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- VENDOR LABELS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMVEND    IF   E           K DISK
     FAPR080    O    F  132        PRINTER OFLIND(*INOF)
     F                                     FORMLEN(6)
     F                                     FORMOFL(6)
     FAPR081    O    F  132        PRINTER OFLIND(*INOV)
     F                                     FORMLEN(18)
     F                                     FORMOFL(17)
      *
      *
     D #VE             S             32    DIM(6)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
     D  LSIZE                  3      3  0
     D  LORDER                 4      4  0
     D  LBTYPE                 5      5
     D  LETYPE                 6      6
     D  LBZIP                  7     11
     D  LEZIP                 12     16
     D  L1099                 17     17
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *
     IRMVEND
     I              VMNAME                      #WVEN1
     I              VMADD2                      #WVEN2
     I              VMADD3                      #WVEN3
     I              VMADD4                      #WVEN4
     I              VMCITY                      #WVENC
     I              VMSTST                      #WVENS
     I              VMZIPD                      #WVENZ
      *
      * LSIZE   1 = 3" X 15/16" LABELS
      *         2 = 4" X 2-15/16" LABELS
      *
     C                   Z-ADD     1             X                 1 0
      *
     C     LSIZE         IFEQ      1
     C                   SETON                                        50
     C                   ENDIF
      *
     C     LSIZE         IFEQ      2
     C                   SETON                                        60
     C                   ENDIF
      *
     C     NXT           TAG
     C                   SETOFF                                       303132
     C                   READ      FMVEND                                 95
     C   95              GOTO      END
      *
     C     VMSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LBTYPE        IFEQ      *BLANKS
     C                   GOTO      NOTYPE
     C                   ENDIF
      *
     C     VMTYPE        IFLT      LBTYPE
     C     VMTYPE        ORGT      LETYPE
     C                   GOTO      NXT
     C                   ENDIF
     C     NOTYPE        TAG
      *
     C     LBZIP         IFEQ      *BLANKS
     C                   GOTO      NOZIP
     C                   ENDIF
      *
     C     #WVENZ        IFLT      LBZIP
     C     #WVENZ        ORGT      LEZIP
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     NOZIP         TAG
      *
     C     L1099         IFGT      *BLANKS
     C     VMFLAG        ANDEQ     *ZEROS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   EXSR      #VEN
      *
     C   50              EXCEPT    LABS
     C   60              EXCEPT    LABB
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      ***********
      * #VEN    *
      ***********
      *
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE VENDOR
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
     C     #VEN          BEGSR
      *
     C                   MOVE      *BLANKS       #VE
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WVEN1        #VE(#X)
     C                   ADD       1             #X
     C     #WVEN2        COMP      *BLANKS                            929291
     C   91              GOTO      #VED1
     C                   MOVEL     #WVEN2        #VE(#X)
     C                   ADD       1             #X
     C     #VED1         TAG
     C     #WVEN3        COMP      *BLANKS                            929291
     C   91              GOTO      #VED2
     C                   MOVEL     #WVEN3        #VE(#X)
     C                   ADD       1             #X
     C     #VED2         TAG
     C     #WVEN4        COMP      *BLANKS                            929291
     C   91              GOTO      #VED3
     C                   MOVEL     #WVEN4        #VE(#X)
     C                   ADD       1             #X
     C     #VED3         TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WVENC        CAT       #WVENS:1      WORK1
     C                   MOVEL     #WVENZ        WORK3
     C                   MOVE      #WVENZ        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #VE(#X)
     C                   ADD       1             #X
     C                   MOVEL     VMCOUN        #VE(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *
     OAPR080    E            LABS           1 01
     O                       #VE(1)              35
     O          E            LABS           1
     O                       #VE(2)         B    35
     O          E            LABS           1
     O                       #VE(3)         B    35
     O          E            LABS           1
     O                       #VE(4)         B    35
     O          E            LABS           1
     O                       #VE(5)         B    35
     O          E            LABS           1
     O                       #VE(6)              35
     OAPR081    E            LABB           1 11
     O                       #VE(1)              38
     O          E            LABB           1
     O                       #VE(2)              38
     O          E            LABB           1
     O                       #VE(3)              38
     O          E            LABB           1
     O                       #VE(4)              38
     O          E            LABB           1
     O                       #VE(5)              38
     O          E            LABB           1
     O                       #VE(6)              38
