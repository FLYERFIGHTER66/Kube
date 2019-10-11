**free
  CTL-OPT
    DftActGrp(*no)
    DatFmt(*usa);

  DCL-PI CHKCUSFZON;
  END-PI;

  dcl-f FMCUSTZC keyed;
  dcl-f FMZIPSZC keyed;
  dcl-f CHKCUSFZNR printer OFLIND(*In01);

  Dcl-s   ZipKey       like(ZMZIP);
  Dcl-s   TestZip      like(CMZIP);
  Dcl-s   Freight_Zn   like(CMUPSZ);

  Dcl-s   FirstTime    Ind  Inz(*On) ;

  setll (*loval) FMCUSTZC;
  read  FMCUSTZC;
  DoW not %eof(FMCUSTZC);

  Select;
    When CMUPSZ = '1';
      Freight_Zn   = '1';                                                  //?Freight Zone 1
    When CMUPSZ = '2';
      Freight_Zn   = '2';                                                  //?Freight Zone 2
    When CMUPSZ = '3';
      Freight_Zn   = '3';                                                  //?Freight Zone 3
    When CMUPSZ = '4';
      Freight_Zn   = '4';                                                  //?Freight Zone 4
    When CMUPSZ = '5';
      Freight_Zn   = '5';                                                  //?Freight Zone 5
    When CMUPSZ = '6';
      Freight_Zn   = '6';                                                  //?Freight Zone 6
    When CMUPSZ = '7';
      Freight_Zn   = '7';                                                  //?Freight Zone 7
    When CMUPSZ = '8';
      Freight_Zn   = '8';                                                  //?Freight Zone 8
    When CMUPSZ = '9';
      Freight_Zn   = '9';                                                  //?Freight Zone 9
    When CMUPSZ = '0';
      Freight_Zn   = '0';                                                  //?Freight Zone 0
    When CMUPSZ = 'Z';
      Freight_Zn   = 'Z';                                                  //?Freight Zone Z
    Other;
      //? If Processing New Zip, First Calculate 'New Freight Zone'

      Freight_Zn   = 'W';                                                  //?Blank Zip Code

      If CMZIP <>  *Blanks;
        TestZip = *Blanks;
        %Subst(TestZip:10-%Len(%Trim(CMZIP)):
            %Len(%Trim(CMZIP))) = %Trim(CMZIP);

        If %check('0123456789':%Trim(CMZIP)) = 0;                          //?i.e. Zip is Numeric
          If %Int(%trim(CMZIP)) <= 99999;
            ZipKey = %Int(%trim(CMZIP));
           Else;
            ZipKey = %Int(%trim(%Subst(CMZIP:1:5)));
          EndIf;
         Else;
          ZipKey = 99999;
        EndIf;

        ZMMILE = *Zero;                                                    //?Zip Code Miles
        Chain ZipKey FMZIPSZC;
        If %Found(FMZIPSZC);
          Select;
          When ZMMILE >=   0 and ZMMILE <  26;
            Freight_Zn   = 'A';                                            //?  0 to  26
          When ZMMILE >=  26 and ZMMILE <  51;
            Freight_Zn   = 'B';                                            //? 26 to  51
          When ZMMILE >=  51 and ZMMILE <  76;
            Freight_Zn   = 'C';                                            //? 51 to  76
          When ZMMILE >=  76 and ZMMILE < 101;
            Freight_Zn   = 'D';                                            //? 76 to 101
          When ZMMILE >= 101 and ZMMILE < 126;
            Freight_Zn   = 'E';                                            //?101 to 126
          When ZMMILE >= 126 and ZMMILE < 151;
            Freight_Zn   = 'F';                                            //?126 to 151
          When ZMMILE >= 151 and ZMMILE < 176;
            Freight_Zn   = 'G';                                            //?151 to 176
          When ZMMILE >= 176 and ZMMILE < 201;
            Freight_Zn   = 'H';                                            //?176 to 201
          When ZMMILE >= 201 and ZMMILE < 226;
            Freight_Zn   = 'I';                                            //?201 to 226
          When ZMMILE >= 226 and ZMMILE < 251;
            Freight_Zn   = 'J';                                            //?226 to 251
          When ZMMILE >= 251 and ZMMILE < 276;
            Freight_Zn   = 'K';                                            //?251 to 276
          When ZMMILE >= 276 and ZMMILE < 301;
            Freight_Zn   = 'L';                                            //?276 to 301
          When ZMMILE >= 301 and ZMMILE < 326;
            Freight_Zn   = 'M';                                            //?301 to 326
          When ZMMILE >= 326 and ZMMILE < 351;
            Freight_Zn   = 'N';                                            //?326 to 351
          When ZMMILE >= 351 and ZMMILE < 376;
            Freight_Zn   = 'O';                                            //?351 to 376
          When ZMMILE >= 376 and ZMMILE < 401;
            Freight_Zn   = 'P';                                            //?376 to 401
          When ZMMILE >= 401 and ZMMILE < 426;
            Freight_Zn   = 'Q';                                            //?401 to 426
          When ZMMILE >= 426 and ZMMILE < 501;
            Freight_Zn   = 'R';                                            //?426 to 501
          When ZMMILE >= 501 and ZMMILE < 601;
            Freight_Zn   = 'S';                                            //?501 to 600
          When ZMMILE >= 601 and ZMMILE < 701;
            Freight_Zn   = 'T';                                            //?601 to 700
          When ZMMILE >= 701 and ZMMILE < 801;
            Freight_Zn   = 'U';                                            //?701 to 800
          When ZMMILE >= 801 and ZMMILE < 901;
            Freight_Zn   = 'V';                                            //?801 to 900
          When ZMMILE >= 901 and ZMMILE < 1001;
            Freight_Zn   = 'W';                                            //?901 to 1000
          Other;
            Freight_Zn   = 'X';                                            //?Out of Range
          EndSl;
        Else;
          Freight_Zn   = 'Y';                                              //?Zip Not Found
        EndIf;
      EndIf;

      //? Next, update all customer master records with appropriate Freight Zone
    EndSl;
    If CMUPSZ <> Freight_Zn and
          CMSTAT = 'A' and
          CMCUST < 900000;
      If FirstTime or *In01;
        Write Header;
        FirstTime = *Off;
        *In01     = *Off;
      EndIf;
      Write Detail;
    EndIf;

    // Now get next record and start over
    read  FMCUSTZC;
  ENDDO;

  *InLR = *On;
  return;

