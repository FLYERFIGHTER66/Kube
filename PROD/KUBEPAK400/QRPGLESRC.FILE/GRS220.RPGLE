      *----------------------------------------------------------      ----
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1995
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDE      RED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXC      EPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *       EFD ENTERPRISES INC.  215-643-5352
      *
      *----------------------------------------------------------      ----
      **PROGRAM NAME-------- GRS220
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **DESCRIPTION--------- ENTER LOT TRANSACTIONS.
      **
      *
      *    DATE----INIT-------DESCRIPTION
      * 12/19/95 EFD MAKE PHYTO MANDATORY AND ALLOW TRANSFER TO HIGHER
      *              PHYTO CODE LOT.
      * 12/19/95 EFD ALLOW DELETION OF AN ENTIRE LOT.
      *  3/20/96 EFD NOT ALLOW TRANSFER TO HIGHER PHYTO. DALE,JOE,RICH
      *  4/11/96 EFD IF NO PROD TABLE ASSUME 100% AVAILABLE.
      * 11/25/96 EFD DO NOT CLEAR REASON CODE.
      * 01/22/97 GD  DO NOT CLEAR CURRENT LOCATION
      *  5/12/97 EFD DO NOT CALL RECALC JOB.
      *  6/02/97 EFD ADD FDLOTND AND GET RID OF FALITEM
      *  6/05/97 EFD DONOT DELETE FDLOTRD HERE WE WILL DO ON SUNDAY
      *
     FGRS220FM  CF   E             WORKSTN
     F                                     SFILE(LOTSFL:RECNO)
     F                                     DEVID(WSID)
     FFPRODCD   IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFPHYTO    IF   E           K DISK
     FFMINVT    UF   E           K DISK
     FFLOTRN    O  A E           K DISK
      *FFIORDR  UF  E           K        DISK
      *FFHORDR  IF  E           K        DISK
     FFDLOT     UF   E           K DISK
     FFLOTND    UF A E           K DISK
     FFDLOTRD   UF A E           K DISK
     FFDLOTRDR  IF   E           K DISK
     F                                     RENAME(RDLOTRD:READYL)
     FFMCUST    IF   E           K DISK
      *
     D MSG             S             30    DIM(5) CTDATA PERRCD(1)              HEADINGS
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND                      @DT
     D #JD             S             03  0 DIM(13) CTDATA PERRCD(13) ASCEND                      @DT
     D MIN             S              7  0 DIM(12)                              MINIMUM
     D MAX             S              7  0 DIM(12)                              MAXIMUM
     D UNT             S              5  0 DIM(12)                              FACTOR UNITS
     D PCT             S              5  2 DIM(12)                              FACTOR %
      ** MINVT ARRAYS
     D IP1             S              9  4 DIM(5)                               PRICE U/M 1
     D IP2             S              9  4 DIM(5)                               PRICE U/M 2
     D IP3             S              9  4 DIM(5)                               PRICE U/M 3
     D IDQ             S             11  1 DIM(5)                               QTY. DISC QTY.
     D IDP             S              4  2 DIM(5)                               QTY. DISC %
     D ISQ             S             11  1 DIM(13)                              SOLD QTY 13 MO
     D ISP             S              9  2 DIM(13)                              SOLD PRICE 13
     D ISC             S              9  2 DIM(13)                              SOLD COST 13 M
     D IGB             S              4  0 DIM(4)                               BEG WKS GERM
     D IGE             S              4  0 DIM(4)                               END WKS GERM
     D IGW             S              2  0 DIM(4)                               # OF WKS GERM
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
      ***********************
      * LOCAL DATA AREA   E *
      ***********************
      *
     D                UDS
     D  LTITEM                 1     12
     D  LTSIZE                13     15
     IRMINVT
     I              IMSEL1                      IP1(1)
     I              IMSEL2                      IP1(2)
     I              IMSEL3                      IP1(3)
     I              IMSEL4                      IP1(4)
     I              IMSEL5                      IP1(5)
     I              IMBCS1                      IP2(1)
     I              IMBCS2                      IP2(2)
     I              IMBCS3                      IP2(3)
     I              IMBCS4                      IP2(4)
     I              IMBCS5                      IP2(5)
     I              IM3CS1                      IP3(1)
     I              IM3CS2                      IP3(2)
     I              IM3CS3                      IP3(3)
     I              IM3CS4                      IP3(4)
     I              IM3CS5                      IP3(5)
     I              IMQLB1                      IDQ(1)
     I              IMQLB2                      IDQ(2)
     I              IMQLB3                      IDQ(3)
     I              IMQLB4                      IDQ(4)
     I              IMQLB5                      IDQ(5)
     I              IMDIS1                      IDP(1)
     I              IMDIS2                      IDP(2)
     I              IMDIS3                      IDP(3)
     I              IMDIS4                      IDP(4)
     I              IMDIS5                      IDP(5)
     I              IMQM01                      ISQ(1)
     I              IMQM02                      ISQ(2)
     I              IMQM03                      ISQ(3)
     I              IMQM04                      ISQ(4)
     I              IMQM05                      ISQ(5)
     I              IMQM06                      ISQ(6)
     I              IMQM07                      ISQ(7)
     I              IMQM08                      ISQ(8)
     I              IMQM09                      ISQ(9)
     I              IMQM10                      ISQ(10)
     I              IMQM11                      ISQ(11)
     I              IMQM12                      ISQ(12)
     I              IMQM13                      ISQ(13)
     I              IM$M01                      ISP(1)
     I              IM$M02                      ISP(2)
     I              IM$M03                      ISP(3)
     I              IM$M04                      ISP(4)
     I              IM$M05                      ISP(5)
     I              IM$M06                      ISP(6)
     I              IM$M07                      ISP(7)
     I              IM$M08                      ISP(8)
     I              IM$M09                      ISP(9)
     I              IM$M10                      ISP(10)
     I              IM$M11                      ISP(11)
     I              IM$M12                      ISP(12)
     I              IM$M13                      ISP(13)
     I              IMCM01                      ISP(1)
     I              IMCM02                      ISP(2)
     I              IMCM03                      ISP(3)
     I              IMCM04                      ISP(4)
     I              IMCM05                      ISP(5)
     I              IMCM06                      ISP(6)
     I              IMCM07                      ISP(7)
     I              IMCM08                      ISP(8)
     I              IMCM09                      ISP(9)
     I              IMCM10                      ISP(10)
     I              IMCM11                      ISP(11)
     I              IMCM12                      ISP(12)
     I              IMCM13                      ISP(13)
     I              IMBD1                       IGB(1)
     I              IMBD2                       IGB(2)
     I              IMBD3                       IGB(3)
     I              IMBD4                       IGB(4)
     I              IMED1                       IGE(1)
     I              IMED2                       IGE(2)
     I              IMED3                       IGE(3)
     I              IMED4                       IGE(4)
     I              IMWG1                       IGW(1)
     I              IMWG2                       IGW(2)
     I              IMWG3                       IGW(3)
     I              IMWG4                       IGW(4)
      *
      **************************************
      ** START OF MAINLINE CODE           **
      **************************************
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TIMWRK           12 0
     C                   MOVE      TIMWRK        TDATE             6 0
     C     TDATE         MULT      10000.01      RDATE             6 0
     C     RSTRT         TAG
     C                   EXSR      CLRIT
     C                   EXSR      CLRIND
     C                   SETOFF                                       5098
      *
      **********************
      ** SCREEN A PROCESS **
      **********************
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102030
     C                   SETOFF                                       405099
     C                   SETOFF                                       969711
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       9831
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
      ** SEE IF WE NEED ALPHA SEARCH
     C     1             SUBST     ITEM:1        VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     ITEM:2        IMLOOK
     C                   MOVE      *BLANKS       SHPFRM            3
     C                   CALL      'LKITEM'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C     ITMKEY        CHAIN(N)  FMINVT                             10
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         IDESC
     C                   SETON                                        31
     C                   GOTO      NXTA
     C                   END
     C                   EXSR      SR100A
     C   99              GOTO      NXTA
     C                   SETOFF                                       77
      ** OUTPUT SUB FILE
     C     NXTSFL        TAG
     C                   EXFMT     LOTCTL
     C***KF 77             EXSR PUTRB
     C   KF              GOTO      RSTRT
     C**                   READCLOTSFL                   90
     C     LINE          CHAIN     LOTSFL                             90
     C   90              GOTO      NXTSFL
     C                   EXSR      CHGLOT
     C     SOWDAT        IFGT      0
     C                   EXSR      SFLS
     C                   ELSE
     C                   EXSR      SFLR
     C                   END
     C                   GOTO      NXTSFL
      *
      *****************
      ** END PROGRAM **
      *****************
      *
     C     END           TAG
     C   KC
     COR KG              SETON                                        LR
      *
      **************************
      ******     SR100A - SCRNA
      **************************
      *
     C     SR100A        BEGSR
      ** CHECK ITEM
     C     ITMKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C     ITMKEY        CHAIN(N)  FMINVT                             10
     C   10              SETON                                        99
     C   10              MOVE      *BLANKS       IDESC
     C  N10              DO
     C     IMLOTC        IFNE      'Y'
     C                   SETON                                        101199
     C                   END
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         IDESC
     C                   ENDDO
      ** CHECK ITEM
     C     SIZE          CHAIN     FMSIZE                             20
     C   20              SETON                                        99
     C   20              MOVE      *BLANKS       SZDESC
      *
      ** CHECK SOW DATE
     C                   Z-ADD     0             RSOW
     C     SOWDAT        IFGT      0
     C                   Z-ADD     SOWDAT        ##MDY
     C                   EXSR      @DT@A1
     C  N90              DO
     C                   EXSR      @DT@B1
     C                   EXSR      @DAYWK
     C     #Y            IFNE      1
     C                   SETON                                        90
     C                   END
     C                   ENDDO
     C   90              SETON                                        303199
     C  N90              MOVE      ##CYMD        RSOW              7 0
     C                   END
      ** CHECK READY DATE
     C                   Z-ADD     0             RRED
     C     REDDAT        IFGT      0
     C                   Z-ADD     REDDAT        ##MDY
     C                   EXSR      @DT@A1
     C  N90              DO
     C                   EXSR      @DT@B1
     C                   EXSR      @DAYWK
     C     #Y            IFNE      1
     C                   SETON                                        90
     C                   END
     C                   ENDDO
     C   90              SETON                                        4099
     C  N90              MOVE      ##CYMD        RRED              7 0
     C                   END
      ** CHECK LOCATION
      *
     C     1             SUBST     SLOC:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     *BLANKS       WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       SLOC
     C                   MOVEL     WHWHSE        SLOC
     C                   SETON                                        99
     C                   GOTO      ENDA
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       SOLOC
     C                   MOVE      *BLANKS       CURLOC
     C     SLOC          IFGT      *BLANKS
     C     CLOC          ANDGT     *BLANKS
     C                   SETON                                        506099
     C                   ENDIF
     C  N50SLOC          IFGT      *BLANKS
     C     SLOC          CHAIN     FMWHSE                             50
     C   50              SETON                                        99
     C  N50              MOVEL     WHDESC        SOLOC
     C                   SETOFF                                       9697
     C                   END
     C  N60CLOC          IFGT      *BLANKS
     C     CLOC          CHAIN     FMWHSE                             50
     C   60              SETON                                        99
     C  N60              MOVEL     WHDESC        CURLOC
     C                   SETOFF                                       9697
     C                   END
     C   99              GOTO      ENDA
      *
      * CHECK PHYTO
      *
     C     PHYTO         IFEQ      '?'
     C     PHYTO         OREQ      '/'
     C                   MOVEL     PHYTO         PHCODE
     C                   CALL      'LKPHYT'
     C                   PARM                    PHCODE
     C                   PARM                    PHYDES           30
     C                   MOVEL     *BLANKS       PHYTO
     C                   MOVEL     PHCODE        PHYTO
     C                   SETON                                        99
     C                   SETON                                        99
     C                   GOTO      ENDA
     C                   ENDIF
      *
     C     PHYTO         CHAIN     FPHYTO                             40
     C   40              SETON                                        99
     C   40              MOVE      *BLANKS       PHYDES
      *
      ** CHECK OPTIONS FOR LIST
     C                   SETON                                        98
     C     SOWDAT        IFGT      0
     C                   EXSR      SFLS
     C                   ELSE
     C                   EXSR      SFLR
     C                   END
     C   98              SETON                                        99
     C     ENDA          ENDSR
      *****************************
      * BUILD SUBFILE BY SOW DATE *
      *****************************
     C     SFLS          BEGSR
     C                   EXSR      CLRSFL
     C     SOWKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C                   KFLD                    RSOW
     C     SOWKEY        SETLL     FDLOTRD
     C     NXSFLS        TAG
     C     SOWKEY        READE(N)  RDLOTRD                                90
     C  N90              DO
     C                   EXSR      BLDSFL
     C                   GOTO      NXSFLS
     C                   ENDDO
     C     ENSFLS        ENDSR
      *******************************
      * BUILD SUBFILE BY READY DATE *
      *******************************
     C     SFLR          BEGSR
     C                   EXSR      CLRSFL
     C     REDKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C     RDKEYI        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C                   KFLD                    RRED
     C     RRED          IFLE      0
     C     REDKEY        SETLL     FDLOTRDR
     C                   ELSE
     C     RDKEYI        SETLL     FDLOTRDR
     C                   END
     C     NXSFLR        TAG
     C     RRED          IFLE      0
     C     REDKEY        READE     READYL                                 90
     C                   ELSE
     C     RDKEYI        READE     READYL                                 90
     C                   END
     C  N90              DO
     C                   EXSR      BLDSFL
     C                   GOTO      NXSFLR
     C                   ENDDO
     C     ENSFLR        ENDSR
      ******************
      * BUILD SUB FILE *
      ******************
     C     BLDSFL        BEGSR
      ** CHECK IF ANY LIMITS EXCEEDED
     C     SLOC          IFNE      *BLANKS
     C     LRGLOC        ANDNE     SLOC
     C                   GOTO      ENDBLD
     C                   ENDIF
     C     CLOC          IFNE      *BLANKS
     C     LRCLOC        ANDNE     CLOC
     C                   GOTO      ENDBLD
     C                   ENDIF
     C     PHYTO         IFNE      *BLANKS
     C     LRCPHY        ANDNE     PHYTO
     C                   GOTO      ENDBLD
     C                   ENDIF
     C     CODE          IFNE      *BLANKS
     C     LRCODE        ANDNE     CODE
     C                   GOTO      ENDBLD
     C                   ENDIF
     C                   ADD       1             RECNO
     C                   SETOFF                                       98
     C                   MOVE      *BLANKS       ACTNCD
     C                   MOVE      LRSOWD        WRK6              6 0
     C     WRK6          MULT      100.0001      SOWD
     C                   MOVE      LRCRDY        WRK6              6 0
     C     WRK6          MULT      100.0001      RDYD
     C                   WRITE     LOTSFL
     C     ENDBLD        ENDSR
      **************************
      * CALL RECALC ALLOCATION *
      **************************
      ******************
      * CLEAR SUB FILE *
      ******************
     C     CLRSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     LOTCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C                   ENDSR
      **********************
      * CHANGE LOT RECORDS *
      **********************
     C     CHGLOT        BEGSR
     C     FDLKEY        KLIST
     C                   KFLD                    LRITEM
     C                   KFLD                    LRSIZE
     C                   KFLD                    LRSOWD
     C                   KFLD                    LRPHYT
     C                   KFLD                    LRCRDY
     C                   KFLD                    LRGLOC
     C                   KFLD                    LRCPHY
     C                   KFLD                    LRCLOC
     C                   KFLD                    LRCODE
     C                   KFLD                    LRCUST
     C                   Z-ADD     SOWD          ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        LRSOWD
     C                   Z-ADD     RDYD          ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        LRCRDY
      ** GET CURRENT CODES FOR LOTRN FILE
     C                   MOVEL     LRCPHY        FLLPHY
     C                   Z-ADD     LRCRDY        FLLRDY
     C                   MOVEL     LRCLOC        FLLLOC
     C                   MOVEL     LRCODE        FLLCOD
     C                   Z-ADD     LRCUST        FLLCST
     C     FDLKEY        CHAIN     FDLOTRD                            90
     C     LRCLOC        CHAIN     FMWHSE                             90
     C   90              MOVE      *BLANKS       SOLOC
     C  N90              MOVEL     WHDESC        SOLOC
     C     LRCPHY        CHAIN     FPHYTO                             90
     C   90              MOVE      *BLANKS       OLPDES
     C  N90              MOVEL     PHYDES        OLPDES
     C                   MOVE      *BLANKS       OCDESC
     C                   Z-ADD     1             X                 2 0
     C     LRCODE        IFEQ      'H'
     C                   Z-ADD     2             X
     C                   END
     C     LRCODE        IFEQ      'R'
     C                   Z-ADD     3             X
     C                   END
     C     LRCODE        IFEQ      'S'
     C                   Z-ADD     4             X
     C                   END
     C     LRCODE        IFEQ      'T'
     C                   Z-ADD     5             X
     C                   END
     C                   MOVEL     MSG(X)        OCDESC
     C                   MOVE      *BLANKS       OCNAM
     C     LRCODE        IFNE      'R'
     C                   Z-ADD     0             LRCUST
     C                   ELSE
     C     LRCUST        CHAIN     FMCUST                             90
     C                   MOVEL     CMNAME        OCNAM
     C                   END
     C                   SETOFF                                       05
     C                   SETOFF                                       102030
     C                   SETOFF                                       404150
     C                   SETOFF                                       9899
     C                   Z-ADD     0             NEWRED
     C                   Z-ADD     0             NWCUST
     C                   Z-ADD     0             NEWQTY
     C                   MOVE      *BLANKS       NWCNAM
     C                   MOVE      *BLANKS       NWCDES
     C                   MOVE      *BLANKS       NWPDES
     C                   MOVE      *BLANKS       NWLDES
     C*                    MOVE *BLANKS   PCDESC
     C*                    MOVE *BLANKS   PCCODE
     C                   MOVE      LRCRDY        WRK6              6 0
     C     WRK6          MULT      100.0001      RDYD
     C     NXTCHG        TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNB
     C                   Z-ADD     0             COUNT             2 0
     C                   READ      SCRNB                                  90
     C   KF              GOTO      ENDCHG
     C                   SETOFF                                       0511
     C                   SETOFF                                       102030
     C                   SETOFF                                       404150
     C                   SETOFF                                       99
      ** CHECK REASON CODE
     C                   MOVEL     PCCODE        VCODE             3
     C     1             SUBST     PCCODE:1      VPCC              1
     C     VPCC          IFEQ      '?'
     C     VPCC          OREQ      '/'
     C                   MOVEL     VCODE         PCCODE
     C                   CALL      'LKPRCD'
     C                   PARM                    PCCODE
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VCODE
     C                   MOVEL     PCCODE        VCODE
     C                   MOVEL     VCODE         PCCODE
     C                   GOTO      NXTCHG
     C                   ENDIF
      *
     C     PCCODE        CHAIN     FPRODCD                            05
     C   05              SETON                                        99
     C   05              MOVE      *BLANKS       PCDESC
     C   05              MOVE      *BLANKS       OREASN            3
     C   05              GOTO      NXTCHG
     C                   SETOFF                                       65
      ** CHECK IF DATE CHANGED
     C     NEWRED        IFGT      0
     C                   Z-ADD     NEWRED        ##MDY
     C                   EXSR      @DT@A1
     C  N90              DO
     C                   EXSR      @DT@B1
     C                   EXSR      @DAYWK
     C     #Y            IFNE      1
     C                   SETON                                        90
     C                   END
     C                   ENDDO
     C   90              SETON                                        10  99
     C  N90              SETON                                        65
     C                   END
      ** CHECK IF LOCATION CHANGED
     C     NEWLOC        IFGT      *BLANKS
     C     NEWLOC        CHAIN     FMWHSE                             90
     C   90              MOVE      *BLANKS       NWLDES
     C  N90              MOVEL     WHDESC        NWLDES
     C  N90              SETON                                        65
     C   90              SETON                                        20  99
     C                   END
      ** CHECK IF PHYTO CHANGED
     C                   SETOFF                                       3031
     C     NEWPHY        IFNE      *BLANKS
     C     NEWPHY        CHAIN     FPHYTO                             30
     C   30              MOVE      *BLANKS       NWPDES
     C  N30LRCPHY        IFLT      NEWPHY
     C                   SETON                                        3031
     C                   END
     C  N30              MOVEL     PHYDES        NWPDES
     C  N30              SETON                                        65
     C   30              SETON                                        99
     C                   END
      ** CHECK IF CODE CHANGE
     C     NEWCOD        IFGT      *BLANKS
     C     NEWCOD        IFEQ      'A'
     C                   Z-ADD     1             X
     C                   END
     C     NEWCOD        IFEQ      'H'
     C                   Z-ADD     2             X
     C                   END
     C     NEWCOD        IFEQ      'R'
     C                   Z-ADD     3             X
     C                   END
     C     NEWCOD        IFEQ      'S'
     C                   Z-ADD     4             X
     C                   END
     C     NEWCOD        IFEQ      'T'
     C                   Z-ADD     5             X
     C                   END
     C                   MOVEL     MSG(X)        NWCDES
     C                   SETON                                        65
     C                   END
      ** CHECK IF CUSTOMER CHANGED
     C     NWCUST        IFGT      0
     C     NEWCOD        IFNE      'R'
     C                   SETON                                        404199
     C                   ELSE
     C     NWCUST        CHAIN     FMCUST                             40
     C   40              SETON                                        99
     C   40              MOVE      *BLANKS       NWCNAM
     C  N40              MOVEL     CMNAME        NWCNAM
     C  N40              SETON                                        65
     C                   END
     C                   END
      ** CHECK FOR QUANTITY
      * IF 65 IS ON LOT CHANGED SUBTRACT QUANTITY
      * IF 65 IS OFF LOT NOT CHANGED ADD QUANTITY
     C                   SETOFF                                       5051
     C     NEWQTY        IFEQ      0
     C                   SETON                                        50  99
     C                   ELSE
     C   65              DO
     C     LRQTOH        SUB       NEWQTY        LEFT
     C                   ENDDO
     C  N65              DO
     C     LRQTOH        ADD       NEWQTY        LEFT
     C*************        SUB  LRQTAL    LEFT
     C                   ENDDO
     C     LEFT          IFLT      0
     C                   SETON                                        505199
     C                   END
     C                   END
     C   99              GOTO      NXTCHG
      ** CHECK FOR CHANGES
     C     PCCODE        IFNE      OREASN
     C                   ADD       1             COUNT
     C                   MOVEL     PCCODE        OREASN
     C                   END
     C     NEWRED        IFNE      OLDRED
     C                   ADD       1             COUNT
     C                   Z-ADD     NEWRED        OLDRED            6 0
     C                   END
     C     NWCUST        IFNE      OLCUST
     C                   ADD       1             COUNT
     C                   Z-ADD     NWCUST        OLCUST            6 0
     C                   END
     C     NEWQTY        IFNE      OLDQTY
     C                   ADD       1             COUNT
     C                   Z-ADD     NEWQTY        OLDQTY           11 1
     C                   END
     C     NEWLOC        IFNE      OLDLOC
     C                   ADD       1             COUNT
     C                   MOVEL     NEWLOC        OLDLOC            3
     C                   END
     C     NEWPHY        IFNE      OLDPHY
     C                   ADD       1             COUNT
     C                   MOVEL     NEWPHY        OLDPHY            1
     C                   END
     C     NEWCOD        IFNE      OLDCOD
     C                   ADD       1             COUNT
     C                   MOVEL     NEWCOD        OLDCOD            1
     C                   END
     C     COUNT         IFGT      0
     C                   SETON                                        98
     C                   GOTO      NXTCHG
     C                   END
      *** UPDATE RECORDS
      **  IF ONLY QTY CHANGE UPDATE: MINVT,FDLOT,AND FLOTRN
     C  N65              DO
     C                   ADD       NEWQTY        LRQTOH
     C                   Z-ADD     RDATE         LRDTLA
     C                   Z-ADD     TIMOD         LRTIME
     C                   MOVEL     USERID        LRUSER
     C                   MOVEL     WSID          LRWSID
     C                   UPDATE    RDLOTRD
      ** UPDATE MINVT
     C     ITEMKY        KLIST
     C                   KFLD                    LRITEM
     C                   KFLD                    LRSIZE
     C                   KFLD                    LRWHSE
     C     ITEMKY        CHAIN     FMINVT                             10
     C                   ADD       NEWQTY        IMQTOH
     C                   ADD       NEWQTY        IMQTAV
     C     IMQTOH        MULT      IMUCST        IMCSOH
     C  N10              UPDATE    RMINVT
     C     LOTKEY        KLIST
     C                   KFLD                    LRITEM
     C                   KFLD                    LRSIZE
     C                   KFLD                    LRWHSE
     C                   KFLD                    LRSOWD
     C                   KFLD                    LRPHYT
     C                   KFLD                    LRGLOC
     C     LOTKEY        CHAIN     FDLOT                              10
      ** CHANGE LOT RECORD
     C                   ADD       NEWQTY        LDQTAV
     C                   ADD       NEWQTY        LDQTOH
     C                   ADD       NEWQTY        LDQTAJ
     C                   Z-ADD     TDATE         LDDTLA
     C                   Z-ADD     TIMOD         LDTIME
     C                   MOVEL     USERID        LDUSER
     C                   MOVEL     WSID          LDWSID
     C                   MOVEL     IMLOOK        LDALPH
     C                   MOVEL     IMPCL1        LDPRCL
     C  N10              UPDATE    RDLOT
     C     LRQTOH        SUB       LRQTAL        TSTL             11 1
     C***        TSTL      IFLT 0
     C***                  EXSR REALC
     C***                  END
      ** ADD TRANSACTION RECORD
     C                   MOVEL     ITEM          FLITEM
     C                   MOVEL     SIZE          FLSIZE
     C                   MOVEL     IMWHSE        FLWHSE
     C                   Z-ADD     LRSOWD        FLSOWD
     C                   MOVEL     LRGLOC        FLGLOC
     C                   MOVEL     LRPHYT        FLPHYT
     C                   Z-ADD     IMCOMP        FLCOMP
     C                   Z-ADD     NEWQTY        FLQTY
     C                   Z-ADD     0             FLSOWN
     C                   Z-ADD     RDATE         FLACTD
     C                   Z-ADD     TIMOD         FLTIME
     C                   MOVEL     USERID        FLUSER
     C                   MOVEL     WSID          FLWSID
     C                   MOVEL     PCCODE        FLREAS
     C                   WRITE     RLOTRN
      ** UPDATE LOTND
     C     LRCLOC        CHAIN     FMWHSE                             90
     C                   MOVEL     WHREG         LNREGN
     C     LNREGN        IFEQ      'E '
     C                   MOVEL     'B'           LNPHYT
     C                   ELSE
     C                   MOVEL     'Y'           LNPHYT
     C                   END
     C                   MOVEL     ITEM          LNITEM
     C                   MOVEL     SIZE          LNSIZE
     C                   Z-ADD     IMCOMP        LNCOMP
     C                   Z-ADD     LRCUST        LNCUST
     C                   MOVEL     LRCODE        LNCODE
     C                   Z-ADD     LRCRDY        LNCRDY
     C     NDKEY         KLIST
     C                   KFLD                    LNITEM
     C                   KFLD                    LNSIZE
     C                   KFLD                    LNPHYT
     C                   KFLD                    LNCRDY
     C                   KFLD                    LNREGN
     C                   KFLD                    LNCODE
     C                   KFLD                    LNCUST
      ** CHECK IF TYPE NEEDED IN LOTND
     C     LNCODE        IFEQ      'A'
     C     LNCODE        OREQ      'R'
     C     NDKEY         CHAIN     FLOTND                             90
     C                   MOVEL     USERID        LNUSER
     C                   Z-ADD     TIMOD         LNTIME
     C                   Z-ADD     TDATE         LNDTLA
     C                   ADD       NEWQTY        LNQTOH
     C  N90              UPDATE    RLOTND
     C                   ENDIF
     C                   GOTO      ENDCHG
     C                   ENDDO
      ** IF 65 ON WE HAVE TO PLUS AND MINUS ALL FILES EXCEPT FMINVT
     C   65              DO
      ** GET RID OF OLD
     C     FDLKEY        CHAIN     FDLOTRD                            93
     C                   SUB       NEWQTY        LRQTOH
     C                   Z-ADD     TDATE         LRDTLA
     C                   Z-ADD     TIMOD         LRTIME
     C                   MOVEL     USERID        LRUSER
     C                   MOVEL     WSID          LRWSID
     C  N93LRQTOH        IFEQ      0
     C***                  DELETRDLOTRD
     C                   UPDATE    RDLOTRD
     C                   ELSE
     C                   UPDATE    RDLOTRD
     C                   END
      ** LOTND
     C     LRCLOC        CHAIN     FMWHSE                             90
     C                   MOVEL     WHREG         LNREGN
     C     LNREGN        IFEQ      'E '
     C                   MOVEL     'B'           LNPHYT
     C                   ELSE
     C                   MOVEL     'Y'           LNPHYT
     C                   END
     C                   MOVEL     ITEM          LNITEM
     C                   MOVEL     SIZE          LNSIZE
     C                   Z-ADD     IMCOMP        LNCOMP
     C                   Z-ADD     LRCUST        LNCUST
     C                   MOVEL     LRCODE        LNCODE
     C                   Z-ADD     LRCRDY        LNCRDY
      ** CHECK IF TYPE NEEDED IN LOTND
     C     LNCODE        IFEQ      'A'
     C     LNCODE        OREQ      'R'
     C     NDKEY         CHAIN     FLOTND                             90
     C                   MOVEL     USERID        LNUSER
     C                   Z-ADD     TIMOD         LNTIME
     C                   Z-ADD     TDATE         LNDTLA
     C                   SUB       NEWQTY        LNQTOH
     C  N90              UPDATE    RLOTND
     C                   ENDIF
     C     LRQTOH        SUB       LRQTAL        TSTL             11 1
     C***        TSTL      IFLT 0
     C***                  EXSR REALC
     C***                  END
      ** ADD TRANSACTION RECORD
     C                   MOVEL     ITEM          FLITEM
     C                   MOVEL     SIZE          FLSIZE
     C                   MOVEL     IMWHSE        FLWHSE
     C                   Z-ADD     LRSOWD        FLSOWD
     C                   MOVEL     LRGLOC        FLGLOC
     C                   MOVEL     LRPHYT        FLPHYT
     C                   Z-ADD     IMCOMP        FLCOMP
     C                   Z-SUB     NEWQTY        FLQTY
     C                   Z-ADD     0             FLSOWN
     C                   Z-ADD     RDATE         FLACTD
     C                   Z-ADD     TIMOD         FLTIME
     C                   MOVEL     USERID        FLUSER
     C                   MOVEL     WSID          FLWSID
     C                   MOVEL     PCCODE        FLREAS
      ** MOVE NEW FIELDS INTO LR FIELDS
     C     NEWRED        IFGT      0
     C                   Z-ADD     NEWRED        ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        LRCRDY
     C                   Z-ADD     ##CYMD        LNCRDY
     C                   END
     C     NEWLOC        IFGT      *BLANKS
     C                   MOVEL     NEWLOC        LRCLOC
     C                   END
     C     NEWPHY        IFGT      *BLANKS
     C                   MOVEL     NEWPHY        LRCPHY
     C                   END
     C     NEWCOD        IFGT      *BLANKS
     C                   MOVEL     NEWCOD        LRCODE
     C                   MOVEL     NEWCOD        LNCODE
     C                   END
     C     NWCUST        IFGT      0
     C                   Z-ADD     NWCUST        LRCUST
     C                   Z-ADD     NWCUST        LNCUST
     C                   END
     C     LRCODE        IFNE      'R'
     C                   Z-ADD     0             LRCUST
     C                   Z-ADD     0             LNCUST
     C                   END
      ** GET NEW CODES IN TRANS FILE
     C                   MOVEL     LRCPHY        FLNPHY
     C                   Z-ADD     LRCRDY        FLNRDY
     C                   MOVEL     LRCLOC        FLNLOC
     C                   MOVEL     LRCODE        FLNCOD
     C                   Z-ADD     LRCUST        FLNCST
     C                   WRITE     RLOTRN
      ** ADD NEW
     C     FDLKEY        CHAIN     FDLOTRD                            93
     C   93              Z-ADD     0             LRQTOH
     C                   ADD       NEWQTY        LRQTOH
     C                   Z-ADD     TDATE         LRDTLA
     C                   Z-ADD     TIMOD         LRTIME
     C                   MOVEL     USERID        LRUSER
     C                   MOVEL     WSID          LRWSID
     C  N93              UPDATE    RDLOTRD
     C   93              WRITE     RDLOTRD
      ** CHECK IF TYPE NEEDED IN LOTND
     C     LNCODE        IFEQ      'A'
     C     LNCODE        OREQ      'R'
     C     NDKEY         CHAIN     FLOTND                             90
     C   90              DO
     C                   Z-ADD     0             LNQTOH
     C                   Z-ADD     0             LNQTOO
     C                   Z-ADD     0             LNQTAL
     C                   Z-ADD     0             LNALTO
     C                   Z-ADD     0             LNALFR
     C                   Z-ADD     0             LNQTAV
     C                   Z-ADD     0             LNQTSP
     C                   Z-ADD     0             LNQTSU
     C                   ENDDO
     C                   MOVEL     USERID        LNUSER
     C                   Z-ADD     TIMOD         LNTIME
     C                   Z-ADD     TDATE         LNDTLA
     C                   ADD       NEWQTY        LNQTOH
     C   90              WRITE     RLOTND
     C  N90              UPDATE    RLOTND
     C                   ENDIF
      ** ADD TRANSACTION RECORD
     C                   MOVEL     ITEM          FLITEM
     C                   MOVEL     SIZE          FLSIZE
     C                   MOVEL     IMWHSE        FLWHSE
     C                   Z-ADD     LRSOWD        FLSOWD
     C                   MOVEL     LRGLOC        FLGLOC
     C                   MOVEL     LRPHYT        FLPHYT
     C                   Z-ADD     IMCOMP        FLCOMP
     C                   Z-ADD     NEWQTY        FLQTY
     C                   Z-ADD     0             FLSOWN
     C                   Z-ADD     RDATE         FLACTD
     C                   Z-ADD     TIMOD         FLTIME
     C                   MOVEL     USERID        FLUSER
     C                   MOVEL     WSID          FLWSID
     C                   MOVEL     PCCODE        FLREAS
     C                   WRITE     RLOTRN
     C                   ENDDO
     C     ENDCHG        ENDSR
      ***********************
      * GET NEW ALLOCATIONS *
      ***********************
     C     REALC         BEGSR
      ********
     C     ENDALC        ENDSR
      ********************
      * CLEAR INDICATORS *
      ********************
     C     CLRIND        BEGSR
     C                   SETOFF                                       192005
     C                   SETOFF                                       212223
     C                   SETOFF                                       242526
     C                   SETOFF                                       272832
     C                   SETOFF                                       404150
     C                   SETOFF                                       333435
     C                   SETOFF                                       555657
     C                   SETOFF                                       77
     C                   SETOFF                                       808899
     C                   ENDSR
      *  **********
      *  * CLRIT  *
      *  **********
     C     CLRIT         BEGSR
     C                   SETOFF                                       289911
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       IDESC
     C**                   MOVE *BLANKS   PCCODE
     C**                   MOVE *BLANKS   PCDESC
     C                   MOVE      *BLANKS       PHYDES
     C                   MOVE      *BLANKS       SZDESC
     C                   MOVE      *BLANKS       PHYTO
     C                   MOVE      *BLANKS       WHDESC
     C                   MOVE      *BLANKS       CODE
     C                   MOVE      *BLANKS       SLOC
     C                   MOVE      *BLANKS       SOLOC
     C*                    MOVE *BLANKS   CLOC
     C                   MOVE      *BLANKS       CURLOC
     C                   Z-ADD     *ZEROS        REDDAT
     C                   Z-ADD     *ZEROS        SOWDAT
     C                   UNLOCK    FMINVT
     C                   UNLOCK    FDLOT
     C                   UNLOCK    FLOTND
     C                   UNLOCK    FDLOTRD
     C                   ENDSR
