     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:                     Move  Bay Check Out                    :?
      *??:............................................................:?

      * Details
     FFSHIDCI   UF   E           K DISK    Prefix(fm) Rename(RSHIST:RSHISTfm)
     FFSHIST    UF A E           K DISK    Prefix(to) Rename(RSHIST:RSHISTto)

     D  fmACCT         S                   Like(fmSICUST)
     D  toACCT         S                   Like(toSICUST)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User

     C     fmACCT        SETLL     FSHIDCI
     C     fmACCT        READE     FSHIDCI

     C                   DoW       not %EOF(FSHIDCI)

     C                   ExSr      MoveDetails
     C                   ExSr      ZeroDetails

     C     fmACCT        READE     FSHIDCI
     C                   EndDo

     C                   Eval      *InLR = *On




     C     MoveDetails   BegSr

     C     DetailKey     KList
     C                   KFld                    toACCT
     C                   KFld                    fmSIITEM
     C                   KFld                    fmSISIZE
     C                   KFld                    fmSISLSM
     C                   KFld                    fmSICOMP

     C                   Clear                   RSHISTto

     C     DetailKey     Chain     FSHIST

      *  MTD QTY   (SICQ)
     C                   Eval      toSICQ01  = toSICQ01  + fmSICQ01
     C                   Eval      toSICQ02  = toSICQ02  + fmSICQ02
     C                   Eval      toSICQ03  = toSICQ03  + fmSICQ03
     C                   Eval      toSICQ04  = toSICQ04  + fmSICQ04
     C                   Eval      toSICQ05  = toSICQ05  + fmSICQ05
     C                   Eval      toSICQ06  = toSICQ06  + fmSICQ06
     C                   Eval      toSICQ07  = toSICQ07  + fmSICQ07
     C                   Eval      toSICQ08  = toSICQ08  + fmSICQ08
     C                   Eval      toSICQ09  = toSICQ09  + fmSICQ09
     C                   Eval      toSICQ10  = toSICQ10  + fmSICQ10
     C                   Eval      toSICQ11  = toSICQ11  + fmSICQ11
     C                   Eval      toSICQ12  = toSICQ12  + fmSICQ12
     C                   Eval      toSICQ13  = toSICQ13  + fmSICQ13
      *  MTD DOL$  (SICS)
     C                   Eval      toSICS01  = toSICS01  + fmSICS01
     C                   Eval      toSICS02  = toSICS02  + fmSICS02
     C                   Eval      toSICS03  = toSICS03  + fmSICS03
     C                   Eval      toSICS04  = toSICS04  + fmSICS04
     C                   Eval      toSICS05  = toSICS05  + fmSICS05
     C                   Eval      toSICS06  = toSICS06  + fmSICS06
     C                   Eval      toSICS07  = toSICS07  + fmSICS07
     C                   Eval      toSICS08  = toSICS08  + fmSICS08
     C                   Eval      toSICS09  = toSICS09  + fmSICS09
     C                   Eval      toSICS10  = toSICS10  + fmSICS10
     C                   Eval      toSICS11  = toSICS11  + fmSICS11
     C                   Eval      toSICS12  = toSICS12  + fmSICS12
     C                   Eval      toSICS13  = toSICS13  + fmSICS13
      *  Prior MTD QTY   (SILQ)
     C                   Eval      toSILQ01  = toSILQ01  + fmSILQ01
     C                   Eval      toSILQ02  = toSILQ02  + fmSILQ02
     C                   Eval      toSILQ03  = toSILQ03  + fmSILQ03
     C                   Eval      toSILQ04  = toSILQ04  + fmSILQ04
     C                   Eval      toSILQ05  = toSILQ05  + fmSILQ05
     C                   Eval      toSILQ06  = toSILQ06  + fmSILQ06
     C                   Eval      toSILQ07  = toSILQ07  + fmSILQ07
     C                   Eval      toSILQ08  = toSILQ08  + fmSILQ08
     C                   Eval      toSILQ09  = toSILQ09  + fmSILQ09
     C                   Eval      toSILQ10  = toSILQ10  + fmSILQ10
     C                   Eval      toSILQ11  = toSILQ11  + fmSILQ11
     C                   Eval      toSILQ12  = toSILQ12  + fmSILQ12
     C                   Eval      toSILQ13  = toSILQ13  + fmSILQ13
      *  Prior MTD DOL$   (SILS)
     C                   Eval      toSILS01  = toSILS01  + fmSILS01
     C                   Eval      toSILS02  = toSILS02  + fmSILS02
     C                   Eval      toSILS03  = toSILS03  + fmSILS03
     C                   Eval      toSILS04  = toSILS04  + fmSILS04
     C                   Eval      toSILS05  = toSILS05  + fmSILS05
     C                   Eval      toSILS06  = toSILS06  + fmSILS06
     C                   Eval      toSILS07  = toSILS07  + fmSILS07
     C                   Eval      toSILS08  = toSILS08  + fmSILS08
     C                   Eval      toSILS09  = toSILS09  + fmSILS09
     C                   Eval      toSILS10  = toSILS10  + fmSILS10
     C                   Eval      toSILS11  = toSILS11  + fmSILS11
     C                   Eval      toSILS12  = toSILS12  + fmSILS12
     C                   Eval      toSILS13  = toSILS13  + fmSILS13
      *  MTD COST  (SICC)
     C                   Eval      toSICC01  = toSICC01  + fmSICC01
     C                   Eval      toSICC02  = toSICC02  + fmSICC02
     C                   Eval      toSICC03  = toSICC03  + fmSICC03
     C                   Eval      toSICC04  = toSICC04  + fmSICC04
     C                   Eval      toSICC05  = toSICC05  + fmSICC05
     C                   Eval      toSICC06  = toSICC06  + fmSICC06
     C                   Eval      toSICC07  = toSICC07  + fmSICC07
     C                   Eval      toSICC08  = toSICC08  + fmSICC08
     C                   Eval      toSICC09  = toSICC09  + fmSICC09
     C                   Eval      toSICC10  = toSICC10  + fmSICC10
     C                   Eval      toSICC11  = toSICC11  + fmSICC11
     C                   Eval      toSICC12  = toSICC12  + fmSICC12
     C                   Eval      toSICC13  = toSICC13  + fmSICC13
      *  Prior MTD COST   (SILC)
     C                   Eval      toSILC01  = toSILC01  + fmSILC01
     C                   Eval      toSILC02  = toSILC02  + fmSILC02
     C                   Eval      toSILC03  = toSILC03  + fmSILC03
     C                   Eval      toSILC04  = toSILC04  + fmSILC04
     C                   Eval      toSILC05  = toSILC05  + fmSILC05
     C                   Eval      toSILC06  = toSILC06  + fmSILC06
     C                   Eval      toSILC07  = toSILC07  + fmSILC07
     C                   Eval      toSILC08  = toSILC08  + fmSILC08
     C                   Eval      toSILC09  = toSILC09  + fmSILC09
     C                   Eval      toSILC10  = toSILC10  + fmSILC10
     C                   Eval      toSILC11  = toSILC11  + fmSILC11
     C                   Eval      toSILC12  = toSILC12  + fmSILC12
     C                   Eval      toSILC13  = toSILC13  + fmSILC13
      *  MTD LBS   (SIC#)
     C                   Eval      toSIC#01  = toSIC#01  + fmSIC#01
     C                   Eval      toSIC#02  = toSIC#02  + fmSIC#02
     C                   Eval      toSIC#03  = toSIC#03  + fmSIC#03
     C                   Eval      toSIC#04  = toSIC#04  + fmSIC#04
     C                   Eval      toSIC#05  = toSIC#05  + fmSIC#05
     C                   Eval      toSIC#06  = toSIC#06  + fmSIC#06
     C                   Eval      toSIC#07  = toSIC#07  + fmSIC#07
     C                   Eval      toSIC#08  = toSIC#08  + fmSIC#08
     C                   Eval      toSIC#09  = toSIC#09  + fmSIC#09
     C                   Eval      toSIC#10  = toSIC#10  + fmSIC#10
     C                   Eval      toSIC#11  = toSIC#11  + fmSIC#11
     C                   Eval      toSIC#12  = toSIC#12  + fmSIC#12
     C                   Eval      toSIC#13  = toSIC#13  + fmSIC#13
      *  Prior LBS   (SIL#)
     C                   Eval      toSIL#01  = toSIL#01  + fmSIL#01
     C                   Eval      toSIL#02  = toSIL#02  + fmSIL#02
     C                   Eval      toSIL#03  = toSIL#03  + fmSIL#03
     C                   Eval      toSIL#04  = toSIL#04  + fmSIL#04
     C                   Eval      toSIL#05  = toSIL#05  + fmSIL#05
     C                   Eval      toSIL#06  = toSIL#06  + fmSIL#06
     C                   Eval      toSIL#07  = toSIL#07  + fmSIL#07
     C                   Eval      toSIL#08  = toSIL#08  + fmSIL#08
     C                   Eval      toSIL#09  = toSIL#09  + fmSIL#09
     C                   Eval      toSIL#10  = toSIL#10  + fmSIL#10
     C                   Eval      toSIL#11  = toSIL#11  + fmSIL#11
     C                   Eval      toSIL#12  = toSIL#12  + fmSIL#12
     C                   Eval      toSIL#13  = toSIL#13  + fmSIL#13
      *  Totals
     C                   Eval      toSICQTL  = toSICQTL  + fmSICQTL
     C                   Eval      toSILQTL  = toSILQTL  + fmSILQTL
     C                   Eval      toSICSTL  = toSICSTL  + fmSICSTL
     C                   Eval      toSIPSTL  = toSIPSTL  + fmSIPSTL

     C                   Eval      toSIDTLA  = $MDYDate($Date(0))
     C                   Eval      toSITIME  = $Now()
     C                   Eval      toSIUSER  = $User()

     C                   If        %Found(FSHIST)
     C                   Update    RSHISTto
     C                   Else
     C                   Eval      toSISTAT  = fmSISTAT
     C                   Eval      toSICUST  = toACCT
     C                   Eval      toSIITEM  = fmSIITEM
     C                   Eval      toSISIZE  = fmSISIZE
     C                   Eval      toSISLSM  = fmSISLSM
     C                   Eval      toSICOMP  = fmSICOMP
     C                   Eval      toSITERR  = fmSITERR
     C                   Eval      toSIPCL1  = fmSIPCL1
     C                   Eval      toSIPCL2  = fmSIPCL2
     C                   Eval      toSIPCL3  = fmSIPCL3
     C                   Eval      toSIDSCD  = fmSIDSCD
     C                   Eval      toSIITYP  = fmSIITYP
     C                   Eval      toSIITAL  = fmSIITAL
     C                   Eval      toSICMAL  = fmSICMAL
     C                   Eval      toSICUTP  = fmSICUTP
     C                   Eval      toSILIST  = fmSILIST
     C                   Write     RSHISTto
     C                   EndIf

     C                   EndSr


     C     ZeroDetails   BegSr
      *  MTD QTY   (SICQ)
     C                   Eval      fmSICQ01  =   *Zeros
     C                   Eval      fmSICQ02  =   *Zeros
     C                   Eval      fmSICQ03  =   *Zeros
     C                   Eval      fmSICQ04  =   *Zeros
     C                   Eval      fmSICQ05  =   *Zeros
     C                   Eval      fmSICQ06  =   *Zeros
     C                   Eval      fmSICQ07  =   *Zeros
     C                   Eval      fmSICQ08  =   *Zeros
     C                   Eval      fmSICQ09  =   *Zeros
     C                   Eval      fmSICQ10  =   *Zeros
     C                   Eval      fmSICQ11  =   *Zeros
     C                   Eval      fmSICQ12  =   *Zeros
     C                   Eval      fmSICQ13  =   *Zeros
      *  MTD DOL$  (SICS)
     C                   Eval      fmSICS01  =   *Zeros
     C                   Eval      fmSICS02  =   *Zeros
     C                   Eval      fmSICS03  =   *Zeros
     C                   Eval      fmSICS04  =   *Zeros
     C                   Eval      fmSICS05  =   *Zeros
     C                   Eval      fmSICS06  =   *Zeros
     C                   Eval      fmSICS07  =   *Zeros
     C                   Eval      fmSICS08  =   *Zeros
     C                   Eval      fmSICS09  =   *Zeros
     C                   Eval      fmSICS10  =   *Zeros
     C                   Eval      fmSICS11  =   *Zeros
     C                   Eval      fmSICS12  =   *Zeros
     C                   Eval      fmSICS13  =   *Zeros
      *  Prior MTD QTY   (SILQ)
     C                   Eval      fmSILQ01  =   *Zeros
     C                   Eval      fmSILQ02  =   *Zeros
     C                   Eval      fmSILQ03  =   *Zeros
     C                   Eval      fmSILQ04  =   *Zeros
     C                   Eval      fmSILQ05  =   *Zeros
     C                   Eval      fmSILQ06  =   *Zeros
     C                   Eval      fmSILQ07  =   *Zeros
     C                   Eval      fmSILQ08  =   *Zeros
     C                   Eval      fmSILQ09  =   *Zeros
     C                   Eval      fmSILQ10  =   *Zeros
     C                   Eval      fmSILQ11  =   *Zeros
     C                   Eval      fmSILQ12  =   *Zeros
     C                   Eval      fmSILQ13  =   *Zeros
      *  Prior MTD DOL$   (SILS)
     C                   Eval      fmSILS01  =   *Zeros
     C                   Eval      fmSILS02  =   *Zeros
     C                   Eval      fmSILS03  =   *Zeros
     C                   Eval      fmSILS04  =   *Zeros
     C                   Eval      fmSILS05  =   *Zeros
     C                   Eval      fmSILS06  =   *Zeros
     C                   Eval      fmSILS07  =   *Zeros
     C                   Eval      fmSILS08  =   *Zeros
     C                   Eval      fmSILS09  =   *Zeros
     C                   Eval      fmSILS10  =   *Zeros
     C                   Eval      fmSILS11  =   *Zeros
     C                   Eval      fmSILS12  =   *Zeros
     C                   Eval      fmSILS13  =   *Zeros
      *  MTD COST  (SICC)
     C                   Eval      fmSICC01  =   *Zeros
     C                   Eval      fmSICC02  =   *Zeros
     C                   Eval      fmSICC03  =   *Zeros
     C                   Eval      fmSICC04  =   *Zeros
     C                   Eval      fmSICC05  =   *Zeros
     C                   Eval      fmSICC06  =   *Zeros
     C                   Eval      fmSICC07  =   *Zeros
     C                   Eval      fmSICC08  =   *Zeros
     C                   Eval      fmSICC09  =   *Zeros
     C                   Eval      fmSICC10  =   *Zeros
     C                   Eval      fmSICC11  =   *Zeros
     C                   Eval      fmSICC12  =   *Zeros
     C                   Eval      fmSICC13  =   *Zeros
      *  Prior MTD COST   (SILC)
     C                   Eval      fmSILC01  =   *Zeros
     C                   Eval      fmSILC02  =   *Zeros
     C                   Eval      fmSILC03  =   *Zeros
     C                   Eval      fmSILC04  =   *Zeros
     C                   Eval      fmSILC05  =   *Zeros
     C                   Eval      fmSILC06  =   *Zeros
     C                   Eval      fmSILC07  =   *Zeros
     C                   Eval      fmSILC08  =   *Zeros
     C                   Eval      fmSILC09  =   *Zeros
     C                   Eval      fmSILC10  =   *Zeros
     C                   Eval      fmSILC11  =   *Zeros
     C                   Eval      fmSILC12  =   *Zeros
     C                   Eval      fmSILC13  =   *Zeros
      *  MTD LBS   (SIC#)
     C                   Eval      fmSIC#01  =   *Zeros
     C                   Eval      fmSIC#02  =   *Zeros
     C                   Eval      fmSIC#03  =   *Zeros
     C                   Eval      fmSIC#04  =   *Zeros
     C                   Eval      fmSIC#05  =   *Zeros
     C                   Eval      fmSIC#06  =   *Zeros
     C                   Eval      fmSIC#07  =   *Zeros
     C                   Eval      fmSIC#08  =   *Zeros
     C                   Eval      fmSIC#09  =   *Zeros
     C                   Eval      fmSIC#10  =   *Zeros
     C                   Eval      fmSIC#11  =   *Zeros
     C                   Eval      fmSIC#12  =   *Zeros
     C                   Eval      fmSIC#13  =   *Zeros
      *  Prior LBS   (SIL#)
     C                   Eval      fmSIL#01  =   *Zeros
     C                   Eval      fmSIL#02  =   *Zeros
     C                   Eval      fmSIL#03  =   *Zeros
     C                   Eval      fmSIL#04  =   *Zeros
     C                   Eval      fmSIL#05  =   *Zeros
     C                   Eval      fmSIL#06  =   *Zeros
     C                   Eval      fmSIL#07  =   *Zeros
     C                   Eval      fmSIL#08  =   *Zeros
     C                   Eval      fmSIL#09  =   *Zeros
     C                   Eval      fmSIL#10  =   *Zeros
     C                   Eval      fmSIL#11  =   *Zeros
     C                   Eval      fmSIL#12  =   *Zeros
     C                   Eval      fmSIL#13  =   *Zeros
      *  Totals
     C                   Eval      fmSICQTL  =   *Zeros
     C                   Eval      fmSILQTL  =   *Zeros
     C                   Eval      fmSICSTL  =   *Zeros
     C                   Eval      fmSIPSTL  =   *Zeros

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
