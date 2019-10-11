     FFIORDR    UF   E             DISK
     FFHORDR    IF   E           K DISK
     FFMINVT    IF   E           K DISK
      ** GET IORDR REC
     C     NXT           TAG
     C                   READ      FIORDR                                 90
     C   90              GOTO      END
     C     OISTAT        IFNE      'A'
     C                   GOTO      NXT
     C                   END
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
      *
     C                   Z-ADD     ##CYMD        OIRVDT
     C     OIITYP        IFNE      ' '
     C                   GOTO      SKPGRM
     C                   END
     C                   CALL      'GETGERM'
     C                   PARM                    OIITEM
     C                   PARM                    OISIZE
     C                   PARM                    OIWHSE
     C                   PARM                    OIRVDT
     C                   PARM                    NISOW             7 0
     C     NISOW         IFGT      0
     C     OIPOST        andNE     'Y'
     C                   Z-ADD     NISOW         OISOW
     C                   ENDIF
     C     SKPGRM        TAG
     C     OIORD#        IFNE      OLORD
     C     OIORD#        CHAIN     FHORDR                             91
     C                   END
     C  N91              DO
     C                   MOVEL     OHPHYT        OIPHYT
     C                   Z-ADD     OIORD#        OLORD             6 0
     C                   MOVEL     OHSHFR        OISHFR
     C                   MOVEL     OHSHPC        OISHPC
     C                   ENDDO
     C     MINKEY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     MINKEY        CHAIN     FMINVT                             97
     C  N97              MOVEL     IMLOOK        OIITMA
     C  N97              MOVEL     IMBIN#        OIBIN#
     C                   UPDATE    RIORDR
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                            LR
