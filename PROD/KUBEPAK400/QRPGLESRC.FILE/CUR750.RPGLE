    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DftActGrp(*no)
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DatFmt(*usa)
      *?PROGRAM NAME-------- CUR750
      *?COMPANY------------- KUBE PAK CORP
      *?SYSTEM-------------- TGMS
      *?PROGRAMMER---------- WJB
      *?APPLICATION--------- SPREAD "CUT" INVENTORY TO NEEDS

      *?           CHANGE--DATE-------DESCRIPTION
      *?12/29/09 WJB INITIAL PROGRAMMING

     FFCUTLOTITMUP   E           K DISK    Prefix(NED_)
     FFCUTLOT   UF   E           K DISK    Prefix(CUT_) Rename(RCUTLOT:CUTLOT)
     FFCUTORD   O  A E           K DISK
     FFCUTCTL   UF   E           K DISK
      *
      *?  .........................
      *?  :  PROG DATA STRUCTURE  :
      *?  :.......................:
     D                SDS
     D  PROGID                 1     10                                         ?PROGRAM NAME
     D  RLIBR                 81     90                                         ?RUN LIBRARY
     D  USERID               254    263                                         ?USER I.D.
     D  SLIBR                314    323                                         ?SOURCE LIBRARY
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY

     D FoundCut        S               N
     D CUT             S              3A   Inz('CUT')
     D Qty2Move        S                   Like(NED_CLQTAV)
     D Vendor          S                   Like(NED_CLVEND)

      *?................................................................................
      *?:        START         BEGIN PROGRAM CALCS                                     :
      *?:..............................................................................:
      *? Read through Lot File looking for 'Need' Records.
     C                   If        NED_CLQTAV < *Zeros and NED_CLSIZE <> 'CUT'
     C                   If        Vendor = 0 or  Vendor = NED_CLVEND
      *? See if there is a 'CUT' Record we can take from.
    ?C                   ExSr      FindCut
     C                   If        FoundCut
      *? Move Inventory from 'CUT' Record to 'Need' Record.
    ?C                   ExSr      MoveCut
      *? Create Orders for Tracking.  (Write FCUTORD records)
    ?C                   ExSr      MakeOrd
     C                   EndIf
     C                   EndIf
     C                   EndIf
      *?................................................................................
      *?:        FindCut       Find 'CUT' Records to take inventory from               :
      *?:..............................................................................:
    ?C     FindCut       BegSR
    ?C     CutKey        KList
    ?C                   KFld                    NED_CLVEND
    ?C                   KFld                    NED_CLITEM
    ?C                   KFld                    CUT
    ?C                   KFld                    NED_CLSOWD
    ?C     CutKey        CHAIN     FCUTLOT
     C                   Eval      FoundCut = %found(FCUTLOT)
     C                   If        CUT_CLQTAV <= 0
     C                   Eval      FoundCut = *Off
     C                   EndIF
    ?C                   EndSR
      *?................................................................................
      *?:        MoveCut       Move 'CUT' Record inventory To 'Need" Record            :
      *?:..............................................................................:
    ?C     MoveCut       BegSR
     C                   IF        -NED_CLQTAV > CUT_CLQTAV
     C                   Eval      Qty2Move = CUT_CLQTAV
     C                   Else
     C                   Eval      Qty2Move = -NED_CLQTAV
     C                   EndIf
     C                   Eval      NED_CLQTAV = NED_CLQTAV + Qty2Move
     C                   Eval      NED_CLQTOH = NED_CLQTOH + Qty2Move
     C                   Eval      CUT_CLQTAV = CUT_CLQTAV - Qty2Move
     C                   Eval      CUT_CLQTOH = CUT_CLQTOH - Qty2Move
    ?C                   Update    CUTLOT
    ?C                   Update    RCUTLOT
    ?C                   EndSR
      *?................................................................................
      *?:        MakeOrd       Make Orders to represent the move.                      :
      *?:..............................................................................:
    ?C     MakeOrd       BegSR
      *? Get next 2 move Sequence Numbers
    ?C     CompVend      KList
    ?C                   KFld                    Company           2 0
    ?C                   KFld                    NED_CLVEND
     C                   Eval      Company = 1
    ?C     CompVend      CHAIN     FCUTCTL                            93
     C                   Eval      COORD#  = CCNXTM
     C                   Eval      CCNXTM =  CCNXTM + 2
    ?C  N93              Update    RCUTCTL
      *? Write the 'Move From' record first
     C                   EVAL      COSTAT  =  'N'
     C                   EVAL      COVEND  =  NED_CLVEND
     C                   EVAL      COSVND  =  NED_CLVEND
     C                   EVAL      COITEM  =  NED_CLITEM
     C                   EVAL      COSIZE  =  NED_CLSIZE
     C                   EVAL      COUSEC  =  NED_CLUSEC
     C                   EVAL      COSOWD  =  NED_CLSOWD
     C                   EVAL      CORDYD  =  NED_CLRDYD
     C                   EVAL      COLOOK  =  NED_CLLOOK
     C                   EVAL      COORDD  =  $Date7($Date(0))
     C                   EVAL      COVNAL  =  'AUTO Transfer'
     C                   EVAL      COQTOO  =  *Zero
     C                   EVAL      COPRTD  =  'N'
     C                   EVAL      COTRAN  =  'Y'
     C                   EVAL      COVITM  =  'Move from CUT'
     C                   EVAL      COQTRC  =  -Qty2Move
    ?C                   Write     RCUTORD
     C                   Eval      COORD#  =  COORD# + 1
     C                   EVAL      COVITM  =  'Move TO   ' + NED_CLSIZE
     C                   EVAL      COQTRC  =  Qty2Move
    ?C                   Write     RCUTORD
    ?C                   EndSR
      *?................................................................................
      *?:        *INZSR        INITIALIZATION SUBROUTINE                               :
      *?:..............................................................................:
     C     *INZSR        BEGSR

      *? Parameters
    ?C     *Entry        PList
    ?C                   Parm                    Vendor

     C                   ENDSR
