      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      **PROGRAM NAME-------- SDR260
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- ITEM COST/PRICE INQUIRY
      *?                                                              ?
      *? |?  Edit Log                                                ?|
      *? |                                                           ?|
      *? |WJB10/26/05?-CHANGED TO USE $ITEMCOST PROGRAM           ?|
      *? |   mm/dd/yy?-                                           ?|
      *?|                                                            |?
      *
      *
     FSDR262FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFMINVTAL  IF   E           K DISK
     FFMINSER   IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFLISTCD   IF   E           K DISK
     FFTCOST    IF   E           K DISK
     FFSERIES   IF   E           K DISK
     FFSERPRC   IF   E           K DISK
     FFSEDCTL   IF   E           K DISK
     FFMVEND    IF   E           K DISK
      *
      * PRICE ARRAY
     D PRC             S              9  4 DIM(3)                               PRICES
      * ALPHA ARRAY
     D ALP             S              1    DIM(15)                              ALPHA SEARCH
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
      *
     D #TotCst         S              9S 4
     D #NetPrc         S              7S 2
     D #Margin         S              7S 2
      *
     IRSERPRC
     I              SPPRC1                      PRC(1)
     I              SPPRC2                      PRC(2)
     I              SPPRC3                      PRC(3)
      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
      ****************
      *   START HERE *
      ****************
     C     RSTART        TAG
     C                   MOVE      *BLANKS       ALPHA
     C                   MOVE      *BLANKS       SIZE
     C                   SETOFF                                       1011
     C     NXTA          TAG                                                                   ARC38
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              GOTO      END
     C                   SETOFF                                       10
      ** CHECK SIZE CODE
     C     1             SUBST     SIZE:1        VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       SIZE
     C                   MOVEL     SZCODE        SIZE
     C                   GOTO      NXTA
     C                   ENDIF
     C     SIZE          IFGT      *BLANKS
     C     SIZE          CHAIN     FMSIZE                             10
     C   10              GOTO      NXTA
     C                   END
      ******************
      * OUTPUT SUBFILE *
      ******************
     C**                   MOVELNSIZE     HLDSIZ
     C                   MOVEL     ALPHA         IMLOOK
     C                   EXSR      GETALL
     C                   EXSR      BLDSFL
     C     NXTSFL        TAG
     C                   EXFMT     RECCTL
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              GOTO      END
     C                   GOTO      NXTA
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      *********************
      * BUILD SUB FILE
      *********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     RECCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C     IMLOOK        SETLL     FMINVTAL
     C     NXTBLD        TAG
     C                   READ      FMINVTAL                               90
     C   90              GOTO      ENDBLD
     C     SIZE          IFGT      *BLANKS
     C     IMSIZE        ANDNE     SIZE
     C                   GOTO      NXTBLD
     C                   END
     C     IMSTAT        IFEQ      'D'
     C     IMLOTC        ORNE      'Y'
     C                   GOTO      NXTBLD
     C                   ENDIF
     C*          HLDWHS    IFGT *BLANKS
     C*          IMWHSE    ANDNEHLDWHS
     C*                    GOTO NXTBLD
     C*                    END
      ** NO ALPHA ENTERED DISPLAY RECORD
     C   16              GOTO      ALOK
      ** NOW CHECK REST OF FIELDS
     C   01              DO
     C                   MOVEL     IMLOOK        TST1              1
     C     TST1          IFEQ      ALC1
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   02              DO
     C                   MOVEL     IMLOOK        TST2              2
     C     TST2          IFEQ      ALC2
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   03              DO
     C                   MOVEL     IMLOOK        TST3              3
     C     TST3          IFEQ      ALC3
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   04              DO
     C                   MOVEL     IMLOOK        TST4              4
     C     TST4          IFEQ      ALC4
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   05              DO
     C                   MOVEL     IMLOOK        TST5              5
     C     TST5          IFEQ      ALC5
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   06              DO
     C                   MOVEL     IMLOOK        TST6              6
     C     TST6          IFEQ      ALC6
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   07              DO
     C                   MOVEL     IMLOOK        TST7              7
     C     TST7          IFEQ      ALC7
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   08              DO
     C                   MOVEL     IMLOOK        TST8              8
     C     TST8          IFEQ      ALC8
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   09              DO
     C                   MOVEL     IMLOOK        TST9              9
     C     TST9          IFEQ      ALC9
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   10              DO
     C                   MOVEL     IMLOOK        TST10            10
     C     TST10         IFEQ      ALC10
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   11              DO
     C                   MOVEL     IMLOOK        TST11            11
     C     TST11         IFEQ      ALC11
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   12              DO
     C                   MOVEL     IMLOOK        TST12            12
     C     TST12         IFEQ      ALC12
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   13              DO
     C                   MOVEL     IMLOOK        TST13            13
     C     TST13         IFEQ      ALC13
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   14              DO
     C                   MOVEL     IMLOOK        TST14            14
     C     TST14         IFEQ      ALC14
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   15              DO
     C                   MOVEL     IMLOOK        TST15            15
     C     TST15         IFEQ      ALC15
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C                   GOTO      ENDBLD
     C     ALOK          TAG
      ** WRITE THE SUB FILE
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE              1
     C                   PARM                    DESC             60
     C                   MOVEL     DESC          DESCO            30
     C                   ADD       1             RECNO
     C                   MOVEL     IMITEM        ITEM
     C                   EXSR      GETCAL
     C                   WRITE     RECSFL
     C   16RECNO         IFLT      5000
     C                   GOTO      NXTBLD
     C                   END
     C  N16              GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   ENDSR
      ********************
      ** GET CALCS      **
      ********************
     C     GETCAL        BEGSR
     C                   Z-ADD     0             OLDPRC            9 4
     C                   MOVE      *BLANKS       OLIST             4
     C     IMITEM        CHAIN     FMINSER                            88
     C  N88ISCODE        CHAIN     FSERIES                            88
     C     NEWVND        TAG
      ** GET VENDORS COST
     C     PRCKEY        KLIST
     C                   KFLD                    SEVND
     C                   KFLD                    SECODE
     C     SEVND         CHAIN     FMVEND                             87
     C   87              MOVE      *BLANKS       VNAME
     C  N87              MOVEL     VMNAME        VNAME
      ** SEE IF TRANSPLANT FROM
     C                   SETOFF                                       25
     C     IMTPSW        IFEQ      'P'
     C     IMFRSZ        ANDGT     *BLANKS
     C                   Z-ADD     0             PLGCST
     C                   CALL      'SDRTXP'
     C                   PARM                    IMITEM
     C                   PARM                    IMFRSZ
     C                   PARM                    PLGCST            9 6
     C                   MOVE      *BLANKS       VNAME
     C                   MOVEL     'Transpla'    WRK16            16
     C                   MOVE      'nt From '    WRK16
     C                   MOVEL     WRK16         VNAME
     C                   MOVE      IMFRSZ        VNAME
     C                   Z-ADD     PLGCST        SSPRC
     C                   SETON                                        25
     C                   GOTO      NOSERI
     C                   END
     C     PRCKEY        CHAIN     FSERPRC                            87
     C   87              DO
     C                   Z-ADD     0             PRC
     C                   Z-ADD     0             SSPRC             7 6
     C                   GOTO      NOSERI
     C                   ENDDO
      ** GET PRICE EACH
     C     PRC(SEFORM)   DIV(H)    1000          SSPRC
     C**                   Z-ADDPRC,SEFORMSELSPR
     C     NOSERI        TAG
     C     IMSIZE        CHAIN     FMSIZE                             90
     C     SZCELL        MULT      IM#SED        #SED              4 0
     C     #SED          MULT(H)   SSPRC         SEDCST
      ** GET FIXED COST
     C                   Z-ADD     0             FIXCST
     C     TCSKEY        KLIST
     C                   KFLD                    ITEMB
     C                   KFLD                    IMSIZE
     C                   KFLD                    TSOW
     C                   MOVE      *BLANKS       ITEMB            12
     C                   MOVEL     IMTPSW        TSOW              1
     C     RTRY          TAG
     C     TCSKEY        SETLL     FTCOST
     C     NXTCST        TAG
     C     TCSKEY        READE     FTCOST                                 90
     C   90              DO
     C     FIXCST        IFEQ      0
     C     TSOW          ANDGT     *BLANKS
     C                   MOVE      *BLANKS       TSOW
     C                   GOTO      RTRY
     C                   ENDIF
     C                   ENDDO
     C  N90              DO
     C     TCQTY         MULT(H)   TCUCST        WRKCST            9 4
     C                   ADD       WRKCST        FIXCST
     C                   GOTO      NXTCST
     C                   ENDDO
     C     SEDCST        ADD       FIXCST        TOTCST
      ** GET PRICE
     C     IMLIST        IFGT      *BLANKS
     C     IMLIST        CHAIN     FLISTCD                            51
     C                   Z-ADD     LCSEL5        UPRICE
     C                   ELSE
     C                   Z-ADD     IMSEL5        UPRICE
     C                   END
      ** CALC TRADE DISCOUNT
     C**         SZDISC    DIV  100       TRWRK   86
     C**         UPRICE    MULT TRWRK     TRDSC     H
     C     UPRICE        IFGT      0.0000
     C*    UPRICE        MULT(H)   .2000         TRDSC
     C     UPRICE        MULT(H)   .2300         TRDSC
     C     UPRICE        SUB       TRDSC         NETPRC
     C     NETPRC        SUB(H)    TOTCST        MARGIN                 55
     C     MARGIN        DIV(H)    NETPRC        MARWRK            9 6
     C     MARWRK        MULT      100           MARPCT            9 4
     C                   ELSE
     C                   Z-ADD     0             TRDSC
     C                   Z-ADD     0             NETPRC
     C                   Z-ADD     0             MARGIN
     C                   Z-ADD     0             MARPCT
     C                   END
