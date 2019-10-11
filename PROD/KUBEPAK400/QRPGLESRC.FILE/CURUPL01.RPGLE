     FFCUTUPLOADUP   E           K DISK
     FFCUTLOT   UF A E           K DISK
     FFCUTORD   UF A E           K DISK

     ?*  Check if Lot Exists
    ?C     LotKey        KList
    ?C                   KFld                    CEVEND
    ?C                   KFld                    CEITEM
    ?C                   KFld                    CESIZE
    ?C                   KFld                    CESOWD
    ?C     LotKey        Setll     FCUTLOT

     ?*  If Lot Doesn't exist, write lot record
     C                   If        Not %Equal(FCUTLOT)
     C                   Eval      CLVEND = CEVEND                              ?VENDOR #
     C                   Eval      CLSTAT = CESTAT                              ?STATUS
     C                   Eval      CLITEM = CEITEM                              ?ITEM #
     C                   Eval      CLSIZE = CESIZE                              ?SIZE CODE
     C                   Eval      CLUSEC = CEUSEC                              ?USE CODE
     C                   Eval      CLSOWD = CESOWD                              ?SOW DATE CYMD
     C                   Eval      CLRDYD = CERDYD                              ?READY DATE CYMD
     C                   Eval      CLLOOK = CELOOK                              ?APLHA SEARCH
     C                   Eval      CLQTTS = *Zeros                              ?QUANTITY TRAYS SOLD
     C                   Eval      CLQTTF = *Zeros                              ?QUANTITY FIXERS
     C                   Eval      CLQTSL = *Zeros                              ?QUANTITY CUTS SOLD
     C                   Eval      CLQTOH = CEQTRC                              ?QTY. CUTS ON-HAND
     C                   Eval      CLQTAV = CEQTRC                              ?QTY. AVAILABLE
     C                   Eval      CLQTOO = *Zeros                              ?QTY. CUTS ON ORDER
    ?C                   Write     RCUTLOT
     C                   EndIf

     ?*  Write Order Record
     C                   Eval      COVEND = CEVEND                              ?VENDOR #
     C                   Eval      COSTAT = CESTAT                              ?STATUS
     C                   Eval      COORD# = CEORD#                              ?ORDER NUMBER
     C                   Eval      COITEM = CEITEM                              ?ITEM #
     C                   Eval      COSIZE = CESIZE                              ?SIZE CODE
     C                   Eval      COUSEC = CEUSEC                              ?USE CODE
     C                   Eval      COORDD = CEORDD                              ?ORDER DATE CYMD
     C                   Eval      COSOWD = CESOWD                              ?SOW DATE CYMD
     C                   Eval      CORDYD = CERDYD                              ?READY DATE CYMD
     C                   Eval      COLOOK = CELOOK                              ?APLHA SEARCH
     C                   Eval      COVNAL = CEVNAL                              ?APLHA FOR VEND
     C                   Eval      COSVND = CESVND                              ?SUPPLYING VENDOR #
     C                   Eval      COVITM = CEVITM                              ?VENDOR ITEM #
     C                   Eval      COQTOO = CEQTOO                              ?QTY. CUTS ORDERED
     C                   Eval      COQTRC = CEQTRC                              ?QTY. CUTS RECEIVED
     C                   Eval      COPRTD = CEPRTD                              ?PRINTED
     C                   Eval      COTRAN = CETRAN                              ?TRANSFERED
    ?C                   Write     RCUTORD

