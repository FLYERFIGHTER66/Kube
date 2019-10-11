      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1996
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
      **PROGRAM NAME-------- LKSPRY
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EF
      **DESCRIPTION--------- APPLICATOR ASSIGNMENT
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFCHMAPP1  IF   E           K DISK
     FFMINVT    IF   E           K DISK
     F***FCHMTOT3IF  E           K        DISK
     FFCHMTOT4  IF   E           K DISK
     FFCHMSPY   IF   E           K DISK
     FLKNAMEFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      *
      ****************************************************************
      *
     C     INVKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C**
     C     TOTKEY        KLIST
     C***                  KFLD           CTSPRY
     C                   KFLD                    CTSPIT
     C                   KFLD                    CTPPM
     C**
     C     SPYKEY        KLIST
     C                   KFLD                    CSITEM
     C                   KFLD                    CSSIZE
     C                   KFLD                    CSPPM
     C**
     C     *ENTRY        PLIST
     C                   PARM                    CAITEM            8
     C                   PARM                    CAPPM             7 2
     C                   MOVE      CAITEM        HLDLOK            8
     C                   MOVE      CAITEM        VLOOK             8
     C                   MOVE      *BLANKS       OLDSRC            8
     C                   MOVE      '700'         SPSIZE            3
     C                   Z-ADD     0             LINE
     C     VLOOK         SETLL     FCHMAPP1
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      VLOOK         OLDSRC
     C     NXTX          TAG
     C                   SETOFF                                       50
     C                   READ      FCHMAPP1                               50
     C**
     C**    CHAIN TO GET DESCRIPTION OF CHEMICAL
     C**
     C                   MOVEL     CAITEM        IMITEM
     C                   MOVEL     SPSIZE        IMSIZE
     C     INVKEY        CHAIN     FMINVT                             92
     C**                   MOVELIMDES1    DESC    8
     C**
     C                   MOVEL     CAITEM        CTSPIT
     C                   MOVE      CAPPM         CTPPM
     C     TOTKEY        CHAIN     FCHMTOT4                           98
     C     *IN98         IFEQ      *OFF
     C                   MOVEL     CTGALS        GALS              5 2
     C                   MOVEL     CTPPM         PPM               7 2
     C                   MOVEL     CTTRAY        TRAYS             5 0
     C                   MOVEL     CTPOLE        POLES             5 0
     C                   MOVEL     CTSPRY        SPRAY             5
     C                   MOVEL     CTLOOK        DESC              8
     C                   MOVEL     CTSPIT        ITEM              8
     C                   END
     C**
     C                   MOVEL     CAITEM        CSITEM
     C                   MOVEL     SPSIZE        CSSIZE
     C                   MOVEL     CAPPM         CSPPM
     C     SPYKEY        CHAIN     FCHMSPY                            94
     C     *IN94         IFEQ      *OFF
     C*
     C**         CSXPL     MULT 55        WTRYS   50
     C**         CTTRAY    IFGT WTRYS
     C**                   MOVEL'BEAN'    SPRAY
     C**                   ELSE
     C**                   MOVEL'BOSS'    SPRAY   5
     C**                   END
     C                   END
     C*
     C                   MOVEL     CAAPP1        APP1              8
     C                   MOVEL     CAAPP2        APP2              8
     C**
     C   50              GOTO      DSPL
      *
     C                   ADD       1             RECNO
     C                   ADD       1             LINE
     C                   WRITE     RECSFL
     C                   GOTO      NXTX
      *
     C     DSPL          TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   Z-ADD     0             LINE
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *ZEROS        PPM
     C                   MOVE      *ZEROS        GALS
     C                   MOVE      *ZEROS        TRAYS
     C                   MOVE      *ZEROS        POLES
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       CAAPP1
     C                   MOVE      *BLANKS       CAAPP2
     C                   MOVE      *BLANKS       SPRAY
     C                   WRITE     RECSFL
     C                   ADD       1             RECNO
     C                   MOVEL     '* End '      ENDD             10
     C                   MOVE      'Data *'      ENDD
     C                   MOVEL     ENDD          WRKNAM           10
     C                   WRITE     RECSFL
      *
     C     NXTFMT        TAG
     C                   EXFMT     RECCTL
     C   KF              MOVEL     *BLANKS       CAITEM
 CAB C   KF              Z-ADD     *ZEROS        CAPPM
     C   KF              GOTO      END
     C     LINE#         IFEQ      0
     C                   GOTO      NXTFMT
     C                   END
     C     LINE#         IFGT      LSTREC
     C                   SETON                                        90
     C                   GOTO      NXTFMT
     C                   END
      ** GET THE SELECTED ITEM
     C                   Z-ADD     LINE#         RECNO
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTFMT
     C     END           TAG
     C                   SETON                                        LR
      **
