     ?*   This Program should:
     ?*    - Read through all Items from CUT and verify Vendor Item# from FMINVTVEND
     ?*    - Update all Items from FCUTLOT and verify Vendor and Alpha Sort
     ?*    - Update all Items from FCUTORD and verify Vendor and Alpha Sort

     FFMINVTCT  UP   E           K DISK
     FFMINVTVENDIF   E           K DISK    Prefix(V_)

     FFCUTORDITMUF   E           K DISK
     FFCUTLOTITMUF   E           K DISK

    ?C     ItemVend      KList
    ?C                   KFld                    IMITEM
    ?C                   KFld                    IMVEND
    ?C     ItemVend      Chain     FMINVTVEND
     C                   If        %Found(FMINVTVEND)
     C                   If        IMVITM <> V_VIVITM
     C                   Eval      IMVITM =  V_VIVITM
    ?C                   Update    RMINVT
     C                   EndIf
     C                   Else
     C                   If        IMVITM <>%Trim(IMITEM)+'-(CUT)'
     C                   Eval      IMVITM = %Trim(IMITEM)+'-(CUT)'
    ?C                   Update    RMINVT
     C                   EndIf
     C                   EndIf

    ?C     IMITEM        SetLL     FCUTORDITM
    ?C     IMITEM        ReadE     FCUTORDITM
     C                   DoW       not %EOF(FCUTORDITM)
     C                   If        COLOOK <> IMLOOK or COVEND <> IMVEND
     C                   Eval      COVEND = IMVEND
     C                   Eval      COLOOK = IMLOOK
    ?C                   Update    RCUTORD
     C                   EndIf
    ?C     IMITEM        ReadE     FCUTORDITM
     C                   EndDo

    ?C     IMITEM        SetLL     FCUTLOTITM
    ?C     IMITEM        ReadE     FCUTLOTITM
     C                   DoW       not %EOF(FCUTLOTITM)
     C                   If        CLLOOK <> IMLOOK or CLVEND <> IMVEND
     C                   Eval      CLVEND = IMVEND
     C                   Eval      CLLOOK = IMLOOK
    ?C                   Update    RCUTLOT
     C                   EndIf
    ?C     IMITEM        ReadE     FCUTLOTITM
     C                   EndDo
