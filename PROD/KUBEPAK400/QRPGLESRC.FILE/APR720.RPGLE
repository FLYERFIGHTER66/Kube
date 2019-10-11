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
      *PROGRAM NAME--------- APR720
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *APPLICATION---------- PRINT 1099 FORMS
      *DESCRIPTION-          A/P 1099 FORMS. USE YEARLY VENDOR FILE.
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFV1099    UF   E           K DISK
     FFAPCTL    UF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FMSC       O    F  132        PRINTER OFLIND(*INOF)
     F                                     FORMLEN(22)
     F                                     FORMOFL(21)
     FINT       O    F  132        PRINTER OFLIND(*INOA)
     F                                     FORMLEN(22)
     F                                     FORMOFL(21)
      *
      * WORK ARRAY
     D #CO             S             32    DIM(5)
     D #VE             S             32    DIM(3)
      *
      * 1099 BOX  PRINT ARRAY
     D BOX             S             11  2 DIM(9)
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      *  PROGRAM NAME
     D  PROGID                 1     10
      *  RUN LIBRARY
     D  RLIBR                 81     90
      *  USER I.D.
     D  USERID               254    261
      *  SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
     D  LTYPE                  3      3  0
     D  LRPRT                  4      4
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
     IRMCORG
     I              RGNAME                      #WCO1
     I              RGADR1                      #WCO2
     I              RGADR2                      #WCO3
     I              RGADR3                      #WCO4
     I              RGCITY                      #WCCT
     I              RGSTST                      #WCST
     I              RGZIP                       #WCZP
      *
     IRMVEND
     I              VMNAME                      #WVE1
     I              VMADD2                      #WVE2
     I              VMCITY                      #WVCT
     I              VMSTST                      #WVST
     I              VMZIPD                      #WVZP
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
      * CHECK COMPANY
      *
     C     LCO           CHAIN     FMCORG                             90
     C                   Z-ADD     0             NOCOMP            2 0
     C     NOCOMP        CHAIN(N)  FAPCTL                             90
      *
     C                   EXSR      WRKARY
      *
      * ? REPRINT
      *
     C     LRPRT         IFEQ      'Y'
     C                   SETON                                        50
     C                   ENDIF
      *
      * TYPE 1=MISC INCOME  2=INTEREST
      *
     C     LTYPE         IFEQ      1
     C                   SETON                                        55
     C                   ENDIF
     C     LTYPE         IFEQ      2
     C                   SETON                                        56
     C                   ENDIF
      *
     C                   Z-ADD     *ZEROS        VVEND             6 0
     C     KEY8          KLIST
     C                   KFLD                    LCO
     C                   KFLD                    VVEND
     C     KEY8          SETLL     FV1099
     C     NXT           TAG
     C                   SETOFF                                       7778
     C                   READ      FV1099                                 90
     C   90              GOTO      END
      *
     C     YMCONO        IFGT      LCO
     C                   GOTO      END
     C                   ENDIF
      *
     C  N50YMPRTD        IFEQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     YMVEND        CHAIN     FMVEND                             91
     C   91              GOTO      NXT
     C     VMFLAG        IFEQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   55VMFLAG        IFEQ      9
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   56VMFLAG        IFNE      9
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VMFLAG        IFNE      0
     C     YMPAID        ANDLE     AZMIS$
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VMFLAG        IFEQ      9
     C     YMPAID        ANDLT     AZINT$
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   EXSR      VENARY
      *
     C     VMTXCD        IFEQ      'F'
     C                   MOVEL     VMTXID        VMTXFA            2
     C                   MOVE      VMTXID        VMTXFB            7
     C                   SETON                                        77
     C                   ENDIF
     C     VMTXCD        IFEQ      'S'
     C                   MOVEL     VMTXID        VMTXSA            3
     C                   MOVE      VMTXID        VMTXSS            6
     C                   MOVEL     VMTXSS        VMTXSB            2
     C                   MOVE      VMTXSS        VMTXSC            4
     C                   SETON                                        78
     C                   ENDIF
      *
      * GET BOX TO PRINT IN
      *
     C                   Z-ADD     0             BOX
     C     VMFLAG        IFNE      9
     C                   MOVE      VMFLAG        B                 1 0
     C                   Z-ADD     YMPAID        BOX(B)
     C                   ENDIF
     C   55              EXCEPT    MISC
     C   56              EXCEPT    INTR
     C                   MOVEL     'Y'           YMPRTD
     C                   UPDATE    RYVEND
     C                   GOTO      NXT
      *
     C     END           TAG
     C     LCO           CHAIN     FAPCTL                             90
     C  N50              Z-ADD     TDATE         AZDT10
     C                   Z-ADD     TDATE         AZDTLA
     C                   Z-ADD     TIMOD         AZTIME
     C                   MOVEL     USERID        AZUSER
     C  N50              UPDATE    RAPCTL
     C                   SETON                                        LR
      *
      ***********
      * WRKARY  *
      ***********
      *
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE COMPANY
      *  FILE.  WORK FIELDS ARE DEFINED AS:
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
     C     WRKARY        BEGSR
      *
     C                   MOVE      *BLANKS       #CO
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WCO1         #CO(#X)
     C                   ADD       1             #X
     C     #WCO2         COMP      *BLANKS                            929291
     C   91              GOTO      #WC1
     C                   MOVEL     #WCO2         #CO(#X)
     C                   ADD       1             #X
     C     #WC1          TAG
     C     #WCO3         COMP      *BLANKS                            929291
     C   91              GOTO      #WC2
     C                   MOVEL     #WCO3         #CO(#X)
     C                   ADD       1             #X
     C     #WC2          TAG
     C     #WCO4         COMP      *BLANKS                            929291
     C   91              GOTO      #WC3
     C                   MOVEL     #WCO4         #CO(#X)
     C                   ADD       1             #X
     C     #WC3          TAG
     C                   MOVE      *BLANKS       WORK             32            BLANK
     C                   MOVE      *BLANKS       WORK1            21            BLANK
     C                   MOVE      *BLANKS       WORK2            10             "
     C                   MOVE      *BLANKS       WORK3             5             "
     C                   MOVE      *BLANKS       WORK4             5             "
     C     #WCCT         CAT       #WCST:1       WORK1
     C                   MOVEL     #WCZP         WORK3
     C                   MOVE      #WCZP         WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2                          19002-1525
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #CO(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      ***********
      * VENARY  *
      ***********
      *
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE COMPANY
      *  FILE.  WORK FIELDS ARE DEFINED AS:
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
     C     VENARY        BEGSR
      *
     C                   MOVE      *BLANKS       #VE
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WVE1         #VE(#X)
     C                   ADD       1             #X
     C     #WVE2         COMP      *BLANKS                            929291
     C   91              GOTO      #WV2
     C                   MOVEL     #WVE2         #VE(#X)
     C                   ADD       1             #X
     C     #WV2          TAG
     C                   MOVE      *BLANKS       WORK             32            BLANK
     C                   MOVE      *BLANKS       WORK1            21            BLANK
     C                   MOVE      *BLANKS       WORK2            10             "
     C                   MOVE      *BLANKS       WORK3             5             "
     C                   MOVE      *BLANKS       WORK4             5             "
     C     #WVCT         CAT       #WVST:1       WORK1
     C                   MOVEL     #WVZP         WORK3
     C                   MOVE      #WVZP         WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2                          19002-1525
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #VE(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *
     O**C     H 00     1P
     O**                                  1 '*'
     O*SC     E   20           MICE
     O*                                  37 ' '
     OMSC       E            MISC           1 05
     O                       #CO(1)              37
     O                       BOX(1)        M     52
     O          E            MISC           1
     O                       #CO(2)              37
     O          E            MISC           1
     O                       #CO(3)              37
     O                       BOX(2)        M     52
     O          E            MISC           1
     O                       #CO(4)              37
     O          E            MISC           1
     O                       #CO(5)              37
     O                       BOX(3)        M     52
     O          E            MISC             11
     O               77      VMTXFA              27
     O               77                          28 '-'
     O               77      VMTXFB              35
     O               78      VMTXSA              28
     O               78                          29 '-'
     O               78      VMTXSB              31
     O               78                          32 '-'
     O               78      VMTXSC              36
     O                       BOX(5)        M     67
     O          E            MISC           1 13
     O                       #VE(1)              37
     O                       BOX(6)        M     52
     O                       BOX(7)        M     67
     O          E            MISC           1 16
     O                       #VE(2)              37
     O                       BOX(8)        M     52
     O          E            MISC           1 18
     O                       #VE(3)              37
     O          E            MISC           1 20
     O                       YMVEND        4     18
      ****** 1099 INT
     O*NT     E   20           INTE
     O*                                  37 ' '
     OINT       E            INTR           1 05
     O                       #CO(1)              37
     O          E            INTR           1
     O                       #CO(2)              37
     O          E            INTR           1
     O                       #CO(3)              37
     O          E            INTR           1
     O                       #CO(4)              37
     O          E            INTR           1
     O                       #CO(5)              37
     O          E            INTR             11
     O               77      VMTXFA              27
     O               77                          28 '-'
     O               77      VMTXFB              35
     O               78      VMTXSA              28
     O               78                          29 '-'
     O               78      VMTXSB              31
     O               78                          32 '-'
     O               78      VMTXSC              36
     O                       YMPAID        M     60
     O          E            INTR           1 13
     O                       #VE(1)              37
     O          E            INTR           1 16
     O                       #VE(2)              37
     O          E            INTR           1 18
     O                       #VE(3)              37
     O          E            INTR           1 20
     O                       YMVEND        4     18
