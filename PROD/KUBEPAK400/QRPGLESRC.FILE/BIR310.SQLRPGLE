    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Print a Pick Slip                                  :?
      *??:............................................................:?
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.   1995
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
      **PROGRAM NAME-------- BIR310
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
      *  5/22/97 EFD SETLL BY ORDER NUMBER
      *  5/28/97 EFD USE NEW FILE FOR CHECKING.
      *  5/28/97 EFD PRINT IF PREV B/O.
      * 12/14/98 EFD PRINT MESSAGE IF STA ORDER.
      *  1/19/99 GD  REARRANGE OUTPUT
      *  3/15/00 GD  CHANGE INPUT FILE TO FIORDRSS
      *  1/19/01 EFD PRINT PUT DOWN LOCATION
      *  1/19/01 EFD CHANGE TO SORT BY BIN# AND PRINT BIN#
      *  1/25/01 EFD ALLOW FOR SELECTION OF BIN/AREA TO PRINT
      *  4/04/02 EFD MAKE COMMENTS PRINT ON AREA SELECTED PICKS.
      *  4/05/02 EFD SETOF 50 IF NEW ORDER.
      *  8/23/02 EFD ADD PICKSEL FILE.
      *
      *****FFIORDRBOUF  E           K        DISK
     F*IORDRSTIF  E           K        DISK
     FFIORDRSS  UF   E           K DISK
      ***F            RIORDR                            KRENAMEIORDRN
     FFHORDR    UF   E           K DISK
     FFHORDRHISTO  A E           K DISK
     FFORDCHGL  UF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMSVIA    IF   E           K DISK
     FFPPO      IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FFALITEM   IF   E           K DISK
     FFPICKSEL  O  A E             DISK
     FBIR310    O    F   80        PRINTER
     FBIR310X   O    F   80        PRINTER EXTIND(*INU1)
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$DotW
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Date

     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND                      @DT
      * ADDRESS ARRAYS
     D #SL             S             32    DIM(5)
     D #SH             S             32    DIM(5)
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
     D  UDSAllowD            134    134
      *
     D  Route          S             18A
     D  TotalCount     S              7S 1
     D  IN17           S               N
     D  IN18           S               N
     D  BDATE7         S              7S 0
     D  EDATE7         S              7S 0
     D  FirstLot       S                        Like(AICRDY)
     D  MultLots       S               N
     D  AICRDY6        S              6S 0
     D  AllowDetail    S               N
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
     C                   TIME                    TIMOD             6 0
     C                   If        UDSAllowD = '1'
     C                   Eval      AllowDetail = *On
     C                   EndIf
     C                   Eval      *In44= AllowDetail
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   WRITE     RPICKSEL
     C     LBEGDT        IFGT      0
     C                   SETON                                        19
     C                   Eval      BDATE7 = $Date7($DateMDY(LBEGDT))
     C                   Eval      EDATE7 = $Date7($DateMDY(LENDDT))
     C                   Z-ADD     LBEGDT        ##MDY
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         BDATE             5 0
     C                   Z-ADD     LENDDT        ##MDY
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         EDATE             5 0
     C                   ENDIF
     C                   Z-ADD     TDATE         ##MDY
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         CURDAT            5 0
     C                   Z-ADD     1             PACK              4 0
     C                   Z-ADD     0             SLIP              4 0
     C     LSELEC        IFEQ      4
     C                   GOTO      NOOPT
     C                   END
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
     C     NOOPT         TAG
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
     C     NEWKEY        KLIST
     C                   KFLD                    STAT
     C                   KFLD                    SHFR
     C                   KFLD                    OHORD#
     C     NXT           TAG
     C                   Z-ADD     0             LINE
     C                   SETOFF                                       50
      *
     C     NEWKEY        SETLL     FIORDRSS
     C     NXTI          TAG
     C                   SETOFF                                       43
     C     LSELEC        IFNE      4
     C                   READ      FIORDRSS                               77
     C                   ELSE
     C     ORDC          IFGT      0
     C                   DELETE    RORDCHG
     C                   END                                                    ORDC>0
     C                   READ      FORDCHGL                               77
     C                   Z-ADD     1             ORDC              2 0
     C                   Z-ADD     OHORD#        OIORD#
     C  N77              GOTO      SEL4
     C                   END                                                    LSELEC><4
     C   77              GOTO      END
      *
     C     OISTAT        IFEQ      'D'
     C                   GOTO      END
     C                   END
      *
     C     PACK          IFEQ      1
     C     OISEQ#        ANDEQ     997
     C                   GOTO      NXTI
     C                   ENDIF
      *
      *
      *  GET DAY OF CENTURY AND VALIDATE DATE RANGE
      *
     C   19OIDTRQ        IFGT      *ZEROS
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         RSHDT             5 0
     C                   ENDIF
     C   19RSHDT         IFGT      *ZEROS
     C     RSHDT         ANDLT     BDATE
     C     RSHDT         ORGT      EDATE
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C   10OIPRCL        IFLT      LPC1
     C     OIPRCL        ORGT      LPC2
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C   11OIROUT        IFLT      LRTE1
     C     OIROUT        ORGT      LRTE2
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C   12OIORD#        IFLT      LBORD
     C                   GOTO      NXTI
     C                   ENDIF
      *
      * CHECK IF THIS IS REPRINT
      *
      *?
     C*          LPREV     IFEQ 'Y'
     C*                    SETOF                     43
     C*                    MOVEL' '       RPRT    1
     C*                    ENDIF
      *
     C     OIPLPT        IFEQ      'P'
     C                   MOVEL     '*'           RPRT              1
     C                   ENDIF
     C     OIPLPT        IFEQ      'N'
     C                   MOVEL     ' '           RPRT              1
     C                   ENDIF
      *
     C   12OIORD#        IFGT      LEORD
     C***55                EXCPTTL1
     C                   Z-ADD     1             PACK
     C                   Z-ADD     0             TOTQTY
     C                   Z-ADD     0             TOTBO
     C                   GOTO      END
     C                   ENDIF
      *
     C*  13      OIPLPT    IFEQ 'Y'
     C*                    GOTO NXTI
     C*                    ENDIF
      *
     C     OICOMP        IFNE      LCONO
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C   16OIWHSE        IFLT      LLOC1
     C                   GOTO      NXTI
     C                   ENDIF
     C   16OIWHSE        IFGT      LLOC2
     C                   GOTO      END
     C                   ENDIF
      *
     C     LPREV         IFEQ      'N'
     C     OIPLPT        ANDEQ     'P'
     C     LSELEC        ANDNE     4
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     SEL4          TAG
     C                   SETOFF                                       202155
     C                   SETOFF                                       2223
     C                   Z-ADD     1             PHEAD
     C                   Z-ADD     1             PGE               3 0
      *
     C     OIORD#        CHAIN     FHORDR                             90
     C   90              DO
     C     OIORD#        ADD       1             OHORD#
     C                   GOTO      NXTI
     C                   ENDDO
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
     C     OIORD#        ADD       1             OHORD#
     C                   GOTO      NXTI
     C                   ENDIF
      *
      * 18=PLANT ORDER
      *
     C   18OHOLST        IFEQ      'TAG   '
     C     OIORD#        ADD       1             OHORD#
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OHSTAT        IFEQ      'D'
     C     OHCOFL        OREQ      'Y'
     C     OIORD#        ADD       1             OHORD#
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C   14OHPHYT        IFLT      LPHY1
     C     OHPHYT        ORGT      LPHY2
     C     OIORD#        ADD       1             OHORD#
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C   15OHSHPC        IFLT      LSHP1
     C     OHSHPC        ORGT      LSHP2
     C     OIORD#        ADD       1             OHORD#
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
     C                   EXSR      GetTotalShip
      *
     C     OHROUT        IFGT      *BLANKS
     C                   SETON                                        20
     C                   ENDIF
     C                   Select
     C                   When      OHSHPC = '01'
     C                   If        %SubSt(OHROUT:1:1) >= 'A' and
     C                             %SubSt(OHROUT:1:1) <= 'Z'
     C                   Eval      Route = %SubSt($DotW($DateMDY(OHDTCN)):1:3)
     C                             + '. Van: ' + OHROUT
     C                   Else
     C                   Eval      Route = %SubSt($DotW($DateMDY(OHDTCN)):1:3)
     C                             + '. Trailer: ' + OHROUT
     C                   EndIf
     C                   When      OHSHPC = '02'
     C                   Eval      Route=%Trim($DotW($DateMDY(OHDTCN)))+' P/U '
     C                   When      OHSHPC = '03'
     C                   Eval      Route =
     C                             %Trim($DotW($DateMDY(OHDTCN)))+' U.P.S.'
     C                   When      OHSHPC = '04'
     C                   Eval      Route =
     C                             %Trim($DotW($DateMDY(OHDTCN)))+' U.P.S.'
     C                   When      OHSHPC = '26' or
     C                             OHSHPC = '27' or
     C                             OHSHPC = '28' or
     C                             OHSHPC = '29' or
     C                             OHSHPC = '30'
     C                   Eval      Route =
     C                             %Trim($DotW($DateMDY(OHDTCN)))+' FedEx'
     C                   Other
     C                   Eval      Route = OHROUT
     C                   EndSl
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
     C                   MOVEL     'P'           OHPLPT
     C                   UPDATE    RHORDR
     C                   Eval      HSTUSER    = USERID
     C                   Eval      HSTPROGRAM = 'BIR310'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
      *
     C                   Z-ADD     OIORD#        OLDORD            6 0
     C     NEWKEY        SETLL     FIORDRSS
     C     NXTA          TAG
     C     NEWKEY        READE     RIORDR                                 77
     C   77              EXCEPT    TL1
     C   77              Z-ADD     0             TOTQTY
     C   77              Z-ADD     0             TOTBO
     C   77              ADD       1             OHORD#
     C   77              GOTO      NXT
      *
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXTA
     C                   ENDIF
      ** CHECK AREA
     C                   MOVE      OIBIN#        BIN               2
     C     AREA          IFGT      *BLANKS
     C     BIN           ANDNE     AREA
     C     LSELEC        ANDNE     4
