    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *??:````````````````````````````````````````````````````````````:?
      *??:     Assign People to Apply Chemicals                       :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Dec. 2004            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program replaces CHR060.  This program allows      ?:
      *? : the growers to make Chem. Application Assignments to the  ?:
      *? : people spraying.                                          ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? : Subroutine ?-Subroutine Description                  ?  ?:
      *? :  *INZSR      -?Initialization Subroutine                  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? : Function   ?-Function Description                    ?  ?:
      *? :  $Date        ?Get Date Value                             ?:
      *? :  $DateMDY     ?Get Date Number in MM/DD/YY                ?:
      *? :  $Monday      ?Get Monday Date Value                      ?:
      *? :  $AddDate     ?Add/Subtract Days from Date                ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : Date    Int  Change Description                         ?:
      *? : 03/23/05 WB01 ?Add Ounces to Print Function               ?:
      *? :............................................................:

     FFGLDETDT  IP   E           K DISK
     FFSUMMARY  UF A E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$Date8
    ?D/COPY QFunctDefn,$DotW
    ?D/COPY QFunctDefn,$Upper

      *? Data Structures

      *? Program Data Structure
     D                SDS
     D  PROGID                 1     10                                         ?PROGRAM NAME
     D  RLIBR                 81     90                                         ?RUN LIBRARY
     D  USERID               254    263                                         ?USER I.D.
     D  SLIBR                314    323                                         ?SOURCE LIBRARY

      *? Field Definitions
     D  KeyDate        S                   Like(SMDATE) Inz(0)
     D  LastDate       S                   Like(SMDATE) Inz(0)
     D  Temp           S              3S 0 Inz(0)

      *?  ...........................................................
      *?  :      C A L C U L A T I O N S                            :
      *?  :.........................................................:

WHT  C                   If           GTACCT = 10500000                         |Cash Account
WHT  C                             or GTACCT = 15000000                         |Account Recievable
     C                   Eval      KeyDate = $Date8($DateMDY(GTTDAT))
    ?C     KeyDate       Chain     FSummary
     C                   If        KeyDate <> LastDate or not %Found(FSummary)
     C                   Clear                   RSummary
     C                   Eval      SMDATE = KeyDate
     C                   Eval      SMDOTW = $DotW($DateMDY(GTTDAT))
     C                   Eval      LastDate = KeyDate
     C                   EndIf
    ?C                   Select
      *?  Process Cash Account (1050-0000) records from G/L
    ?C                   When      GTACCT = 10500000
    ?C                   Select
      *?  Cash Account (1050-0000) records from A/P
    ?C                   When      GTSRCE = 'A/P'
     C                   Eval      SMAP = SMAP + GTDOL$
      *?  Cash Account (1050-0000) records from A/R
    ?C                   When      GTSRCE = 'A/R'
     C                   Eval      SMAR = SMAR + GTDOL$
      *?  Cash Account (1050-0000) records from J/E
    ?C                   When      GTSRCE = 'J/E'
     C                   Eval      SMJE = SMJE + GTDOL$
    ?C                   Eval      GTJEDS = $Upper(GTJEDS)
    ?C                   Select
      *?           J/E for Cash Reciepts
    ?C                   When      %Scan('CASH RECEIPTS':GTJEDS) > 0
     C                   Eval      SMCASH = SMCASH + GTDOL$
      *?           J/E for Payroll
    ?C                   When      %Scan('PAYROLL':GTJEDS) > 0
     C                   Eval      SMPAY = SMPAY + GTDOL$
      *?           J/E for Petty Cash
    ?C                   When      %Scan('PETTY CASH':GTJEDS) > 0
     C                   Eval      SMPETY = SMPETY + GTDOL$
      *?           J/E not otherwise catagorized
    ?C                   Other
     C                   Eval      SMJEOT = SMJEOT + GTDOL$
    ?C                   EndSL
    ?C                   Other
     C                   Eval      SMOTHR = SMOTHR + GTDOL$
    ?C                   EndSL
      *?  Process Accounts Recievable (1500-0000) records from G/L
    ?C                   When      GTACCT = 15000000
     C                   Eval      SMGLAR = SMGLAR + GTDOL$
    ?C                   EndSL
     C                   If        %Found(FSummary)
    ?C                   Update    RSummary
     C                   Else
    ?C                   Write     RSummary
     C                   EndIf
     C                   EndIf
