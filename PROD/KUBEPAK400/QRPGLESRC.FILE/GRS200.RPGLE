      *----------------------------------------------------------      ----
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 2000
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
      **PROGRAM NAME-------- GRS200
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
      *  9/20/96 EFD NOT ALLOW BLANK LOCATION. PER DALE/BETTY.
      *  3/27/97 EFD CHECK MINVT RECORD FOR STATUS A.
      *
     FGRS200FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFPRODCD   IF   E           K DISK
     FFPTABLE   IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFPHYTO    IF   E           K DISK
     FFMINVT    UF   E           K DISK
     FFLOTRN    UF A E           K DISK
     FFDLOT     UF A E           K DISK
     FFDLOTRD   UF A E           K DISK
      *
     D MSG             S             30    DIM(6) CTDATA PERRCD(1)              HEADINGS
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND                      @DT
0001 D #JD             S             03  0 DIM(13) CTDATA PERRCD(13) ASCEND                      @DT
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
     IRPTABLE
     I              PTBQ01                      MIN(1)
     I              PTBQ02                      MIN(2)
     I              PTBQ03                      MIN(3)
     I              PTBQ04                      MIN(4)
     I              PTBQ05                      MIN(5)
     I              PTBQ06                      MIN(6)
     I              PTBQ07                      MIN(7)
     I              PTBQ08                      MIN(8)
     I              PTBQ09                      MIN(9)
     I              PTBQ10                      MIN(10)
     I              PTBQ11                      MIN(11)
     I              PTBQ12                      MIN(12)
     I              PTEQ01                      MAX(1)
     I              PTEQ02                      MAX(2)
     I              PTEQ03                      MAX(3)
     I              PTEQ04                      MAX(4)
     I              PTEQ05                      MAX(5)
     I              PTEQ06                      MAX(6)
     I              PTEQ07                      MAX(7)
     I              PTEQ08                      MAX(8)
     I              PTEQ09                      MAX(9)
     I              PTEQ10                      MAX(10)
     I              PTEQ11                      MAX(11)
     I              PTEQ12                      MAX(12)
     I              PTUN01                      UNT(1)
     I              PTUN02                      UNT(2)
     I              PTUN03                      UNT(3)
     I              PTUN04                      UNT(4)
     I              PTUN05                      UNT(5)
     I              PTUN06                      UNT(6)
     I              PTUN07                      UNT(7)
     I              PTUN08                      UNT(8)
     I              PTUN09                      UNT(9)
     I              PTUN10                      UNT(10)
     I              PTUN11                      UNT(11)
     I              PTUN12                      UNT(12)
     I              PTPE01                      PCT(1)
     I              PTPE02                      PCT(2)
     I              PTPE03                      PCT(3)
     I              PTPE04                      PCT(4)
     I              PTPE05                      PCT(5)
     I              PTPE06                      PCT(6)
     I              PTPE07                      PCT(7)
     I              PTPE08                      PCT(8)
     I              PTPE09                      PCT(9)
     I              PTPE10                      PCT(10)
     I              PTPE11                      PCT(11)
     I              PTPE12                      PCT(12)
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
     C                   MOVEL     'A'           LRCODE
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
     C                   SETOFF                                       10  99
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
     C                   EXSR      SR100A
     C   99              GOTO      NXTA
     C                   MOVEL     MSG(OPTION)   OUTTYP
      * CHANGE A READY DATE
     C     OPTION        IFEQ      3
     C                   CALL      'GRS220'
     C                   GOTO      NXTA
     C                   END
      * CHANGE A AVAILABLE QTY
     C     OPTION        IFEQ      4
     C                   CALL      'GRS220'
     C                   GOTO      NXTA
     C                   END
      * TRANSFER TO ANOTHER LOT
     C     OPTION        IFEQ      5
     C                   CALL      'GRS220'
     C                   GOTO      NXTA
     C                   END
      *
      **********************
      ** SCREEN B PROCESS **
      **********************
      *
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       102030
     C                   SETOFF                                       405099
     C                   SETOFF                                       969711
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
      * SEE IF WE NEED ALPHA SEARCH
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
     C                   PARM                    SHPFRM
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   GOTO      NXTB
     C                   END
     C                   EXSR      SR100B
     C   99              GOTO      NXTB
      *
      ************************************
      ** NOW DECIDE WHICH ROUTINE TO RUN *
      ************************************
      * ADD A LOT
     C     OPTION        IFEQ      1
     C                   EXSR      ADDLOT
     C                   END
      * CHANGE A LOT
     C     OPTION        IFEQ      2
     C                   EXSR      CHGLOT
     C                   END
      * CHANGE DESCRIPTION ETC.
     C     OPTION        IFEQ      6
     C                   EXSR      CHGCOM
     C                   END
      *** RETURN FROM SUB ROUTINES HERE
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       IDESC
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       SZDESC
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
     C                   GOTO      NXTB
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
     C     SR100A        BEGSR
      *
     C     OPTION        IFLE      0
     C     OPTION        ORGT      6
     C                   SETON                                        1099
     C                   ENDIF
      *
     C                   ENDSR
      *
      **************************
      ******     SR100B - SCRNB
      **************************
      *
     C     SR100B        BEGSR
      ** CHECK ITEM
     C     ITMKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C     ITMKEY        CHAIN(N)  FMINVT                             10
     C  N10IMSTAT        COMP      'A'                                1010
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
      * CHECK ITEM
     C     SIZE          CHAIN     FMSIZE                             20
     C   20              SETON                                        99
     C   20              MOVE      *BLANKS       SZDESC
      *
      ** CHECK SOW DATE
     C                   Z-ADD     SOWDAT        ##MDY
     C                   EXSR      @DT@A1
     C  N90              DO
     C                   EXSR      @DT@B1
     C                   EXSR      @DAYWK
     C     #Y            IFNE      1
     C                   SETON                                        90
     C                   END
     C                   ENDDO
     C   90              SETON                                        3099
     C  N90              MOVE      ##CYMD        LDSOWD
      *
      * CHECK LOCATION
      *
     C     1             SUBST     LOC:1         VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     *BLANKS       WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       LOC
     C                   MOVEL     WHWHSE        LOC
     C                   SETON                                        99
     C                   GOTO      ENDB
     C                   ENDIF
      *
     C     LOC           CHAIN     FMWHSE                             50
     C   50              SETON                                        99
     C   50              MOVE      *BLANKS       WHDESC
     C                   SETOFF                                       9697
     C   99              GOTO      ENDB
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
     C                   MOVEL     PHCODE        PHTYO
     C                   SETON                                        99
     C                   GOTO      ENDB
     C                   ENDIF
      *
     C     PHYTO         CHAIN     FPHYTO                             40
     C   40              SETON                                        99
     C   40              MOVE      *BLANKS       PHYDES
      *
      * CHECK STATUS OF LOT
      *
     C     LOTKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C                   KFLD                    IMWHSE
     C                   KFLD                    LDSOWD
     C                   KFLD                    PHYTO
     C                   KFLD                    LOC
     C     LOTKEY        CHAIN     FDLOT                              70
     C                   SETOFF                                       9697
     C   70OPTION        IFGT      1
     C                   SETON                                        9699
     C                   END
     C  N70OPTION        IFEQ      1
     C                   SETON                                        9799
     C                   END
     C     ENDB          ENDSR
      *******************
      * ADD LOT RECORDS *
      *******************
     C     ADDLOT        BEGSR
     C                   Z-ADD     0             LDSOWN
     C                   Z-ADD     0             LDQTOH
     C                   Z-ADD     0             REDDAT
     C                   MOVE      *BLANKS       LDSDLT
     C                   MOVE      *BLANKS       LDDESC
     C                   MOVE      *BLANKS       LDAREA
      ** CALC READY DATE.
     C                   EXSR      GETGRM
     C     NXTADD        TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNB1
     C                   Z-ADD     0             COUNT             2 0
     C                   READ      SCRNB1                                 90
     C   KC
     COR KG
     COR KF              GOTO      ENDADD
     C                   SETOFF                                       102030
     C                   SETOFF                                       99
      ** CHECK SOW QUANTITY
     C     LDSOWN        IFLE      0
     C                   SETON                                        1099
     C                   END
     C     LDSOWN        IFNE      OSOWN
     C                   Z-ADD     LDSOWN        OSOWN            11 1
     C                   ADD       1             COUNT
     C                   END
      ** CHECK AVAILABLE QUANTITY
     C     LDQTOH        IFGT      LDSOWN
     C                   SETON                                        2099
     C                   END
     C     LDQTOH        IFLE      0
     C     IMFTAB        CHAIN     FPTABLE                            91
     C  N91              DO
     C                   Z-ADD     12            X                 2 0
     C     NXTFCT        TAG
     C     LDSOWN        IFGE      MIN(X)
     C     LDSOWN        ANDLE     MAX(X)
     C     UNT(X)        IFGT      0                                            --|
     C     LDSOWN        SUB       UNT(X)        LDQTOH                           |
     C                   ELSE                                                    +|
     C     PCT(X)        DIV       100           PCTA              5 4            |
     C**         PCTA      ADD  1.00      FACT    54         |
     C     1.00          SUB       PCTA          FACT              5 4            |
      ** CHECK IF GT 100
     C**         LDSOWN    IFGE 100
     C**                   ADD  .0111     FACT
     C**                   END
     C**         LDSOWN    DIV  FACT      LDQT   110H        |
     C     LDSOWN        MULT(H)   FACT          LDQT             11 0            |
     C                   Z-ADD     LDQT          LDQTOH                           |
     C                   END                                                    --|
     C                   GOTO      ENDFCT
     C                   ENDIF
     C                   SUB       1             X
     C     X             IFGT      0
     C                   GOTO      NXTFCT
     C                   END
     C                   ENDDO
      ** 4/11/96
     C   91              Z-ADD     LDSOWN        LDQTOH
     C                   END
     C     ENDFCT        TAG
     C     LDQTOH        IFLE      0
     C                   SETON                                        2099
     C                   END
     C     LDQTOH        IFNE      OAVAL
     C                   Z-ADD     LDQTOH        OAVAL            11 1
     C                   ADD       1             COUNT
     C                   END
      ** CHECK READY DATE
     C                   Z-ADD     REDDAT        ##MDY
     C                   EXSR      @DT@A1
     C  N90              DO
     C                   EXSR      @DT@B1
     C                   EXSR      @DAYWK
     C     #Y            IFNE      1
     C                   SETON                                        90
     C                   END
     C                   ENDDO
     C   90              SETON                                        3099
     C  N90              MOVE      ##CYMD        LDSHPD
     C  N90              MOVE      ##CYMD        LDCRDY
     C  N90REDDAT        IFNE      OREDD
     C                   Z-ADD     REDDAT        OREDD             6 0
     C                   ADD       1             COUNT
     C                   END
     C     LDSDLT        IFNE      OSDLT
     C                   MOVE      LDSDLT        OSDLT            10
     C                   ADD       1             COUNT
     C                   END
     C     LDDESC        IFNE      ODESC
     C                   MOVE      LDDESC        ODESC            30
     C                   ADD       1             COUNT
     C                   END
     C     LDAREA        IFNE      OAREA
     C                   MOVE      LDAREA        OAREA             6
     C                   ADD       1             COUNT
     C                   END
     C   99              GOTO      NXTADD
     C     COUNT         IFGT      0
     C                   SETON                                        98
     C                   GOTO      NXTADD
     C                   END
      ** ADD RECORDS
      ** UPDATE MINVT
     C     ITMKEY        CHAIN     FMINVT                             10
     C                   ADD       LDQTOH        IMQTOH
     C                   ADD       LDQTOH        IMQTAV
     C     IMQTOH        MULT      IMUCST        IMCSOH
     C                   UPDATE    RMINVT
      ** ADD LOT RECORD
     C                   MOVE      'A'           LDSTAT
     C                   MOVEL     ITEM          LDITEM
     C                   MOVEL     SIZE          LDSIZE
     C                   MOVEL     IMWHSE        LDWHSE
     C                   MOVEL     LOC           LDGLOC
     C                   MOVEL     PHYTO         LDPHYT
     C                   Z-ADD     IMCOMP        LDCOMP
     C                   Z-ADD     IMUCST        LDCOST
     C                   Z-ADD     IMVEND        LDVEND
     C                   Z-ADD     LDQTOH        LDQTAV
     C                   Z-ADD     0             LDQTAL
     C                   Z-ADD     0             LDQTSP
     C                   Z-ADD     0             LDQTAJ
     C                   Z-ADD     TDATE         LDDTLA
     C                   Z-ADD     TIMOD         LDTIME
     C                   MOVEL     USERID        LDUSER
     C***                  MOVELWSID      LDWSID
     C                   MOVEL     IMLOOK        LDALPH
     C                   MOVEL     IMPCL1        LDPRCL
     C                   Z-ADD     0             LDGERM
     C                   Z-ADD     0             LDPCQT
     C                   WRITE     RDLOT
      ** ADD LOT BALANCE RECORD
     C                   MOVE      'A'           LRSTAT
     C                   MOVEL     ITEM          LRITEM
     C                   MOVEL     SIZE          LRSIZE
     C                   MOVEL     IMWHSE        LRWHSE
     C                   MOVEL     LOC           LRGLOC
     C                   MOVEL     LOC           LRCLOC
     C                   MOVEL     PHYTO         LRPHYT
     C                   MOVEL     PHYTO         LRCPHY
     C                   Z-ADD     0             LRCUST
     C                   Z-ADD     LDSOWD        LRSOWD
     C                   Z-ADD     LDCRDY        LRCRDY
     C                   Z-ADD     IMCOMP        LRCOMP
     C                   Z-ADD     LDQTOH        LRQTOH
     C                   Z-ADD     0             LRQTAL
     C                   Z-ADD     TDATE         LRDTLA
     C                   Z-ADD     TIMOD         LRTIME
     C                   MOVEL     USERID        LRUSER
     C**                   MOVELWSID      LRWSID
     C                   MOVEL     IMLOOK        LRALPH
     C                   MOVEL     IMPCL1        LRPRCL
     C                   WRITE     RDLOTRD
      ** ADD TRANSACTION RECORD
     C                   MOVEL     ITEM          FLITEM
     C                   MOVEL     SIZE          FLSIZE
     C                   MOVEL     IMWHSE        FLWHSE
     C                   Z-ADD     LDSOWD        FLSOWD
     C                   MOVEL     LOC           FLGLOC
     C                   MOVEL     PHYTO         FLPHYT
     C                   Z-ADD     IMCOMP        FLCOMP
     C                   Z-ADD     LDQTOH        FLQTY
     C                   Z-ADD     LDSOWN        FLSOWN
     C                   Z-ADD     RDATE         FLACTD
     C                   Z-ADD     TIMOD         FLTIME
     C                   MOVEL     USERID        FLUSER
     C                   MOVEL     WSID          FLWSID
     C                   MOVEL     'SOW'         FLREAS
     C                   WRITE     RLOTRN
     C     ENDADD        ENDSR
      **********************
      * CHANGE LOT RECORDS *
      **********************
     C     CHGLOT        BEGSR
     C                   SETOFF                                       717273
     C                   Z-ADD     0             SOWADJ
     C                   Z-ADD     0             AVAADJ
     C                   Z-ADD     0             NEWSOW
     C                   Z-ADD     0             NEWAVA
     C                   MOVE      *BLANKS       PCDESC
     C                   MOVE      *BLANKS       PCCODE
     C                   MOVE      *BLANKS       OREASN
     C     NXTCHG        TAG
     C   99              SETOFF                                       9871
     C                   WRITE     SCRNB2
     C                   Z-ADD     0             COUNT             2 0
     C                   READ      SCRNB2                                 90
     C   KC
     COR KG
     COR KF              GOTO      ENDCHG
     C                   SETOFF                                       0511
     C                   SETOFF                                       102030
     C                   SETOFF                                       99
      *
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
      ** CHECK REASON CODE
     C     PCCODE        CHAIN     FPRODCD                            05
     C   05              SETON                                        99
     C   05              MOVE      *BLANKS       PCDESC
     C   05              MOVE      *BLANKS       OREASN            3
     C   KX
     CANN99              EXSR      CHKDEL
     C   KX
     CANN99
     CAN 72              SETON                                        99
     C   KX
     CANN99
     CANN71              DO
     C                   SETON                                        71
     C                   GOTO      NXTCHG
     C                   ENDDO
      ** CHECK SOW ADJUSTMENT
     C     LDSOWN        ADD       SOWADJ        NEWSOW
     C     NEWSOW        IFLT      0
     C                   SETON                                        101199
     C                   Z-ADD     0             NEWSOW
     C                   Z-ADD     0             OLDSOW           11 1
     C                   END
      ** CHECK AVAILABLE ADJUSTMENT
     C     LDQTOH        ADD       AVAADJ        NEWAVA
     C     NEWAVA        IFLT      0
     C                   SETON                                        202199
     C                   Z-ADD     0             NEWAVA
     C                   Z-ADD     0             OLDAVA           11 1
     C                   END
     C   99              GOTO      NXTCHG
      ** CHECK FOR CHANGES
     C     PCCODE        IFNE      OREASN
     C                   ADD       1             COUNT
     C                   MOVEL     PCCODE        OREASN
     C                   END
     C     NEWSOW        IFNE      OLDSOW
     C                   ADD       1             COUNT
     C                   Z-ADD     NEWSOW        OLDSOW
     C                   END
     C     NEWAVA        IFNE      OLDAVA
     C                   ADD       1             COUNT
     C                   Z-ADD     NEWAVA        OLDAVA
     C                   END
     C     COUNT         IFGT      0
     C                   SETON                                        98
     C                   GOTO      NXTCHG
     C                   END
      *** UPDATE RECORDS
     C   KX              Z-SUB     LDQTOH        AVAADJ
     C   KX              MOVEL     'D'           LDSTAT
      ** UPDATE MINVT
     C     ITMKEY        CHAIN     FMINVT                             10
     C                   ADD       AVAADJ        IMQTOH
     C                   ADD       AVAADJ        IMQTAV
     C     IMQTOH        MULT      IMUCST        IMCSOH
     C                   UPDATE    RMINVT
      ** CHANGE LOT RECORD
     C                   ADD       AVAADJ        LDQTAV
     C                   ADD       AVAADJ        LDQTOH
     C                   ADD       AVAADJ        LDQTAJ
     C                   ADD       SOWADJ        LDSOWN
     C                   Z-ADD     TDATE         LDDTLA
     C                   Z-ADD     TIMOD         LDTIME
     C                   MOVEL     USERID        LDUSER
     C***                  MOVELWSID      LDWSID
     C                   MOVEL     IMLOOK        LDALPH
     C                   MOVEL     IMPCL1        LDPRCL
     C  NKX              UPDATE    RDLOT
     C   KX              DELETE    RDLOT
      ** ADD TRANSACTION RECORD
     C                   MOVEL     ITEM          FLITEM
     C                   MOVEL     SIZE          FLSIZE
     C                   MOVEL     IMWHSE        FLWHSE
     C                   Z-ADD     LDSOWD        FLSOWD
     C                   MOVEL     LDGLOC        FLGLOC
     C                   MOVEL     LDPHYT        FLPHYT
     C                   Z-ADD     IMCOMP        FLCOMP
     C                   Z-ADD     AVAADJ        FLQTY
     C                   Z-ADD     SOWADJ        FLSOWN
     C                   Z-ADD     RDATE         FLACTD
     C                   Z-ADD     TIMOD         FLTIME
     C                   MOVEL     USERID        FLUSER
     C                   MOVEL     WSID          FLWSID
     C                   MOVEL     PCCODE        FLREAS
     C  NKX              WRITE     RLOTRN
     C   KX              DELETE    RLOTRN
      * UPDATE LOT BALANCE FILE
     C                   MOVEL     ITEM          LRITEM
     C                   MOVEL     SIZE          LRSIZE
     C                   MOVEL     IMWHSE        LRWHSE
     C                   MOVEL     LOC           LRGLOC
     C                   MOVEL     LOC           LRCLOC
     C                   MOVEL     PHYTO         LRPHYT
     C                   MOVEL     PHYTO         LRCPHY
     C**                   MOVEL'A'       LRCODE
     C                   Z-ADD     0             LRCUST
     C                   Z-ADD     LDSOWD        LRSOWD
     C                   Z-ADD     LDCRDY        LRCRDY
     C                   Z-ADD     IMCOMP        LRCOMP
     C                   Z-ADD     LDQTOH        LRQTOH
     C                   Z-ADD     TDATE         LRDTLA
     C                   Z-ADD     TIMOD         LRTIME
     C                   MOVEL     USERID        LRUSER
     C**                   MOVELWSID      LRWSID
     C                   MOVEL     IMLOOK        LRALPH
     C                   MOVEL     IMPCL1        LRPRCL
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
     C     FDLKEY        CHAIN     FDLOTRD                            90
     C                   ADD       AVAADJ        LRQTOH
     C  NKX
     CAN 90              WRITE     RDLOTRD
     C  NKX
     CANN90              UPDATE    RDLOTRD
     C   KX
     CANN90              DELETE    RDLOTRD
     C     ENDCHG        ENDSR
      *******************
      * CHANGE COMMENTS *
      *******************
     C     CHGCOM        BEGSR
     C                   SETOFF                                       98
     C     NXTCOM        TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNB6
     C                   Z-ADD     0             COUNT             2 0
     C                   READ      SCRNB6                                 90
     C   KC
     COR KG
     COR KF              GOTO      ENDCOM
     C     LDSDLT        IFNE      OSDLT
     C                   MOVE      LDSDLT        OSDLT            10
     C                   ADD       1             COUNT
     C                   END
     C     LDDESC        IFNE      ODESC
     C                   MOVE      LDDESC        ODESC            30
     C                   ADD       1             COUNT
     C                   END
     C     LDAREA        IFNE      OAREA
     C                   MOVE      LDAREA        OAREA             6
     C                   ADD       1             COUNT
     C                   END
     C     COUNT         IFGT      0
     C                   SETON                                        98
     C                   GOTO      NXTCOM
     C                   END
      ** CHG RECORD
      **  LOT RECORD
     C                   Z-ADD     TDATE         LDDTLA
     C                   Z-ADD     TIMOD         LDTIME
     C                   MOVEL     USERID        LDUSER
     C***                  MOVELWSID      LDWSID
     C                   Z-ADD     0             LDGERM
     C                   Z-ADD     0             LDPCQT
     C                   UPDATE    RDLOT
     C     ENDCOM        ENDSR
      ********************
      * GET READY DATE   *
      ********************
     C     GETGRM        BEGSR
     C                   CALL      'GETRDY'
     C                   PARM                    ITEM
     C                   PARM                    SIZE
     C                   PARM                    IMWHSE
     C                   PARM                    SOWDAT
     C                   PARM                    REDDAT
     C     ENDGRM        ENDSR
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
     C                   SETOFF                                       808899
     C                   ENDSR
      *  **********
      *  * CHKDEL *
      *  **********
      *  IF ANY TRANSACTIONS EXCEPT "SOW" DO NOT ALLOW DELETION
     C     CHKDEL        BEGSR
     C     TRNKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C                   KFLD                    IMWHSE
     C                   KFLD                    LDSOWD
     C                   KFLD                    LOC
     C                   KFLD                    PHYTO
     C                   SETOFF                                       72
     C     TRNKEY        SETLL     FLOTRN
     C     NXTRY         TAG
     C     TRNKEY        READE     RLOTRN                                 90
     C   90              GOTO      ENDDEL
     C     FLREAS        IFNE      'SOW'
     C                   SETON                                        72
     C                   END
     C                   GOTO      NXTRY
     C     ENDDEL        TAG
     C     TRNKEY        SETLL     FLOTRN
     C     TRNKEY        READE     RLOTRN                                 90
     C                   ENDSR
      *  **********
      *  * CLRIT  *
      *  **********
     C     CLRIT         BEGSR
     C                   SETOFF                                       289911
     C                   MOVE      *BLANKS       OUTTYP
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       IDESC
     C                   MOVE      *BLANKS       PCCODE
     C                   MOVE      *BLANKS       PCDESC
     C                   MOVE      *BLANKS       PHYDES
     C                   MOVE      *BLANKS       SZDESC
     C                   MOVE      *BLANKS       PHYTO
     C                   MOVE      *BLANKS       LOC
     C                   MOVE      *BLANKS       WHDESC
     C                   Z-ADD     *ZEROS        OPTION
     C                   Z-ADD     *ZEROS        REDDAT
     C                   UNLOCK    FMINVT
     C                   UNLOCK    FDLOT
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
Enter Original Sow Information
    Change Sow Information
       Change Ready Date
   Change Available Quantity
   Transfer to Another Lot
      Change Lot Comment
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
000031059090120151181212243273304334
**  02 03 04 05 06 07 08 09 10 11 12   DAY OF YEAR FROM START OF MONTH.
000031059090120151181212243273304334365
