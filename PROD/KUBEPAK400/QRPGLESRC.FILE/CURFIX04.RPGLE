     FFCUTLOT   UF   E           K DISK
      *
     C     *LoVal        Setll     FCUTLOT
     C                   Read      FCUTLOT

     C                   DoW       not %EOF(FCUTLOT  )
     C                   Call      'GETREADY'    GETREADY
     C                   Call      'GETGERM'     GETGERM
     C                   If        CLSOWD = SOWDAT
     C                   Else
     C                   Eval      CLRDYD = CLSOWD
     C                   EndIf
     C                   Update    RCUTLOT
     C                   Read      FCUTLOT
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
