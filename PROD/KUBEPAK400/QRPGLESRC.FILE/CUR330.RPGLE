      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      **PROGRAM NAME-------- CUR330
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT ORDERS FOR CUTTINGS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFCUTSEQ   IF   E           K DISK
     FFCUTORDN  UF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFCALENCY  IF   E           K DISK
     FCUR330    O    F  120        PRINTER OFLIND(*INOF)
      *
      * ADDRESS ARRAYS
     D #CO             S             32    DIM(5)
     D #VE             S             32    DIM(6)
      * MESSAGE ARRAY
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)              MESSAGE
      *
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
     D  ORD#                   1      6  0                                      ARC380
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
WJB  D  Vendor         S                   Like(VMVEND)
      *
     IRMCORG
     I              RGNAME                      #WCO1
     I              RGADR1                      #WCO2
     I              RGADR2                      #WCO3
     I              RGADR3                      #WCO4
     I              RGCITY                      #WCOCT
     I              RGSTST                      #WCOST
     I              RGZIP                       #WCOZP
      *
     IRMVEND
     I              VMNAME                      #WVE1
     I              VMADD2                      #WVE2
     I              VMADD3                      #WVE3
     I              VMADD4                      #WVE4
     I              VMCITY                      #WVECT
     I              VMSTST                      #WVEST
     I              VMZIPD                      #WVEZP
      ****************
      *  START HERE  *
      ****************
      ** GET LOW AND HIGH SOW DATE
     C                   EXSR      GETSOW
     C                   Z-ADD     0             ORDDAT            6 0
     C                   Z-ADD     LSOW          CSOW              7 0
     C     NXTSEQ        TAG
WJB  C*                  READ      FCUTSEQ                                90
WJB  C     Vendor        READe     FCUTSEQ                                90
     C   90              DO
     C     CSOW          IFGE      HSOW
     C                   GOTO      END
     C                   END
      ** GET NEXT DATE
     C                   Z-ADD     CSOW          ##MDY
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   ADD       7             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        CSOW
     C                   Z-ADD     0             CSSEQ#
WJB  C     VendSeq#      KList
WJB  C                   KFld                    Vendor
WJB  C                   KFld                    CSSEQ#
WJB  C*    CSSEQ#        SETLL     FCUTSEQ
WJB  C     VendSeq#      SETLL     FCUTSEQ
     C                   GOTO      NXTSEQ
     C                   ENDDO
     C     ORDKEY        KLIST
WJB  C                   KFLD                    Vendor
     C                   KFLD                    ORD#
     C                   KFLD                    CSOW
     C                   KFLD                    CSLOOK
     C     ORDKEY        SETLL     FCUTORDN
     C     NXT           TAG
     C     ORDKEY        READE     FCUTORDN                               90
     C   90              GOTO      NXTSEQ
     C     ORDDAT        IFLE      0
     C     COORDD        CHAIN     FCALENCY                           93
     C                   Z-ADD     CLDATE        ORDDAT            6 0
     C                   END                                                    ORDDAT=0
     C     ITMKEY        KLIST
     C                   KFLD                    COITEM
     C                   KFLD                    COSIZE
     C     ITMKEY        CHAIN     FMINVT                             92
     C   92              MOVEL     MSG(1)        IMDES1
     C     COSOWD        CHAIN     FCALENCY                           93
      ** ORDER BY HUNDREDS
     C                   MOVEL     COQTOO        QTY               5 0
     C                   ADD       QTY           TOTQTY            9 0
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF DO
     C                   EXCEPT    DETL
     C                   MOVEL     'Y'           COPRTD
     C                   UPDATE    RCUTORD
     C                   GOTO      NXT
      ** END
     C     END           TAG
     C                   EXCEPT    TOTL
     C                   SETON                                        LR
      *
      **********
      * CONAME * MOVE COMPANY NAME AND ADDRESS TO CONDENSED DATA
      **********
      *
     C     CONAME        BEGSR
     C                   MOVE      *BLANKS       #CO
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WCO1         #CO(#X)
     C                   ADD       1             #X
     C     #WCO2         COMP      *BLANKS                            929291
     C   91              GOTO      #CO1
     C                   MOVEL     #WCO2         #CO(#X)
     C                   ADD       1             #X
     C     #CO1          TAG
     C     #WCO3         COMP      *BLANKS                            929291
     C   91              GOTO      #CO2
     C                   MOVEL     #WCO3         #CO(#X)
     C                   ADD       1             #X
     C     #CO2          TAG
     C     #WCO4         COMP      *BLANKS                            929291
     C   91              GOTO      #CO3
     C                   MOVEL     #WCO4         #CO(#X)
     C                   ADD       1             #X
     C     #CO3          TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WCOCT        CAT       #WCOST:1      WORK1
     C                   MOVEL     #WCOZP        WORK3
     C                   MOVE      #WCOZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #CO(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *
      **********
      * VENADR * CONDENSE VENDOR NAME AND ADDRESS
      **********
     C     VENADR        BEGSR
      *
     C     OLVEND        CHAIN     FMVEND                             11
     C   11              GOTO      EVENAD
      *
     C                   MOVE      *BLANKS       #VE
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WVE1         #VE(#X)
     C                   ADD       1             #X
     C     #WVE2         COMP      *BLANKS                            929291
     C   91              GOTO      #VE1
     C                   MOVEL     #WVE2         #VE(#X)
     C                   ADD       1             #X
     C     #VE1          TAG
     C     #WVE3         COMP      *BLANKS                            929291
     C   91              GOTO      #VE2
     C                   MOVEL     #WVE3         #VE(#X)
     C                   ADD       1             #X
     C     #VE2          TAG
     C     #WVE4         COMP      *BLANKS                            929291
     C   91              GOTO      #VE3
     C                   MOVEL     #WVE4         #VE(#X)
     C                   ADD       1             #X
     C     #VE3          TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WVECT        CAT       #WVEST:1      WORK1
     C                   MOVEL     #WVEZP        WORK3
     C                   MOVE      #WVEZP        WORK4
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
      *
     C     EVENAD        ENDSR
      ***********************
      ** GET HIGH LOW SOW  **
      ***********************
     C     GETSOW        BEGSR
     C                   Z-ADD     0             HSOW              7 0
     C                   Z-ADD     9999999       LSOW              7 0
