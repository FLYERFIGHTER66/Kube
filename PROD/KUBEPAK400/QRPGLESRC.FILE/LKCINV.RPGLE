      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1997
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
      **PROGRAM NAME-------- LKCINV
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- GD
      **DESCRIPTION--------- CUSTOMER INVOICE LOOKUP
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFHORDWCR  IF   E           K DISK
     FFHORCWI   IF   E           K DISK
     FLKCINVFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    WHBLCU            6 0
     C                   PARM                    WHCOMP            2 0
     C                   PARM                    WHINV#            6 0
     C                   PARM                    TYP               2
     C                   MOVE      WHBLCU        HLDLOK            6 0
     C                   MOVE      WHBLCU        VLOOK             6 0
     C                   Z-ADD     0             OLDSRC            6 0
     C                   MOVE      *BLANKS       TYP
      *
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             VLINE
     C     VLOOK         SETLL     FHORDWCR
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      VLOOK         OLDSRC
     C     NXTX          TAG
     C                   SETOFF                                       50
     C     VLOOK         READE     FHORDWCR                               50
     C   50              GOTO      DSPL
      *
     C                   SETOFF                                       21        RI CRMEMO
     C                   Z-ADD     0             CHCRM#
     C                   MOVE      *BLANKS       TYPE
     C                   MOVEL     WHNAME        SHIPTO
     C                   ADD       1             RECNO
     C                   ADD       1             VLINE
     C                   WRITE     RECSFL
     C                   EXSR      GETCRD
     C                   GOTO      NXTX
      *
     C     DSPL          TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       2             RECNO
     C                   Z-ADD     0             VLINE
     C                   Z-ADD     *ZEROS        WHCOMP
     C                   Z-ADD     *ZEROS        WHBLCU
     C                   Z-ADD     *ZEROS        WHINV#
     C                   Z-ADD     *ZEROS        WHINDT
     C                   Z-ADD     *ZEROS        WH$AMT
     C                   MOVEL     *BLANKS       WHPOS
     C                   MOVEL     *BLANKS       WHSHFR
     C                   MOVEL     *BLANKS       SHIPTO
     C                   WRITE     RECSFL
      *
     C     NXTFMT        TAG
     C                   Z-ADD     0             LINE#
     C                   Z-ADD     0             LINE
     C                   EXFMT     RECCTL
     C   KF              MOVE      *BLANKS       WHPOS
     C   KF              Z-ADD     *ZEROS        WHCOMP
     C   KF              Z-ADD     *ZEROS        WHBLCU
     C   KF              Z-ADD     *ZEROS        WHINV#
     C   KF              Z-ADD     *ZEROS        WH$AMT
     C   KF              Z-ADD     *ZEROS        WHINDT
     C   KF              GOTO      END
      ** SEE IF ON A SUBFILE LINE
     C     LINE          IFGT      0
     C     LINE          ANDLE     LSTREC
     C     LINE          CHAIN     RECSFL                             90
     C   90              GOTO      NXTFMT
     C     TYPE          IFEQ      'Credit'
     C                   MOVEL     'CM'          TYP
     C                   Z-ADD     CHCRM#        WHINV#
     C                   ELSE
     C                   MOVEL     'IN'          TYP
     C                   END
     C                   GOTO      END
     C                   ELSE
     C                   Z-ADD     0             LINE
     C                   END
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
     C     TYPE          IFEQ      'Credit'
     C                   MOVEL     'CM'          TYP
     C                   Z-ADD     CHCRM#        WHINV#
     C                   ELSE
     C                   MOVEL     'IN'          TYP
     C                   END
     C     END           TAG
     C                   SETON                                        LR
      ********************
      * GET CREDIT MEMOS *
      ********************
     C     GETCRD        BEGSR
     C     CRDKEY        KLIST
     C                   KFLD                    WHBLCU
     C                   KFLD                    HLDINV
     C                   Z-ADD     WHINV#        HLDINV            6 0
     C                   Z-ADD     0             WHINV#
     C                   SETON                                        21
     C                   MOVEL     'Credit'      TYPE
     C     CRDKEY        SETLL     FHORCWI
     C     NXTCRD        TAG
     C     CRDKEY        READE     FHORCWI                                90
     C   90              GOTO      ENDCRD
     C                   Z-ADD     CHDTOR        WHINDT
     C                   Z-ADD     CHTOT$        WH$AMT
     C                   MOVEL     CHPOS         WHPOS
     C                   MOVEL     CHSHFR        WHSHFR
     C                   MOVEL     CHNAME        SHIPTO
     C                   ADD       1             RECNO
     C                   ADD       1             VLINE
     C                   WRITE     RECSFL
     C                   GOTO      NXTCRD
     C     ENDCRD        TAG
     C                   Z-ADD     HLDINV        WHINV#
     C                   SETOFF                                       21
     C                   MOVE      *BLANKS       TYPE
     C                   ENDSR
