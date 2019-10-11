     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:           Move S/A from One Account to Another             :?
      *??:............................................................:?

      * Details
     FFSHISTSC# UF   E           K DISK    Prefix(fm) Rename(RSHISTS:RSHISTfm)
     FFSHISTS   UF A E           K DISK    Prefix(to) Rename(RSHISTS:RSHISTto)

     D  fmACCT         S                   Like(fmSHCUST)
     D  toACCT         S                   Like(toSHCUST)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User

     C     fmACCT        SETLL     FSHISTSC#
     C     fmACCT        READE     FSHISTSC#

     C                   DoW       not %EOF(FSHISTSC#)

     C                   ExSr      MoveDetails
     C                   ExSr      ZeroDetails

     C     fmACCT        READE     FSHISTSC#
     C                   EndDo

     C                   Eval      *InLR = *On




     C     MoveDetails   BegSr

     C     DetailKey     KList
     C                   KFld                    toACCT
     C                   KFld                    fmSHITEM
     C                   KFld                    fmSHSIZE
     C                   KFld                    fmSHSLSM
     C                   KFld                    fmSHCOMP

     C                   Clear                   RSHISTto

     C     DetailKey     Chain     FSHISTS

      *  MTD QTY   (SICQ)
     C                   Eval      toSHCQ01  = toSHCQ01  + fmSHCQ01
     C                   Eval      toSHCQ02  = toSHCQ02  + fmSHCQ02
     C                   Eval      toSHCQ03  = toSHCQ03  + fmSHCQ03
     C                   Eval      toSHCQ04  = toSHCQ04  + fmSHCQ04
     C                   Eval      toSHCQ05  = toSHCQ05  + fmSHCQ05
     C                   Eval      toSHCQ06  = toSHCQ06  + fmSHCQ06
     C                   Eval      toSHCQ07  = toSHCQ07  + fmSHCQ07
     C                   Eval      toSHCQ08  = toSHCQ08  + fmSHCQ08
     C                   Eval      toSHCQ09  = toSHCQ09  + fmSHCQ09
     C                   Eval      toSHCQ10  = toSHCQ10  + fmSHCQ10
     C                   Eval      toSHCQ11  = toSHCQ11  + fmSHCQ11
     C                   Eval      toSHCQ12  = toSHCQ12  + fmSHCQ12
     C                   Eval      toSHCQ13  = toSHCQ13  + fmSHCQ13
      *  MTD DOL$  (SICS)
     C                   Eval      toSHCS01  = toSHCS01  + fmSHCS01
     C                   Eval      toSHCS02  = toSHCS02  + fmSHCS02
     C                   Eval      toSHCS03  = toSHCS03  + fmSHCS03
     C                   Eval      toSHCS04  = toSHCS04  + fmSHCS04
     C                   Eval      toSHCS05  = toSHCS05  + fmSHCS05
     C                   Eval      toSHCS06  = toSHCS06  + fmSHCS06
     C                   Eval      toSHCS07  = toSHCS07  + fmSHCS07
     C                   Eval      toSHCS08  = toSHCS08  + fmSHCS08
     C                   Eval      toSHCS09  = toSHCS09  + fmSHCS09
     C                   Eval      toSHCS10  = toSHCS10  + fmSHCS10
     C                   Eval      toSHCS11  = toSHCS11  + fmSHCS11
     C                   Eval      toSHCS12  = toSHCS12  + fmSHCS12
     C                   Eval      toSHCS13  = toSHCS13  + fmSHCS13
      *  Prior MTD QTY   (SILQ)
     C                   Eval      toSHLQ01  = toSHLQ01  + fmSHLQ01
     C                   Eval      toSHLQ02  = toSHLQ02  + fmSHLQ02
     C                   Eval      toSHLQ03  = toSHLQ03  + fmSHLQ03
     C                   Eval      toSHLQ04  = toSHLQ04  + fmSHLQ04
     C                   Eval      toSHLQ05  = toSHLQ05  + fmSHLQ05
     C                   Eval      toSHLQ06  = toSHLQ06  + fmSHLQ06
     C                   Eval      toSHLQ07  = toSHLQ07  + fmSHLQ07
     C                   Eval      toSHLQ08  = toSHLQ08  + fmSHLQ08
     C                   Eval      toSHLQ09  = toSHLQ09  + fmSHLQ09
     C                   Eval      toSHLQ10  = toSHLQ10  + fmSHLQ10
     C                   Eval      toSHLQ11  = toSHLQ11  + fmSHLQ11
     C                   Eval      toSHLQ12  = toSHLQ12  + fmSHLQ12
     C                   Eval      toSHLQ13  = toSHLQ13  + fmSHLQ13
      *  Prior MTD DOL$   (SILS)
     C                   Eval      toSHLS01  = toSHLS01  + fmSHLS01
     C                   Eval      toSHLS02  = toSHLS02  + fmSHLS02
     C                   Eval      toSHLS03  = toSHLS03  + fmSHLS03
     C                   Eval      toSHLS04  = toSHLS04  + fmSHLS04
     C                   Eval      toSHLS05  = toSHLS05  + fmSHLS05
     C                   Eval      toSHLS06  = toSHLS06  + fmSHLS06
     C                   Eval      toSHLS07  = toSHLS07  + fmSHLS07
     C                   Eval      toSHLS08  = toSHLS08  + fmSHLS08
     C                   Eval      toSHLS09  = toSHLS09  + fmSHLS09
     C                   Eval      toSHLS10  = toSHLS10  + fmSHLS10
     C                   Eval      toSHLS11  = toSHLS11  + fmSHLS11
     C                   Eval      toSHLS12  = toSHLS12  + fmSHLS12
     C                   Eval      toSHLS13  = toSHLS13  + fmSHLS13
      *  MTD COST  (SICC)
     C                   Eval      toSHCC01  = toSHCC01  + fmSHCC01
     C                   Eval      toSHCC02  = toSHCC02  + fmSHCC02
     C                   Eval      toSHCC03  = toSHCC03  + fmSHCC03
     C                   Eval      toSHCC04  = toSHCC04  + fmSHCC04
     C                   Eval      toSHCC05  = toSHCC05  + fmSHCC05
     C                   Eval      toSHCC06  = toSHCC06  + fmSHCC06
     C                   Eval      toSHCC07  = toSHCC07  + fmSHCC07
     C                   Eval      toSHCC08  = toSHCC08  + fmSHCC08
     C                   Eval      toSHCC09  = toSHCC09  + fmSHCC09
     C                   Eval      toSHCC10  = toSHCC10  + fmSHCC10
     C                   Eval      toSHCC11  = toSHCC11  + fmSHCC11
     C                   Eval      toSHCC12  = toSHCC12  + fmSHCC12
     C                   Eval      toSHCC13  = toSHCC13  + fmSHCC13
      *  Prior MTD COST   (SILC)
     C                   Eval      toSHLC01  = toSHLC01  + fmSHLC01
     C                   Eval      toSHLC02  = toSHLC02  + fmSHLC02
     C                   Eval      toSHLC03  = toSHLC03  + fmSHLC03
     C                   Eval      toSHLC04  = toSHLC04  + fmSHLC04
     C                   Eval      toSHLC05  = toSHLC05  + fmSHLC05
     C                   Eval      toSHLC06  = toSHLC06  + fmSHLC06
     C                   Eval      toSHLC07  = toSHLC07  + fmSHLC07
     C                   Eval      toSHLC08  = toSHLC08  + fmSHLC08
     C                   Eval      toSHLC09  = toSHLC09  + fmSHLC09
     C                   Eval      toSHLC10  = toSHLC10  + fmSHLC10
     C                   Eval      toSHLC11  = toSHLC11  + fmSHLC11
     C                   Eval      toSHLC12  = toSHLC12  + fmSHLC12
     C                   Eval      toSHLC13  = toSHLC13  + fmSHLC13
      *  MTD LBS   (SIC#)
     C                   Eval      toSHC#01  = toSHC#01  + fmSHC#01
     C                   Eval      toSHC#02  = toSHC#02  + fmSHC#02
     C                   Eval      toSHC#03  = toSHC#03  + fmSHC#03
     C                   Eval      toSHC#04  = toSHC#04  + fmSHC#04
     C                   Eval      toSHC#05  = toSHC#05  + fmSHC#05
     C                   Eval      toSHC#06  = toSHC#06  + fmSHC#06
     C                   Eval      toSHC#07  = toSHC#07  + fmSHC#07
     C                   Eval      toSHC#08  = toSHC#08  + fmSHC#08
     C                   Eval      toSHC#09  = toSHC#09  + fmSHC#09
     C                   Eval      toSHC#10  = toSHC#10  + fmSHC#10
     C                   Eval      toSHC#11  = toSHC#11  + fmSHC#11
     C                   Eval      toSHC#12  = toSHC#12  + fmSHC#12
     C                   Eval      toSHC#13  = toSHC#13  + fmSHC#13
      *  Prior LBS   (SIL#)
     C                   Eval      toSHL#01  = toSHL#01  + fmSHL#01
     C                   Eval      toSHL#02  = toSHL#02  + fmSHL#02
     C                   Eval      toSHL#03  = toSHL#03  + fmSHL#03
     C                   Eval      toSHL#04  = toSHL#04  + fmSHL#04
     C                   Eval      toSHL#05  = toSHL#05  + fmSHL#05
     C                   Eval      toSHL#06  = toSHL#06  + fmSHL#06
     C                   Eval      toSHL#07  = toSHL#07  + fmSHL#07
     C                   Eval      toSHL#08  = toSHL#08  + fmSHL#08
     C                   Eval      toSHL#09  = toSHL#09  + fmSHL#09
     C                   Eval      toSHL#10  = toSHL#10  + fmSHL#10
     C                   Eval      toSHL#11  = toSHL#11  + fmSHL#11
     C                   Eval      toSHL#12  = toSHL#12  + fmSHL#12
     C                   Eval      toSHL#13  = toSHL#13  + fmSHL#13
      *  Totals
     C                   Eval      toSHCQTL  = toSHCQTL  + fmSHCQTL
     C                   Eval      toSHLQTL  = toSHLQTL  + fmSHLQTL
     C                   Eval      toSHCSTL  = toSHCSTL  + fmSHCSTL
     C                   Eval      toSHPSTL  = toSHPSTL  + fmSHPSTL

     C                   Eval      toSHDTLA  = $MDYDate($Date(0))
     C                   Eval      toSHTIME  = $Now()
     C                   Eval      toSHUSER  = $User()

     C                   If        %Found(FSHISTS)
     C                   Update    RSHISTto
     C                   Else
     C                   Eval      toSHSTAT  = fmSHSTAT
     C                   Eval      toSHCUST  = toACCT
     C                   Eval      toSHITEM  = fmSHITEM
     C                   Eval      toSHSIZE  = fmSHSIZE
     C                   Eval      toSHSLSM  = fmSHSLSM
     C                   Eval      toSHCOMP  = fmSHCOMP
     C                   Eval      toSHTERR  = fmSHTERR
     C                   Eval      toSHPCL1  = fmSHPCL1
     C                   Eval      toSHPCL2  = fmSHPCL2
     C                   Eval      toSHPCL3  = fmSHPCL3
     C                   Eval      toSHDSCD  = fmSHDSCD
     C                   Eval      toSHITYP  = fmSHITYP
     C                   Eval      toSHITAL  = fmSHITAL
     C                   Eval      toSHCMAL  = fmSHCMAL
     C                   Eval      toSHCUTP  = fmSHCUTP
     C                   Eval      toSHLIST  = fmSHLIST
     C                   Write     RSHISTto
     C                   EndIf

     C                   EndSr


     C     ZeroDetails   BegSr
      *  MTD QTY   (SICQ)
     C                   Eval      fmSHCQ01  =   *Zeros
     C                   Eval      fmSHCQ02  =   *Zeros
     C                   Eval      fmSHCQ03  =   *Zeros
     C                   Eval      fmSHCQ04  =   *Zeros
     C                   Eval      fmSHCQ05  =   *Zeros
     C                   Eval      fmSHCQ06  =   *Zeros
     C                   Eval      fmSHCQ07  =   *Zeros
     C                   Eval      fmSHCQ08  =   *Zeros
     C                   Eval      fmSHCQ09  =   *Zeros
     C                   Eval      fmSHCQ10  =   *Zeros
     C                   Eval      fmSHCQ11  =   *Zeros
     C                   Eval      fmSHCQ12  =   *Zeros
     C                   Eval      fmSHCQ13  =   *Zeros
      *  MTD DOL$  (SICS)
     C                   Eval      fmSHCS01  =   *Zeros
     C                   Eval      fmSHCS02  =   *Zeros
     C                   Eval      fmSHCS03  =   *Zeros
     C                   Eval      fmSHCS04  =   *Zeros
     C                   Eval      fmSHCS05  =   *Zeros
     C                   Eval      fmSHCS06  =   *Zeros
     C                   Eval      fmSHCS07  =   *Zeros
     C                   Eval      fmSHCS08  =   *Zeros
     C                   Eval      fmSHCS09  =   *Zeros
     C                   Eval      fmSHCS10  =   *Zeros
     C                   Eval      fmSHCS11  =   *Zeros
     C                   Eval      fmSHCS12  =   *Zeros
     C                   Eval      fmSHCS13  =   *Zeros
      *  Prior MTD QTY   (SILQ)
     C                   Eval      fmSHLQ01  =   *Zeros
     C                   Eval      fmSHLQ02  =   *Zeros
     C                   Eval      fmSHLQ03  =   *Zeros
     C                   Eval      fmSHLQ04  =   *Zeros
     C                   Eval      fmSHLQ05  =   *Zeros
     C                   Eval      fmSHLQ06  =   *Zeros
     C                   Eval      fmSHLQ07  =   *Zeros
     C                   Eval      fmSHLQ08  =   *Zeros
     C                   Eval      fmSHLQ09  =   *Zeros
     C                   Eval      fmSHLQ10  =   *Zeros
     C                   Eval      fmSHLQ11  =   *Zeros
     C                   Eval      fmSHLQ12  =   *Zeros
     C                   Eval      fmSHLQ13  =   *Zeros
      *  Prior MTD DOL$   (SILS)
     C                   Eval      fmSHLS01  =   *Zeros
     C                   Eval      fmSHLS02  =   *Zeros
     C                   Eval      fmSHLS03  =   *Zeros
     C                   Eval      fmSHLS04  =   *Zeros
     C                   Eval      fmSHLS05  =   *Zeros
     C                   Eval      fmSHLS06  =   *Zeros
     C                   Eval      fmSHLS07  =   *Zeros
     C                   Eval      fmSHLS08  =   *Zeros
     C                   Eval      fmSHLS09  =   *Zeros
     C                   Eval      fmSHLS10  =   *Zeros
     C                   Eval      fmSHLS11  =   *Zeros
     C                   Eval      fmSHLS12  =   *Zeros
     C                   Eval      fmSHLS13  =   *Zeros
      *  MTD COST  (SICC)
     C                   Eval      fmSHCC01  =   *Zeros
     C                   Eval      fmSHCC02  =   *Zeros
     C                   Eval      fmSHCC03  =   *Zeros
     C                   Eval      fmSHCC04  =   *Zeros
     C                   Eval      fmSHCC05  =   *Zeros
     C                   Eval      fmSHCC06  =   *Zeros
     C                   Eval      fmSHCC07  =   *Zeros
     C                   Eval      fmSHCC08  =   *Zeros
     C                   Eval      fmSHCC09  =   *Zeros
     C                   Eval      fmSHCC10  =   *Zeros
     C                   Eval      fmSHCC11  =   *Zeros
     C                   Eval      fmSHCC12  =   *Zeros
     C                   Eval      fmSHCC13  =   *Zeros
      *  Prior MTD COST   (SILC)
     C                   Eval      fmSHLC01  =   *Zeros
     C                   Eval      fmSHLC02  =   *Zeros
     C                   Eval      fmSHLC03  =   *Zeros
     C                   Eval      fmSHLC04  =   *Zeros
     C                   Eval      fmSHLC05  =   *Zeros
     C                   Eval      fmSHLC06  =   *Zeros
     C                   Eval      fmSHLC07  =   *Zeros
     C                   Eval      fmSHLC08  =   *Zeros
     C                   Eval      fmSHLC09  =   *Zeros
     C                   Eval      fmSHLC10  =   *Zeros
     C                   Eval      fmSHLC11  =   *Zeros
     C                   Eval      fmSHLC12  =   *Zeros
     C                   Eval      fmSHLC13  =   *Zeros
      *  MTD LBS   (SIC#)
     C                   Eval      fmSHC#01  =   *Zeros
     C                   Eval      fmSHC#02  =   *Zeros
     C                   Eval      fmSHC#03  =   *Zeros
     C                   Eval      fmSHC#04  =   *Zeros
     C                   Eval      fmSHC#05  =   *Zeros
     C                   Eval      fmSHC#06  =   *Zeros
     C                   Eval      fmSHC#07  =   *Zeros
     C                   Eval      fmSHC#08  =   *Zeros
     C                   Eval      fmSHC#09  =   *Zeros
     C                   Eval      fmSHC#10  =   *Zeros
     C                   Eval      fmSHC#11  =   *Zeros
     C                   Eval      fmSHC#12  =   *Zeros
     C                   Eval      fmSHC#13  =   *Zeros
      *  Prior LBS   (SIL#)
     C                   Eval      fmSHL#01  =   *Zeros
     C                   Eval      fmSHL#02  =   *Zeros
     C                   Eval      fmSHL#03  =   *Zeros
     C                   Eval      fmSHL#04  =   *Zeros
     C                   Eval      fmSHL#05  =   *Zeros
     C                   Eval      fmSHL#06  =   *Zeros
     C                   Eval      fmSHL#07  =   *Zeros
     C                   Eval      fmSHL#08  =   *Zeros
     C                   Eval      fmSHL#09  =   *Zeros
     C                   Eval      fmSHL#10  =   *Zeros
     C                   Eval      fmSHL#11  =   *Zeros
     C                   Eval      fmSHL#12  =   *Zeros
     C                   Eval      fmSHL#13  =   *Zeros
      *  Totals
     C                   Eval      fmSHCQTL  =   *Zeros
     C                   Eval      fmSHLQTL  =   *Zeros
     C                   Eval      fmSHCSTL  =   *Zeros
     C                   Eval      fmSHPSTL  =   *Zeros

     C                   Update    RSHISTfm

     C                   EndSr
      *?  ...........................................................
      *?  :      *InzSr - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *InzSr        BegSr                                                  ?

    ?C     *Entry        PList
     C                   Parm                    FMACCT
     C                   Parm                    TOACCT

    ?C                   EndSr                                                  ?
