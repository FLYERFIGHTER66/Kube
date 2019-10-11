    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:     Populate the REP010PF file.                            :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2007            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program replace two queries.  CUR600QRY and        ?:
      *? : CUR600QRYA.                                               ?:
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
      *? : Int   Date  ?-Change Description                     ?  ?:
      *? :  WJB 10/22/07  ?Initial Programming                       ?:
      *? :  ... ../../..  ?..........................................?:
      *? :............................................................:

     FFDLOTRDY  IF   E           K DISK
     FREADYFW   UF A E           K DISK

     D  Monday         S               D
     D  TIMENOW        S               T
     D  X              S              1S 0
     D  LastLRCRDY     S                   Like(LRCRDY)
     D  PartPCT        S              4S 1
     D  ShowPartials   S               N   Inz(*On)
     D  LRITEMo        S                   Like(LRITEM)

     D  QtyDS          DS
     D  QTAVW1                             Like(QTAVW2)
     D  QTAVW2
     D  QTAVW3
     D  QTAVW4
     D  QTAVW5
     D   Qty                          7S 0 Overlay(QtyDS) Dim(5)

     D  WeeksDS        DS
     D  Mon1                          7S 0
     D  Mon2                          7S 0
     D  Mon3                          7S 0
     D  Mon4                          7S 0
     D  Mon5                          7S 0
     D   Weeks                        7S 0 Overlay(WeeksDS) Dim(5) Ascend

     D/Copy QFunctDefn,$Now
     D/Copy QFunctDefn,$Date
     D/Copy QFunctDefn,$AddDate
     D/Copy QFunctDefn,$DateMDY
     D/Copy QFunctDefn,$Date7
     D/Copy QFunctDefn,$Monday
     D/Copy QFunctDefn,$ItemDesc

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

     C     Mon1          SetLL     FDLOTRDY
     C                   Read      FDLOTRDY

     C                   DoW       not %EOF(FDLOTRDY) and
     C                             LRCRDY <= Mon5
                     //? Add to list if there is Availability
     C*                  If        LRQTAV  <> 0 and LRGLOC <> 'N' and
     C*                            (LRCUST < 999990
     C*                            or (LRCUST = 999997 and ShowPartials and
     C*                                LRGLOC <> '997'))

      /Free

         //    ? Add to list if there is Availability
         If    ( LRQTAV > 0 and LRGLOC = 'R' or
                 LRQTAV > 1 and LRGLOC <>'R' )
          and    LRGLOC <> 'N'
          and  ( LRCUST < 999990 or
               ( LRCUST = 999997 and ShowPartials and LRGLOC <> '997'));

      /End-Free

     C                   If        LRCRDY <> LastLRCRDY
     C                   Eval      LastLRCRDY = LRCRDY

      *                  Set x for the week the inventory is in.
     C                   Eval      x = 1
     C                   DoW       LRCRDY <> Weeks(x)
     C                   Eval      x = x + 1
     C                   EndDo

     C                   EndIf

     C                   Clear                   FutureR
     C                   Eval      LRITEMo = LRITEM
     C                   If        LRCUST = 999997  and ShowPartials
      /FREE
         //? Get Partial Totals
         exec sql
           SELECT  LDPRTT * 100
           INTO    :PartPCT
           FROM    FLOSSLOT
           WHERE   LDITEM=:LRITEM
             and   LDSIZE=:LRSIZE
             and   LDSOWD=:LRSOWD
             and   LDREDY=:LRCRDY
             and   LDGLOC='R'      ;
         LRITEM = %Trim(LRITEM)+'P';
         If LRQTOH >= LRQTAL;
           LRQTOH = %Int(PartPCT);
          Else;
           LRQTOH = *Zero;
         EndIf;
         LRQTAL = *Zero;

      /END-FREE
     C                   EndIf
     C     ItemSize      Chain     ReadyFW
     C*                  Eval      Qty(x) = Qty(x) + LRQTAV
     C                   Eval      Qty(x) = Qty(x) + LRQTOH - LRQTAL
     C                   If        %Found(ReadyFW)
     C                   Update    FutureR
     C                   Else
     C                   Eval      ITEM   = LRITEM
     C                   Eval      SIZE   = LRSIZE
     C*                  Eval      DES1   = LRDESC
     C                   Eval      DES1   = $ItemDesc(LRITEMo:LRSIZE)
     C                   Eval      DATE   = $Date(0)
     C                   Eval      TIME   = TIMENOW
     C                   Write     FutureR
     C                   EndIF
     C                   EndIF

     C                   Read      FDLOTRDY
     C                   EndDo

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C     ItemSize      KList
     C                   KFld                    LRItem
     C                   KFld                    LRSize

     C                   Eval      Monday = $Monday($Date(0):'FRI')
     C                   Eval      Mon1 = $Date7($AddDate(Monday:7))
     C                   Eval      Mon2 = $Date7($AddDate(Monday:14))
     C                   Eval      Mon3 = $Date7($AddDate(Monday:21))
     C                   Eval      Mon4 = $Date7($AddDate(Monday:28))
     C                   Eval      Mon5 = $Date7($AddDate(Monday:35))
     C                   Time                    TIMENOW

     C                   EndSR
