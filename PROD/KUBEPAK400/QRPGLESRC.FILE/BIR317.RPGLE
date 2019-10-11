    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.   1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   .  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES INC.      215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR317
      *SYSTEM-------------- GREENHOUSE MANAGEMENT
      *APPLICATION--------- PRINTING OF PICK SLIPS BY SHIP VIA
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 1/12/00 EFD USE QUERY FILE
      * 3/23/00 EFD TAKE OUT QUERY FILE
      *  1/19/01 EFD PRINT PUT DOWN LOCATION
      *  1/19/01 EFD CHANGE TO SORT BY BIN# AND PRINT BIN#
      *
     FFIORDRSS  IF   E           K DISK
     FFHORDRTR  UF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMSVIA    IF   E           K DISK
     FFPPO      IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FBIR317    O    F   80        PRINTER OFLIND(*INOF)
     FBIR317X   O    F   80        PRINTER OFLIND(*INOV)
     F                                     EXTIND(*INU1)
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$DotW
    ?D/COPY QFunctDefn,$DateMDY

      *
      * ADDRESS ARRAYS
     D #SL             S             32    DIM(5)
     D #SH             S             32    DIM(5)
     D                UDS
     D  LCONO                  1      2  0
     D  LJOBQ                  6      6
     D  LP1ID                 17     26
     D  LP2ID                 27     36
     D  LBEGDT                37     42  0
     D  LENDDT                43     48  0
     D  LSELEC                49     49  0
     D  LBORD                 50     55  0
     D  LPC1                  59     60
     D  LPC2                  61     62
     D  LRTE1                 63     64
     D  LRTE2                 65     66
     D  LPHY1                 67     67
     D  LPHY2                 68     68
     D  LPREV                 69     69
     D  LSHP1                 70     71
     D  LSHP2                 72     73
     D  LLOC1                 74     76
     D  LLOC2                 77     79
     D  LTAG                  80     80  0
     D  LEORD                 81     86  0
     D  AREA                  87     88
     D  LCANCL               133    133
      *
     D  Route          S             18A
      *
     IRHORDR
     I              OHNAME                      #WSHP1
     I              OHSHP2                      #WSHP2
     I              OHSHP3                      #WSHP3
     I              OHSHP4                      #WSHP4
     I              OHSHCT                      #WSHCT
     I              OHSHST                      #WSHST
     I              OHSHZP                      #WSHZP
     I              OHSLD1                      #WSLD1
     I              OHSLD2                      #WSLD2
     I              OHSLD3                      #WSLD3
     I              OHSLD4                      #WSLD4
     I              OHSLCT                      #WSLCT
     I              OHSLST                      #WSLST
     I              OHSLZP                      #WSLZP
      *
      *  GET DAY OF CENTURY
      *
     C     LBEGDT        IFGT      0
     C                   Eval      LENDDT = LBEGDT
     C                   SETON                                        19
     C                   Z-ADD     LBEGDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        BEGCYM            7 0
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         BDATE             5 0
     C                   Z-ADD     LENDDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ENDCYM            7 0
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EDATE             5 0
     C                   ENDIF
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         CURDAT            5 0
     C                   Z-ADD     1             PACK              4 0
     C                   Z-ADD     0             SLIP              4 0
      *
     C     LPC1          IFGT      *BLANKS
     C                   SETON                                        10
     C                   ENDIF
      *
     C     LRTE1         IFGT      *BLANKS
     C                   SETON                                        11
     C                   ENDIF
      *
     C     LBORD         IFGT      *ZEROS
     C                   SETON                                        12
     C                   ENDIF
      *
     C     LPHY1         IFGT      *BLANKS
     C                   SETON                                        14
     C                   ENDIF
      *
     C     LSHP1         IFGT      *BLANKS
     C                   SETON                                        15
     C                   ENDIF
      *
     C     LLOC1         IFGT      *BLANKS
     C                   MOVEL     LLOC1         SHFR              3
     C                   SETON                                        16
     C                   ENDIF
      *
      * PLANT ORDERS ONLY
     C     LTAG          IFEQ      1
     C                   SETON                                        18
     C                   ENDIF
      * TAG ORDERS ONLY
     C     LTAG          IFEQ      2
     C                   SETON                                        17
     C                   ENDIF
      *
     C     LP2ID         IFGT      *BLANKS
     C                   SETON                                        88
     C                   ENDIF
      ** SETLL
     C                   Z-ADD     LBORD         OHORD#
     C                   MOVEL     'A'           STAT              1
      *
     C*?????               MOVE '0'       PRTFLG  1
      *
      *** FIND A LINE ITEM TO PRINT ON PICK SLIP
      *
     C                   MOVEL     'A '          SHPC              2
     C                   MOVEL     'A '          STAT
     C***        NXT       TAG
     C                   Z-ADD     0             LINE
      *
     C     LBEGDT        SETLL     FHORDRTR
     C     NXTI          TAG
     C                   SETOFF                                       4350
     C                   READ      RHORDR                                 77
     C   77              GOTO      END
     C   19OHDTCN        IFGT      LENDDT
     C     OHDTCN        ANDGT     0
     C                   GOTO      END
     C                   END
      *
      *