4/04 C     OIITYP        ANDNE     'C'
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
     C   55              EXCEPT    TL1
     C                   Z-ADD     0             TOTQTY
     C                   Z-ADD     0             TOTBO
     C                   GOTO      END
     C                   ENDIF
      *
     C     OIORD#        IFNE      OLDORD
     C   55              EXCEPT    TL1
     C                   Z-ADD     *ZEROS        TOTORD
     C                   ADD       1             OHORD#
     C                   Z-ADD     1             PACK
     C                   Z-ADD     0             TOTQTY
     C                   Z-ADD     0             TOTBO
     C                   GOTO      NXT
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
     C     OIRQTY        IFNE      *ZERO
     C                   Z-ADD     OIRQTY        LEFT
     C                   END
      *
     C   50              EXCEPT    TL1
     C   50              EXCEPT    MSGLN
     C   50              ADD       1             PGE
     C   50              ADD       1             SLIP
     C   50              EXCEPT    HDG
     C   50OHSTA         IFEQ      'Y'
     C                   EXCEPT    HDGSTA
     C                   END
     C   50              Z-ADD     0             LINE
     C   50              SETOFF                                       50
      *
     C  N71
     CAN 40              ADD       LEFT          TOTQTY           11 1
     C   40              ADD       1             PACK
     C   40
     CAN 71              ADD       LEFT          TOTBO            11 1
      *
     C                   MOVEL     OIITEM        ITEM              6
     C                   MOVE      OIBIN#        BIN               2
