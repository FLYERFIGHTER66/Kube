     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:              Weekly Tray & Soil Requirements               :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Aug. 2004            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program generates a report which shows the Tray    ?:
      *? : and Soil breakdown for the specified Sow Week.            ?:
      *? :                                                           ?:
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
      *? :  11      ?Overflow indicator                              ?:
      *? :  12      ?First Page indicator                            ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFAROPN    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FSTATEMENTPO    E             PRINTER OFLIND(*IN12) USROPN

     D Desc            S             20    DIM(25) CTDATA PERRCD(1)

      *?  LDA
     D                UDS

      *? Address Data Structure
     D  AddressDS      DS
     D Address1                      30
     D Address2                      30
     D Address3                      30
     D Address4                      30
     D Address                       30    DIM(4) OverLay(AddressDS) Inz(*Blank)

      *? Email Address Data Structure
     D  TOEMAILDS      DS
     D TOEMAIL1                      32
     D TOEMAIL2                      32
     D TOEMAIL3                      32
     D TOEMAIL4                      32
     D TOEMAIL5                      32
     D TOEMAIL6                      32
     D TOEMAIL7                      32
     D TOEMAIL8                      32
     D TOEMAIL                      256    overlay(TOEMAILDS)

      *? A/R Open Data Structure
     D  AR_Open_DS     DS
     D Status                              Like(ARSTAT) Inz                     ?STATUS
     D Customer                            Like(ARCUST) Inz                     ?AR CUST. NUMBER
     D Invoice#                            Like(ARINV#) Inz                     ?INV #
     D Q1_ARSUFF                           Like(ARSUFF) Inz                     ?SUFFIX
     D Q1_ARSEQ#                           Like(ARSEQ#) Inz                     ?SEQ #
     D Q1_ARCTYP                           Like(ARCTYP) Inz                     ?CUST TYPE
     D Q1_ARSLM1                           Like(ARSLM1) Inz                     ?SLSPERSON 1
     D Q1_ARCOM1                           Like(ARCOM1) Inz                     ?COMM 1
     D Q1_ARSLM2                           Like(ARSLM2) Inz                     ?SLSPERSON 2
     D Q1_ARCOM2                           Like(ARCOM2) Inz                     ?COMM 2
     D Q1_ARTERR                           Like(ARTERR) Inz                     ?TERRITORY
     D Q1_ARCOMP                           Like(ARCOMP) Inz                     ?COMPANY NUMBER
     D TransType                           Like(ARTTYP) Inz                     ?TRANS TYPE
     D InvDate7                            Like(ARTDAT) Inz                     ?TRANS DATE CYMD
     D DueDate7                            Like(ARDUDT) Inz                     ?INV DUE DATE CYMD
     D Amount                              Like(AR$AMT) Inz                     ?INV,O/A,C/M,L/C AMT
     D Q1_ARDISC                           Like(ARDISC) Inz                     ?DISCOUNT AMOUNT
     D Q1_ARDTAK                           Like(ARDTAK) Inz                     ?DISCOUNT TAKEN
     D Q1_ARADJ$                           Like(ARADJ$) Inz                     ?ADJ AMOUNT
     D Q1_ARPAID                           Like(ARPAID) Inz                     ?AMOUNT PAID
     D Q1_ARDUE$                           Like(ARDUE$) Inz                     ?REMAINING DUE
     D Q1_ARCHEK                           Like(ARCHEK) Inz                     ?CHECK NO.
     D Q1_ARCKDT                           Like(ARCKDT) Inz                     ?CHECK DATE CYMD
     D Q1_ARGLAC                           Like(ARGLAC) Inz                     ?G/L ACCT
     D Q1_ARDESC                           Like(ARDESC) Inz                     ?DESC
     D Q1_ARDTLA                           Like(ARDTLA) Inz                     ?LAST ACT. DATE
     D Q1_ARTIME                           Like(ARTIME) Inz                     ?TIME
     D Q1_ARUSER                           Like(ARUSER) Inz                     ?USER
     D Q1_ARDCDT                           Like(ARDCDT) Inz                     ?CASH DISC. DUE DATE
     D Q1_ARORD#                           Like(ARORD#) Inz                     ?ORDER #
     D Q1_ARLOOK                           Like(ARLOOK) Inz                     ?CUST ALPHA
     D Q1_ARSHCU                           Like(ARSHCU) Inz                     ?SHIP TO CUST
     D Q1_ARSACU                           Like(ARSACU) Inz                     ?S/A CUST
     D Q1_ARBLCU                           Like(ARBLCU) Inz                     ?BILL TO CUST
     D Q1_ARPONO                           Like(ARPONO) Inz                     ?CUST P.O. #
     D Q1_ARCRCD                           Like(ARCRCD) Inz                     ?CREDIT CARD
     D Q1_ARCRC#                           Like(ARCRC#) Inz                     ?CREDIT CARD #
     D Q1_ARCRCE                           Like(ARCRCE) Inz                     ?C.C. EXPIRE
     D Q1_ARCRCA                           Like(ARCRCA) Inz                     ?C.C. APPROVAL
     D PrintOnStmt                         Like(ARPRST) Inz                     ?PRINT ON STMNT Y/N
     D Q1_ARSHP#                           Like(ARSHP#) Inz                     ?SHIPMENT #
     D Q1_ARREAS                           Like(ARREAS) Inz                     ?REASON CODE
     D Q1_ARTAXJ                           Like(ARTAXJ) Inz                     ?TAX JURISDICTION
     D Q1_ARSHFR                           Like(ARSHFR) Inz                     ?SHIP FROM
     D Q1_ARPOS                            Like(ARPOS ) Inz                     ?POS CODE
     D Q1_ARSINV                           Like(ARSINV) Inz                     ?OA INV #
     D Q1_ARSSUF                           Like(ARSSUF) Inz                     ?OA SUFFIX
     D Q1_ARBKCD                           Like(ARBKCD) Inz                     ?BANK CODE

      *? Fields
     D  BaseDate       S              7S 0
     D  RecordCount    S              5S 0 INZ(0)
     D* InvDate7       S                   Like(ARTDAT)
     D* DueDate7       S                   Like(ARDUDT)
     D  FrCust         S                   Like(Customer) Inz(0)
     D  ToCust         S                   Like(Customer) Inz(999999)
     D  SaveCust       S                   Like(Customer)
     D  SaveInv        S                   Like(Invoice#)
     D  InclCred       S              1A
     D  InclZero       S              1A
     D  Error_Amt$     S              9S 2
     D  DaysLate       S              9S 2
     D  AddrLine       S              1S 0 Inz(1)
     D  FmtZip         S             10A   Inz(*Blanks)

      *? Indicators
     D  First_Time     S               N   INZ(*On)
     D  EndOfFile      S               N   INZ(*Off)
     D  DontPrint      S               N   INZ(*Off)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Duration
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

    ?C                   ExSr      GetData
    ?
      *? Read through SQL cursor and Print
     C                   Eval      Invoice#  = *Zero
    ?C                   ExSr      ReadData
     C                   Eval      SaveInv   = Invoice#
     C                   DoW       not EndOfFile
     C                   ExSr      PrintData
    ?C                   ExSr      ReadData
     C                   EndDo

     C                   Eval      Customer = *Zeros
     C                   ExSr      PrintData
     C                   ExSr      CloseData
     C                   If        %Open(STATEMENTP)
     C                   Close     STATEMENTP
     C                   EndIf
     C                   Eval      *InLR = *On


      *?  ...........................................................
      *?  :      GetData - Get selected A/R Open information        :
      *?  :.........................................................:

     C     GetData       BegSr

     C                   Select
     C                   When      EMAILIT = 'N'
     ?*  Declare recordset C1 for Print (Only)
    ?c/exec sql
    ?c+
    ?c+  DECLARE   C1 cursor for
    ?c+
    ?c+    SELECT     *
    ?c+    FROM       FAROPN a
    ?c+    WHERE      a.ARCUST between :FrCust and :ToCust
    ?c+      and      a.ARTDAT <= :BaseDate
    ?c+      and     (select     sum(b.AR$AMT)
    ?c+               from       FAROPN b
    ?c+               where      b.ARTDAT <= :BaseDate
    ?c+                 and      b.ARCUST = a.ARCUST) >=
    ?c+                        ( Case when :InclCred = 'Y' then -99999999
    ?c+                               when :InclCred = 'N' then .001 end )
    ?c+      and   (            :InclZero = 'Y'
    ?c+                 OR
    ?c+                         :InclZero = 'N'
    ?c+                and     (select     sum(b.AR$AMT)
    ?c+                         from       FAROPN b
    ?c+                         where      b.ARTDAT <= :BaseDate
    ?c+                           and      b.ARCUST = a.ARCUST) <> 0   )
    ?c+    ORDER BY   a.ARCUST, a.ARINV#, a.ARSUFF, a.ARSEQ#
    ?c+
    ?c+  For Read only
    ?c+
    ?c/end-exec
     ?*  Open the SQL recordset C1
    ?c/exec sql
    ?c+                  Open      C1
    ?c/end-exec
     C                   When      TYPE = 'PRINT' and EMAILIT = 'Y'
     ?*  Declare recordset C2 for Print (When also Emailing)
    ?c/exec sql
    ?c+
    ?c+  DECLARE   C2 cursor for
    ?c+
    ?c+    SELECT     *
    ?c+    FROM       FAROPN a
    ?c+    WHERE      a.ARCUST between :FrCust and :ToCust
    ?c+      and      a.ARTDAT <= :BaseDate
    ?c+      and     (select     sum(b.AR$AMT)
    ?c+               from       FAROPN b
    ?c+               where      b.ARTDAT <= :BaseDate
    ?c+                 and      b.ARCUST = a.ARCUST) >=
    ?c+                        ( Case when :InclCred = 'Y' then -99999999
    ?c+                               when :InclCred = 'N' then .001 end )
    ?c+      and   (            :InclZero = 'Y'
    ?c+                 OR
    ?c+                         :InclZero = 'N'
    ?c+                and     (select     sum(b.AR$AMT)
    ?c+                         from       FAROPN b
    ?c+                         where      b.ARTDAT <= :BaseDate
    ?c+                           and      b.ARCUST = a.ARCUST) <> 0   )
    ?c+      and      a.ARCUST not in
    ?c+              (SELECT   EMACCT
    ?c+               FROM     FMEMAIL
    ?c+               WHERE    EMCODE = 'STM'
    ?c+                 and    EMAIL <> ' ')
    ?c+    ORDER BY   a.ARCUST, a.ARINV#, a.ARSUFF, a.ARSEQ#
    ?c+
    ?c+  For Read only
    ?c+
    ?c/end-exec
     ?*  Open the SQL recordset C2
    ?c/exec sql
    ?c+                  Open      C2
    ?c/end-exec
     C                   When      TYPE = 'FAX  '
     ?*  Declare recordset C3 for Fax
    ?c/exec sql
    ?c+
    ?c+  DECLARE   C3 cursor for
    ?c+
    ?c+    SELECT     *
    ?c+    FROM       FAROPN a
    ?c+    WHERE      a.ARCUST between :FrCust and :ToCust
    ?c+      and      a.ARTDAT <= :BaseDate
    ?c+      and     (select     sum(b.AR$AMT)
    ?c+               from       FAROPN b
    ?c+               where      b.ARTDAT <= :BaseDate
    ?c+                 and      b.ARCUST = a.ARCUST) >=
    ?c+                        ( Case when :InclCred = 'Y' then -99999999
    ?c+                               when :InclCred = 'N' then .001 end )
    ?c+      and   (            :InclZero = 'Y'
    ?c+                 OR
    ?c+                         :InclZero = 'N'
    ?c+                and     (select     sum(b.AR$AMT)
    ?c+                         from       FAROPN b
    ?c+                         where      b.ARTDAT <= :BaseDate
    ?c+                           and      b.ARCUST = a.ARCUST) <> 0   )
    ?c+      and      a.ARCUST in
    ?c+              (SELECT   EMACCT
    ?c+               FROM     FMEMAIL
    ?c+               WHERE    EMCODE = 'STM'
    ?c+                 and    upper(EMNAME) = 'FAX'
    ?c+                 and    EMAIL  <>' ')
    ?c+    ORDER BY   a.ARCUST, a.ARINV#, a.ARSUFF, a.ARSEQ#
    ?c+
    ?c+  For Read only
    ?c+
    ?c/end-exec
     ?*  Open the SQL recordset C3
    ?c/exec sql
    ?c+                  Open      C3
    ?c/end-exec
     C                   When      TYPE = 'EMAIL'
     ?*  Declare recordset C4 for Email
    ?c/exec sql
    ?c+
    ?c+  DECLARE   C4 cursor for
    ?c+
    ?c+    SELECT     *
    ?c+    FROM       FAROPN a
    ?c+    WHERE      a.ARCUST between :FrCust and :ToCust
    ?c+      and      a.ARTDAT <= :BaseDate
    ?c+      and     (select     sum(b.AR$AMT)
    ?c+               from       FAROPN b
    ?c+               where      b.ARTDAT <= :BaseDate
    ?c+                 and      b.ARCUST = a.ARCUST) >=
    ?c+                        ( Case when :InclCred = 'Y' then -99999999
    ?c+                               when :InclCred = 'N' then .001 end )
    ?c+      and   (            :InclZero = 'Y'
    ?c+                 OR
    ?c+                         :InclZero = 'N'
    ?c+                and     (select     sum(b.AR$AMT)
    ?c+                         from       FAROPN b
    ?c+                         where      b.ARTDAT <= :BaseDate
    ?c+                           and      b.ARCUST = a.ARCUST) <> 0   )
    ?c+      and      a.ARCUST in
    ?c+              (SELECT   EMACCT
    ?c+               FROM     FMEMAIL
    ?c+               WHERE    EMCODE = 'STM'
    ?c+                 and    upper(EMNAME) <>'FAX'
    ?c+                 and    EMAIL  <>' ')
    ?c+    ORDER BY   a.ARCUST, a.ARINV#, a.ARSUFF, a.ARSEQ#
    ?c+
    ?c+  For Read only
    ?c+
    ?c/end-exec
     ?*  Open the SQL recordset
    ?c/exec sql
    ?c+                  Open      C4
    ?c/end-exec
     C                   EndSl


     C                   EndSr

      *?  ...........................................................
      *?  :      CloseDate - Close the Data Set                     :
      *?  :.........................................................:

     C     CloseData     BegSr

     ?*  Close the SQL recordset
     C                   Select
     C                   When      EMAILIT = 'N'
    ?c/exec sql
    ?c+ Close C1
    ?c/end-exec
     C                   When      TYPE = 'PRINT' and EMAILIT = 'Y'
    ?c/exec sql
    ?c+ Close C2
    ?c/end-exec
     C                   When      TYPE = 'FAX  '
    ?c/exec sql
    ?c+ Close C3
    ?c/end-exec
     C                   When      TYPE = 'EMAIL'
    ?c/exec sql
    ?c+ Close C4
    ?c/end-exec
     C                   EndSl

     C                   EndSr

      *?  ...........................................................
      *?  :      ReadData - Read Data                               :
      *?  :.........................................................:

     C     ReadData      BegSr

     ?*  Read Sow Schedule Records for Selected Week
     C                   Select
     C                   When      EMAILIT = 'N'
    ?c/exec sql
    ?c+ Fetch C1 into :AR_Open_DS
    ?c/end-exec
     C                   When      TYPE = 'PRINT' and EMAILIT = 'Y'
    ?c/exec sql
    ?c+ Fetch C2 into :AR_Open_DS
    ?c/end-exec
     C                   When      TYPE = 'FAX  '
    ?c/exec sql
    ?c+ Fetch C3 into :AR_Open_DS
    ?c/end-exec
     C                   When      TYPE = 'EMAIL'
    ?c/exec sql
    ?c+ Fetch C4 into :AR_Open_DS
    ?c/end-exec
     C                   EndSl

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   Eval      RecordCount = RecordCount + 1                ?Record Count
     C                   EndIf

     C                   EndSr

      *?  ...........................................................
      *?  :      PrintData - Print Soubroutine                      :
      *?  :.........................................................:

     C     PrintData     BegSr

     C                   If        not %Open(STATEMENTP)
     C                   Open      STATEMENTP
     C                   EndIf
      *? If the Cutomer has changed, write the totals for the previous Customer.
     C                   If        SaveCust <> Customer
     C                   If        not First_Time
    ?C                   ExSr      Wrt_InvDetl
    ?C                   ExSr      Wrt_NewCust
     C                   Else
     C                   ExSr      First
     C                   EndIf
     C                   Else

      *? If processing a new invoice, Write Invoice Detail Line for previous Invoice.
     C                   If        SaveInv <> Invoice#
    ?C                   ExSr      Wrt_InvDetl
     C                   EndIf
     C                   EndIf

      *? Set the Do Not Print Indicator if PrintOnStmt = 'N'
      *?    Note:  If the DontPrint indicator is on, the line will not print on the statement
      *?           unless there is a Balance Due.  A balance due overrides the DontPrint.
     C                   If        PrintOnStmt = 'N'
     C                   Eval      DontPrint = *On
     C                   EndIf

      *? Add to Invoice and Total Buckets
     C                   Select

      *?    invoice total
     C                   When         TransType = 1                             ?Invoice
     C                             or TransType = 3                             ?On Account
     C                             or TransType = 5                             ?Credit Memo
     C                             or TransType = 12                            ?Returned Check/Chg
     C                   ADD       Amount        InvTotal

      *?    payments and adjustments
     C                   When         TransType = 2                             ?Payment
     C                             or TransType = 4                             ?Apply Credit Memo
     C                             or TransType = 10                            ?Credit Card
     C                             or TransType = 14                            ?Check Charge
     C                   ADD       Amount        InvPayAdj

      *?    late charges
     C                   When         TransType = 7                             ?Late Charges
     C                             and Status = 'L'                             ?New Style Late Chg
     C                   ADD       Amount        InvLateChg

     C                   When         TransType = 7                             ?Late Charges
     C                             and Status = 'A'                             ?Old Style Late Chg
     C                   ADD       Amount        InvTotal

     C                   Other
     C                   ADD       Amount        Error_Amt$
     C                   EndSl

      *?    balance due
     C                   ADD       Amount        InvBalDue
     C                   ADD       Amount        CustTotal$

      *?    aging
     C                   Select
     C                   When      DaysLate < 01
     C                   ADD       Amount        CUSTCURR
     C                   When      DaysLate < 30
     C                   ADD       Amount        CUST01TO30
     C                   When      DaysLate < 60
     C                   ADD       Amount        CUST31TO60
     C                   Other
     C                   ADD       Amount        CUSTOVER60
     C                   EndSl

     C                   EndSr


      *?  ...........................................................
      *?  :      Email       - email document                       :
      *?  :.........................................................:

     C     Email         BEGSR

     C                   If        TYPE = 'EMAIL'
     C                   If        %Open(STATEMENTP)
     C                   Close     STATEMENTP
     C                   EndIf
     C                   Eval      TONAME=%Trim(CMNAME)+' ('+%char(Account)+')'
     C                   Eval      TOEMAIL  = 'wbehr@kubepak.com'
    ?c/exec sql
    ?c+ Select EMAIL
    ?c+ into :TOEMAIL from FMEMAIL
    ?c+ Where EMACCT = :Account and EMCODE = 'STM'
    ?c/end-exec
     C                   Call      'EMSTATEMNT'
     C                   Parm                    TONAME           30
     C                   Parm                    TOEMAIL1         32
     C                   Parm                    TOEMAIL2         32
     C                   Parm                    TOEMAIL3         32
     C                   Parm                    TOEMAIL4         32
     C                   Parm                    TOEMAIL5         32
     C                   Parm                    TOEMAIL6         32
     C                   Parm                    TOEMAIL7         32
     C                   Parm                    TOEMAIL8         32
     C                   If        not %Open(STATEMENTP)
     C                   Open      STATEMENTP
     C                   EndIf
     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      First       - First Record Processing              :
      *?  :.........................................................:

     C     First         BEGSR

     C                   Eval      First_Time = *Off
     C                   Eval      Account  = Customer
     C                   Eval      SaveCust = Customer
     C                   Eval      SaveInv  = Invoice#
     C     Customer      Chain     FMCUST
     C                   ExSr      FormatName
     C                   Eval      DueDate = $MDYDate($Date(DueDate7))
     C                   Eval      InvDate = $MDYDate($Date(InvDate7))
     C                   Eval      DaysLate = $Duration($Date(DueDate7):
     C                                                  $Date(BaseDate):'D')
     C                   Eval      CustPage = 1

     C                   If        TransType <= 25
     C                   Eval      Reference = Desc(TransType)
      /Free
        If TransType = 1;
          Reference = 'PO:' + Q1_ARPONO;
        ENDIF;
      /End-Free
     C                   EndIf

    ?C                   WRITE     HEADER
    ?C                   WRITE     COLUMNS

     C                   EndSr


      *?  ...........................................................
      *?  :      Wrt_NewCust - Write Invoice Detail Subroutine      :
      *?  :.........................................................:

     C     Wrt_NewCust   BEGSR

      *? If it's not the first page for a Customer write the Continuation Header on OverFlow
     C                   If        *In12
     C                   Eval      CustPage = CustPage + 1
    ?C                   WRITE     CONTINUE
    ?C                   WRITE     COLUMNS
     C                   EndIf

    ?c/exec sql
    ?c+ Select substr(EMAIL,1,15)
    ?c+ into :EMAIL15 from FMEMAIL
    ?c+ Where EMACCT = :Account  and EMCODE = 'STM'
    ?c+ Fetch First Row Only
    ?c/end-exec
    ?C                   WRITE     CustTotal
     C                   ExSr      Email
     C                   Eval      *In12 = *Off

     C                   If        not EndOfFile
     C                   Eval      SaveCust = Customer
     C                   Eval      Account  = Customer
     C     Customer      Chain     FMCUST
     C                   ExSr      FormatName
     C                   Eval      CustPage = 1
     C                   Z-Add     *Zero         CustCurr
     C                   Z-Add     *Zero         Cust01to30
     C                   Z-Add     *Zero         Cust31to60
     C                   Z-Add     *Zero         CustOver60
     C                   Z-Add     *Zero         CustTotal$
    ?C                   WRITE     HEADER
    ?C                   WRITE     COLUMNS
     C                   EndIF

     C                   EndSr


      *?  ...........................................................
      *?  :      Wrt_InvDetl - Write Invoice Detail Subroutine      :
      *?  :.........................................................:

     C     Wrt_InvDetl   BEGSR

      *? If it's not the first page for a Customer write the Continuation Header on OverFlow
     C                   If        *In12
     C                   Eval      CustPage = CustPage + 1
    ?C                   WRITE     CONTINUE
    ?C                   WRITE     COLUMNS
     C                   Eval      *In12 = *Off
     C                   EndIf

     C                   If        not DontPrint or InvBalDue <> 0
    ?C                   WRITE     InvDetl
     C                   EndIf

     C                   Eval      DontPrint = *Off

      *? Format new Invoice and Clear Old Totals
     C                   If        not EndOfFile
     C                   Eval      SaveInv = Invoice#
     C                   Eval      DueDate = $MDYDate($Date(DueDate7))
     C                   Eval      InvDate = $MDYDate($Date(InvDate7))
     C                   Eval      DaysLate = $Duration($Date(DueDate7):
     C                                                  $Date(BaseDate):'D')
     C                   If        TransType <= 25
     C                   Eval      Reference = Desc(TransType)
      /Free
        If TransType = 1;
          Reference = 'PO:' + Q1_ARPONO;
        ENDIF;
      /End-Free
     C                   EndIf

     C                   Z-ADD     *Zeros        InvTotal
     C                   Z-ADD     *Zeros        InvPayAdj
     C                   Z-ADD     *Zeros        InvLateChg
     C                   Z-ADD     *Zeros        Error_Amt$
     C                   Z-ADD     *Zeros        InvBalDue
     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      FormatName - Format Customer Name                  :
      *?  :.........................................................:

     C     FormatName    BEGSR

     C                   Reset                   Address
     C                   Reset                   AddrLine

     C                   If        CMADD2 <> *Blanks
     C                             and CMADD2 <> 'MAILING ADDRESS'
     C                             and CMADD2 <> 'DELIVERY ADDRESS'
     C                   Eval      Address(AddrLine) = CMADD2
     C                   Eval      AddrLine = AddrLine + 1
     C                   EndIf

     C                   If        CMADD3 <> *Blanks
     C                             and CMADD3 <> 'MAILING ADDRESS'
     C                             and CMADD3 <> 'DELIVERY ADDRESS'
     C                   Eval      Address(AddrLine) = CMADD3
     C                   Eval      AddrLine = AddrLine + 1
     C                   EndIf

     C                   If        CMADD4 <> *Blanks
     C                             and CMADD4 <> 'MAILING ADDRESS'
     C                             and CMADD4 <> 'DELIVERY ADDRESS'
     C                   Eval      Address(AddrLine) = CMADD4
     C                   Eval      AddrLine = AddrLine + 1
     C                   EndIf

     C                   Reset                   FmtZip
     C                   If        %Len( %Trim( CMZIP ) ) > 5
     C                   Eval      FmtZip = %Subst( CMZIP: 1: 5 ) + '-' +
     C                                      %Subst( CMZIP: 6: 4 )
     C                   Else
     C                   Eval      FmtZip = %Trim(CMZIP)
     C                   EndIf

     C                   Eval      Address(AddrLine) =
     C                                   %Trim( CMCITY ) + ', ' +
     C                                   %Trim( CMSTST ) + ' ' +
     C                                   %Trim( FmtZip )

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C     *Entry        PList
     C                   Parm                    @AsOfDate         6
     C                   Parm                    @FrCust           6
     C                   Parm                    @ToCust           6
     C                   Parm                    InclCred
     C                   Parm                    InclZero
     C                   Parm                    EmailIt           1
     C                   Parm                    Type              5

     C                   If        Type = 'FAX'
     C                   Eval      *In40 = *On
     C                   EndIf
     C                   Move      @AsOfDate     AsOfDate
     C                   Move      @FrCust       FrCust
     C                   If        @ToCust = '000000'
     C                   If        @FrCust = '000000'
     C                   Z-add     999999        ToCust
     C                   Else
     C                   Move      @FrCust       ToCust
     C                   EndIf
     C                   Else
     C                   Move      @ToCust       ToCust
     C                   EndIf

     C*                  Eval      AsOfDate = $MDYDate($Date(BaseDate))
     C                   Eval      BaseDate = $Date7($DateMDY(AsOfDate))
     C                   Eval      *IN11 = *On                                  |1st Page of Report
     C                   Eval      *In99 = *Off
     C   99              Read      FAROPN

     C                   EndSR
** .+... 1 ...+... 2 ...+... 3 ...+... 4 ...+... 5 ...+... 6 ...+... 7 ...+... 8 ...+... 9 ...+... 0
Invoice             | 01
Payment             | 02
On Account          | 03
Apply Credit Memo   | 04
Credit Memo         | 05
 ** transaction **  | 06
Late Charges        | 07
 ** transaction **  | 08
 ** transaction **  | 09
Credit Card         | 10
 ** transaction **  | 11
Returned Check/Chg  | 12
 ** transaction **  | 13
Check Charge        | 14
 ** transaction **  | 15
 ** transaction **  | 16
 ** transaction **  | 17
 ** transaction **  | 18
 ** transaction **  | 19
 ** transaction **  | 20
 ** transaction **  | 21
 ** transaction **  | 22
 ** transaction **  | 23
 ** transaction **  | 24
 ** transaction **  | 25
