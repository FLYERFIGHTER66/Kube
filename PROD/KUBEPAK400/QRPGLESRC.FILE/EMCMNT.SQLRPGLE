     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: EMCMNT.01                                                  :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2014                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : EMCMNT.01?Original Version                                ?:
      *? :............................................................:

     FEMCMNTFM  CF   E             WORKSTN
     F                                     SFILE(EMCMNT01S:RRN01)

      //  Main procedure prototype & interface
     D EMCMNT          PR                  ExtPgm('EMCMNT')
     D  #Account                      6P 0
     D  #RRN                          9P 0
     D  #Update                        N
     D EMCMNT          PI
     D  #Account                      6P 0
     D  #RRN                          9P 0
     D  #Update                        N

      *? Function Prototypes
     D Load01          PR
     D Scrn01          PR
     D Edit01          PR

     D Load02          PR
     D Scrn02          PR
     D Edit02          PR
     D isEmailAd       PR              N
     D   #CustEmail                 256A

    ?D/COPY QFunctDefn,$ErrMsg
    ?D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$Center
     D/COPY QFunctDefn,$isPrinter
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$TimeStamp
     D/COPY QFunctDefn,$RtvMsgD
    ?D/COPY QFunctDefn,QCMDEXC
    ?D/COPY QFunctDefn,$_DATES

      *? Data Structures
     D                SDS
     D  $PGM             *PROC

     D FMEMAIL_DS    E DS                  extname(FMEMAIL)

     D ScreenCodes     DS
     D  TBS01
     D  TBS02
     D  TBS03
     D  TBS04
     D  TBS05
     D  TBS06
     D  TBS07
     D  TBS08
     D  TBS09
     D  TBS10
     D  TBS11
     D  TBS12
     D  TBS13
     D  TBS14
     D  TBS15
     D  TBSHRT_Array                       Like(TBS01) Dim(15)
     D                                     Overlay(ScreenCodes)
     D  TBTBCD_Array   S              3A   Dim(15)

     D Code_DS         DS
     D  CODE01
     D  CODE02
     D  CODE03
     D  CODE04
     D  CODE05
     D  CODE06
     D  CODE07
     D  CODE08
     D  CODE09
     D  CODE10
     D  CODE11
     D  CODE12
     D  CODE13
     D  CODE14
     D  CODE15
     D  CodeArray                          Like(CODE01) Dim(15)
     D                                     Overlay(Code_DS)

      *? Field Definitions
     D   Screen        S              3S 0 Inz(0)                               ?Screen Number
     D   RRN01         S              4S 0                                      ?SFL RRN
     D   SelDate7      S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   blank50       S             50A   Inz(*Blanks)                         ?50 Blanks
     D   CUST20        S             20A   Inz(*Blanks)                         ?Cust Name 20
     D   Printer       S             10A                                        ?Printer to Use
     D   TimeStamp     S               Z                                        ?TimeStamp
     D   User          S             10A                                        ?User ID
     D   SELACCOUNT    S              6S 0                                      ?
     D   SELNAME       S             30A                                        ?
     D   SELEMAIL      S             30A                                        ?
     D   SELACTIVE     S              1A                                        ?
     D   SELSEARCH     S             30A                                        ?
     D   SELTYPE       S              3A                                        ?
     D   SQLNAME       S             32A                                        ?
     D   SQLEMAIL      S             32A                                        ?
     D   SQLSEARCH     S             32A                                        ?
     D   SelSave       S           1200A
     D   SaveKeys02    S            286A
     D   invalid       S               N                                        invalid email add.

    ?D/COPY QFunctDefn,$isEmailAd
      /Free

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:

         DoW *InLR <> *On;
           Select;
             When Screen = 01;
               Edit01();
             When Screen = 02;
               Edit02();
             Other;
               Initialize();
               Load01();
               Scrn01();
           ENDSL;
         ENDDO;

         *InLR = *On;

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Sub-Procedures                                                   :
      // :..................................................................:

    ?D/COPY QFunctDefn,$ErrMsgSP

       dcl-proc Initialize;

         $ERR_PROG  = $PGM;
         Monitor;
           SelAccount = %dec(#Account:6:0);
          On-Error;
           SelAccount = 373;  // Default to Misc. se we don have to load so many
         EndMon;
         SelActive  = 'Y';
         SelName    = ' ';
         SelEmail   = ' ';
         SelSearch  = ' ';
         SelType    = '   ';
         SelSave =
         SELSEARCH+SELACTIVE+SELTYPE+%Char(SELACCOUNT)+SELNAME+SELEMAIL;
         Buttons();
         Monitor;
           *IN41 = #Update;
          On-Error;
           *In41 = *Off;  // Default to inquiry mode.
           #Update = *In41;
         EndMon;

       end-proc;
       //_____________________________________________________________
       //
       dcl-proc Buttons;

     D  XATABL_DS    E DS                  extname(XATABL)
     D  GoodCode       S               N   Inz(*On)
     D  X              S              2S 0 Inz(0)

         DoW GoodCode and X < 15;
           GoodCode = *Off;
           Exec SQL
             SELECT  *
             INTO   :XATABL_DS
             FROM    XATABL
             WHERE   TBRCDE='T'
               AND   SUBSTR(TBTBCD,1,2)='EM'
               AND   TBTBCD > :TBTBCD
             FETCH FIRST ROW ONLY;
           If SQLSTATE = '00000';
             GoodCode = *On;
             X += 1;
             TBSHRT_Array(X) = %Subst(TBTBCD:3:3) +': '+ TBSHRT;
             TBTBCD_Array(X) = %Subst(TBTBCD:3:3);
           EndIf;
         EndDo;

       end-proc;

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 1 SubProcedures                                           :
      // :..................................................................:
       dcl-proc Load01;

     D LastSqlKey      S            293A
     D GoodFetch       S               N

         RRN01 = 0;
         *In25 = *Off;  // Clear Subfile
         Write EMCMNT01C;
         *In26 = *Off;  // Subfile Data Indicator
         *In25 = *On;
         RRN01 = 0;

         SqlName    = '%' + %Trim(SelName)    + '%';
         SqlEmail   = '%' + %Trim(SelEmail)   + '%';
         SqlSearch  = '%' + %Trim(SelSearch)  + '%';
         SqlState   = '00000';
         LastSqlKey = *Blanks;
         GoodFetch  = *On;

         DoW GoodFetch and RRN01 < 2000;
           GoodFetch = *Off;
           Exec SQL
             Select    *
             into      :FMEMAIL_DS
             from       FMEMAIL
             Where     (EMACTT   =  'C')
               and     (EMSTAT   =  'A'         or :SelActive <> 'Y')
               and     (EMACCT   =  :SelAccount or :SelAccount = 0  )
               and     (EMCODE   =  :SelType    or :SelType    = ' ')
               and     (upper(EMNAME) like trim(:SqlName) or :SelName  = ' ')
               and     (upper(EMAIL) like trim(:SqlEmail) or :SelEmail = ' ')
               and     (EMACTT||EMNAME||EMAIL||EMACCT > :LastSqlKey)
               and     (:SqlSearch = ' ' or EMACCT in
                       (Select CMCUST from FMCUST
                        Where upper(CMNAME) like trim(:SqlSearch)
                           or upper(CMADD2) like trim(:SqlSearch)
                           or upper(CMADD3) like trim(:SqlSearch)
                           or upper(CMADD4) like trim(:SqlSearch)
                           or upper(CMCITY) like trim(:SqlSearch)
                           or  char(CMPHON) like trim(:SqlSearch)
                           or upper(CMCNAM) like trim(:SqlSearch)
                           or upper(CMFNAM) like trim(:SqlSearch)
                           or upper(CMLNAM) like trim(:SqlSearch)
                           or upper(CMCNME) like trim(:SqlSearch)
                           or  char(CMPHO2) like trim(:SqlSearch)))
             Order by  EMACTT, EMNAME, EMAIL, EMACCT
             Fetch First Row Only;

           If SQLState = '00000';
             GoodFetch = *On;
             LastSqlKey = EMACTT+EMNAME+EMAIL+%Char(EMACCT);
             LastSqlKey = EMACTT+EMNAME+EMAIL+%Trim(%EditC(EMACCT:'Z'));
             EMAIL50 = %Subst(%Trim(EMNAME)+' <'+%Trim(EMAIL)+'>'+blank50:1:50);

             Exec SQL // Get Customer Info
               SELECT substr(
                     (trim(CMCITY)||', '||
                      trim(CMSTST)||' '||
                      trim(CMZIP )||', '||
                      trim(CMPHON)||', '||
                      trim(CMCNME)),1,75)
               INTO :CUSTVEND
               FROM fmcust
               WHERE CMCUST = :EMACCT;

             Exec SQL // Get Customer Info
               SELECT substr(trim(CMNAME),1,20)
               INTO :CUST20
               FROM fmcust
               WHERE CMCUST = :EMACCT;
             CustName = $Center(Cust20:%Len(%Trim(CUST20)));

             Codes();
             RRN01 += 1;
             Write EMCMNT01S;
             *In26 = *On;  //Non-Empty Subfile
           EndIf;
         EndDo;
         If *In26;
           Chain RRN01 EMCMNT01S;
           *In27 = *On;
           Update EMCMNT01S;
           *In27 = *Off;
         EndIf;

       end-proc;
      //_____________________________________________________________________
      //
       dcl-proc Scrn01;

         Screen = 01;
         write ASSUME;
         write EMCMNT01F;

         If SFLCSRRRN > 0;
           SFLPOSTO1 = SFLCSRRRN;
           If SFLPOSTO1 > RRN01;
             SFLPOSTO1 = RRN01;
             SFLCSRRRN = RRN01;
           EndIf;
          Else;
           SFLPOSTO1 = 1;
         EndIf;


         SFLRCDS = RRN01;
         If *In50;
           write msgctl;
         EndIf;
         exfmt EMCMNT01C;
         $ClrError();
       end-proc;
      //_____________________________________________________________________
      //
       dcl-proc Edit01;

         Select;

           When *In03;
             *InLR = *On;
           When *In05;
             Load01();
             Scrn01();
           When *In04;  //  Call inquiry for Tpye Code
           //SomeProgram();
             Load01();
             Scrn01();
           When *In06 and SelAccount = 0;  //  Call inquiry for Tpye Code
             $SndError('EML0004':' ');
             Scrn01();
           When *In06 and SelAccount <> 0;  // Add new Name
             Clear EMNAME;
             Clear EMAIL;
             Clear Code_DS;
             Clear SaveKeys02;
             EMSTAT = 'A';
             EMACTT = 'C';
             EMACCT = SelAccount;
             Scrn02();
           When SelSave <>
             SELSEARCH+SELACTIVE+SELTYPE+%Char(SELACCOUNT)+SELNAME+SELEMAIL;
             SelSave =
             SELSEARCH+SELACTIVE+SELTYPE+%Char(SELACCOUNT)+SELNAME+SELEMAIL;
             Load01();
             Scrn01();
           When #Update and SFLCSRRRN <> 0;
             Load02();
             Scrn02();
           When SFLCSRRRN <> 0;
             Chain SFLCSRRRN EMCMNT01S;
             Exec SQL // Get RRN for first matching name.
               Select  MIN(RRN(FMEMAIL))
               Into   :#RRN
               From    FMEMAIL
               Where   EMSTAT = 'A'
                 and   EMACTT = 'C'
                 and   EMACCT = :SelAccount
                 and   EMNAME = :EMNAME
                 and   EMAIL  = :EMAIL;
             *InLR = *On;
           Other;
             Scrn01();
         EndSl;

       end-proc;

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 2 SubProcedures                                           :
      // :..................................................................:
       dcl-proc Load02;

         Chain SFLCSRRRN EMCMNT01S;
         SaveKeys02 = EMNAME + EMAIL;
         Codes();

       end-proc;
       //_____________________________________________________________
      //
       dcl-proc Codes;


     D  GoodCode       S               N   Inz(*On)
     D  Code           S              3A   Inz(*Blanks)
     D  X              S              2S 0 Inz(0)

         Clear CodeArray;

         DoW GoodCode and X < 15;
           GoodCode = *Off;
           Exec SQL
             SELECT  EMCODE
             INTO    :Code
             FROM     FMEMAIL
             WHERE    EMACTT=:EMACTT
               AND    EMACCT=:EMACCT
               AND    EMNAME=:EMNAME
               AND    EMAIL =:EMAIL
               AND    EMCODE > :Code
             ORDER BY EMCODE
             FETCH FIRST ROW ONLY;
           If SQLSTATE = '00000';
             GoodCode = *On;
             X += 1;
             CodeArray(X) = Code;
           EndIf;
         EndDo;

       end-proc;

       //_____________________________________________________________
      //
       dcl-proc AllowMultiple;   // return true if the #code is allowed to occure multiple times
         dcl-pi *n ind;
           #Code Char(3) Const;
         end-pi;

         If #code = 'TRK';
           Return *On;
          Else;
           Return *Off;
         ENDIF;

       end-proc;

       //_____________________________________________________________
      //
       dcl-proc PickCodeSP;
         dcl-pi *n;
           #Code Char(3) Const;
         end-pi;

       dcl-s ExistHere Ind inz(*Off);
       dcl-s ExistOther Ind inz(*Off);

           Exec SQL
             SELECT  '1'
             INTO   :ExistHere
             FROM    FMEMAIL
             WHERE   EMACTT=:EMACTT
               AND   EMACCT=:EMACCT
               AND   EMNAME=:EMNAME
               AND   EMAIL =:EMAIL
               AND   EMCODE = :#Code
             FETCH FIRST ROW ONLY;
           If ExistHere;  //Remove
             Exec SQL
               Delete  FMEMAIL
               WHERE   EMACTT=:EMACTT
                 AND   EMACCT=:EMACCT
                 AND   EMNAME=:EMNAME
                 AND   EMAIL =:EMAIL
                 AND   EMCODE = :#Code;
            Else;
             Exec SQL
               SELECT  '1'
               INTO   :ExistOther
               FROM    FMEMAIL
               WHERE   EMACTT=:EMACTT
                 AND   EMACCT=:EMACCT
                 AND   EMCODE = :#Code
               FETCH FIRST ROW ONLY;
             If not ExistOther or AllowMultiple(#Code) ;  //Add New
               TimeStamp = $TimeStamp;
               User = $User;
               Exec SQL  // Create a new Entry in the FMEMAIL File
                 INSERT INTO FMEMAIL
                 (EMSTAT, EMACTT, EMACCT, EMCODE, EMNAME, EMAIL, EMTMST, EMUSER)
                 VALUES('A'
                      , 'C'
                      , :EMACCT
                      , :#Code
                      , :EMNAME
                      , :EMAIL
                      , :TimeStamp
                      , :USER  );
              Else;
               $SndError('EML0002':#Code);
             EndIf;
           EndIf;

       end-proc;


       //_____________________________________________________________
      //
       dcl-proc NewNamesSP;


     D  PrevEMNAME     S                   Like(EMNAME)
     D  PrevEMAIL      S                   Like(EMAIL)

         TimeStamp = $TimeStamp;
         User = $User;

         PrevEMNAME = %Subst(SaveKeys02:01:030);
         PrevEMAIL  = %Subst(SaveKeys02:31:256);

         Exec SQL  // Create a new Entry in the FMEMAIL File
           UPDATE   FMEMAIL
           SET      EMNAME=:EMNAME
             ,      EMAIL =:EMAIL
             ,      EMTMST=:TimeStamp
             ,      EMUSER=:User
           WHERE    EMACTT=:EMACTT
             AND    EMACCT=:EMACCT
             AND    EMNAME=:PrevEMNAME
             AND    EMAIL =:PrevEMAIL;

       end-proc;
      //_____________________________________________________________________
      //
       dcl-proc Scrn02;

         Screen = 02;
         write ASSUME;

         If *In50;
           write msgctl;
         EndIf;

         If Code_DS = *Blank;
           *In53 = *On;
          Else;
           *In53 = *Off;
         EndIf;

         *In54 = *Off;
         if email <> *blank;
           *In54 = not isEmailAd(email);  // *In54 = this is not a valid email address
         ENDIF;

         exfmt EMCMNT02;

         $ClrError();

         invalid = email <> *blank and not isEmailAd(email);  // this is not a valid email address
         if invalid;
           $SndError('EML0001':EMAIL);
         ENDIF;

       end-proc;
      //_____________________________________________________________________
      //
       dcl-proc Edit02;


         Select;

           When *In03;
             *InLR = *On;
           When *In12;
             Load01();
             Scrn01();
           When PICKCODES <> 0;
             PickCodeSP(TBTBCD_Array(PickCodes));
             Codes();
             Scrn02();
           When SaveKeys02 <> EMNAME + EMAIL
            and ( not invalid or (invalid and *In14) );
             NewNamesSP();
             Load01();
             Scrn01();
           When not *In13 and Code_DS = *Blanks;
             $SndError('EML0003':' ');
             Scrn02();
           When SaveKeys02 <> EMNAME + EMAIL and invalid;
             Scrn02();
           Other;
             Load01();
             Scrn01();
         EndSl;
       end-proc;
      //_____________________________________________________________________
      //
      /End-Free
     P isEmailAd       B
     D isEmailAd       PI              N
     D  #CustEmail                  256A
    ?D/COPY QFunctDefn,$isEmailAd
      /Free

         Return $isEmailAd(%subst(#CustEmail:001:32):
                           %subst(#CustEmail:033:32):
                           %subst(#CustEmail:065:32):
                           %subst(#CustEmail:097:32):
                           %subst(#CustEmail:129:32):
                           %subst(#CustEmail:161:32):
                           %subst(#CustEmail:193:32):
                           %subst(#CustEmail:225:32));

       end-proc;


