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
      *PROGRAM NAME-------- FXSOWSCH
      *SYSTEM-------------- INVENTORY
      *APPLICATION--------- FIX SOWSCH - CHANGE FOR EACH FIX
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFSOWSCHJ  UF   E           K DISK
     FFTRAY     UF   E           K DISK
     FFBADTR    UF   E           K DISK
      *
      ** GET NEXT RECORD
     C                   Z-ADD     1020128       SOWDAT            7 0
     C                   Z-ADD     110           BJOB#             4 0
     C                   Z-ADD     115           EJOB#             4 0
     C                   Z-ADD     0             OJOB#             4 0
     C                   Z-ADD     0             SOWN              9 0
     C                   Z-ADD     85719         BTRAY             8 0
     C                   Z-ADD     85725         ETRAY             8 0
     C     TRYKEY        KLIST
     C                   KFLD                    SOWDAT
     C                   KFLD                    BJOB#
     C**         BTRAY     SETLLFTRAY
     C     NXT           TAG
     C                   READ      FBADTR                                 90
     C   90              GOTO      END
     C*          TRTAG#    IFGT ETRAY
     C*                    GOTO END
     C*                    END
     C     BTTAG#        CHAIN     FTRAY                              71
     C                   MOVE      *BLANKS       TRREAS
     C                   MOVEL     'A'           TRSTAT
     C**N71                UPDATRTRAY
     C  N71              DELETE    RTRAY
     C     TRJOB#        IFNE      OJOB#
     C     OJOB#         ANDGT     0
     C     SOWKEY        KLIST
     C                   KFLD                    SOWDAT
     C                   KFLD                    OJOB#
     C     SOWKEY        CHAIN     FSOWSCHJ                           90
     C  N90              DO
     C                   Z-ADD     0             SOSOWQ
     C                   Z-ADD     0             SOSOWL
     C                   MOVEL     'A'           SOSTAT
     C                   UPDATE    RSOWSCH
     C                   Z-ADD     0             QTY               6 0
     C                   ENDDO
     C                   END
     C                   ADD       1             QTY
     C                   Z-ADD     TRJOB#        OJOB#
     C**         TRJOB#    IFGT EJOB#
     C**                   GOTO END
     C**                   END
     C                   DELETE    RBADTR
     C                   GOTO      NXT
     C     END           TAG
     C     OJOB#         IFGT      0
     C     SOWKEY        CHAIN     FSOWSCHJ                           90
     C  N90              DO
     C                   Z-ADD     0             SOSOWQ
     C                   Z-ADD     0             SOSOWL
     C                   MOVEL     'A'           SOSTAT
     C                   UPDATE    RSOWSCH
     C                   ENDDO
     C                   END
     C                   SETON                                        LR
