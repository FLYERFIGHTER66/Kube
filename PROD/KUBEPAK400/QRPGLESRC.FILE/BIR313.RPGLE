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
      **PROGRAM NAME-------- BIR313
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **APPLICATION--------- PRINTING OF PICK SLIPS BY ORDER NUMBER
      **DESCRIPTION--------- THIS PROGRAM PRINTS PICK SLIPS WITHIN A
      **                     SELECTED DATE FOR ONE COMPANY OR ALL, AND
      **                     FOR ONE ROUTE OR ALL. IT FLAGS THE ORDER
      **                     LINE ITEM AND HEADER RECORDS WITH A 'P'
      **                     IN THE PICK SLIP PRINTED FIELD.
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FQRYOU313  IF   E           K DISK
     F                                     RENAME(QRYOU313:QRYOUT)
     FFIORDR    UF   E           K DISK
     FFHORDR    UF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMSVIA    IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FBIR313    O    F   80        PRINTER
     FBIR313X   O    F   80        PRINTER EXTIND(*INU1)
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$DotW
    ?D/COPY QFunctDefn,$DateMDY

     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND                      @DT
      * ADDRESS ARRAYS
     D #SL             S             32    DIM(5)
     D #SH             S             32    DIM(5)
      **
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
     D  LCANCL               133    133
      *
     D  Route          S             18A
      *
     IQRYOUT
     I              OIORD#                      ORDER
     I              BREAKLVL                    BREAK1
     I              OVERFLOW                    BREAK2
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
     C                   SETON                                        19
     C                   Z-ADD     LBEGDT        ##MDY
     C                   EXSR      @DT@A1
     C                   MOVE      ##CYMD        BCYMD             7 0
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         BDATE             5 0
     C                   Z-ADD     LENDDT        ##MDY
     C                   EXSR      @DT@A1
     C                   MOVE      ##CYMD        ECYMD             7 0
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         EDATE             5 0
     C                   ENDIF
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         CURDAT            5 0
     C                   Z-ADD     1             PACK              4 0
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
     C                   SETON                                        U1
     C                   ENDIF
      *
      *** FIND NEXT ORDER
      *
     C     NXTQRY        TAG
     C                   Z-ADD     0             LINE
      *
     C                   SETOFF                                       43
     C                   READ      QRYOU313                               77
     C   77              GOTO      END
      *
     C     OIRVDT        IFLT      BCYMD
     C     OIRVDT        ORGT      ECYMD
     C                   GOTO      NXTQRY
     C                   END
      *
     C   12ORDER         IFLT      LBORD
     C                   GOTO      NXTQRY
     C                   ENDIF
      *
     C   12ORDER         IFGT      LEORD
     C                   GOTO      NXTQRY
     C                   ENDIF
      *
     C     OHPONO        IFGT      *BLANKS
     C                   SETON                                        24
     C                   ELSE
     C                   SETOFF                                       24
     C                   ENDIF
      ** GET HORDR RECORD
     C     ORDER         CHAIN     FHORDR                             90
     C   90              GOTO      NXTQRY
     C                   Z-ADD     1             PGE               2 0
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
     C                   GOTO      NXTQRY
     C                   ENDIF
      *
      * 18=PLANT ORDER
      *
     C   18OHOLST        IFEQ      'TAG   '
     C                   GOTO      NXTQRY
     C                   ENDIF
      *
      *
     C   14OHPHYT        IFLT      LPHY1
     C     OHPHYT        ORGT      LPHY2
     C                   GOTO      NXTQRY
     C                   ENDIF
      *
     C   15OHSHPC        IFLT      LSHP1
     C     OHSHPC        ORGT      LSHP2
     C                   GOTO      NXTQRY
     C                   ENDIF
      *
     C     OHSHPC        CHAIN     FMSVIA                             98
     C                   MOVEL     SVDESC        SDESC            20
     C                   MOVEL     OHTMCD        TERMCD            2
     C     TERMCD        CHAIN     FMTERM                             98
      *
     C     OHCUST        CHAIN     FMCUST                             98
      *
     C                   EXSR      #SLD
     C                   EXSR      #SHP
     C*                    EXSR GETNAM
      *
     C     OHROUT        IFGT      *BLANKS
     C                   SETON                                        20
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
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C     ##DDD         SUB       CURDAT        TSTD              5 0
     C     TSTD          COMP      2                                  78
      *
     C                   ADD       1             SLIP
     C                   EXCEPT    HDG
     C     OHSTA         IFEQ      'Y'
     C                   EXCEPT    HDGSTA
     C                   END
     C                   MOVEL     'P'           OHPLPT
     C                   UPDATE    RHORDR
      *
     C                   Z-ADD     OHORD#        OLDORD            6 0
     C     OHORD#        SETLL     FIORDR
     C     NXTA          TAG
     C     OHORD#        READE     RIORDR                                 77
     C   77              EXCEPT    TL1
     C   77              Z-ADD     0             TOTQTY
     C   77              Z-ADD     0             TOTBO
     C   77              GOTO      NXTQRY
      *
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     OIPLPT        IFEQ      'P'
     C                   MOVEL     '*'           RPRT              1
     C                   ENDIF
     C     OIPLPT        IFEQ      'N'
     C                   MOVEL     ' '           RPRT              1
     C                   ENDIF
      *
      *  GET DAY OF CENTURY
      *
     C   19OIDTRQ        IFGT      *ZEROS
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         RSHDT             5 0
     C                   ENDIF
     C                   SETOFF                                       6071
     C  N60OIBOLN        IFEQ      'B'
     C                   MOVE      'B'           OIPRBO
     C******               MOVE *BLANKS   OIBOLN
     C                   Z-ADD     OIBORQ        ##MDY
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C     ##DDD         IFGE      BDATE
     C     ##DDD         IFLE      EDATE
     C                   SETON                                        6071
     C                   END
     C                   END
     C                   END
     C   19
     CANN60OIDTRQ        IFGT      *ZEROS
     C     RSHDT         ANDLT     BDATE
     C     RSHDT         ORGT      EDATE
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C   10OIPRCL        IFLT      LPC1
     C     OIPRCL        ORGT      LPC2
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C   11OIROUT        IFLT      LRTE1
     C     OIROUT        ORGT      LRTE2
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C   12OIORD#        IFLT      LBORD
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C   12OIORD#        IFGT      LEORD
     C                   EXCEPT    TL1
     C                   Z-ADD     0             TOTQTY
     C                   Z-ADD     0             TOTBO
     C                   GOTO      END
     C                   ENDIF
      *
     C     OICOMP        IFNE      LCONO
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LPREV         IFEQ      'N'
     C     OIPLPT        ANDEQ     'P'
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     OIORD#        IFNE      OLDORD
     C   55              EXCEPT    TL1
     C                   Z-ADD     *ZEROS        TOTORD
     C                   ADD       1             OHORD#
     C                   Z-ADD     1             PACK
     C                   Z-ADD     0             TOTQTY
     C                   Z-ADD     0             TOTBO
     C                   GOTO      NXTQRY
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
     C*                    ADD  OIQBOO    LEFT
     C*          OIQBOO    IFGT 0
     C*                    Z-ADDOIQBOO    LEFT
     C*                    ENDIF
     C     OIRQTY        IFNE      *ZERO
     C                   Z-ADD     OIRQTY        LEFT
     C                   END
      *
     C  N71
     CAN 40              ADD       LEFT          TOTQTY           11 1
     C   40              ADD       1             PACK
     C   40
     CAN 71              ADD       LEFT          TOTBO            11 1
      *
     C                   ADD       1             PHEAD             5 0
     C                   SETON                                        55
     C                   SETOFF                                       50
     C                   ADD       1             LINE              2 0
     C     LINE          COMP      19                                 50  50
     C   50              EXCEPT    TL1
     C   50              EXCEPT    MSGLN
     C   50              ADD       1             PGE               2 0
     C   50              ADD       1             SLIP              4 0
     C   50              EXCEPT    HDG
     C   50OHSTA         IFEQ      'Y'
     C                   EXCEPT    HDGSTA
     C                   END
     C   50              Z-ADD     0             LINE
     C   50              SETOFF                                       50
      *
     C                   MOVEL     OIITEM        ITEM              6
     C                   EXCEPT    DETL
     C                   MOVEL     'P'           OIPLPT
     C                   UPDATE    RIORDR
     C                   GOTO      NXTA
      *
      * COPIED ROUTINE BEFORE EXCPT DETL
      *
      *
     C*    N60   OIBOLN    IFEQ 'B'
     C*                    MOVE 'B'       OIPRBO
     C*                    MOVE *BLANKS   OIBOLN
     C*                    Z-ADDOIBORQ    ##MDY
     C*                    EXSR @DT@A1
     C*                    EXSR @DT@B1
     C*          ##DDD     IFGE BDATE
     C*          ##DDD     IFLE EDATE
     C*                    SETON                     60
     C*                    END
     C*                    END
     C*                    END
     C*    N60   OIPRBO    IFEQ 'B'
      ***                  MOVE 'B'       OIPRBO
     C*          OIBORQ    MULT 10000.01  WKBODT  60
     C*          WKBODT    IFGE LDDAT1
     C*          WKBODT    IFLE LDDAT2
     C*                    SETON                     60
     C*                    END
     C*                    END
     C*                    END
      *
     C*  60                GOTO CONTU1
     C*                    GOTO LOOP1
     C*          CONTU1    TAG
     C*RNLR                Z-ADD0         ##DDD   50
     C     END           TAG
     C                   SETON                                        LR
      *
      * REARRANGE BILL TO AND SHIP TO DATA
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
      ********************************************************************@DT@A1
      * VALIDATE DATES. INDICATOR 90 IS ON IF ERROR. 91-92 ALWAYS SETOF.  @DT@A1
      * YY GE 00  MM 01-12 DAY 01-28/29/30/31                             @DT@A1
      * ##MDY INPUT DATE MMDDYY                                           @DT@A1
      * ##CYMD OUTPUT DATE CYYMMDD IF DATE IS OK. ELSE ZERO.              @DT@A1
      * C IDENTIFIES 20 OR 21 CENTURY. C=0 FOR YY 70-99. C=1 FOR YY 00-69.@DT@A1
     C     @DT@A1        BEGSR                                                                 @DT@A
     C                   MOVE      ##MDY         #03A              3 0          MYY            @DT@A
     C                   MOVEL     0             #03A                           CYY            @DT@A
     C                   MOVEL     ##MDY         #04               4 0          MMDD           @DT@A
     C                   MOVEL     ##MDY         #02B              2 0          MM             @DT@A
     C                   MOVE      #04           #02C              2 0          DD             @DT@A
     C                   Z-ADD     ##MDY         ##MDY             6 0  90      YY IS NEGATIVE @DT@A
     C  N90              Z-ADD     #02B          #02               2 0    90    MM LT 01 ERROR @DT@A
     C  N90#02B          COMP      12                                 90        MM GT 12 ERROR @DT@A
     C  N90#02C          COMP      01                                   90      DD LT 01 ERROR @DT@A
     C  N90#02C          COMP      31                                 90  91    DD GT OR EQ 31 @DT@A
     C     #02B          COMP      07                                 92        MM 08-12       @DT@A
     C   921             ADD       #02B          #02                            MAKE MM ODD    @DT@A
     C     #02           DIV       2             #02                                           @DT@A
     C                   MVR                     #02                  92        31 DAY MONTH   @DT@A
     C   91
     CANN92              SETON                                        90        MM EVEN DD 31  @DT@A
     C     #02B          COMP      02                                     91    FEB            @DT@A
     C  N91                                                                                    @DT@A
     COR 90              GOTO      @DT@AX                                                      @DT@A
     C     #03A          DIV       4             #03               3 0          JUST FOR MVR   @DT@A
     C                   MVR                     #02                      91    LEAP YEAR      @DT@A
     C     #02C          COMP      29                                 90  92    DD GT 29 ERROR @DT@A
     C  N91
     CAN 92              SETON                                        90        NO LEAP DD 29  @DT@A
     C     @DT@AX        TAG                                                    GOOD DATE      @DT@A
     C                   MOVEL     #03A          ##CYMD            7 0          CYY----        @DT@A
     C                   MOVE      #04           ##CYMD                         CYYMMDD        @DT@A
     C     #03A          COMP      070                                  91                     @DT@A
     C   91              MOVEL     1             ##CYMD                         21ST CENTURY   @DT@A
     C   90              Z-ADD     0             ##CYMD                         ERROR          @DT@A
     C                   SETOFF                                       9192                     @DT@A
     C                   ENDSR                                                                 @DT@A
      *****
      ********************************************************************@DT@B1
      * CONVERT CYYMMDD TO DAY OF CENTURY DDDDD. INDICATOR 90 MINUS DATE  @DT@B1
      * ##CYMD INPUT DATE CYYMMDD                                         @DT@B1
      * ##DDD OUTPUT DAY OF CENTURY DDDDD. BASE DATE IS 01/01/1900        @DT@B1
      * INDICATORS USED 90-92.                                            @DT@B1
      ********************************************************************@DT@B1
     C     @DT@B1        BEGSR                                                                 @DT@B
     C                   Z-ADD     ##CYMD        ##CYMD            7 0  90      NEG DATE       @DT@B
      * CONVERT YEAR TO DAYS                                              @DT@B1
     C                   MOVEL     ##CYMD        #03               3 0          YY             @DT@B
     C     #03           MULT      365           ##DDD             5 0          FIRST LEAP     @DT@B
     C     #03           DIV       4             #03                      93    # OF LEAPS     @DT@B
     C                   MVR                     #02A              2 0    91    LEAP YEAR      @DT@B
     C   91
     CANN93#03           SUB       1             #03                                           @DT@B
     C     #03           ADD       ##DDD         ##DDD                          DAYS FOR LEAP  @DT@B
      * CONVERT MONTH TO DAYS                                             @DT@B1
     C                   MOVE      ##CYMD        #04               4 0          MMDD           @DT@B
     C                   MOVEL     #04           #02A                           MM             @DT@B
     C     #02A          IFLE      0
     C                   Z-ADD     1             #02A
     C                   END
     C     #DY(#02A)     ADD       ##DDD         ##DDD                          DAY OF YEAR    @DT@B
     C     #02A          COMP      02                                 92        GT FEB         @DT@B
     C   91
     CAN 92
     CANN931             ADD       ##DDD         ##DDD                          LP YR MM 3-12  @DT@B
      * ADD DAY OF MONTH                                                  @DT@B1
     C                   MOVE      ##CYMD        #02               2 0          DD             @DT@B
     C     #02           ADD       ##DDD         ##DDD                          ADD DAYS       @DT@B
     C   90              Z-ADD     0             ##DDD                                         @DT@B
     C                   SETOFF                                       919293                   @DT@B
     C                   ENDSR                                                                 @DT@B
      ********************************************************************@DT@B1
     OBIR313    E            HDG              02
     O                       SLIP          Z     80
     O                                           75 'Slip#'
     O               42                          30 '* * * * * * * * * * * * '
     O               42                          44 'R E P R I N T'
     O               42                          70 '* * * * * * * * * * * * '
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
     O                                           66 'Qty  '
     O                                           77 '  B/O   '
     O          E            HDG            0
     O                                            3 'B/O'
     O                                           12 'Date'
     O                                           20 'Item  '
     O                                           37 'Description'
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
     O               40N71   LEFT          4     66
     O               40 71   LEFT          4     77
     O***              40      OIUUOM    66
     O***              40      RPRT      68
     O               40      OIDTRQ        Y     12
     O                       OIPRBO               2
     O                       ITEM                20
     O                       OISIZE              23
     O                       DESP                54
     O***              40                77 '________'
     O**               40      BO        64
     O          E            DETL           2
     O               40                          58 '_____________'
     O               40                          45 '________________________'
     O          E            MSGLN          1
     O                                           43 '* * Continued'
     O                                           60 'On Next Page * *'
     O          E            TL1            1 56
     O                                           11 'Order Date:'
     O                       OHDTOR        Y     20
     O                       TOTBO         4     77
     O                                           71 'B/O:'
     O                       TOTQTY        4     66
     O                                           58 'Total Ship:'
     O          E            TL1            1
     O                                           16 'Program:  BIR313'
     O                                           28 'Run Date:'
     O                       TDATE         Y     37
     O                                           39 '@'
     O                       TIMOD               48 '  :  :  '
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
     O          E            TL1            1
     O                       OHORD#        4     80
     O                                           73 'Order:'
      *
     OBIR313X   E    U1      HDG              02
     O                       SLIP          Z     80
     O                                           75 'Slip#'
     O                  42                       30 '* * * * * * * * * * * * '
     O                  42                       44 'R E P R I N T'
     O                  42                       70 '* * * * * * * * * * * * '
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
     O                                           66 'Qty  '
     O                                           77 '  B/O   '
     O          E       U1   HDG            0
     O                                            3 'B/O'
     O                                           11 'Item'
     O                                           34 'Description'
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
     O               40N71   LEFT          4     66
     O               40 71   LEFT          4     77
     O***              40      OIUUOM    66
     O***              40      RPRT      68
     O               40      OIDTRQ        Y     12
     O                       OIPRBO               2
     O                       ITEM                19
     O                       OISIZE              23
     O                       DESP                54
     O***              40                77 '________'
     O**               40      BO        64
     O          E       U1   DETL           2
     O               40                          61 '_____________'
     O               40                          48 '________________________'
     O          E       U1   MSGLN          1
     O                                           43 '* * Continued'
     O                                           60 'On Next Page * *'
     O          E       U1   TL1            1 56
     O                                           11 'Order Date:'
     O                       OHDTOR        Y     20
     O                       TOTBO         4     77
     O                                           71 'B/O:'
     O                       TOTQTY        4     66
     O                                           58 'Total Ship:'
     O          E       U1   TL1            1
     O                                           16 'Program:  BIR313'
     O                                           28 'Run Date:'
     O                       TDATE         Y     37
     O                                           39 '@'
     O                       TIMOD               48 '  :  :  '
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
     O          E       U1   TL1            1
     O                       OHORD#        4     80
     O                                           73 'Order:'
      *
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
