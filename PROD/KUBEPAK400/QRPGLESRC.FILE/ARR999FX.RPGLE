    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:     Populate the FCUT600 file.                             :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Sep. 2005            ? Kube-Pak Corporation ?    :
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
      *? :  WJB  9/26/05  ?Initial Programming                       ?:
      *? :  ... ../../..  ?..........................................?:
      *? :............................................................:

     FFARHIST   UF   E           K DISK
     FFAROPN    UF A E           K DISK

     D  ItsOpen        S               N   Inz(*Off)
     D  Duplicate      S               N   Inz(*Off)
     D  AddSeq#        S                   Like(ARSEQ#) Inz(000)

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

      *?  Read Through all Open Invoices
    ?C     *LoVal        SetLL     FAROPN
    ?C                   Read(N)   FAROPN
     C                   DoW       not %EOF(FAROPN)
      *?  Determine if History Exists for record that is actually still open
    ?C     HistKey       KList
    ?C                   KFld                    ARCUST
    ?C                   KFld                    ARINV#
    ?C                   KFld                    ARSUFF
    ?C                   KFld                    ARSEQ#

    ?C     HistKey       Chain(N)  FARHIST
     C                   Eval      ItsOpen = %Found(FARHIST)

     C                   If        ItsOpen
     C                   ExSr      BumpSeq#                                     ?Bump Sequence Numbe
     C                   EndIf

    ?C     HistKey       SetGT     FAROPN
    ?C                   Read(N)   FAROPN
     C                   EndDo

     C                   Eval      *InLr = *On

      *?  ...........................................................
      *?  :      BumpSeq# - Bump FAROPN sequence numbers            :
      *?  :.........................................................:

     C     BumpSeq#      BEGSR

      *?  Make sure all open sequence numbers are higher than the History Sequence Number
    ?C     BumpKey       KList
    ?C                   KFld                    ARCUST
    ?C                   KFld                    ARINV#
    ?C                   KFld                    ARSUFF
    ?C     BumpKey       SetGT     FARHIST
    ?C     BumpKey       ReadPE    FARHIST
     C                   Eval      AddSeq# = AHSEQ# + 1
      *?  Bump from Highest Seq # to Lowest to prevent Dups
    ?C     BumpKey       SetGT     FAROPN
    ?C     BumpKey       ReadPE    FAROPN
     C                   DoW       not %EOF(FAROPN)
     C                   Eval      ARSEQ# = ARSEQ# + AddSeq#
     C                   Update    RAROPN
    ?C     BumpKey       ReadPE    FAROPN
     C                   EndDo

     C                   EndSR


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR


     C                   EndSR
