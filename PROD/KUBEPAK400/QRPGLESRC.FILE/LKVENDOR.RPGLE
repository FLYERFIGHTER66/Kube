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
      *PROGRAM NAME-------- LKVENDOR
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- VENDOR LOOKUP
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 4/12/01 BLANK OUT ADDR ON END DATA LINE
      *
      *
     FFMVENDAL  IF   E           K DISK
     FLKVENDFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      *
      * ALPHA ARRAY
     D ALP             S              1    DIM(15)                              ALPHA SEARCH
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP            2 0
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVE      VMLOOK        HLDLOK           15
     C                   MOVE      VMLOOK        VLOOK            15
     C                   MOVE      *BLANKS       OLDSRC           15
     C                   MOVE      *BLANKS       VMVEND
     C                   MOVE      *BLANKS       VMNAME
      *  CHECK FOR FINAL END PROGRAM
     C     VMLOOK        IFGE      '99999999'
     C                   GOTO      ENDLR
     C                   END
      *
     C     RSTRT         TAG
     C                   EXSR      GETALL
     C                   EXSR      BLDSFL
     C                   Z-ADD     0             VLINE
     C                   Z-ADD     0             LINE#
     C     NXTFMT        TAG
     C                   Z-ADD     0             LINE#
     C                   Z-ADD     0             LINE
     C                   EXFMT     RECCTL
     C                   SETOFF                                       90
     C   KF              DO
     C                   MOVE      *BLANKS       VMNAME
     C                   MOVE      *BLANKS       VMCITY
     C                   MOVE      *BLANKS       VMSTST
     C                   Z-ADD     0             VMVEND
     C                   Z-ADD     0             VMCONM
     C                   GOTO      END
     C                   ENDDO
      * SEE IF ON A SUBFILE LINE
     C     LINE          IFGT      0
     C     LINE          ANDLE     LSTREC
     C     LINE          CHAIN     RECSFL                             90
     C   90              GOTO      NXTFMT
     C                   GOTO      END
     C                   ELSE
     C                   Z-ADD     0             LINE
     C                   END
     C     LINE#         IFGT      LSTREC
     C                   SETON                                        90
     C                   GOTO      NXTFMT
     C                   END
     C     VLOOK         IFNE      OLDSRC
     C                   GOTO      RSTRT
     C                   END
     C     LINE#         IFEQ      0
     C                   GOTO      NXTFMT
     C                   END
      *
      * GET THE SELECTED ITEM
      *
     C                   Z-ADD     LINE#         RECNO
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTFMT
     C     END           TAG
     C                   RETURN
     C     ENDLR         TAG
     C                   SETON                                        LR
      ****************
      * BLD SUB FILE *
      ****************
     C     BLDSFL        BEGSR
     C     VLOOK         SETLL     FMVENDAL
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             LINE#
     C                   Z-ADD     0             VLINE
     C                   MOVE      VLOOK         OLDSRC
     C     NXTX          TAG
     C                   SETOFF                                       50
     C                   READ      FMVENDAL                               50
     C   50              GOTO      DSPL
     C     VMSTAT        IFEQ      'D'
     C                   GOTO      NXTX
     C                   ENDIF
     C                   MOVEL     VMADD2        ADDR             15
     C                   MOVEL     VMCITY        CITY             12
      ** NO ALPHA ENTERED DISPLAY RECORD
     C   16              GOTO      ALOK
      ** NOW CHECK REST OF FIELDS
     C   01              DO
     C                   MOVEL     VMLOOK        TST1              1
     C     TST1          IFEQ      ALC1
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   02              DO
     C                   MOVEL     VMLOOK        TST2              2
     C     TST2          IFEQ      ALC2
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   03              DO
     C                   MOVEL     VMLOOK        TST3              3
     C     TST3          IFEQ      ALC3
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   04              DO
     C                   MOVEL     VMLOOK        TST4              4
     C     TST4          IFEQ      ALC4
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   05              DO
     C                   MOVEL     VMLOOK        TST5              5
     C     TST5          IFEQ      ALC5
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   06              DO
     C                   MOVEL     VMLOOK        TST6              6
     C     TST6          IFEQ      ALC6
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   07              DO
     C                   MOVEL     VMLOOK        TST7              7
     C     TST7          IFEQ      ALC7
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   08              DO
     C                   MOVEL     VMLOOK        TST8              8
     C     TST8          IFEQ      ALC8
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   09              DO
     C                   MOVEL     VMLOOK        TST9              9
     C     TST9          IFEQ      ALC9
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   10              DO
     C                   MOVEL     VMLOOK        TST10            10
     C     TST10         IFEQ      ALC10
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   11              DO
     C                   MOVEL     VMLOOK        TST11            11
     C     TST11         IFEQ      ALC11
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   12              DO
     C                   MOVEL     VMLOOK        TST12            12
     C     TST12         IFEQ      ALC12
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   13              DO
     C                   MOVEL     VMLOOK        TST13            13
     C     TST13         IFEQ      ALC13
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   14              DO
     C                   MOVEL     VMLOOK        TST14            14
     C     TST14         IFEQ      ALC14
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   15              DO
     C                   MOVEL     VMLOOK        TST15            15
     C     TST15         IFEQ      ALC15
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C                   GOTO      DSPL
     C     ALOK          TAG
      *
     C                   ADD       1             RECNO
     C                   ADD       1             VLINE
     C                   WRITE     RECSFL
     C                   GOTO      NXTX
      *
     C     DSPL          TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       2             RECNO
     C                   Z-ADD     0             VLINE
     C                   MOVEL     *BLANKS       VMNAME
     C                   MOVEL     '* End of'    ENDFLD           16
     C                   MOVE      ' Data * '    ENDFLD
     C                   MOVEL     ENDFLD        VMNAME
