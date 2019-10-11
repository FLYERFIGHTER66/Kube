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
      **PROGRAM NAME-------- ALOCD
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS DISTRIBUTION.
      **PROGRAMMER---------- EFD
      **APPLICATION--------- DELETE ALLOCATION BY LINE ITEM.
      *                      (THIS IS A CALLED PROGRAM)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMINVT    UF   E           K DISK
     FFDLOTRD   UF   E           K DISK
     FFALITEM   UF   E           K DISK
      **
      ** MINVT ARRAYS
     D IGB             S              4  0 DIM(4)                               BEG WKS GERM 4
     D IGE             S              4  0 DIM(4)                               END WKS GERM 4
     D IGW             S              2  0 DIM(4)                               # OF WKS GERM
     D IGB7            S              7  0 DIM(4)                               BEG WKS GERM 7
     D IGE7            S              7  0 DIM(4)                               END WKS GERM 7
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
     IRMINVT
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
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    QTY              11 1
     C                   PARM                    ORDER#            6 0
     C                   PARM                    SEQ#              3 0
     C                   PARM                    DEALL             1            DELETE ALL Y
      ********
     C                   If        QTY = *Zero
     C                   Return
     C                   ENDIF
     C                   Z-ADD     QTY           LTDHLD           11 1
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TIMWRK           12 0
     C                   MOVE      TIMWRK        TDATE             6 0
     C                   UNLOCK    FMINVT
     C     DEALL         IFEQ      'Y'
     C     FALKEY        KLIST
     C                   KFLD                    ORDER#
     C                   KFLD                    SEQ#
     C     FALKEY        SETLL     FALITEM
     C     NXTALL        TAG
     C     FALKEY        READE     RALITEM                                90
     C   90              GOTO      END
     C     LOTKEY        KLIST
     C                   KFLD                    AIITEM
     C                   KFLD                    AISIZE
     C                   KFLD                    AISOWD
     C                   KFLD                    AICRDY
     C                   KFLD                    AIGLOC
     C                   KFLD                    AICLOC
     C                   KFLD                    AICODE
     C                   KFLD                    AICUST
     C                   MOVEL     'A'           AICODE            1
     C                   MOVEL     AIGLOC        AICLOC            3
     C     LOTKEY        CHAIN     FDLOTRD                            91
     C                   SUB       AIQTOA        LRQTAL
     C     LRQTAL        IFLT      0
     C                   Z-ADD     0             LRQTAL
     C                   END
     C     LRQTOH        SUB       LRQTAL        LRQTAV
     C  N91              UPDATE    RDLOTRD
      ** NOW GET MINVT
     C     MINKEY        KLIST
     C                   KFLD                    AIITEM
     C                   KFLD                    AISIZE
     C     MINKEY        CHAIN     FMINVT                             91
     C                   SUB       AIQTOA        IMQTAL
     C  N91              UPDATE    RMINVT
     C                   DELETE    RALITEM
     C                   GOTO      NXTALL
     C                   END                                                    DELALL=Y
      ** SEE IF ANY ONE ALLOC WILL SATISFY QTY TO DELETE
     C     FALKEY        SETLL     FALITEM
     C     NXTTST        TAG
     C     FALKEY        READE     RALITEM                                90
     C   90              GOTO      NOT1
     C     AIQTOA        IFEQ      QTY
     C                   MOVEL     'A'           AICODE            1
     C     LOTKEY        CHAIN     FDLOTRD                            91
     C                   SUB       AIQTOA        LRQTAL
     C     LRQTAL        IFLT      0
     C                   Z-ADD     0             LRQTAL
     C                   END
     C     LRQTOH        SUB       LRQTAL        LRQTAV
     C  N91              UPDATE    RDLOTRD
      ** NOW GET MINVT
     C     MINKEY        CHAIN     FMINVT                             91
     C                   SUB       AIQTOA        IMQTAL
     C  N91              UPDATE    RMINVT
     C                   DELETE    RALITEM
     C                   GOTO      END
     C                   END
     C                   GOTO      NXTTST
     C     NOT1          TAG
      ** NOW GET RID OF AS MUCH AS IT TAKES.
     C     FALKEY        SETLL     FALITEM
     C     NXT1          TAG
     C     FALKEY        READE     RALITEM                                90
     C   90              GOTO      END
     C     QTY           IFGE      AIQTOA
     C                   MOVEL     'A'           AICODE            1
     C     LOTKEY        CHAIN     FDLOTRD                            91
     C                   SUB       AIQTOA        LRQTAL
     C     LRQTAL        IFLT      0
     C                   Z-ADD     0             LRQTAL
     C                   END
     C     LRQTOH        SUB       LRQTAL        LRQTAV
     C  N91              UPDATE    RDLOTRD
      ** NOW GET MINVT
     C     MINKEY        CHAIN     FMINVT                             91
     C                   SUB       AIQTOA        IMQTAL
     C  N91              UPDATE    RMINVT
     C                   DELETE    RALITEM
     C                   SUB       AIQTOA        QTY
     C     QTY           IFGT      0
     C                   GOTO      NXT1
     C                   ELSE
     C                   GOTO      END
     C                   END
     C                   END
     C     QTY           SUB       AIQTOA        LEFT             11 1
     C                   MOVEL     'A'           AICODE            1
     C     LOTKEY        CHAIN     FDLOTRD                            91
     C                   SUB       LEFT          LRQTAL
     C     LRQTAL        IFLT      0
     C                   Z-ADD     0             LRQTAL
     C                   END
     C     LRQTOH        SUB       LRQTAL        LRQTAV
     C  N91              UPDATE    RDLOTRD
      ** NOW GET MINVT
     C     MINKEY        CHAIN     FMINVT                             91
     C                   SUB       LEFT          IMQTAL
     C  N91              UPDATE    RMINVT
     C                   SUB       LEFT          AIQTOA
     C                   UPDATE    RALITEM
     C                   GOTO      END
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ********************************************************************@DT@A1
