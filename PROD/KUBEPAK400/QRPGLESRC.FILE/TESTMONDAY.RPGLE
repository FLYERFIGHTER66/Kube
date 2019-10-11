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

     FTESTMONDAYCF   E             WORKSTN

     D  Start          S               D
     D  X              S              1S 0

     D   DAT_DS        DS                  INZ
     D  DAT01
     D  DAT02
     D  DAT03
     D  DAT04
     D  DAT05
     D  DAT06
     D  DAT07
     D  DAT08
     D   DAT                          6S 0 Dim(8) Overlay(DAT_DS)

     D   WKD_DS        DS                  INZ
     D  WKD01
     D  WKD02
     D  WKD03
     D  WKD04
     D  WKD05
     D  WKD06
     D  WKD07
     D  WKD08
     D   WKD                          9A   Dim(8) Overlay(WKD_DS)

     D   MON_DS        DS                  INZ
     D  MON01
     D  MON02
     D  MON03
     D  MON04
     D  MON05
     D  MON06
     D  MON07
     D  MON08
     D   MON                          6S 0 Dim(8) Overlay(MON_DS)

     D/Copy QFunctDefn,$Date
     D/Copy QFunctDefn,$DOTW
     D/Copy QFunctDefn,$AddDate
     D/Copy QFunctDefn,$DateMDY
     D/Copy QFunctDefn,$MDYDate
     D/Copy QFunctDefn,$Monday

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

     C                   DoW       not *In03
     C                   ExFmt     Monday
     C                   ExSr      Calculate
     C                   EndDo
     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      Calculate - Calculate the Mondays                  :
      *?  :.........................................................:

     C     Calculate     BegSR

      *?  Calculate the $Monday for Each Start Date
     C                   Eval      X = *Zero
     C                   Eval      Start = $AddDate($DateMDY(StartDate):-1)
     C                   DoW       X < 8
     C                   Eval      X = X + 1
     C                   Eval      DAT(X) = $MDYDate($AddDate(Start:X))
     C                   Eval      WKD(X) = $DOTW($DateMDY(DAT(X)))
     C                   Eval      MON(X) =
     C                             $MDYDate($Monday($DateMDY(DAT(X)):STARTON))
     C                   EndDo

     C                   EndSR

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C                   Eval      StartDate = $MDYDate($Date(0))

     C                   EndSR
