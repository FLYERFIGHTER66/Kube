     FFCUTLOT   UF   E           K DISK
     FFCUTORDIOAIF   E           K DISK
      *
     D  Vendor         S              6S 0 Inz(23)
      *
    ?C     *LoVal        Setll     FCUTLOT
    ?C                   Read      FCUTLOT

     C                   DoW       not %EOF(FCUTLOT  )
     C                   Eval      CLQTOH = *Zeros
     C                   Eval      CLQTOO = *Zeros
     C                   Eval      CLQTAV = *Zeros

    ?C     LotKey        SetLL     FCUTORDIOA
    ?C     LotKey        ReadE     FCUTORDIOA
     C                   DoW       not %EOF(FCUTORDIOA)
    ?C                   Select
    ?C                   When      COSTAT = ' '
     C                   Eval      CLQTOO = CLQTOO + COQTOO
    ?C                   When         COSTAT = 'C'
    ?C                             or COSTAT = 'M'
    ?C                             or COSTAT = '9'
    ?C                             or COSTAT = 'P'
     C                   Eval      CLQTOH = CLQTOH + COQTRC
    ?C                   EndSl

     C                   If        CLQTOH < 0
     C                   Eval      CLQTOH = 0
     C                   EndIf

    ?C     LotKey        ReadE     FCUTORDIOA
     C                   EndDo

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