0005  ********************************************************************@DT@A1
0006  * VALIDATE DATES. INDICATOR 90 IS ON IF ERROR. 91-92 ALWAYS SETOF.  @DT@A1
0007  * YY GE 00  MM 01-12 DAY 01-28/29/30/31                             @DT@A1
0008  * ##MDY INPUT DATE MMDDYY                                           @DT@A1
0009  * ##CYMD OUTPUT DATE CYYMMDD IF DATE IS OK. ELSE ZERO.              @DT@A1
0010  * C IDENTIFIES 20 OR 21 CENTURY. C=0 FOR YY 70-99. C=1 FOR YY 00-69.@DT@A1
0002 C     @DT@A1        BEGSR                                                                 @DT@A
0011 C                   MOVE      ##MDY         #03A              3 0          MYY            @DT@A
0012 C                   MOVEL     0             #03A                           CYY            @DT@A
0013 C                   MOVEL     ##MDY         #04               4 0          MMDD           @DT@A
0014 C                   MOVEL     ##MDY         #02B              2 0          MM             @DT@A
0015 C                   MOVE      #04           #02C              2 0          DD             @DT@A
0016 C                   Z-ADD     ##MDY         ##MDY             6 0  90      YY IS NEGATIVE @DT@A
0017 C  N90              Z-ADD     #02B          #02               2 0    90    MM LT 01 ERROR @DT@A
0018 C  N90#02B          COMP      12                                 90        MM GT 12 ERROR @DT@A
0019 C  N90#02C          COMP      01                                   90      DD LT 01 ERROR @DT@A
0020 C  N90#02C          COMP      31                                 90  91    DD GT OR EQ 31 @DT@A
0021 C     #02B          COMP      07                                 92        MM 08-12       @DT@A
0022 C   921             ADD       #02B          #02                            MAKE MM ODD    @DT@A
0023 C     #02           DIV       2             #02                                           @DT@A
0024 C                   MVR                     #02                  92        31 DAY MONTH   @DT@A
     C   91
