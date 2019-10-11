     FFHORDR    UF   E           K DISK
     FFIORDR    UF   E           K DISK
     FFIORDRBO  UF   E           K DISK
     F                                     RENAME(RIORDR:IORDR)
     FFOPNORD   UF   E           K DISK
      ** READ HORDR
     C     NXT           TAG
     C                   READ      FHORDR                                 90
     C   90              GOTO      ENDH
     C     OHCUST        IFGT      0
     C                   GOTO      NXT
     C                   END
      ** IF HERE NO CUST NUMBER
     C     OHORD#        SETLL     FIORDR
     C     NXTIOR        TAG
     C     OHORD#        READE     FIORDR                                 91
     C  N91              DO
     C                   DELETE    RIORDR
     C                   GOTO      NXTIOR
     C                   ENDDO
     C     OHORD#        CHAIN     FOPNORD                            92
     C  N92              DELETE    ROPNORD
     C                   DELETE    RHORDR
     C                   GOTO      NXT
     C     ENDH          TAG
      ** CHECK FOR COMMENT ONLY ORDERS
     C                   Z-ADD     0             OHORD#
     C                   Z-ADD     0             OORD#             6 0
     C     OHORD#        SETLL     FIORDR
     C     NXTCOM        TAG
     C                   READ      FIORDR                                 90
     C   90              DO
     C     OORD#         IFGT      0
     C     OPEN          IFGT      0
     C     OPEN          ANDEQ     COMM
     C                   EXSR      CLOSE
     C                   END
     C                   END
     C                   GOTO      ENDCOM
     C                   ENDDO                                                   90 DO
     C     OIORD#        IFNE      OORD#
     C     OORD#         IFGT      0
     C     OPEN          IFGT      0
     C     OPEN          ANDEQ     COMM
     C                   EXSR      CLOSE
     C                   END                                                    OPEN>0
     C                   END                                                    OORD#>0
     C                   Z-ADD     OIORD#        OORD#
     C                   Z-ADD     0             OPEN              6 0
     C                   Z-ADD     0             COMM              6 0
     C                   END                                                    OIORD#><OORD
     C     OISTAT        IFEQ      'A'
     C                   ADD       1             OPEN
     C     OIITYP        IFEQ      'C'
     C                   ADD       1             COMM
     C                   END
     C                   END
     C                   GOTO      NXTCOM
      **
     C     ENDCOM        TAG
     C                   SETON                                            LR
      ******************
      * CLOSE COMMENTS *
      ******************
     C     CLOSE         BEGSR
     C     OORD#         SETLL     FIORDRBO
     C     NXTCLO        TAG
     C     OORD#         READE     FIORDRBO                               91
     C   91              GOTO      ENDCLO
     C                   MOVEL     'D'           OISTAT
     C                   MOVEL     'Y'           OICOFL
     C                   UPDATE    IORDR
     C                   GOTO      NXTCLO
     C     ENDCLO        TAG
     C     OORD#         CHAIN     FOPNORD                            92
     C  N92              DELETE    ROPNORD
     C     OORD#         CHAIN     FHORDR                             92
     C                   MOVEL     'D'           OHSTAT
     C                   MOVEL     'Y'           OICOFL
     C                   UPDATE    RHORDR
     C                   ENDSR
