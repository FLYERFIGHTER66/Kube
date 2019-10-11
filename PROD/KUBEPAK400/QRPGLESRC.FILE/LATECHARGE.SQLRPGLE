    ?H DftActGrp(*no)
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DatFmt(*usa)
    ?H/COPY QFunctDefn,@CopyRight
      *??:````````````````````````````````````````````````````````````:?
      *??:       Monthly Late Charges (Assessed Daily)                :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Jube 2004            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :  put description here                                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :  *INZSR   -?Initialization Subroutine                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

      *? File Definitions
     FWMCUST    IF   E           K DISK
     FFAROPNDD  IF   E           K DISK
     F                                     RENAME(RAROPN:AROPNI)
     F*AROPN  UF  E           K        DISK                      A
     FFARCTL    IF   E           K DISK
     FFARLC     UF A E           K DISK
     FFARLCD    UF A E           K DISK
     FFSTATUS   UF A E           K DISK
     FFMTRAN    UF A E           K DISK

      *? Array Definitions
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)              ?Messages

      *? Indicatior Definitions
     D  $Include       S               N   Inz(*On)                             ?Include the Account
     D  NextReqd       S               N   Inz(*On)                             ?Next Date Processin

      *? Field Definitions
     D  DaysOld        S              4S 0 Inz(*Zero)                           ?Days old for invoic
     D  AgeDays        S              4S 0 Inz(*Zero)                           ?Days old for invoic
     D  LDATEC         S              7S 0 Inz(*Zero)                           ?Run as Date cyymmdd
     D  InvDue$        S                   Inz(*Zero) Like(ARDUE$)              ?Invoice Due Amount
     D  GraceDays      S              3S 0 Inz(*Zero)                           ?Days Grace Period

      *? Data Structures
     D                SDS
     D  PROGID                 1     10                                         ?PROGRAM NAME
     D  RLIBR                 81     90                                         ?RUN LIBRARY
     D  USERID               254    263                                         ?USER I.D.
     D  SLIBR                314    323                                         ?SOURCE LIBRARY

     D                UDS
     D  LDATE                  1      6  0                                      ?L/C Calc Date
     D  LDATE@                 1      6                                         ?L/C Calc Date Alpha
     D  LCANCL               133    133                                         ?Cancel Processing

     D                 DS
     D  CCYYMM                 1      6  0                                      ?Cent. Year Month
     D    YYMM                 3      6  0                                      ?Year Month

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$Duration
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Month
    ?D/COPY QFunctDefn,$Year
      *? External Program Prototypes
    ?D*COPY QFunctDefn,QCmdExc

      *?  ...........................................................
      *?  :   C A L C U L A T I O N S                               :
      *?  :.........................................................:

    ?C     *LoVal        SETLL     WMCUST
    ?C                   READ      WMCUST                                 90

     C                   DoW       not %EOF(WMCUST)
     C* - - - - - - - - -ExSr- - - Include- - - - - - - - - - - - - - - - - -
     C                   If            CMAPLC <> 'B'                            ?Brokers
     C                             and CMAPLC <> 'N'                            ?No L/C
     C                             and $Include                                 ?Include Account

     C                   ExSr      GetBal                                       ?Determine Open Bal.

     C                   If        CustBal > *Zero
     C                   ExSr      Process
     C                   EndIf

     C                   EndIf

    ?C                   READ      WMCUST                                 90
     C                   EndDo

     C                   If        NextReqd                                     |Next Date Process
     C                             and $DateMDY(LDATE) >= $Date(0)
     C                             or not NextReqd
     C                   ExSr      ExitSR
     C                   Else
     C                   Eval      LDATE= $MDYDate($AddDate($DateMDY(LDATE):1))
     C                   ExSr      FmtDates
     C                   EndIf

      *?  ...........................................................
      *?  :      GETBAL - Get the Customer Balance                  :
      *?  :.........................................................:

     C     GETBAL        BEGSR
      * ?This routine determines if the Customer has an open balance and also
      * ?determines how much credit is on the Account.

     C                   Z-ADD     0             CustBal          11 2
     C                   Z-ADD     0             CashOnHand       11 2

    ?C     CMCUST        SETLL     FAROPNDD
    ?C     CMCUST        READE     FAROPNDD
     C                   DoW       not %EOF(FAROPNDD)
      * ?Add up all transactions except Late Charges
     C                   If        ARTTYP <> 7
     C                   ADD       AR$AMT        CustBal
      * ?Add up all O/A and C/M transactions.
     C                   If        ARSUFF = 'CM' or ARSUFF = 'OA'
     C                   ADD       AR$AMT        CashOnHand
     C                   EndIf
     C                   EndIf
    ?C     CMCUST        READE     FAROPNDD
     C                   EndDo

     C                   ENDSR

      *?  ...........................................................
      *?  :      Process - Process A/R open for Late Charges        :
      *?  :.........................................................:

     C     Process       BEGSR

     C                   Z-SUB     CashOnHand    BalCashOH        11 2          ?Balance Cash OnHand

    ?C     CMCUST        SETLL     FAROPNDD
    ?C     CMCUST        READE     FAROPNDD                               91

     C                   DoW       not %EOF(FAROPNDD)
      /Free
         GraceDays = 0;
         Exec SQL  // Get the number of grace days from the term code on the invoice header
           SELECT  TCTDGP
           INTO   :GraceDays
           FROM    FMTERMAD
              ,    FHORDW
           WHERE   TCTERM=WHTMCD
             and   WHINV#=:ARINV#;
      /End-Free
     C                   Eval      DaysOld =                                    ?Invoice Days Old
     C                             $Duration($Date(ARDUDT):$DateMDY(LDATE):'D') ?compared to LDATE
     C                   Eval      AgeDays = DaysOld -GraceDays                 ?Days past due
     C     AgeDays       Div       30            Temp              4 0
     C                   MVR                     Temp
     C                   If            ARSEQ# = *Zero
     C                             and ARDUE$ <> *Zero                          ?Has an open Balance
     C                             and (ARTTYP = 1 or ARTTYP = 12)              ?is Invoice or RetCk
     C                             and AgeDays >= ACLCD#                        ?Old enough 2 get LC
     C                             and Temp = 0                                 ?0 means div by 30

     C                   Z-add     ARDUE$        InvDue$

     C                   If        BalCashOH >= ARDUE$
    ? *                  No Late Charges Due
     C                   SUB       ARDUE$        BalCashOH
     C                   Else
    ? *                  Late Charges are Due Subtract Balance of Cash On Hand
     C                   SUB       BalCashOH     ARDUE$
     C                   Z-ADD     0             BalCashOH
     C                   ExSr      CalcLC
     C                   EndIf

     C                   EndIf
    ?C     CMCUST        READE     FAROPNDD                               91
     C                   EndDo

     C                   EndSr

      *?  ...........................................................
      *?  :      CalcLC - Calculate Late Charge                     :
      *?  :.........................................................:

     C     CalcLC        BEGSR

      *?   Check if a late charge has been processed is for this date.
    ?C     LDKEY         SetLL     FARLCD
     C                   If        not %Equal(FARLCD)
     C     ARDUE$        MULT(H)   BPCT          WKAMT            15 9
     C                   Z-Add(H)  WKAMT         LateChgAmt        8 2

    ?C     LCKEY         CHAIN     FARLC                              75

     C   75              DO
     C                   Z-ADD     0             ARLCPD                         ?LATE CHARGE PAID
     C                   Z-ADD     LateChgAmt    ARLCAM                         ?LATE CHARGE AMOUNT
     C                   Z-ADD(H)  ARLCAM        ARLCDU                         ?L/C DUE
     C                   Z-ADD     LateChgAmt    ARLCMT                         ?M.T.D. L. C. AMOUNT
     C                   Z-ADD     AgeDays       ARLCDY                         ?# DAYS LATE
     C                   Z-ADD     LDATEC        ARLMLC                         ?DATE LAST MONTH CAL
    ?C                   WRITE     RARLC
     C                   ENDDO                                                   75  DO

     C  N75              DO
     C                   ADD       LateChgAmt    ARLCAM                         ?LATE CHARGE AMOUNT
     C                   Z-ADD     ARLCAM        ARLCDU                         ?L/C DUE
     C                   ADD       LateChgAmt    ARLCMT                         ?M.T.D. L. C. AMOUNT
     C                   Z-add     AgeDays       ARLCDY                         ?# DAYS LATE
     C                   Z-ADD     LDATEC        ARLMLC                         ?DATE LAST MONTH CAL
    ?C                   UPDATE    RARLC
     C                   ENDDO                                                   75  DO

     C                   ADD       LateChgAmt    MTranAmt$         9 2
    ?C     LDKEY         CHAIN     FARLCD                             75
     C                   Z-add     AgeDays       ARDAYS                         ?# DAYS LATE
     C                   Z-ADD     LateChgAmt    ARMAMT
     C                   Z-ADD     InvDue$       ARINVB                         ?Invoice Balance
     C                   Z-ADD     ARDUE$        ARBASE                         ?L/C Based on Amount
     C                   Z-ADD     LDATEC        ARLMLC                         ?DATE L/C Calc'd
     C                   Eval      ARPOST = $Date7($Date(0))                    ?DATE L/C Posted
    ?C   75              WRITE     RARLCD
    ?C  N75              UPDATE    RARLCD
     C                   EndIf

     C                   EndSr

    ? *   ...........................................................
    ? *   :      INCLUDE - List of Customers to Include TEMP        :
    ? *   :.........................................................:
    ?
    ?C     INCLUDE       BEGSR
    ?
    ?C                   Eval      $Include = *Off
    ? *? Include only these customers for now...  TEMPORARY ! ! ! !
    ?C     CMCUST        IfEq      002386
    ?C     CMCUST        OrEq      002554
    ?C                   Eval      $Include = *On
    ?C                   EndIf
    ?
    ?C                   EndSr

      *?  ...........................................................
      *?  :      ExitSR  - Exit Subroutine                          :
      *?  :.........................................................:

     C     ExitSR        BEGSR

    ? ** UPDATE STATUS FILE
    ?C     STKEY         CHAIN     FSTATUS                            55
     C                   Z-ADD     TDATET        STDATE
     C                   Z-ADD     TIMOD         STTIME
     C                   Z-ADD     0             STACTP
     C                   MOVEL     USERID        STUSER
     C                   MOVEL     MSG(1)        STDESC
    ?C   55              WRITE     RSTATUS
    ?C  N55              UPDATE    RSTATUS
    ? ** OUTPUT MTRAN
     C     MTranAmt$     IFNE      0
     C                   Z-ADD     3912          CUST              6 0
     C                   Z-ADD     LDATE         INV#              6 0
     C                   MOVEL     'LC'          SUFF              2
     C                   Z-ADD     0             SEQ               3 0
    ?C     MTKEY         CHAIN     RMTRAN                             57
     C   57              DO
     C                   CLEAR                   RMTRAN
     C                   Z-ADD     3912          MTCUST
     C                   Z-ADD     LDATE         MTINV#
     C                   MOVEL     'LC'          MTSUFF
     C                   Z-ADD     0             MTSEQ#
     C                   MOVEL     'A'           MTSTAT
     C                   Z-ADD     1             MTCOMP
     C                   ENDDO                                                  57 DO

     C                   Z-ADD     07            MTTTYP
     C                   Z-ADD     LDATEC        MTTDAT
     C                   Z-ADD     LDATEC        MTDUDT
     C                   ADD       MTranAmt$     MT$AMT
     C                   Z-ADD     MTCUST        MTSHCU
     C                   Z-ADD     MTCUST        MTSACU
     C                   Z-ADD     MTCUST        MTBLCU
    ?C     MTCUST        CHAIN     WMCUST                             90
     C                   MOVEL     CMLOOK        MTLOOK
     C                   MOVEL     MSG(1)        MTDESC
     C                   Z-ADD     TDATE         MTDTLA
     C                   Z-ADD     TIMOD         MTTIME
     C                   MOVEL     USERID        MTUSER
     C                   MOVEL     CMCTYP        MTCTYP
    ?C   57              WRITE     RMTRAN
    ?C  N57              UPDATE    RMTRAN
     C                   END                                                    MTranAmt$ <> 0
     C     TDATET        IFEQ      TDATE
     C                   MOVEL     'X'           LCANCL
     C                   ELSE
     C                   MOVE      *BLANKS       LCANCL
     C                   END
     C                   SETON                                        LR

     C                   EndSR

      *?  ...........................................................
      *?  :      FmtDates - Format Dates for this run               :
      *?  :.........................................................:

     C     FmtDates      BEGSR

     C                   Z-ADD     LDATE         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY             6 0

     C                   Eval      LDATEC = $Date7($DateMDY(LDATE))
    ? ** GET YYMM
     C                   Eval      CCYYMM = $Year($DateMDY(LDATE)) * 100
     C                                   + $Month($DateMDY(LDATE))
     C                   Z-add     CCYYMM        ARINV             6 0


     C                   EndSR

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C     LCKEY         KLIST
     C                   KFLD                    ARCUST
     C                   KFLD                    ARINV#
     C                   KFLD                    ARSUFF

     C     LDKEY         KLIST
     C                   KFLD                    ARCUST
     C                   KFLD                    ARINV#
     C                   KFLD                    ARSUFF
     C*     * * *        KFLD      * * *       * DaysOld * * * *
     C                   KFLD                    AgeDays

    ? * USER STATUS FILE
     C     STKEY         KLIST
     C                   KFLD                    STPROG
     C                   KFLD                    STCOMP

     C     MTKEY         KLIST
     C                   KFLD                    CUST
     C                   KFLD                    INV#
     C                   KFLD                    SUFF
     C                   KFLD                    SEQ

     C                   TIME                    TIMOD             6 0

     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATET            6 0

     C                   MOVEL     PROGID        STPROG
     C                   Z-ADD     1             STCOMP

     C                   If        LDATE@ = '*Next'
     C                   Eval      NextReqd = *On
    ?C     STKEY         CHAIN     FSTATUS                            55
     C                   Eval      LDATE= $MDYDate($AddDate($DateMDY(STDATE):1))
     C                   EndIf

     C                   If        LDATE@ = *Zeros or LDATE@ = *Blanks
     C                   Eval      LDATE = $MDYDATE($DATE(0))
     C                   EndIf

     C                   ExSr      FmtDates

     C                   Z-ADD     0             MTranAmt$         9 2
     C                   Z-ADD     1             LCO               2 0
    ?C     LCO           CHAIN     FARCTL                             LR
     C     ACLCPC        DIV       100           BPCT              4 4

    ?c/Exec SQL
    ?c+
    ?c+   DELETE FROM WMCUST
    ?c+
    ?c/End-exec

    ?c/Exec SQL
    ?c+
    ?c+   INSERT INTO WMCUST
    ?c+     select * from fmcust where cmcust in (
    ?c+     SELECT     a.ARCUST
    ?c+     FROM       FAROPN a
    ?c+     WHERE     (select     sum(b.AR$AMT)
    ?c+                from       FAROPN b
    ?c+                where      b.ARCUST = a.ARCUST
    ?c+                  and      b.ARTTYP <> 7 ) > 0  )
    ?c+
    ?c/End-exec

     C                   ENDSR
** Message Array
Late Charges Posted                    1
