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
      **DESCRIPTION--------- SPRAYER LOOKUP
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFCHMSPY   IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FLKSPRYFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      *
      ****************************************************************
      *
     C     INVKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C**
     C     *ENTRY        PLIST
     C                   PARM                    CSITEM            8
     C                   PARM                    CSPPM             7 2
     C                   MOVE      CSITEM        HLDLOK            8
     C                   MOVE      CSITEM        VLOOK             8
     C                   MOVE      *BLANKS       OLDSRC            8
     C                   MOVE      '700'         SPSIZE            3
     C                   Z-ADD     0             LINE
     C     VLOOK         SETLL     FCHMSPY
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      VLOOK         OLDSRC
     C     NXTX          TAG
     C                   SETOFF                                       50
     C                   READ      FCHMSPY                                50
     C**
     C**    CHAIN TO GET DESCRIPTION OF CHEMICAL
     C**
     C                   MOVEL     CSITEM        IMITEM
     C                   MOVEL     SPSIZE        IMSIZE
     C     INVKEY        CHAIN     FMINVT                             92
     C                   MOVEL     IMDES1        DESC             10
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
     C                   MOVE      *BLANKS       CSITEM
     C                   MOVE      *ZEROS        CSPPM
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *ZEROS        CSXPL
     C                   WRITE     RECSFL
     C                   ADD       1             RECNO
     C                   MOVEL     '* End '      ENDD             10
     C                   MOVE      'Data *'      ENDD
     C                   MOVEL     ENDD          WRKNAM           10
     C                   WRITE     RECSFL
      *
     C     NXTFMT        TAG
     C                   EXFMT     RECCTL
     C   KF              MOVEL     *BLANKS       CSITEM
 CAB C   KF              Z-ADD     *ZEROS        CSPPM
 CAB C   KF              Z-ADD     *ZEROS        CSXPL
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
