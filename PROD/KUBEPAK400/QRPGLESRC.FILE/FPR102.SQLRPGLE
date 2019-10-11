      /COPY QFunctDefn,@CopyRight
     H   DftActGrp(*no)
     H   DatFmt(*usa)
     H   BndDir('*LIBL/KPFUNCTION')
     H   ALWNULL(*InputOnly)

      //?                                                              ?
      //??|                                                            |?
      //??|       Finished Crop Inventory                              |?
      //?|                                                            |?

      //?PROGRAM NAME-------- FPR102
      //?PROGRAMMER---------- WJB
      //?APPLICATION--------- PRINT BAY SHEETS FOR INVENTORY

      //?           CHANGE--DATE-------DESCRIPTION
      //?  2/23/16  WJB  Initial Programming

     FFPR102P   O    E             PRINTER OFLIND(Overflow)

      //? Main procedure prototype & interface
     D NCR721          PR                  ExtPgm('NCR721')
     D  #SEC                          2P 0
     D  #BAY                          2P 0
     D  #NOS                          1A
     D  #EOW                          1A
     D NCR721          PI
     D  #SEC                          2P 0
     D  #BAY                          2P 0
     D  #NOS                          1A
     D  #EOW                          1A

      //? Data Structures
     D  RFINLOC      E DS                  ExtName(FFINLOC)
     D  FLSECT@                       2A   Overlay(FLSECT)
     D  FLBAY@                        2A   Overlay(FLBAY)

      //? Field Definitions
     D  OverFlow       S               N   Inz(*Off)
     D  User           S             10A
     D  Today          S              6S 0
     D  Now            S              6S 0
     D  x              S              3S 0

      //? Function Prototypes
     D/COPY QFunctDefn,$_Dates
     D/COPY QFunctDefn,$Monday
     D/COPY QFunctDefn,$Month
     D/COPY QFunctDefn,$Day
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$Now
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$isCust

     D Headings        PR
     D Details         PR
     D Footers         PR
     D TableLookup     PR                  ExtPgm('XATABLE')
     D  #TABID                        2A   const
     D  ##KEYP#                       2A   const
     D  ##EELM#                       6A   const


      /FREE

         FLSECT = #SEC;
         FLBAY  = #BAY;
         FLNORS = #NOS;
         FLEORW = #EOW;

         Headings();
         Details();
         Footers();
         *InLR = *On;
         Return;

      /END-FREE
      //--------------------------------------------------------------------
     P Headings        B
     D Headings        PI
      /Free

         Side = FLNORS + FLEORW;
         Location = FLSECT@ + '0' + FLBAY@ + Side;
         Write Header;

      /END-FREE
     P Headings        E
      //--------------------------------------------------------------------
     P Details         B
     D Details         PI
      /Free

         Exec SQL   Declare C1 cursor for
           SELECT   *
           FROM     FFINLOC
           WHERE    FLSECT = :FLSECT
             and    FLBAY  = :FLBAY
             and    FLNORS = :FLNORS
             and    FLEORW = :FLEORW
           Order by FLGHSE
                  , FLSECT
                  , FLBAY
                  , FLNORS
                  , FLEORW
                  , FLSRTP
                  , FLENDP
                  , FLTAG#;
         Exec SQL   Close C1;
         Exec SQL   Open  C1;
         Exec SQL   Fetch C1 into :RFINLOC;
         DoW SQLState = '00000' or SQLState = '22007';
           IMDES1  = *Blanks;
           If FLSHIP <= $Date(20000101);
             FLSHIP@ = *Blanks;
            Else;
             EVALR FLSHIP@ = %Char($Month(FLSHIP)) + '/' + %Char($Day(FLSHIP));
           EndIf;
           If FLDATE <= $Date(20000101);
             FLDATE@ = *Blanks;
            Else;
             FLDATE@ = %Char($Month(FLDATE)) + '/' + %Char($Day(FLDATE));
           EndIf;
           If FLCUST <> 0;
             FLCUST@ = %Char(FLCUST);
             Exec SQL
               SELECT  TBSHRT
               INTO   :TBSHRT
               FROM    XATABL
               WHERE   TBTBCD = 'AB'||right('000000'||Trim(:FLCUST@),5);
             EvalR TBSHRT = %Trim(TBSHRT);
            Else;
             FLCUST@ = *Blanks;
             TBSHRT  = *Blanks;
           EndIf;
           Exec SQL
             SELECT   IMDES1
             INTO    :IMDES1
             FROM     FMINVT
             WHERE    IMITEM = :FLITEM
               and    IMSIZE = :FLSIZE;
           ITEMSIZE = %Trim(FLITEM) + ' (' + %Trim(FLSIZE) + ')';
           EvalR FLTAG#@  = '00000000' + %Char(FLTAG#);
           If OverFlow;
             Footers();
             Headings();
             OverFlow = *Off;
           EndIf;
           Write Detail;
           Exec SQL   Fetch C1 into :RFINLOC;
         EndDo;
         Exec SQL   Close C1;

      /END-FREE
     P Details         E
      //--------------------------------------------------------------------
     P Footers         B
     D Footers         PI
      /Free

         Write Footer;
         Write Boxes2;

      /END-FREE
     P Footers         E