0025 CANN92              SETON                                        90        MM EVEN DD 31  @DT@A
0026 C     #02B          COMP      02                                     91    FEB            @DT@A
0027 C  N91                                                                                    @DT@A
0028 COR 90              GOTO      @DT@AX                                                      @DT@A
0029 C     #03A          DIV       4             #03               3 0          JUST FOR MVR   @DT@A
0030 C                   MVR                     #02                      91    LEAP YEAR      @DT@A
0031 C     #02C          COMP      29                                 90  92    DD GT 29 ERROR @DT@A
     C  N91
0032 CAN 92              SETON                                        90        NO LEAP DD 29  @DT@A
0033 C     @DT@AX        TAG                                                    GOOD DATE      @DT@A
0034 C                   MOVEL     #03A          ##CYMD            7 0          CYY----        @DT@A
0035 C                   MOVE      #04           ##CYMD                         CYYMMDD        @DT@A
0036 C     #03A          COMP      070                                  91                     @DT@A
0037 C   91              MOVEL     1             ##CYMD                         21ST CENTURY   @DT@A
0038 C   90              Z-ADD     0             ##CYMD                         ERROR          @DT@A
0039 C                   SETOFF                                       9192                     @DT@A
0040 C                   ENDSR                                                                 @DT@A
0275 C*
0004 C********************************************************************
0005 C* COPYRIGHT EFD EMTERPRISES INC.
0006 C********************************************************************
0007 C* FIGURES OUT DAY OF THE WEEK THAT ENTERED DATE IS.
0008 C* ##DDD INPUT DATE DDDDD - RESULT FROM @DT@B2
0009 C* #Y OUTPUT INDEX REFLECTING DAY OF WEEK
0009 C* 1 = MONDAY
0011 C********************************************************************
0003 CSR   @DAYWK        BEGSR
0285 CSR   ##DDD         DIV       7.0000        #WKS             10 5
0286 CSR                 MOVE      #WKS          ##R               5 5
0287 CSR   ##R           MULT(H)   7             #Y                1 0
     C*