WJB15C*                  If        LEFT > *Zero or OIITYP <> *Blank
WJB15C                   If        OISTAT = 'A' or OIITYP <> *Blank
     C                   ExSr      MultiLot
     C                   EXCEPT    DETL
     C                   If        MultLots and AllowDetail
     C                   ExSr      PrintLots
WJB  C                   EndIf
WJB  C                   EndIf
     C                   MOVEL     'P'           OIPLPT
     C                   UPDATE    RIORDR
     C                   ADD       1             PHEAD             5 0
     C                   SETON                                        55
     C                   SETOFF                                       50
     C                   ADD       1             LINE              2 0
     C     LINE          COMP      19                                 50  50
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

      /Free
         //--- MultiLot --------------------------------------------------------
         begSR MultiLot;
           SetLL (OIORD#:OISEQ#) FALITEM;
           ReadE (OIORD#:OISEQ#) FALITEM;
           FirstLot = *Zero;
           MultLots = *Off;
           *In41   = *On;
           AICRDY6 = OIDTRQ;
           DoW not %EOF(FALITEM);
             If FirstLot <> 0 and AICRDY <> FirstLot and AIQTOA <> 0;
               MultLots = *On;
               AICRDY6 = *Zero;
               *In41   = *Off ;
               LeaveSR;
              Else;
               If AIQTOA <> 0;
                 FirstLot = AICRDY;
                 AICRDY6 = $MDYDate($Date(AICRDY));
               ENDIF;
             EndIf;
             ReadE (OIORD#:OISEQ#) FALITEM;
           EndDo;
         //If not AllowDetail;
         //  *In41 = *On;
         //endif;
         endSR;

         //--- PrintLots -------------------------------------------------------
         begSR PrintLots;
           SetLL (OIORD#:OISEQ#) FALITEM;
           ReadE (OIORD#:OISEQ#) FALITEM;
           DoW not %EOF(FALITEM);
             If AIQTOA <> 0;
               AICRDY6 = $MDYDate($Date(AICRDY));
               Except XDetl;
               Line += 1;
             EndIf;
             ReadE (OIORD#:OISEQ#) FALITEM;
           EndDo;
         endSR;

         //--- GetTotalShip ----------------------------------------------------
         begSR GetTotalShip;

           In17 = *In17;
           In18 = *In18;
           exec Sql
             Select sum(OIQORD-OIQSHP)
             into   :TotalCount
             from   FIORDR, FHORDR
             where   OIORD# = OHORD#
               and  (OIORD# = :OHORD#)
               and  (OIDTRQ = 0  or
                     OIRVDT between :BDATE7 and :EDATE7 or :BDATE=0)
               and  (:LPC1  = '' or OIPRCL >= :LPC1)
               and  (:LPC2  = '' or OIPRCL <= :LPC2)
               and  (:LRTE1 = '' or OIROUT >= :LRTE1)
               and  (:LRTE1 = '' or OIROUT <= :LRTE2)
               and  (:LBORD = 0  or OIORD# >= :LBORD)
               and  (:LEORD = 0  or OIORD# <= :LEORD)
               and  (:LLOC1 = '' or OIWHSE >= :LLOC1)
               and  (:LLOC2 = '' or OIWHSE <= :LLOC2)
               and   :LCONO = OICOMP
               and  (:IN17 = '0' or OHOLST =  'TAG   ')
               and  (:IN18 = '0' or OHOLST <> 'TAG   ')
               and   OHSTAT <> 'D'
               and   OHCOFL <> 'Y'
               and  (:LPHY1 = '' or OHPHYT >= :LPHY1)
               and  (:LPHY2 = '' or OHPHYT <= :LPHY2)
               and  (:LSHP1 = '' or OHSHPC >= :LSHP1)
               and  (:LSHP2 = '' or OHSHPC <= :LSHP2);

         endSR;

      /End-Free

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
     OBIR310    E            HDG              02
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
     O                                            5 'Loc'
     O                                           12 'Tray'
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
     O          E            XDETL          1
     O                       AICRDY6       Y     14
     O                       ITEM                21
     O                       BIN                  5
     O                       OISIZE              24
     O                       AIQTOA        4     36
     O                                           54 'Flats (Split Lot)'
     O          E            DETL           0
     O               40N71   LEFT          4     66
     O               40 71   LEFT          4     77
     O               40 41   AICRDY6       Y     14
     O               40N41 44                    14 ' -multi-'
     O               40N41N44OIDTRQ        Y     14
     O                       OIPRBO               2
     O                       ITEM                21
     O                       BIN                  5
     O                       OISIZE              24
     O                       DESP                55
     O***              40                77 '________'
     O**               40      BO        64
     O          E    41      DETL           2
     O               40                          35 '__________'
     O               40                          55 '____________________'
     O          E   N41 44   DETL           1
     O               40                          35 '__________'
     O               40                          55 '____________________'
     O          E   N41N44   DETL           2
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
     O                       TotalCount    4     66
     O*                      TOTQTY        4     47
     O                                           58 'Total Ship:'
     O          E            TL1            1
     O                                           16 'Program: -BIR310'
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
     OBIR310X   E    U1      HDG              02
     O**                       SLIP  Z   80
     O**                                 75 'Slip#'
     O                  42                       32 '* * * * * * * * * * * * '
     O                  42                       46 'R E P R I N T'
     O                  42                       72 '* * * * * * * * * * * * '
     O          E            HDG              03
     O                                           80 'Kube-Pak - Allentown, NJ'
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
     O**                                  5 'Loc'
     O                                           66 'Qty  '
     O                                           77 '  B/O   '
     O          E       U1   HDG            0
     O                                            3 'B/O'
     O                                           12 'Date'
     O                                           21 'Item  '
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
     O               40N71   LEFT          4     66
     O               40 71   LEFT          4     77
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
     O*                      TOTQTY        4     47
     O                       TotalCount    4     66
     O                                           58 'Total Ship:'
     O          E       U1   TL1            1
     O                                           16 'Program: -BIR310'
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
     O                                           13 'Ord Taken By:'
     O**                       OHUSER    24
     O                       POENTR              24
     O                                           36 'Ord Date:'
     O                       OHDTOR        Y     45
     O                       TOTBO         4     77
     O                                           71 'B/O:'
     O                       TotalCount    4     66
     O*                      TOTQTY        4     47
     O                                           58 'Total Ship:'
     O          E       U1   TL1            1
     O                       OHORD#        4     80
     O                                           73 'Order:'
      *
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