EFD01C   10              DO
EFD01C                   EXSR      CKPC
EFD01C   30              GOTO      PCOK
EFD01C  N30              GOTO      NXTI
     C                   ENDDO
EFD01C     PCOK          TAG
      * CHECK FOR LOCATION
     C     AREA          IFGT      *BLANKS
     C                   EXSR      CKAREA
     C  N31              GOTO      NXTI
     C                   END
      *
     C   19OHDTCN        IFGT      *ZEROS
     C     OHDTCN        IFNE      LBEGDT
     C     OHDTCN        ORNE      LENDDT
     C                   GOTO      NXTI
     C                   ENDIF
     C                   ENDIF
      *
     C   12OHORD#        IFLT      LBORD
     C                   GOTO      NXTI
     C                   ENDIF
      *
      * CHECK IF THIS IS REPRINT
      *
      *?
      *
     C   12OHORD#        IFGT      LEORD
     C                   EXCEPT    TL1
     C                   Z-ADD     1             PACK
     C                   Z-ADD     0             TOTQTY
     C                   Z-ADD     0             TOTBO
EFD  C                   Z-ADD     0             LINE
     C                   GOTO      END
     C                   ENDIF
      *
     C                   SETOFF                                       202155
     C                   SETOFF                                       2223
     C                   Z-ADD     1             PGE               3 0
      *
      *
     C*          OHPLPT    IFEQ 'X'
     C*                    GOTO NXTI
     C*                    ENDIF
      *
     C     OHPONO        IFGT      *BLANKS
     C                   SETON                                        24
     C                   ENDIF
      *
      * CHECK IF THIS IS REPRINT
      *
     C     OHPLPT        IFEQ      'P'
     C                   SETON                                        42
     C                   ENDIF
      *
      * 17=TAG ORDER
      *
     C   17OHOLST        IFNE      'TAG   '
     C**         OIORD#    ADD  1         OHORD#
     C                   GOTO      NXTI
     C                   ENDIF
      *
      * 18=PLANT ORDER
      *
     C   18OHOLST        IFEQ      'TAG   '
     C**         OIORD#    ADD  1         OHORD#
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OHSTAT        IFEQ      'D'
     C     OHCOFL        OREQ      'Y'
     C**         OIORD#    ADD  1         OHORD#
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C   14OHPHYT        IFLT      LPHY1
     C     OHPHYT        ORGT      LPHY2
     C**         OIORD#    ADD  1         OHORD#
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C   15OHSHPC        IFLT      LSHP1
     C     OHSHPC        ORGT      LSHP2
     C**         OIORD#    ADD  1         OHORD#
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OHSHPC        CHAIN     FMSVIA                             98
     C                   MOVEL     SVDESC        SDESC            20
     C                   MOVEL     OHTMCD        TERMCD            2
     C     TERMCD        CHAIN     FMTERM                             98
      *
     C     OHCUST        CHAIN     FMCUST                             98
      * GET OTHER PUT DOWN LOCATIONS
     C     OHORD#        CHAIN     FPPO                               51
     C   51              DO
     C                   MOVE      *BLANKS       POLOWC
     C                   MOVE      *BLANKS       POLOWF
     C                   MOVE      *BLANKS       POLORB
     C                   ENDDO
      *
     C                   EXSR      #SLD
     C                   EXSR      #SHP
     C*                    EXSR GETNAM
      *
     C     OHROUT        IFGT      *BLANKS
     C                   SETON                                        20
     C                   If        OHSHPC = '01'
     C                   If        %SubSt(OHROUT:1:1) >= 'A' and
     C                             %SubSt(OHROUT:1:1) <= 'Z'
     C                   Eval      Route = %SubSt($DotW($DateMDY(OHDTCN)):1:3)
     C                             + '. Van: ' + OHROUT
     C                   Else
     C                   Eval      Route = %SubSt($DotW($DateMDY(OHDTCN)):1:3)
     C                             + '. Trailer: ' + OHROUT
     C                   EndIf
     C                   Else
     C                   Eval      Route = OHROUT
     C                   EndIf
     C                   ENDIF
      *
     C     OHSTOP        IFGT      *ZEROS
     C                   SETON                                        21
     C                   ENDIF
      *
     C     OHSPIN        IFGT      *BLANKS
     C                   SETON                                        22
     C                   ENDIF
      *
     C     OHSHIN        IFGT      *BLANKS
     C                   SETON                                        23
     C                   ENDIF
      ** CHECK IF FUTURE DATE
     C                   Z-ADD     OHDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##DDD         SUB       CURDAT        TSTD              5 0
     C     TSTD          COMP      2                                  78
      *
     C                   ADD       1             SLIP