WJB  C                   Eval      TotCst = 0                                   ?Total Cost
WJB  C                   Eval      NetPrc = 0                                   ?Net Price
WJB  C                   Eval      Margin = 0                                   ?Profit Margin
WJB  C                   Call      '$ITEMCOST'
WJB ?C                   Parm                    IMITEM                         ?Item
WJB ?C                   Parm                    IMSIZE                         ?Size
WJB ?C                   Parm                    #TotCst                        ?Total Cost
WJB ?C                   Parm                    #NetPrc                        ?Net Price
WJB ?C                   Parm                    #Margin                        ?Profit Margin
WJB  C                   Eval      TotCst = #TotCst                             ?Total Cost
WJB  C                   Eval      NetPrc = #NetPrc                             ?Net Price
WJB  C                   Eval      Margin = #Margin                             ?Profit Margin
WJB  C     MARGIN        DIV(H)    NETPRC        MARWRK            9 6
WJB  C     MARWRK        MULT      100           MARPCT            9 4
     C                   ENDSR
      *********************
      * GET ALPHA LENGTH
      *********************
      ** GET ALPHA SEARCH COMPARE CHAR
     C     GETALL        BEGSR
     C                   MOVE      *BLANKS       ALC15
     C                   MOVE      *BLANKS       ALC14
     C                   MOVE      *BLANKS       ALC13
     C                   MOVE      *BLANKS       ALC12
     C                   MOVE      *BLANKS       ALC11
     C                   MOVE      *BLANKS       ALC10
     C                   MOVE      *BLANKS       ALC9
     C                   MOVE      *BLANKS       ALC8
     C                   MOVE      *BLANKS       ALC7
     C                   MOVE      *BLANKS       ALC6
     C                   MOVE      *BLANKS       ALC5
     C                   MOVE      *BLANKS       ALC4
     C                   MOVE      *BLANKS       ALC3
     C                   MOVE      *BLANKS       ALC2
     C                   MOVE      *BLANKS       ALC1
     C                   SETOFF                                       010203
     C                   SETOFF                                       040506
     C                   SETOFF                                       070809
     C                   SETOFF                                       101213
     C                   SETOFF                                       141516
     C     ALPHA         IFGT      *BLANKS
     C                   MOVEA     ALPHA         ALP
     C     ALP(15)       IFGT      *BLANKS
     C                   MOVEL     ALPHA         ALC15            15
     C                   SETON                                        15
     C                   GOTO      ENDALP
     C                   END
     C     ALP(14)       IFGT      *BLANKS
     C                   MOVEL     ALPHA         ALC14            14
     C                   SETON                                        14
     C                   GOTO      ENDALP
     C                   END
     C     ALP(13)       IFGT      *BLANKS
     C                   MOVEL     ALPHA         ALC13            13
     C                   SETON                                        13
     C                   GOTO      ENDALP
     C                   END
     C     ALP(12)       IFGT      *BLANKS
     C                   MOVEL     ALPHA         ALC12            12
     C                   SETON                                        12
     C                   GOTO      ENDALP
     C                   END
     C     ALP(11)       IFGT      *BLANKS
     C                   MOVEL     ALPHA         ALC11            11
     C                   SETON                                        11
     C                   GOTO      ENDALP
     C                   END
     C     ALP(10)       IFGT      *BLANKS
     C                   MOVEL     ALPHA         ALC10            10
     C                   SETON                                        10
     C                   GOTO      ENDALP
     C                   END
     C     ALP(9)        IFGT      *BLANKS
     C                   MOVEL     ALPHA         ALC9              9
     C                   SETON                                        09
     C                   GOTO      ENDALP
     C                   END
     C     ALP(8)        IFGT      *BLANKS
     C                   MOVEL     ALPHA         ALC8              8
     C                   SETON                                        08
     C                   GOTO      ENDALP
     C                   END
     C     ALP(7)        IFGT      *BLANKS
     C                   MOVEL     ALPHA         ALC7              7
     C                   SETON                                        07
     C                   GOTO      ENDALP
     C                   END
     C     ALP(6)        IFGT      *BLANKS
     C                   MOVEL     ALPHA         ALC6              6
     C                   SETON                                        06
     C                   GOTO      ENDALP
     C                   END
     C     ALP(5)        IFGT      *BLANKS
     C                   MOVEL     ALPHA         ALC5              5
     C                   SETON                                        05
     C                   GOTO      ENDALP
     C                   END
     C     ALP(4)        IFGT      *BLANKS
     C                   MOVEL     ALPHA         ALC4              4
     C                   SETON                                        04
     C                   GOTO      ENDALP
     C                   END
     C     ALP(3)        IFGT      *BLANKS
     C                   MOVEL     ALPHA         ALC3              3
     C                   SETON                                        03
     C                   GOTO      ENDALP
     C                   END
     C     ALP(2)        IFGT      *BLANKS
     C                   MOVEL     ALPHA         ALC2              2
     C                   SETON                                        02
     C                   GOTO      ENDALP
     C                   END
     C     ALP(1)        IFGT      *BLANKS
     C                   MOVEL     ALPHA         ALC1              1
     C                   SETON                                        01
     C                   GOTO      ENDALP
     C                   END
      ** IF ALPHA BLANK SETON 16
     C                   ELSE
     C                   SETON                                        16
     C     ENDALP        TAG
     C                   END
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     01            CHAIN     FSEDCTL                            90
     C                   ENDSR
