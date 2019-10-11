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
      **PROGRAM NAME-------- SDR340
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- ITEMS WITH NO SEED COST
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FSDR340    O    F  080        PRINTER OFLIND(*INOF)
     FFMINVTAL  IF   E           K DISK
     FFMINSER   IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFSERIES   IF   E           K DISK
     FFSERPRC   IF   E           K DISK
     FFSEDCTL   IF   E           K DISK
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
      ****************
      *    LDA       *
      ****************
     D                UDS
     D  LCO                    1      2  0
     D  ALPHA                  3     17
     D  SIZE                  18     20
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
      *
      *
     IRSERPRC
     I              SPPRC1                      PRC(1)
     I              SPPRC2                      PRC(2)
     I              SPPRC3                      PRC(3)
      ****************
      *   START HERE *
      ****************
     C     SIZE          IFGT      *BLANKS
     C     SIZE          CHAIN     FMSIZE                             10
     C                   ELSE
     C                   MOVEL     '**ALL**'     SZDESC
     C                   END
     C                   MOVEL     ALPHA         IMLOOK
     C                   EXSR      GETALL
     C                   EXSR      BLDSFL
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      *********************
      * BUILD SUB FILE
      *********************
     C     BLDSFL        BEGSR
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
     C     IMTPSW        OREQ      'R'
     C     IMTPSW        OREQ      'P'
     C                   GOTO      NXTBLD
     C                   ENDIF
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
     C                   EXSR      GETCAL
     C     SEDCST        IFGT      0.0000
     C                   GOTO      NXTBLD
     C                   END
      ** WRITE THE SUB FILE
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE              1
     C                   PARM                    DESC             60
     C                   MOVEL     DESC          DESCO            30
     C                   MOVEL     IMITEM        ITEM              4
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    DETL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   ENDSR
      ********************
      ** GET CALCS      **
      ********************
     C     GETCAL        BEGSR
     C                   Z-ADD     0             SEDCST
     C                   MOVE      *BLANKS       OLIST             4
     C     IMITEM        CHAIN     FMINSER                            88
     C   88              MOVE      *BLANKS       ISCODE
     C  N88ISCODE        CHAIN     FSERIES                            88
     C   88              MOVE      *BLANKS       SEVND
     C   88              MOVE      *BLANKS       SECODE
     C   88              MOVE      *BLANKS       SEDESC
     C   88              MOVE      *BLANKS       SEFORM
     C     NEWVND        TAG
      ** GET VENDORS COST
     C     PRCKEY        KLIST
     C                   KFLD                    SEVND
     C                   KFLD                    SECODE
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
     C     #SED          MULT(H)   SSPRC         SEDCST            9 4
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
     C                   SETON                                        OF
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OSDR340    E            HEAD           1 03
     O                                            6 'SDR340'
     O                                           22 'Requested by:'
     O                       USERID              33
     O                                           57 'Items with No Seed Cost'
     O                       PAGE          Z     80
     O                                           70 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           70 'Time:'
     O                       TIMOD               80 '  :  :  '
     O          E            HEAD           0
     O                                           16 'Item Size'
     O                                           28 'Description'
     O***                                63 'Species/Variety'
     O                                           58 'Cross Ref.'
     O                                           66 'Form'
     O                                           70 'KP'
     O          E            HEAD           1
     O                                           20 '       _____________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           70 '__________'
     O          EF           DETL           1
     O                       ITEM                11
     O                       IMSIZE              16
     O                       DESCO               47
     O**                       SEDESC    78
     O                       ISCODE              58
     O                       SEFORM              64
     O                       IMSOWC              69
