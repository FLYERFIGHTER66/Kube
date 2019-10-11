     ?*   This Program should:
     ?*    - Read through all Items from CUT and verify valid Lot Record

     FFCUTORD   IP   E           K DISK
     FFCUTLOT   IF A E           K DISK

    ?C     LotKey        KList
    ?C                   KFld                    COVEND
    ?C                   KFld                    COITEM
    ?C                   KFld                    COSIZE
    ?C                   KFld                    COSOWD
    ?C     LotKey        SetLL     FCUTLOT
     C                   If        not %Equal(FCUTLOT)
     C                   Eval      CLVEND = COVEND                              |VENDOR #
     C                   Eval      CLSTAT = 'A'                                 |STATUS
     C                   Eval      CLITEM = COITEM                              |ITEM #
     C                   Eval      CLSIZE = COSIZE                              |SIZE CODE
     C                   Eval      CLUSEC = *Blanks                             |USE CODE
     C                   Eval      CLSOWD = COSOWD                              |SOW DATE CYMD
     C                   Eval      CLRDYD = CORDYD                              |READY DATE CYMD
     C                   Eval      CLLOOK = COLOOK                              |APLHA SEARCH
     C                   Eval      CLQTTS = *Zeros                              |QUANTITY TRAYS SOLD
     C                   Eval      CLQTSP = *Zeros                              |QUANTITY TRAYS SPEC
     C                   Eval      CLQTTF = *Zeros                              |QUANTITY FIXERS
     C                   Eval      CLQTSL = *Zeros                              |QUANTITY CUTS SOLD
     C                   Eval      CLQTOH = *Zeros                              |QTY. CUTS ON-HAND
     C                   Eval      CLQTAV = *Zeros                              |QTY. AVAILABLE
     C                   Eval      CLQTOO = *Zeros                              |QTY. CUTS ON ORDER
    ?C                   Write     RCUTLOT
     C                   EndIf