EFD01C                   MOVEL     *BLANKS       ADDR
     C                   Z-ADD     0             VMCONM
     C                   Z-ADD     0             VMVEND
     C                   MOVEL     *BLANKS       CITY
     C                   MOVEL     *BLANKS       VMSTST
     C                   WRITE     RECSFL
     C                   ENDSR
      *
      *********************
      * GET ALPHA LENGTH
      *********************
      * GET ALPHA SEARCH COMPARE CHAR
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
     C     VLOOK         IFGT      *BLANKS
     C                   MOVEA     VLOOK         ALP
     C     ALP(15)       IFGT      *BLANKS
     C                   MOVEL     VLOOK         ALC15            15
     C                   SETON                                        15
     C                   GOTO      ENDALP
     C                   END
     C     ALP(14)       IFGT      *BLANKS
     C                   MOVEL     VLOOK         ALC14            14
     C                   SETON                                        14
     C                   GOTO      ENDALP
     C                   END
     C     ALP(13)       IFGT      *BLANKS
     C                   MOVEL     VLOOK         ALC13            13
     C                   SETON                                        13
     C                   GOTO      ENDALP
     C                   END
     C     ALP(12)       IFGT      *BLANKS
     C                   MOVEL     VLOOK         ALC12            12
     C                   SETON                                        12
     C                   GOTO      ENDALP
     C                   END
     C     ALP(11)       IFGT      *BLANKS
     C                   MOVEL     VLOOK         ALC11            11
     C                   SETON                                        11
     C                   GOTO      ENDALP
     C                   END
     C     ALP(10)       IFGT      *BLANKS
     C                   MOVEL     VLOOK         ALC10            10
     C                   SETON                                        10
     C                   GOTO      ENDALP
     C                   END
     C     ALP(9)        IFGT      *BLANKS
     C                   MOVEL     VLOOK         ALC9              9
     C                   SETON                                        09
     C                   GOTO      ENDALP
     C                   END
     C     ALP(8)        IFGT      *BLANKS
     C                   MOVEL     VLOOK         ALC8              8
     C                   SETON                                        08
     C                   GOTO      ENDALP
     C                   END
     C     ALP(7)        IFGT      *BLANKS
     C                   MOVEL     VLOOK         ALC7              7
     C                   SETON                                        07
     C                   GOTO      ENDALP
     C                   END
     C     ALP(6)        IFGT      *BLANKS
     C                   MOVEL     VLOOK         ALC6              6
     C                   SETON                                        06
     C                   GOTO      ENDALP
     C                   END
     C     ALP(5)        IFGT      *BLANKS
     C                   MOVEL     VLOOK         ALC5              5
     C                   SETON                                        05
     C                   GOTO      ENDALP
     C                   END
     C     ALP(4)        IFGT      *BLANKS
     C                   MOVEL     VLOOK         ALC4              4
     C                   SETON                                        04
     C                   GOTO      ENDALP
     C                   END
     C     ALP(3)        IFGT      *BLANKS
     C                   MOVEL     VLOOK         ALC3              3
     C                   SETON                                        03
     C                   GOTO      ENDALP
     C                   END
     C     ALP(2)        IFGT      *BLANKS
     C                   MOVEL     VLOOK         ALC2              2
     C                   SETON                                        02
     C                   GOTO      ENDALP
     C                   END
     C     ALP(1)        IFGT      *BLANKS
     C                   MOVEL     VLOOK         ALC1              1
     C                   SETON                                        01
     C                   GOTO      ENDALP
     C                   END
      ** IF ALPHA BLANK SETON 16
     C                   ELSE
     C                   SETON                                        16
     C     ENDALP        TAG
     C                   END
     C                   ENDSR