0288 CSR   #Y            IFGT      7
0289 CSR   #Y            SUB       7             #Y
     CSR                 END
     C*
     CSR   #Y            IFEQ      0
     CSR                 Z-ADD     7             #Y
     CSR                 END
     C*
0293 CSR                 ENDSR
      *
0006  ********************************************************************@DT@B1
0007  * CONVERT CYYMMDD TO DAY OF CENTURY DDDDD. INDICATOR 90 MINUS DATE  @DT@B1
0008  * ##CYMD INPUT DATE CYYMMDD                                         @DT@B1
0009  * ##DDD OUTPUT DAY OF CENTURY DDDDD. BASE DATE IS 01/01/1900        @DT@B1
0010  * INDICATORS USED 90-92.                                            @DT@B1
0011  ********************************************************************@DT@B1
0003 C     @DT@B1        BEGSR                                                                 @DT@B
0012 C                   Z-ADD     ##CYMD        ##CYMD            7 0  90      NEG DATE       @DT@B
0013  * CONVERT YEAR TO DAYS                                              @DT@B1
0014 C                   MOVEL     ##CYMD        #03               3 0          YY             @DT@B
0015 C     #03           MULT      365           ##DDD             5 0          FIRST LEAP     @DT@B
0016 C     #03           DIV       4             #03                      93    # OF LEAPS     @DT@B
0017 C                   MVR                     #02A              2 0    91    LEAP YEAR      @DT@B
     C   91
