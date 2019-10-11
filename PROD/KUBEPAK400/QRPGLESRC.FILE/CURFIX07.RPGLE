     FFCUTLOT   UF   E           K DISK
      *
     D  Vendor         S                   Like(CLVEND) Inz(23)
      *
     C     Vendor        Setll     FCUTLOT
     C     Vendor        ReadE     FCUTLOT

     C                   DoW       not %EOF(FCUTLOT  )
     C                   If        CLSOWD = CLRDYD
     C                   Call      'GETREADY'    GETREADY
     C                   Call      'GETGERM'     GETGERM
     C                   If        CLSOWD = SOWDAT
     C                   Update    RCUTLOT
     C                   EndIf
     C                   EndIf
     C     Vendor        ReadE     FCUTLOT
     C                   EndDo

    ?C     GETREADY      PList
    ?C                   Parm                    CLITEM
    ?C                   Parm                    CLSIZE
    ?C                   Parm      '   '         IMWHSE            3
    ?C                   Parm                    CLRDYD
    ?C                   Parm                    CLSOWD

    ?C     GETGERM       PList
    ?C                   Parm                    CLITEM
    ?C                   Parm                    CLSIZE
    ?C                   Parm      '   '         IMWHSE
    ?C                   Parm                    CLRDYD
    ?C                   Parm                    SOWDAT            7 0          CYMD

     C                   Eval      *InLR = *On
