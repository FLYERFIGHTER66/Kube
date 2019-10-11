     FFCUTLOT   UF   E           K DISK
     FFCUTORDIO IF   E           K DISK
      *
     D  Vendor         S              6S 0 Inz(23)
      *
    ?C     *LoVal        Setll     FCUTLOT
    ?C                   Read      FCUTLOT

     C                   DoW       not %EOF(FCUTLOT  )
     C                   Eval      CLQTOH = *Zeros
     C                   Eval      CLQTOO = *Zeros
     C                   Eval      CLQTAV = *Zeros

    ?C     LotKey        SetLL     FCUTORDIO
    ?C     LotKey        ReadE     FCUTORDIO
     C                   DoW       not %EOF(FCUTORDIO)
    ?C                   Select
    ?C                   When      COSTAT = ' '
     C                   Eval      CLQTOO = CLQTOO + COQTOO
    ?C                   When         COSTAT = 'C'
    ?C                             or COSTAT = 'M'
    ?C                             or COSTAT = '9'
    ?C                             or COSTAT = 'P'
     C                   Eval      CLQTOH = CLQTOH + COQTRC
    ?C                   EndSl

    ?C     LotKey        ReadE     FCUTORDIO
     C                   EndDo

     C                   If        CLQTOH < 0
     C                   Eval      CLQTOH = 0
     C                   EndIf

     C                   Eval      CLQTAV = CLQTOH + CLQTOO - CLQTSL
    ?C                   Update    RCUTLOT
    ?C                   Read      FCUTLOT
     C                   EndDo

    ?C     LotKey        KList
    ?C                   KFld                    CLVEND
    ?C                   KFld                    CLITEM
    ?C                   KFld                    CLSIZE
    ?C                   KFld                    CLSOWD

     C                   Eval      *InLR = *On
