     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:                      Notes Application                     :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May 2004             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :  This is program populates a default title for a new note.?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :  *INZSR   -?Initialization Subroutine                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

      *? Files with Notes Capability
     FFMVEND    IF   E           K DISK                                         ?Vendor Master
     FFMCUST    IF   E           K DISK                                         ?Customer Master

      *? Field Definitions
     D   #File         S             10A                                        ?File
     D   #FileKey      S             25A                                        ?File Key
     D   #Desc         S             30A                                        ?Description Returne

      *? Numeric File Keys
     D   FMVEND#       S              6S 0                                      ?File Key FMVEND
     D   FMCUST#       S              6S 0                                      ?File Key FMVEND

      *? Key Data Structures
     D   Key_DS        DS                                                       ?
     D   @FileKey                    25A                                        ?File Key
     D   FMVEND@                      6A   OverLay(@FileKey:01)                 ?File Key FMVEND
     D   FMCUST@                      6A   OverLay(@FileKey:01)                 ?File Key FMCUST
     D   K1_FMINVT                   16A   OverLay(@FileKey:01)                 ?File Key FMINVT 1
     D   K1_FCUTLOT                   6A   OverLay(@FileKey:01)                 ?File Key FCUTLOT 1
     D   K2_FCUTLOT                   4A   OverLay(@FileKey:07)                 ?File Key FCUTLOT 2
     D   K3_FCUTLOT                   3A   OverLay(@FileKey:11)                 ?File Key FCUTLOT 3
     D   K4_FCUTLOT                  10A   OverLay(@FileKey:14)                 ?File Key FCUTLOT 4

     C                   Eval      #Desc = *Blanks

    ?C                   SELECT                                                 ?
    ?C                   When      #File = 'FMVEND'                             ?
     C                   ExSr      FMVEND_SR
    ?C                   When      #File = 'FMCUST'                             ?
     C                   ExSr      FMCUST_SR
    ?C                   When      #File = 'FMINVT'                             ?
     C                   ExSr      FMINVT_SR
    ?C                   When      #File = 'FCUTLOT'                            ?
     C                   ExSr      FCUTLOT_SR
    ?C                   Other
     C                   Eval      #Desc = #FileKey
    ?C                   EndSl

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      FMVEND_SR - Vendor Master File                     :
      *?  :.........................................................:
    ?C     FMVEND_SR     BegSr                                                  ?

     C                   DoW       %scan(' ':FMVEND@:1) <> 0
     C                   Eval      %SUBST(FMVEND@:%scan(' ':FMVEND@:1):1) = '0'
     C                   EndDo
     C                   Move      FMVEND@       FMVEND#
     C     FMVEND#       Chain     FMVEND                                       ?Vendor Master
     C                   If        %found(FMVEND)
     C                   Eval      #Desc = VMNAME
     C                   EndIf

     C                   EndSr

      *?  ...........................................................
      *?  :      FMCUST_SR - Customer Master File                   :
      *?  :.........................................................:
    ?C     FMCUST_SR     BegSr                                                  ?

     C                   DoW       %scan(' ':FMCUST@:1) <> 0
     C                   Eval      %SUBST(FMCUST@:%scan(' ':FMCUST@:1):1) = '0'
     C                   EndDo
     C                   Move      FMCUST@       FMCUST#
     C     FMCUST#       Chain     FMCUST                                       ?Customer Master
     C                   If        %found(FMCUST)
     C                   Eval      #Desc = CMNAME
     C                   EndIf

     C                   EndSr

      *?  ...........................................................
      *?  :      FMINVT_SR - Inventory Master File                  :
      *?  :.........................................................:
    ?C     FMINVT_SR     BegSr                                                  ?

     C                   Eval      #Desc = K1_FMINVT

     C                   EndSr

      *?  ...........................................................
      *?  :      FCUTLOT_SR - Cutting Lot File                      :
      *?  :.........................................................:
    ?C     FCUTLOT_SR    BegSr                                                  ?

     C*    FCUTLOT_Key   KList                                                  ?
     C*                  KFld                    K1_FCUTLOT                     ?Vendor
     C*                  KFld                    K2_FCUTLOT                     ?Item (4)
     C*                  KFld                    K3_FCUTLOT                     ?Size
     C*                  KFld                    K4_FCUTLOT                     ?Week
     C*    FCUTLOT_Key   Chain     FCUTLOT                                      ?Lot File
     C*                  If        %found(FMINVT)
     C                   Eval      #Desc = K2_FCUTLOT
     C                                   + '('
     C                                   + %Trim(K3_FCUTLOT)
     C                                   + ') '
     C                                   + K4_FCUTLOT
     C*                  EndIf

     C                   EndSr

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C     *Entry        PList
     C                   Parm                    #File
     C     @FileKey      Parm                    #FileKey
     C                   Parm                    #Desc

    ?C                   EndSr                                                  ?
