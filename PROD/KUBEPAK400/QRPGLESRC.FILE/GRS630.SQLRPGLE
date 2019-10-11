     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:                     Ready Bay Check Out                    :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  April 2004           ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? : Adds an Dummy Order to FPUTORD for Ready Bay Additions    ?:
      *? :............................................................:

     FFPUTORDO  UF A E           K DISK                                         ?PS Order File
     FFHORDR    UF A E           K DISK                                         ?Order Header
     FFHORDRHISTO  A E           K DISK

     D GRS630          PI
     D  weekSelected                  7S 0
     D  Master#                       2S 0
     D  modeSelected                  1A                                        C=Count R=Run
     D  TrayCount                     5S 0                                      ?Tray Count

      * Function Prototypes
     D/COPY QFunctDefn,$_Dates
     D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$TimeStamp

      * Field Definitions
     D maxSequence     S                   Like(PDSEQ#) Inz(0)                  ?SFLRRN Screen 02
     D today7          S              7S 0 Inz(0)                               ?SFLRRN Screen 02

      * Data Structure
     D C1_DS           DS                  Inz
     D  orderToCreate                      Like(PDORD#)
     D  AICRDY                             Like(PDSHPD)
     D  AISHPD                             Like(PDSHPD)
     D  AIITEM                             Like(PDITEM)
     D  AISIZE                             Like(PDSIZE)
     D  AIQTOA                             Like(PDQORD)
     D  IMLOOK                             Like(PDLOOK)
     D  CLWEEK                        2S 0
     D  CLYEAR                        2S 0

      /Free
           Exec SQL
           SELECT    Sum(AIQTOA)
                     Into :TrayCount
           FROM      FALITEM
           WHERE     AISHPD > AICRDY
             and     AICRDY = :weekSelected
             and     AIQTOA > 0;
         If modeSelected = 'C';
           *InLR = *On;
           Return;
          Else;
           //Establish SQL Cursor for Records to be inserted
           Exec SQL  Declare C1 Cursor For
           SELECT    980000 + (CLYEAR*100) + CLWEEK
                ,    AICRDY
                ,    AISHPD
                ,    AIITEM
                ,    AISIZE
                ,    AIQTOA
                ,    IMLOOK
                ,    CLWEEK
                ,    CLYEAR
           FROM      FALITEM, FCALENCY, FMINVT
           WHERE     AISHPD = CLCYMD
             and     AIITEM = IMITEM
             and     AISIZE = IMSIZE
             and     AISHPD > AICRDY
             and     AICRDY = :weekSelected
             and     AIQTOA > 0
           ORDER BY  AICRDY
                  ,  AIITEM
                  ,  AISIZE;

           //Open the SQL Cursor
           Exec SQL Open C1;

           //Read through SQL Cursor and Write/Update FPUTORD
           Exec SQL Fetch C1 into :C1_DS;
           DoW SQLSTT = '00000';
             //We have a good Record...  See if it exists on the FPUTORDO File
             Chain (AICRDY:Master#:orderToCreate:AIITEM:AISIZE) FPUTORDO;
             Chain orderToCreate FHORDR;
             If not %Found(FHORDR);
               OHSTAT = 'A';
               OHORD# = orderToCreate;
               OHLOC  = '999998';
               OHCUST = 999995;
               OHNAME = 'Hold and Ship Week ' + %Char(CLYEAR) +
                        '-' + %Char(CLWEEK);
               OHDTLA = $MDYdate($Date(0));
               OHTIME = $Now();
               OHUSER = 'GRS630';
               Write RHORDR;
               HSTUSER    = $User()      ;
               HSTPROGRAM = 'GRS630'     ;
               HSTTIME    = $Timestamp() ;
               Write     RHORDRHIST      ;
             ENDIF;
             If %Found(FPUTORDO);
               EvalR PDLOC = %Trim(OHLOC);
               PDQORD = AIQTOA;
               Update RPUTORD;
             Else;
               Exec SQL Select max(PDSEQ#) into :maxSequence
                   from FPUTORD where PDORD# = :orderToCreate;

               PDORD# = orderToCreate;    //TEXT('ORDER NUMBER')
               PDSEQ# = maxSequence + 1;  //TEXT('ORDER SEQ. NUMBER')
               PDSHPD = AICRDY;           //TEXT('SHIP DATE CYMD')
               PDMAST = Master#;          //TEXT('MASTER NUMBER')
               PDCUST = 999995;           //TEXT('CUSTOMER NUMBER')
               PDITEM = AIITEM;           //TEXT('ITEM #')
               PDSIZE = AISIZE;           //TEXT('SIZE CODE')
               PDQORD = AIQTOA;           //TEXT('QTY ORDERED')
               PDQSCH = 0;                //TEXT('QTY SCHEDULED')
               PDQSCN = 0;                //TEXT('QTY SCANNED')
               PDLOTC = 'Y';              //TEXT('LOT CONTROL Y/N')
               PDPRTD = ' ';              //TEXT('PRINTED Y/N')
               PDLOOK = IMLOOK;           //TEXT('ALPHA SEARCH')
         evalR PDLOC  = %Trim(OHLOC);     //TEXT('ORDER LOCATION')
               PDORDY = today7;           //TEXT('ORDER DATE CYMD')
               PDBORD = ' ';              //TEXT('BACK ORDER B/ ')
               PDSTA  = ' ';              //TEXT('STA Y/N')
               PDRDYB = ' ';              //TEXT('READY BAY Y/ ')
               Write RPUTORD;
             ENDIF;
             Exec SQL Fetch C1 into :C1_DS;
           ENDDO;

           Exec SQL Close C1;

         EndIf;

         *InLR = *On;
         Return;

      /End-Free