EFD  C     PACK          IFEQ      1
      **
     C                   Call      'BIR103'
     C                   Parm                    OHDTRQ                         ?Ship Date
     C                   Parm                    OHORD#                         ?Order Number
     C                   Parm                    Qty_Carts         5 2          ?Number of Carts
     C                   Parm      'N'           Show_YN           1            ?Show Screen Y/N
     C                   Z-add     Qty_Carts     Qty_Carts1        4 1
      **
     C                   EXCEPT    HDG
     C     OHSTA         IFEQ      'Y'
     C                   EXCEPT    HDGSTA
     C                   END
EFD  C                   END
     C                   MOVEL     'P'           OHPLPT
     C                   UPDATE    RHORDR
      ** SET LL ON IORSR AND RE READ FROM BEGINING
     C                   MOVEL     'A '          SHPC              2
     C                   MOVEL     'A '          STAT
     C     NEWKEY        KLIST
     C                   KFLD                    STAT
     C                   KFLD                    SHFR
     C                   KFLD                    OHORD#
     C     NEWKEY        SETLL     FIORDRSS
     C     NXTI2         TAG
     C                   READ      FIORDRSS                               90
     C   90              DO
     C   55              EXCEPT    TL1
     C                   Z-ADD     *ZEROS        TOTORD
     C**                   ADD  1         OHORD#
     C                   Z-ADD     1             PACK
     C                   Z-ADD     0             TOTQTY
     C                   Z-ADD     0             TOTBO
     C                   GOTO      NXTI
     C                   ENDDO
      *
     C     OIORD#        IFNE      OHORD#
     C   55              EXCEPT    TL1
     C                   Z-ADD     *ZEROS        TOTORD
     C**                   ADD  1         OHORD#
     C                   Z-ADD     1             PACK
     C                   Z-ADD     0             TOTQTY
     C                   Z-ADD     0             TOTBO
     C                   GOTO      NXTI
     C                   ENDIF
      *
      *  GET DAY OF CENTURY AND VALIDATE DATE RANGE
      *
     C   19OIDTRQ        IFGT      *ZEROS
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RSHDT             5 0
     C                   ENDIF
     C   19RSHDT         IFGT      *ZEROS
     C     OIDTRQ        ANDNE     OHDTRQ
     C                   GOTO      NXTI2
     C                   ENDIF
     C     AREA          IFGT      *BLANKS
     C                   MOVE      OIBIN#        BIN
     C     BIN           IFNE      AREA
     C                   GOTO      NXTI2
     C                   ENDIF
     C                   ENDIF
      *
     C     OIITYP        IFEQ      'C'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'S'
     C     OIITYP        OREQ      'N'
     C                   MOVEL     *BLANKS       DESP
     C                   MOVEL     OIDES1        DESP
     C                   GOTO      NOITM
     C                   ENDIF
      *
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     KEY18         CHAIN     FMINVT                             90
     C                   EXSR      GETDES
      *
     C     NOITM         TAG
     C     OISEQ#        IFLT      989
     C                   SETON                                        40
     C                   ADD       OIQORD        TOTORD           11 1
     C                   ENDIF
     C     OIITYP        IFEQ      'S'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'C'
     C                   SETOFF                                       40
     C                   ENDIF
      *
     C     OIQBOO        IFGT      0
     C                   MOVEL     'B/O'         BO                3
     C                   ELSE
     C                   MOVE      *BLANKS       BO                3
     C                   END
     C     OIQORD        SUB       OIQSHP        LEFT             11 1
     C*WJB               ADD       OIQBOO        LEFT
     C*WJB OIQBOO        IFGT      0
     C*WJB               Z-ADD     OIQBOO        LEFT
     C*WJB               ENDIF
     C     OIRQTY        IFNE      *ZERO
     C                   Z-ADD     OIRQTY        LEFT
     C                   END
      *
     C   50              Z-ADD     0             LINE
     C   50              SETOFF                                       50
     C                   SETOFF                                       71
     C     OIBOLN        IFEQ      'B'
     C                   MOVE      'B'           OIPRBO
     C******               MOVE *BLANKS   OIBOLN
     C                   Z-ADD     OIBORQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##DDD         IFGE      BDATE
     C     ##DDD         IFLE      EDATE
     C                   SETON                                        6071
     C                   END
     C                   END
     C                   END
      *
     C   40
     CANN71              ADD       LEFT          TOTQTY           11 1
     C   40              ADD       1             PACK
     C   40
     CAN 71              ADD       LEFT          TOTBO            11 1
      *
     C   OF              DO
     C                   EXCEPT    MSGLN
     C                   EXCEPT    HDG
     C     OHSTA         IFEQ      'Y'
     C                   EXCEPT    HDGSTA
     C                   END
     C                   ENDDO
      *
     C                   MOVEL     OIITEM        ITEM              6
     C                   MOVE      OIBIN#        BIN               2
     C                   EXCEPT    DETL
     C                   ADD       1             PACK
     C                   SETON                                        55
     C*                    SETOF                     50
     C                   Z-ADD     OIORD#        OLDORD            6 0
      *
     C                   ADD       1             LINE              2 0
     C     LINE          IFGE      19
     C                   SETON                                        50
     C                   ENDIF
     C                   GOTO      NXTI2
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      *  ***********
      *  * #SLD    *
      *  ***********
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
     C     #SLD          BEGSR
      *
     C                   MOVE      *BLANKS       #SL
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WSLD1        #SL(#X)
     C                   ADD       1             #X
     C     #WSLD2        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD1
     C                   MOVEL     #WSLD2        #SL(#X)
     C                   ADD       1             #X
     C     #SLD1         TAG
     C     #WSLD3        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD2
     C                   MOVEL     #WSLD3        #SL(#X)
     C                   ADD       1             #X
     C     #SLD2         TAG
     C     #WSLD4        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD3
     C                   MOVEL     #WSLD4        #SL(#X)
     C                   ADD       1             #X
     C     #SLD3         TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WSLCT        CAT       #WSLST:1      WORK1
     C                   MOVEL     #WSLZP        WORK3
     C                   MOVE      #WSLZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SL(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *  ***********
      *  * #SHP    *
      *  ***********
      *
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE SHIP TO
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
     C     #SHP          BEGSR
      *
     C                   MOVE      *BLANKS       #SH
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WSHP1        #SH(#X)
     C                   ADD       1             #X
     C     #WSHP2        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP1
     C                   MOVEL     #WSHP2        #SH(#X)
     C                   ADD       1             #X
     C     #SHP1         TAG
     C     #WSHP3        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP2
     C                   MOVEL     #WSHP3        #SH(#X)
     C                   ADD       1             #X
     C     #SHP2         TAG
     C     #WSHP4        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP3
     C                   MOVEL     #WSHP4        #SH(#X)
     C                   ADD       1             #X
     C     #SHP3         TAG
     C                   MOVE      *BLANKS       WORK             32            BLANK
     C                   MOVE      *BLANKS       WORK1            21            BLANK
     C                   MOVE      *BLANKS       WORK2            10             "
     C                   MOVE      *BLANKS       WORK3             5             "
     C                   MOVE      *BLANKS       WORK4             5             "
     C     #WSHCT        CAT       #WSHST:1      WORK1
     C                   MOVEL     #WSHZP        WORK3
     C                   MOVE      #WSHZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C*                    MOVELWORK1     WORK
     C*                    MOVE WORK2     WORK
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SH(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'P'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
      *?
     C                   MOVEL     DESCO         DESP             30
     C                   ENDSR
      **********
      * CKPC
      **********
     C     CKPC          BEGSR
     C                   SETOFF                                       30
     C                   MOVEL     'A '          SHPC              2
     C                   MOVEL     'A '          STAT
     C     NEWKEY        SETLL     FIORDRSS
     C     NXTPC         TAG
     C     NEWKEY        READE     FIORDRSS                               90
     C   90              GOTO      ENDPC
     C   19OIDTRQ        IFGT      *ZEROS
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RSHDT             5 0
     C                   ENDIF
     C   19RSHDT         IFGT      *ZEROS
     C     RSHDT         ANDLT     BDATE
     C     RSHDT         ORGT      EDATE
     C                   GOTO      NXTPC
     C                   ENDIF
     C     OIPRCL        IFGE      LPC1
     C     OIPRCL        ANDLE     LPC2
     C                   SETON                                        30
     C                   GOTO      ENDPC
     C                   ENDIF
     C                   GOTO      NXTPC
     C     ENDPC         TAG
     C                   ENDSR
      **********
      * CKAREA
      **********
     C     CKAREA        BEGSR
     C                   SETOFF                                       31
     C                   MOVEL     'A '          SHPC              2
     C                   MOVEL     'A '          STAT
     C     NEWKEY        SETLL     FIORDRSS
     C     NXTARE        TAG
     C     NEWKEY        READE     FIORDRSS                               90
     C   90              GOTO      ENDARE
     C   19OIDTRQ        IFGT      *ZEROS
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RSHDT             5 0
     C                   ENDIF
     C   19RSHDT         IFGT      *ZEROS
     C     RSHDT         ANDLT     BDATE
     C     RSHDT         ORGT      EDATE
     C                   GOTO      NXTARE
     C                   ENDIF
     C                   MOVE      OIBIN#        BIN
     C     BIN           IFNE      AREA
     C                   GOTO      NXTARE
     C                   ENDIF
     C                   SETON                                        31
     C                   GOTO      ENDARE
     C     ENDARE        TAG
     C                   ENDSR
      ********************************************************************@DT@B1
     OBIR317    E            HDG              02
     O               42                          30 '* * * * * * * * * * * * '
     O               42                          44 'R E P R I N T'
     O               42                          70 '* * * * * * * * * * * * '
     O                       PAGE          Z     80
     O                                           75 'Report Page:'
     O          E            HDG              03
     O                                           80 'Kube-Pak - Allentown, NJ'
     O          E            HDG              04
     O                       OHCUST        Z     54
     O                       OHBLCU        Z     14
     O                       CMPHON              70 '   -   -    '
     O          E            HDG              05
     O                                            5 'Bill'
     O                                           46 'Ship'
     O                       #SL(1)              38
     O                       #SH(1)              79
     O          E            HDG              06
     O                                            5 ' To:'
     O                       #SL(2)              38
     O                       #SH(2)              79
     O                                           46 ' To:'
     O          E            HDG              07
     O                       #SL(3)              38
     O                       #SH(3)              79
     O          E            HDG              08
     O                       #SL(4)              38
     O                       #SH(4)              79
     O          E            HDG              09
     O                       #SL(5)              38
     O                       #SH(5)              79
     O          E            HDG              10
     O                                            6 'Terms:'
     O                       OHTMCD               9
     O                       TCDESC              40
     O          E            HDG              11
     O                                           10 'Order #:'
     O                       OHORD#        Z     17
     O               78                          55 '*** FUTURE DATE ***'
     O                                           71 'Req Ship Date:'
     O                       OHDTRQ        Y     80
     O          E            HDG            1 13
     O                                            5 'Loc'
     O                                           66 'Qty  '
     O                                           77 '  B/O   '
     O          E            HDG            0
     O                                            3 'B/O'
     O                                           12 'Date'
     O                                           21 'Item  '
     O                                           36 'Description'
     O                                           66 'Ordered'
     O                                           77 'Quantity'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           80 '________'
     O          E            HDGSTA         0
     O                                           51 'Subject to Availability'
     O          E            HDGSTA         2
     O                                           51 '_______________________'
     O          E            DETL           0
     O               40 71   LEFT          4     77
     O               40N71   LEFT          4     66
     O***              40      OIUUOM    66
     O***              40      RPRT      68
     O               40      OIDTRQ        Y     14
     O                       OIPRBO               2
     O                       ITEM                21
     O                       BIN                  5
     O                       OISIZE              24
     O                       DESP                55
     O***              40                77 '________'
     O**               40      BO        64
     O          E            DETL           2
     O               40                          35 '__________'
     O               40                          55 '____________________'
     O          E            MSGLN          1
     O                                           43 '* * Continued'
     O                                           60 'On Next Page * *'
     O          E            TL1            1 56
     O                                           13 'Ord Taken By:'
     O                       POENTR              24
     O                                           28 'on:'
     O                       OHDTOR        Y     37
     O                       TOTBO         4     77
     O                                           71 'B/O:'
     O                       TOTQTY        4     66
     O                                           58 'Total Ship:'
     O          E            TL1            1
     O                                           16 'Program:  BIR317'
     O                                           28 'Run Date:'
     O                       TDATE         Y     37
     O                                           39 '@'
     O                       TIMOD               48 '  :  :  '
     O                                           58 'Carts:'
     O                       Qty_Carts1    J     66
     O                       PGE           Z     80
     O                                           77 'Page:'
     O          E            TL1            1
     O                                           52 'Ship Via:'
     O                       SDESC               74
     O          E            TL1            1
     O               23                          11 'Ship Instr:'
     O                       OHSHIN              42
     O                                           52 'Route:'
     O*                      OHROUT              62
     O                       Route               72
     O                       OHSTOP        Z     80
     O                                           78 'Stop:'
     O          E            TL1            1
     O               22                          14 'Special Instr:'
     O                       OHSPIN              45
     O                                           52 'Loc:'
     O                       OHLOC               61
     O                       POLOWC              70
     O                       POLOWF              79
     O          E            TL1            1
     O                       OHORD#        4     80
     O                                           73 'Order:'
      *
     OBIR317X   E    U1      HDG              02
     O**                       SLIP  Z   80
     O**                                 75 'Slip#'
     O                  42                       32 '* * * * * * * * * * * * '
     O                  42                       46 'R E P R I N T'
     O                  42                       72 '* * * * * * * * * * * * '
     O                       PAGE1         Z     80
     O                                           75 'Report Page:'
     O          E       U1   HDG              04
     O                       OHCUST        Z     54
     O                       OHBLCU        Z     14
     O                       CMPHON              70 '   -   -    '
     O          E       U1   HDG              05
     O                                            5 'Bill'
     O                                           46 'Ship'
     O                       #SL(1)              38
     O                       #SH(1)              79
     O          E       U1   HDG              06
     O                                            5 ' To:'
     O                       #SL(2)              38
     O                       #SH(2)              79
     O                                           46 ' To:'
     O          E       U1   HDG              07
     O                       #SL(3)              38
     O                       #SH(3)              79
     O          E       U1   HDG              08
     O                       #SL(4)              38
     O                       #SH(4)              79
     O          E       U1   HDG              09
     O                       #SL(5)              38
     O                       #SH(5)              79
     O          E       U1   HDG              10
     O                                            6 'Terms:'
     O                       OHTMCD               9
     O                       TCDESC              40
     O          E       U1   HDG              11
     O                                           10 'Order #:'
     O                       OHORD#        Z     17
     O               78                          55 '*** FUTURE DATE ***'
     O                                           71 'Req Ship Date:'
     O                       OHDTRQ        Y     80
     O          E       U1   HDG            1 13
     O                                            5 'Loc'
     O                                           66 'Qty  '
     O                                           77 '  B/O   '
     O          E       U1   HDG            0
     O                                            3 'B/O'
     O                                           12 'Date'
     O                                           21 'Item'
     O                                           36 'Description'
     O                                           66 'Ordered'
     O                                           77 'Quantity'
     O          E       U1   HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           80 '________'
     O          E       U1   HDGSTA         0
     O                                           51 'Subject to Availability'
     O          E       U1   HDGSTA         2
     O                                           51 '_______________________'
     O          E       U1   DETL           0
     O               40 71   LEFT          4     77
     O               40N71   LEFT          4     66
     O               40      OIDTRQ        Y     14
     O                       OIPRBO               2
     O                       ITEM                21
     O                       BIN                  5
     O                       OISIZE              24
     O                       DESP                55
     O          E       U1   DETL           2
     O               40                          35 '__________'
     O               40                          55 '____________________'
     O          E       U1   MSGLN          1
     O                                           43 '* * Continued'
     O                                           60 'On Next Page * *'
     O          E       U1   TL1            1 56
     O                                           13 'Ord Taken By:'
     O                       POENTR              24
     O                                           28 'on:'
     O                       OHDTOR        Y     37
     O                       TOTBO         4     77
     O                                           71 'B/O:'
     O                       TOTQTY        4     66
     O                                           58 'Total Ship:'
     O          E       U1   TL1            1
     O                                           16 'Program:  BIR317'
     O                                           28 'Run Date:'
     O                       TDATE         Y     37
     O                                           39 '@'
     O                       TIMOD               48 '  :  :  '
     O                                           58 'Carts:'
     O                       Qty_Carts1    J     66
     O                       PGE           Z     80
     O                                           77 'Page:'
     O          E       U1   TL1            1
     O                                           52 'Ship Via:'
     O                       SDESC               74
     O          E       U1   TL1            1
     O               23                          11 'Ship Instr:'
     O                       OHSHIN              42
     O                                           52 'Route:'
     O*                      OHROUT              62
     O                       Route               72
     O                       OHSTOP        Z     80
     O                                           78 'Stop:'
     O          E       U1   TL1            1
     O               22                          14 'Special Instr:'
     O                       OHSPIN              45
     O                                           52 'Loc:'
     O                       OHLOC               61
     O                       POLOWC              70
     O                       POLOWF              79
     O          E       U1   TL1            1
     O                       OHORD#        4     80
     O                                           73 'Order:'
