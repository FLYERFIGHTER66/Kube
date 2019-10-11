     FTESTFM    CF   E             WORKSTN
     F                                     SFILE(TSTSFL:RECNO)
     FFTRAYJD   IF   E           K DISK
     C     TRYJD         KLIST
     C                   KFLD                    SOSOWD            7 0
     C                   KFLD                    SOJOB#            4 0
     C                   KFLD                    HIGHNM
     C     SOJKEY        KLIST
     C                   KFLD                    SOSOWD            7 0
     C                   KFLD                    SOJOB#            4 0
     C                   Z-ADD     99999999      HIGHNM            8 0
     C                   Z-ADD     1020128       SOSOWD
     C                   Z-ADD     435           SOJOB#
     C                   Z-ADD     0             RECNO             5 0
      ** GET BEGINING AND ENDING TAG NUMBERS
     C     TRYJD         SETLL     FTRAYJD
     C     NXTGTG        TAG
     C     SOJKEY        READE     FTRAYJD                                90
     C  N90              DO
     C                   ADD       1             RECNO
     C                   WRITE     TSTSFL
     C                   GOTO      NXTGTG
     C                   ENDDO
     C                   ADD       1             RECNO
     C                   WRITE     TSTSFL
     C                   EXFMT     TSTCTL
     C                   SETON                                        LR
