    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

     FFIORDRSD  UF   E           K DISK
     FFALITEM   UF A E           K DISK
     FFMSIZCPLUGIF   E           K DISK

     D  SaveOrder      S                   like(OIORD#)
     D  ShipDate7      S                   like(OIRVDT)
     D  ShipDate7@     S              7A

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$DateMDY

     C     *Entry        PList
     C                   Parm                    ShipDate7@

     C                   Eval      ShipDate7 = %Int(ShipDate7@)

      *  Read through all Orders for a given Week
     C     ShipDate7     SetLL     FIORDRSD
     C     ShipDate7     ReadE     FIORDRSD
     C                   DoW       not %EOF(FIORDRSD)

      *  First Clear FALITEM if new Order
     C                   If        SaveOrder <> OIORD#
     C                   Eval      SaveOrder =  OIORD#
     C                   ExSr      ClrFALITEM
     C                   EndIf

     C     OISIZE        SetLL     FMSIZCPLUG

      *  Process all lines that are PLUG items
     C                   If        %Equal(FMSIZCPLUG) and OISTAT = 'A'

      *  If this should be a lot Control Order, Change it.
     C                   If        OILOTC <> 'Y' and
     C                             OISOW  <= $Date7($AddDate($Date(0):-6))
     C                   Eval      OILOTC =  'Y'
     C                   Update    RIORDR
     C                   EndIf

      *  Make sure FALITEM record doesn't exist (Backorders wont be cleared in SR ClrFALITEM)
     C     FALKEY        KList
     C                   KFld                    OIORD#
     C                   KFld                    OISEQ#
     C     FALKEY        SetLL     FALITEM
     C                   If        %Equal(FALITEM)
     C     FALKEY        Chain     FALITEM
     C                   Delete    RALITEM
     C                   EndIf

      *  Map fields from FIORDR to FALITEM
     C                   Eval      AIORD# = OIORD#                              ORDER NUMBER
     C                   Eval      AIOSEQ = OISEQ#                              ORDER SEQ #
     C                   If        OIBOLN = 'Y'
     C                   Eval      AISHPD = $Date7($DateMDY(OIBORQ))            Orig. B/O Date
     C                   Else
     C                   Eval      AISHPD = OIRVDT                              SHIP DATE CYMD
     C                   EndIf
     C                   Eval      AISTAT = OISTAT                              STATUS A/D/C
     C                   Eval      AIITEM = OIITEM                              ITEM #
     C                   Eval      AISIZE = OISIZE                              SIZE CODE
     C                   Eval      AIWHSE = OIWHSE                              LOCATION
     C                   Eval      AISOWD = OISOW                               SOW DATE CYMD
     C                   If        OILOT# = *Blanks
     C                   Eval      AIGLOC = 'R'                                 GROW LOC. ORIG
     C                   Else
     C                   Eval      AIGLOC = *Blanks                             GROW LOC. ORIG
     C                   EndIf
     C                   Eval      AIGLOC = *Blanks                             GROW LOC. ORIG
     C                   Eval      AIPHYT = *Blanks                             PHYTO CODE
     C                   Eval      AICRDY = OIRVDT                              CURR READY DATE CYMD
     C                   Eval      AICUST = OICUST                              RESERV. CUST #
     C                   Eval      AICOMP = OICOMP                              COMPANY NO
     C                   Eval      AIQTOA = OIQORD - OIQSHP                     QTY ALLOC
     C                   Eval      AIDTLA = $MDYDate($Date(0))                  LAST ACTIVITY DATE
     C                   Eval      AITIME = $Now()                              TIME
     C                   Eval      AIUSER = 'FIXFALITEM'                        USER
     C                   Eval      AIPRCL = OIPRCL                              PRODUCT CLASS

     C                   If        AIQTOA <> *Zero and
     C                             AISOWD <= $Date7($AddDate($Date(0):-6))
     C                   Write     RALITEM
     C                   EndIf

     C                   EndIf
     C     ShipDate7     ReadE     FIORDRSD
     C                   EndDo
     C                   Eval      *InLR = *On
      *------------------------------------------------------------------------
     C     ClrFALITEM    BegSr
     C     OIORD#        SetLL     FALITEM
     C     OIORD#        ReadE     FALITEM
     C                   DoW       not %EOF(FALITEM)
     C                   If        AISHPD = ShipDate7
     C                   Delete    RALITEM
     C                   EndIf
     C     OIORD#        ReadE     FALITEM
     C                   EndDo
     C                   EndSr