0018 CANN93#03           SUB       1             #03                                           @DT@B
0019 C     #03           ADD       ##DDD         ##DDD                          DAYS FOR LEAP  @DT@B
0020  * CONVERT MONTH TO DAYS                                             @DT@B1
0021 C                   MOVE      ##CYMD        #04               4 0          MMDD           @DT@B
0022 C                   MOVEL     #04           #02A                           MM             @DT@B
0023 C     #DY(#02A)     ADD       ##DDD         ##DDD                          DAY OF YEAR    @DT@B
0024 C     #02A          COMP      02                                 92        GT FEB         @DT@B
     C   91
     CAN 92
0025 CANN931             ADD       ##DDD         ##DDD                          LP YR MM 3-12  @DT@B
0026  * ADD DAY OF MONTH                                                  @DT@B1
0027 C                   MOVE      ##CYMD        #02               2 0          DD             @DT@B
0028 C     #02           ADD       ##DDD         ##DDD                          ADD DAYS       @DT@B
0029 C   90              Z-ADD     0             ##DDD                                         @DT@B
0030 C                   SETOFF                                       919293                   @DT@B
0031 C                   ENDSR                                                                 @DT@B
0032  ********************************************************************@DT@B1
0004 C********************************************************************@DT@D0
0007 C* CONVERT DAY OF CENTURY DDDDD TO MMDDYY                            @DT@D0
0008 C* ##DDD INPUT DAY OF CENTURY.                                       @DT@D0
0009 C* ##MDY OUTPUT DATE MMDDYY.                                         @DT@D0
0010 C* INDICATOR 90 IS A MINUS DATE.                                     @DT@D0
0011 C* INDICATORS 91-93 USED.                                            @DT@D0
0012 C********************************************************************@DT@D0
0003 CSR   @DT@D0        BEGSR                                                                 @DT@D
0013 CSR                 Z-ADD     0             ##MDY             6 0                         @DT@D
0014 C                   SETOFF                                       919293                   @DT@D
0015 C* TEST IF ZERO OR NEGATIVE                                          @DT@D0
0016 C     ##DDD         SUB       1             #05               5 0  90      REDUCE DDD BY 1@DT@D
0017 C   90              GOTO      @DT@DX                                       ERROR          @DT@D
0018 C* CALCULATE YEARS AND DAY OF YEAR                                   @DT@D0
0019 C     #05           DIV       365           #03               3 0          CYY            @DT@D
0020 C                   MVR                     #03A              3 0          DDD            @DT@D
0021 C* CALCULATE # OF LEAPS                                              @DT@D0
0022 C     #03           DIV       4             #02               2 0    92    # LEAPS        @DT@D
0023 C                   MVR                     #01               1 0    91    LEAP YEAR      @DT@D
     C   92
