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
      **PROGRAM NAME-------- LKITPC
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **DESCRIPTION--------- ITEM P.C. 1 SEARCH  ALL ITEMS
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 12/08/00 EFD ADD SIZE CODE TO INDEX
      *
     FFMINVTPS  IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     F                                     RENAME(RMINVT:MINVT)
     FLKITPCFM  CF   E             WORKSTN
     F                                     SFILE(ITMSFL:RECNO)
      * MESSAGE ARRAY
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)              MESSAGE
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
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    IMPCL1
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVE      IMLOOK        HLDLOK           15
     C                   MOVE      IMSIZE        HLDSIZ            3
     C                   MOVE      IMSIZE        NSIZE
     C                   MOVE      IMWHSE        HLDWHS            3
     C                   MOVE      IMWHSE        NWHSE
     C                   MOVE      IMPCL1        HLDPC             2
     C                   MOVE      IMPCL1        NEWPC
     C                   MOVE      IMLOOK        ALPHA
     C                   MOVE      *BLANKS       OLDSRC           15
     C                   MOVE      *ZEROS        *IN
      *  CHECK FOR FINAL END PROGRAM
     C     IMLOOK        IFGE      '99999999'
     C                   GOTO      ENDLR
     C                   END
      *
      ** GET DEPARTMENT
     C     SHPFR         CHAIN     FMDEPT                             50
     C     RSTRT         TAG
     C                   EXSR      GETALL
     C                   EXSR      BLDSFL
     C     NXTC          TAG
     C                   Z-ADD     0             LINE              5 0
     C                   Z-ADD     0             VLINE
     C                   EXFMT     ITMCTL
     C                   SETOFF                                       90
     C   KE              GOTO      RSTRT
     C   KF              DO
     C                   MOVE      *BLANKS       IMITEM
     C                   MOVE      *BLANKS       IMSIZE
     C                   GOTO      END
     C                   ENDDO
      ** SEE IF ON A SUBFILE LINE
     C     LINE          IFGT      0
     C     LINE          ANDLE     LSTLIN
     C     LINE          CHAIN     ITMSFL                             90
     C     MINKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
     C     MINKEY        CHAIN     FMINVT                             90
     C                   GOTO      END
     C                   ELSE
     C                   Z-ADD     0             LINE
     C                   END
      ** SEE IF LINE NUMBER ENTERED
     C     VLINE         IFGT      0
     C     VLINE         IFGT      LSTLIN
     C                   SETON                                        70
     C                   GOTO      NXTC
     C                   END
     C     VLINE         CHAIN     ITMSFL                             90
     C     MINKEY        CHAIN     FMINVT                             90
     C                   GOTO      END
     C                   END
      * SEE IF WE NEED SEARCH
     C                   MOVEL     NSIZE         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       NSIZE             3
     C                   CALL      'LKSIZE'
     C                   PARM                    NSIZE
     C                   PARM                    SZDESC           10
     C                   ENDIF
      *
     C                   MOVEL     NWHSE         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       NWHSE
     C                   CALL      'LKLOCA'
     C                   PARM                    NWHSE             3
     C                   PARM                    WHDESC           30
     C                   ENDIF
      *
     C                   MOVEL     NEWPC         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       NEWPC
     C                   MOVEL     PCPRCL        NEWPC
     C                   ENDIF
      ** SEE IF ALPHA CHANGED
     C     ALPHA         IFNE      IMLOOK
     C                   MOVEL     NSIZE         HLDSIZ
     C                   MOVEL     NEWPC         HLDPC
     C                   MOVEL     NWHSE         HLDWHS
     C                   MOVEL     ALPHA         IMLOOK
     C                   EXSR      GETALL
     C                   EXSR      BLDSFL
     C                   END
      ** SEE IF SIZE CHANGED
     C     NSIZE         IFNE      HLDSIZ
     C                   MOVEL     NSIZE         HLDSIZ
     C                   MOVEL     NEWPC         HLDPC
     C                   MOVEL     NWHSE         HLDWHS
     C                   EXSR      BLDSFL
     C                   END
      ** SEE IF WHSE CHANGED
     C     NWHSE         IFNE      HLDWHS
     C                   MOVEL     NWHSE         HLDWHS
     C                   MOVEL     NEWPC         HLDPC
     C                   EXSR      BLDSFL
     C                   END
      ** SEE IF P.C. CHANGED
     C     NEWPC         IFNE      HLDPC
     C                   MOVEL     NEWPC         HLDPC
     C                   EXSR      BLDSFL
     C                   END
     C                   GOTO      NXTC
      *** END PROGRAM
     C     END           TAG
     C                   MOVEA     '0'           *IN
     C                   RETURN
     C     ENDLR         TAG
     C                   SETON                                        LR
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
      *********************
      * BUILD SUB FILE
      *********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     ITMCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C     IMKEY         KLIST
     C                   KFLD                    HLDPC
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMLOOK
     C     IMKEY         SETLL     FMINVTPS
     C     NXTBLD        TAG
     C     HLDPC         READE     FMINVTPS                               90
     C   90              GOTO      ENDBLD
     C     HLDSIZ        IFGT      *BLANKS
     C     IMSIZE        ANDNE     HLDSIZ
     C                   GOTO      NXTBLD
     C                   END
     C     HLDWHS        IFGT      *BLANKS
     C     IMWHSE        ANDNE     HLDWHS
     C                   GOTO      NXTBLD
     C                   END
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
     C                   Z-ADD     IMQTOH        QTYOH
     C     IMQTOH        SUB       IMQTAL        QTYAV
     C                   MOVEL     'R'           TYPE
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE              1
     C                   PARM                    DESC             60
     C                   MOVEL     DESC          DESCO
     C                   ADD       1             RECNO
     C                   Z-ADD     RECNO         LINE#
     C                   Z-ADD     RECNO         LSTLIN            5 0
     C                   WRITE     ITMSFL
     C   16RECNO         IFLT      2000
     C                   GOTO      NXTBLD
     C                   END
     C  N16              GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     0             QTYOH
     C                   Z-ADD     0             QTYAV
     C                   Z-ADD     0             LINE#
     C                   MOVE      *BLANKS       IMITEM
     C                   MOVE      *BLANKS       IMSIZE
     C                   MOVE      *BLANKS       IMWHSE
     C                   MOVE      *BLANKS       DESCO
     C                   MOVEL     MSG(1)        DESCO
     C                   ADD       1             RECNO
     C                   WRITE     ITMSFL
     C                   ENDSR
** MESSAGE
  **** End of Data ****
