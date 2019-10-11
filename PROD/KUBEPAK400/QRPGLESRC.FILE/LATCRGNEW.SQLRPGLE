     **Free
         //  :````````````````````````````````````````````````````````````:
         //  :       Monthly Late Charges (Assessed Daily)                :
         //  :............................................................:
         //  :````````````````````````````````````````````````````````````:
         //  : Created:  June 2004            ? Kube-Pak Corporation ?    :
         //  :      by:  William J. Behr                                  :
         //  :............................................................:

        /COPY QFunctDefn,#CopyRight  // Kube-Pak Corporation. All rights reserved.
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI LATCRGNEW;
           DCL-PARM ParmDate Date(*USA) Const;       // Specify Date of 01/01/1900 or *NEXT
           DCL-PARM Cust@ char(6) Const;             // Specify Cutomer # or '*ALL'
           DCL-PARM Invoice@ char(6) Const;          // Specify Invoice # or '*ALL'
         END-PI;

         dcl-pr LATCRGFIXS extpgm ;
           Cust@ char(6) const ;
           Invoice@ char(6) const ;
         end-pr ;

         dcl-ds sds psds qualified;
           Proc *proc ;
           User char(10) pos(254);
         end-ds;


         dcl-f FARLC keyed usage(*update:*output) ;  // Late Charge Header File
         dcl-f FMTRAN keyed usage(*update:*output) ;  // Financial Transaction

         dcl-ds AR_Control EXTNAME('FARCTL') end-ds;

         dcl-s FirstTime Ind Inz(*On);
         dcl-s NextDateRequest Ind;
         dcl-s LCInd Ind Inz(*Off);

         dcl-s ThisDate date;
         dcl-s Today6 zoned(6:0);

         dcl-s ThisProgram char(10);
         dcl-s ThisUser char(10);
         dcl-s ThisCust Packed(6:0);
         dcl-s ThisInvoice zoned(6:0);
         dcl-s ThisDate7 zoned(7:0);
         dcl-s ThisDate6 zoned(6:0);
         dcl-s ThisTime6 zoned(6:0) Inz(000000);
         dcl-s CashOnHand Packed(11:2);
         dcl-s MDY6 Packed(6:0);

      //------------------------------------------------------------------------
      // Begic Program Logic
      //------------------------------------------------------------------------

         ThisProgram = sds.Proc;
         ThisUser = sds.User;
         Today6 = %Int(%Char(%Date():*MDY0));

         Reset AR_Control;
         Exec SQL Select * into :AR_Control from FARCTL WHERE ACCOMP = 1;
         If ACLC = 'N';  // If FARCTL set to Charge Late Charges = 'N', then just return.
           Return;
         ENDIF;

         Dow GetNextDate() <= %Date();            //  Do While less than or equal to today
           ThisDate6 = %Int(%Char(ThisDate:*MDY0));
           ThisDate7 = %Int(%Char(ThisDate:*CYMD0));
           GetCustList();                         //  Get List of Customers for this day
           Reset ThisCust;
           Dow GetNextCust() <> 999999;           //  Do While not 999999=No More Customers
             CashOnHand = GetCashOnHand(ThisCust);
             Reset ThisInvoice;
             Dow GetNextInvoice <> 999999;        //  999999=Shutdown code
               LATCRGFIXS(%Char(ThisCust):%Char(ThisInvoice));
               ProcessInvoice(ThisCust:ThisInvoice);
             EndDo;
           EndDo;
           Exec SQL UPDATE FSTATUS   // Update the last run date each time a date is processed.
                    SET    STDATE = :ThisDate6
                      ,    STTIME = :ThisTime6
                      ,    STUSER =  User
                    WHERE  STPROG = :ThisProgram;
           If not NextDateRequest;
             Leave;
           EndIf;
         EndDo;

         *InLR = *On;

      //------------------------------------------------------------------------
      // GetNextDate - Get the next date to process
      //------------------------------------------------------------------------
         dcl-proc GetNextDate;
           dcl-pi *n DATE;
           end-pi ;
           Select;
           When FirstTime and $year(ParmDate) = 1900;     //  Get the first '*Next' date.
             NextDateRequest = *On;
             FirstTime = *Off;
             Exec SQL SELECT STDATE into :MDY6 FROM fstatus
                      WHERE STPROG = :ThisProgram;
             ThisDate = %date(MDY6:*MDY) + %days(1);
           When FirstTime and $year(ParmDate) <>1900;   //  Process Parm Date only
             NextDateRequest = *Off;
             FirstTime = *Off;
             ThisDate = ParmDate;
           When NextDateRequest = *On;                  //  Get the next date.
             ThisDate = ThisDate + %days(1);
           Other;                                       //  Shut Down
             ThisDate = %Date() + %days(1);
             ThisTime6 = %Int(%Char(%Time():*HMS0));
           EndSl;
           Return ThisDate;
         end-proc;

      //------------------------------------------------------------------------
      // GetCustList - Get List Of Cutomers
      //------------------------------------------------------------------------
         dcl-proc GetCustList;

        // dcl-s CYMD7 Zoned(7:0);
           dcl-s SelCust Zoned(6:0) inz(0);

           If Cust@ <> '*ALL';
             SelCust = %int(Cust@);
           ENDIF;

           Exec SQL
              DELETE FROM WMCUST;

       //  Bill S. doesn't want the date considered in the late charge calculation.
       //          The late charge should only be calculated if the invoice is still
       //          unpaid on the actual date not the as-of-date.
       //  CYMD7 = %dec(%char(ThisDate:*CYMD0):7:0);
       //    Exec SQL
       //      INSERT INTO WMCUST
       //        select * from fmcust where cmcust in
       //        ( SELECT     distinct a.ARCUST
       //          FROM       FAROPN a
       //          WHERE      ARTDAT     <= :CYMD7
       //            and     (select     sum(b.AR$AMT)
       //                     from       FAROPN b
       //                     where      b.ARCUST = a.ARCUST
       //                       and      b.ARTTYP <> 7 ) > 0 );


       // 08/31/2017 - Added a where condition to include
       //              CMAPLC = 'Y' to check Customer Late Charges Flag
           Exec SQL
             INSERT INTO WMCUST
               select * from fmcust
                where   CMAPLC = 'Y'
                  and ((CMCUST = :SelCust)
                  or  (:Cust@ = '*ALL' and CMCUST in
               ( SELECT     distinct a.ARCUST
                 FROM       FAROPN a
                 WHERE     (select     sum(b.AR$AMT)
                            from       FAROPN b
                            where      b.ARCUST = a.ARCUST
                              and      b.ARTTYP <> 7 ) > 0 )));

         end-proc;

      //------------------------------------------------------------------------
      // GetNextCust - Get the next cust to process
      //------------------------------------------------------------------------
         dcl-proc GetNextCust;
           dcl-pi *n Packed(6:0) end-pi;
           dcl-s  LastCust Packed(6:0);

           LastCust = ThisCust;
           ThisCust = 999999;

           Exec SQL // Get Next Customer
             SELECT CMCUST
             INTO :ThisCust
             FROM WMCUST
             WHERE CMCUST > :LastCust
             ORDER BY CMCUST
             Fetch First Row Only;

           Return ThisCust;
         end-proc;

      //------------------------------------------------------------------------
      // GetCashOnHand - Get the next cust to process
      //------------------------------------------------------------------------
         dcl-proc GetCashOnHand;
           dcl-pi      *n Packed(11:2);
                 ThisCust Packed(6:0);
           end-pi;

           DCL-S NullInd INT(5) INZ(0);  // Purpose: Null Indicator for CashOnHand
           DCL-S NullValue Like(NullInd) INZ(-1);

           CashOnHand = 0;

           Exec SQL // Get Cash-on-hand for current Customer
             select   sum(AR$AMT)
             into    :CashOnHand :NullInd
             from     FAROPNDD
             where    ARCUST = :ThisCust
               and    ARTTYP <> 7
               and   (ARSUFF = 'CM' or ARSUFF = 'OA');

           If NullInd = NullValue;
             Return 0;
            Else;
             Return CashOnHand;
           ENDIF;

         end-proc;

      //------------------------------------------------------------------------
      // GetNextInvoice - Get the next cust to process
      //------------------------------------------------------------------------
         dcl-proc GetNextInvoice;
           dcl-pi *n Packed(6:0) end-pi;
           dcl-s LastInvoice like(ThisInvoice);

           If Invoice@ = '*ALL';
             LastInvoice = ThisInvoice;
             ThisInvoice = 999999;
            Else;
             ThisInvoice = %Int(Invoice@);
             Return ThisInvoice;
           EndIf;

           Exec SQL // Get Next Customer
             SELECT    ARINV#
             INTO     :ThisInvoice
             FROM      FAROPNDD
             WHERE     ARCUST = :ThisCust
             and       ARSEQ# = 0
             and       ARDUE$ <> 0
             and      (ARTTYP = 1 or ARTTYP = 12)
             and       ARINV#  > :LastInvoice
             ORDER BY  ARINV#
             Fetch First Row Only;

           Return ThisInvoice;
         end-proc;

      //------------------------------------------------------------------------
      // ProcessInvoice - Process the Invoice
      //------------------------------------------------------------------------
         dcl-proc ProcessInvoice;
           dcl-pi *n;
             ThisCust Packed(6:0);
             ThisInvoice Zoned(6:0);
           end-pi;

           //  Process Logic Here
           GetLCHeader(ThisCust:ThisInvoice); // All LC calc'd based on LC header
           If ThisDate >= AR1STL and isCardinal(30) and not LateChargeExists();
             CalcLateCharge();
           EndIf;
         end-proc;

      //------------------------------------------------------------------------
      // GetLCHeader - Get -or- Create & Get the Late Charge Header
      //------------------------------------------------------------------------
         dcl-proc GetLCHeader;
           dcl-pi *n;
             CustIn Packed(6:0);
             InvoiceIn Zoned(6:0);
           end-pi ;
           dcl-ds FHORDW_DS;
             dcl-subf Terms_Code char(2);
             dcl-subf Terms_Desc char(30);
             dcl-subf Terms_Days zoned(3:0);
             dcl-subf Invoice_Date6 zoned(6:0);
           end-ds;
           dcl-s GraceDays zoned(3:0);
           dcl-s Invoice_Date Date;
           dcl-s Invoice_Date7 zoned(7:0);

           //  See if Header exists (Using Customer and Invoice)
           Setll (CustIn:InvoiceIn) FARLC;
           //  If it exists, use this header for LC Calculation
           If %Equal(FARLC);
             Chain (CustIn:InvoiceIn) FARLC;
             Return;
             else;
           //  If it doesn't exist, create generic header.
             Clear FHORDW_DS;
             Exec SQL // Get Invoice Information
               SELECT WHTMCD, WHTERM, WHTDAS, WHINDT
               Into :FHORDW_DS FROM FHORDW
               Where WHINV# = :InvoiceIn
               Fetch First Row Only;
             Invoice_Date  = %Date(Invoice_Date6:*MDY);
             Invoice_Date7 = %Int(%Char(%Date(Invoice_Date6:*MDY):*CYMD0));
             Exec SQL // Get LC Information
               SELECT TCTDGP into :GraceDays from FMTERMAD
               Where TCTERM = :Terms_Code
               Fetch First Row Only;
             ARSTAT = 'A'     ;                                       // STATUS
             ARCUST = CustIn  ;                                       // AR CUST. NUMBER
             ARINV# = InvoiceIn;                                      // INV #
             ARSUFF = '  ';                                           // SUFFIX
             ARLCDU = 0       ;                                       // L/C DUE
             ARLCDY = 0       ;                                       // # DAYS LATE
             ARLCAM = 0       ;                                       // LATE CHARGE AMOUNT
             ARLCMT = 0       ;                                       // M.T.D. L. C. AMOUNT
             ARLCPD = 0       ;                                       // LATE CHARGE PAID
             ARLMLC = 0       ;                                       // DATE LAST MONTH CALC.
             ARTMTS = %TimeStamp();                                   // Terms Timestamp
             ARTMCD = Terms_Code;                                     // TERMS:Terms Code
             ARTERM = Terms_Desc;                                     // TERMS:Terms
             ARINVD = Invoice_Date;                                   // A/R Invoice Date
             ARDAYD = Terms_Days;                                     // TERMS:Days to Due Date
             ARDUED = Invoice_Date + %Days(Terms_Days);               // A/R Due Date
             ARWAIT = ACLCD#  ;                                       // A/R Days Overdue For L/C
             ARALWD = ARDUED + %Days(ARWAIT);                         // A/R Date L/C Allowed
             ARGRAC = GraceDays;                                      // TERMS:Days past Due 1st L/C
             ARDGRC = ARDUED + %Days(ARGRAC);                         // L/C Grace Date
             If ARDGRC > ARALWD;
               AR1STL = ARDGRC;                                       // First L/C Date
              else;
               AR1STL = ARALWD;                                       // First L/C Date
             EndIf;
             ARLCTM = %TimeStamp();                                   // Last Change Timestamp
             ARLCPG = ThisProgram;                                    // Last Change Program
              // create new LC Header here...
             Write RARLC;
             Chain (ARCUST:ARINV#) FARLC;
           EndIf;
         end-proc;

      //------------------------------------------------------------------------
      // LateChargeExists - Determine if Late Charge Already Exists for ThisDate
      //------------------------------------------------------------------------
         dcl-proc LateChargeExists;
           dcl-pi *n Ind end-pi;

           LCInd = *Off;

           Exec SQL    // See if LC Detail exists for ThisDate
             SELECT  '1'
             INTO   :LCInd
             FROM    farlcd
             WHERE   ARCUST=:ThisCust
               and   ARINV#=:ThisInvoice
               and   ARLMLC=:ThisDate7
             Fetch First Row Only;

           Return LCInd;

         end-proc;

      //------------------------------------------------------------------------
      // isCardinal - Determine if ThisDate is a cardinal Date of Grace Date (ARDGRC)
      //------------------------------------------------------------------------
         dcl-proc isCardinal;
           dcl-pi *n Ind;
             interval int(5) options(*nopass) value ;
           END-PI;

           If      %DIFF (AR1STL:ThisDate:*DAYS)/interval =
              %int(%DIFF (AR1STL:ThisDate:*DAYS)/interval);
             Return *On;
            else;
             Return *Off;
           EndIf;
         end-proc;

      //------------------------------------------------------------------------
      // CalcLateCharge - This invoice gets a latecharge...  write records
      //------------------------------------------------------------------------
         dcl-proc CalcLateCharge;

           dcl-s InvoiceBalance packed(11:2) inz(0);
           dcl-s LCBaseAmount packed(11:2) inz(0);
           dcl-s LateCharge packed(11:2) inz(0);
           dcl-s DaysLate packed(4:0) inz(0);
           dcl-s Today7 packed(7:0) inz(0);
           dcl-ds CM_CTYP_LOOK_DS;
             dcl-subf CMCTYP char(2) Inz(*Blanks);
             dcl-subf CMLOOK char(3) Inz(*Blanks);
           END-DS;
           dcl-ds tot_detail;
             dcl-subf maxDaysLate zoned(4:0) Inz(0);
             dcl-subf totLateCharge zoned(11:2) Inz(0);
             dcl-subf lastLcDate zoned(7:0) Inz(0);
           END-DS;

           If ARGRAC > ARWAIT;
             DaysLate = %DIFF(ThisDate:AR1STL:*DAYS) + ARGRAC;
            Else;
             DaysLate = %DIFF(ThisDate:AR1STL:*DAYS) + ARWAIT;
           EndIf;

           Today7 = %int(%char(%Date():*cymd0));

           Exec SQL //  Get Total Invoice Balance
             SELECT sum( AR$AMT )
               INTO :InvoiceBalance
               FROM faropndd
               WHERE ARINV# = :ThisInvoice
                 and ARCUST = :ThisCust
                 and ARTDAT <= :ThisDate7;

           // If FARCTL set to Charge Late Charges on Late Charges
           If ACLCLC = 'Y';
             LCBaseAmount = InvoiceBalance;
            else;
             Exec SQL //  Get L/C Base Amount
               SELECT sum( AR$AMT )
                 INTO :LCBaseAmount
                 FROM faropndd
                 WHERE ARINV# = :ThisInvoice
                   and ARCUST = :ThisCust
                   and ARSUFF <> 'LC'
       //  Bill S. doesn't want the date considered in the late charge calculation.
       //          The late charge should only be calculated if the invoice is still
       //          unpaid on the actual date not the as-of-date.
       //          and ARTDAT <= :ThisDate7;
                   and ARTDAT <= :Today7;
           ENDIF;

           // Apply any cash on hand
           If CashOnHand > 0;
             If CashOnHand >= LCBaseAmount;
               CashOnHand -= LCBaseAmount;
               Return;
              Else;
               LCBaseAmount -= CashOnHand;
               CashOnHand = 0;
             ENDIF;
           ENDIF;

           LateCharge = LCBaseAmount * (ACLCPC/100);
           If LateCharge < ACLCMN;
             LateCharge = ACLCMN;
           ENDIF;

           Exec SQL //  Write LateCharge Detail record
             INSERT INTO FARLCD
               VALUES( :ThisCust
                     , :ThisInvoice
                     , '  '
                     , :DaysLate
                     , :LateCharge
                     , :InvoiceBalance
                     , :LCBaseAmount
                     , :ThisDate7
                     , :Today7 );

           //  Write FMTRAN Record
           If LateCharge <> 0;
             Clear CM_CTYP_LOOK_DS;
             Exec SQL // Get Customer Type and Alpha Lookup
               Select  CMCTYP||CMLOOK
               into   :CM_CTYP_LOOK_DS
               from    FMCUST
               where   CMCUST = :ThisCUST
               Fetch First Row Only;
             Chain ( 3912 : ThisDate6 : 'LC' : 0 ) FMTRAN;
             If not %found(FMTRAN);
               Clear RMTRAN;
               MTCUST = 3912;
               MTINV# = ThisDate6;
               MTSUFF = 'LC';
               MTSEQ# = 0;
               MTSTAT = 'A';
               MTCOMP = 1;
             EndIf;
             MTTTYP = 07;
             MTTDAT = Today7;
             MTDUDT = Today7;
             MT$AMT += LateCharge;
             MTSHCU = 3912;
             MTSACU = 3912;
             MTBLCU = 3912;
             MTLOOK = 'Late Charges';
             MTDESC = 'Late Charges Posted';
             MTDTLA = %Int(%Char(%Date():*MDY0));
             MTTIME = %Int(%Char(%Time():*HMS0));
             MTUSER = ThisUser;
             MTCTYP = CMCTYP;     // need this
             If not %found(FMTRAN);
               Write RMTRAN;
              Else;
               Update RMTRAN;
             Endif;
           Endif;

           Clear tot_detail;
           Exec SQL //  Get LateCharge Detail records totals
             SELECT Max(ARDAYS)
                  , sum(ARMAMT)
                  , Max(ARLMLC)
             INTO  :tot_detail
             FROM   farlcd
             WHERE  ARINV# = :ThisInvoice
               and  ARCUST = :ThisCust;

           Exec SQL //  Update Late Charge Header
             Update FARLC
               Set  ARLCDY = :maxDaysLate
                 ,  ARLCDU = :totLateCharge - ARLCPD
                 ,  ARLCAM = :totLateCharge
                 ,  ARLMLC = :lastLcDate
                 ,  ARLCTM =  current timestamp
                 ,  ARLCPG = :ThisProgram
             WHERE  ARINV# = :ThisInvoice
               and  ARCUST = :ThisCust;

         end-proc;

      //------------------------------------------------------------------------
      // $Year - Get the year from the date
      //------------------------------------------------------------------------
         dcl-proc $Year;
           dcl-pi *n UNS(5) ;
             DateIn DATE options(*nopass) value ;
           end-pi ;
           Return %subdt(DateIn:*YEARS);
         end-proc;