0024 CAN 91              SETOFF                                       91        1900 NOT LEAP  @DT@D
0025 C     #03A          ADD       1             #03A                           ADD TO DDD BY 1@DT@D
0026 C* IF LEAP YEAR, REDUCE # OF LEAPS BY ONE.                           @DT@D0
0027 CSR 91#02           SUB       1             #02                                           @DT@D
0028 CSR   #03A          SUB       #02           #03A                 92                       @DT@D
0029 C* IF DAYS NOT POSITIVE, ADJUST YEARS.                               @DT@D0
0030 CSRN92#03A          ADD       365           #03A                                          @DT@D
0031 C  N92#03           SUB       1             #03                    91      NO LONGER LEAP @DT@D
0032 C* DETERMINE IF NEW YEAR IS A LEAP.                                  @DT@D0
     CSRN92
0033 CANN91#01           COMP      1                                      91    IS A LEAP      @DT@D
0034 C* IF LEAP YEAR WAS MINUS                                            @DT@D0
     CSRN92
0035 CAN 91#03A          ADD       1             #03A                                          @DT@D
0036 C*                                                                   @DT@D0
0037 CSR   @DT@DA        TAG                                                                   @DT@D
0038 C* CALCULATE MONTH AND DAY.                                          @DT@D0
0039 CSR                 Z-ADD     2             #02                    9293                   @DT@D
0040 C* LEAP YEAR.                                                        @DT@D0
0041 CSR 91#03A          COMP      60                                 93  92                   @DT@D
     CSR 91
0042 CAN 93#03A          SUB       1             #03A                                          @DT@D
     CSR 91
0043 CAN 92              Z-ADD     3             #02                                           @DT@D
0044 CSRN92#03A          LOOKUP    #JD(#02)                           93  93                   @DT@D
0045 C*                                                                   @DT@D0
0046 CSR   #02           SUB       1             #02                                           @DT@D
0047 CSR   #03A          SUB       #JD(#02)      #03A                                          @DT@D
0048 CSR                 Z-ADD     #03A          #04               4 0                         @DT@D
0049 CSR                 MOVEL     #02           #04                                           @DT@D
0050 CSR                 Z-ADD     #03           ##MDY                                         @DT@D
0051 CSR                 MOVEL     #04           ##MDY                                         @DT@D
0052 C*                                                                   @DT@D0
0053 CSR                 SETOFF                                       919293                   @DT@D
0054 CSR   @DT@DX        ENDSR                                                                 @DT@D
0055 C********************************************************************@DT@D0
** HEADINGS
Available
Hold
Reserved
Stock
Transplant
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
000031059090120151181212243273304334
**  02 03 04 05 06 07 08 09 10 11 12   DAY OF YEAR FROM START OF MONTH.
000031059090120151181212243273304334365