WJB  C     VendOrd#      KList
WJB  C                   KFld                    Vendor
WJB  C                   KFld                    ORD#
WJB  C*    ORD#          SETLL     FCUTORDN
WJB  C     VendOrd#      SETLL     FCUTORDN
     C     NXTSOW        TAG
WJB  C*    ORD#          READE(N)  FCUTORDN                               90
WJB  C     VendOrd#      READE(N)  FCUTORDN                               90
     C   90              GOTO      ENDSOW
     C     COSOWD        IFLT      LSOW
     C                   Z-ADD     COSOWD        LSOW
     C                   END
     C     COSOWD        IFGT      HSOW
     C                   Z-ADD     COSOWD        HSOW
     C                   END
     C                   GOTO      NXTSOW
     C     ENDSOW        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
WJB  C     *Entry        PList
WJB  C                   Parm                    Vendor
WJB  C     Vendor        Chain     FMVEND
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     1             LCO               2 0
     C     LCO           CHAIN     FMCORG                             98
     C                   EXSR      CONAME
WJB  C*                  Z-ADD     23            OLVEND            6 0
WJB  C                   Z-ADD     Vendor        OLVEND            6 0
     C                   EXSR      VENADR
     C                   SETON                                        OF
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OCUR330    E            HEAD           1 03
     O                                           27 'Cutting Order #:'
     O                       COORD#        4     34
     O                                           45 'Date:'
     O                       ORDDAT        Y     54
     O                       PAGE          Z     83
     O                                           80 'Page:'
     O          E            HEAD        2  1
     O                                           13 'Ship To:'
     O                                           49 'Vendor:'
     O          E            HEAD           1
     O                       #CO(1)              38
     O                       #VE(1)              75
     O          E            HEAD           1
     O                       #CO(2)              38
     O                       #VE(2)              75
     O          E            HEAD           1
     O                       #CO(3)              38
     O                       #VE(3)              75
     O          E            HEAD           1
     O                       #CO(4)              38
     O                       #VE(4)              75
     O          E            HEAD           1
     O                       #CO(5)              38
     O                       #VE(5)              75
     O          E            HEAD           2
     O                       #VE(6)              75
     O          E            HEAD           0
     O                                           20 'Item Number    '
     O                                           32 'Description'
     O                                           56 'Week'
     O                                           65 'Sow Date'
     O                                           75 'Quantity'
     O          E            HEAD           1
     O                                           20 '     _______________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '_______________     '
     O          EF           DETL           1
     O                       COVITM              20
     O                       IMDES1              48
     O                       CLWEEK        4     55
     O                       CLDATE        Y     65
     O                       QTY           2     75
     O          E            TOTL        1  1
     O                                           75 '========'
     O          E            TOTL           1
     O                                           60 'Total Quantity=========>'
     O                       TOTQTY        2     75
** Messages
No Item Number Found                           1
