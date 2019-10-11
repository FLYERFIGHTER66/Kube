     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Dec. 2013            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? : Adds an Dummy Order to FPUTORD for Ready Bay Additions    ?:
      *? :............................................................:

     FFCALENCY  IF   E           K DISK                                         ?Calendar File
     FFPUTORDO  UF A E           K DISK                                         ?Calendar File
     FFHORDR    UF A E           K DISK                                         ?Calendar File
     FFHORDRHISTO  A E           K DISK

     D GRS620          PI
     D  weekSelected                  7S 0
     D  Master#                       2S 0

      * Function Prototypes
     D/COPY QFunctDefn,$_Dates
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$TimeStamp

      * Field Definitions
     D orderToCreate   S                   Like(PDORD#) Inz(0)                  ?SFLRRN Screen 02
     D maxSequence     S                   Like(PDSEQ#) Inz(0)                  ?SFLRRN Screen 02
     D today7          S              7S 0 Inz(0)                               ?SFLRRN Screen 02

      * Data Structure
     D C1_DS           DS                  Inz
     D  LRCRDY                             Like(PDSHPD)
     D  LRITEM                             Like(PDITEM)
     D  LRSIZE                             Like(PDSIZE)
     D  available                          Like(PDQORD)
     D  LRALPH                             Like(PDLOOK)

      /Free

       Chain weekSelected FCALENCY;
       If %Found(FCALENCY);
         orderToCreate = 990000 + (CLYEAR*100) + CLWEEK;
         today7 = $Date7($Date(0));
       Else;
         *InLR = *On;
         Return;
       ENDIF;

       //Establish SQL Cursor for Records to be inserted
       Exec SQL  Declare C1 Cursor For

       SELECT    ALL
                 LRCRDY
              ,  substr(LRITEM,1,11) ||
                   case when LRCUST = 999997 then 'P' else ' ' end
              ,  LRSIZE
              ,  sum(LRQTOH)-sum(LRQTAL)
              ,  min(LRALPH)
       FROM      fdlotrd
       GROUP BY  LRCRDY
              ,  LRITEM
              ,  LRSIZE
              ,  LRGLOC
              ,  LRCUST
       HAVING    sum(LRQTOH)-sum(LRQTAL) > 0
          and    LRGLOC                  = 'S'
          and    LRCRDY                  = :weekSelected
       ORDER BY  LRCRDY
              ,  LRITEM
              ,  LRSIZE;

       //Open the SQL Cursor
       Exec SQL Open C1;

       //Read through SQL Cursor and Write/Update FPUTORD
       Exec SQL Fetch C1 into :C1_DS;
       DoW SQLSTT <> '02000';
         //We have a good Record...  See if it exists on the FPUTORDO File
         Chain (LRCRDY:Master#:orderToCreate:LRITEM:LRSIZE) FPUTORDO;
         Chain orderToCreate FHORDR;
         If not %Found(FHORDR);
           OHSTAT = 'A';
           OHORD# = orderToCreate;
           OHCOMP = 1;
           OHDTRY = weekSelected;
           OHLOC  = '999999';
           OHCUST = 999996;
           OHNAME = 'Ready Bay Select Order';
           OHUSER = 'GRS620';
           Write RHORDR;
           HSTUSER    = $User() ;
           HSTPROGRAM = 'GRS620';
           HSTTIME    = $Timestamp();
           Write     RHORDRHIST;
         ENDIF;
         If %Found(FPUTORDO);
           evalR PDLOC = %Trim(OHLOC);
           PDQORD = available;
           Update RPUTORD;
         Else;
           Exec SQL Select max(PDSEQ#) into :maxSequence
               from FPUTORD where PDORD# = :orderToCreate;

           PDORD# = orderToCreate;    //TEXT('ORDER NUMBER')
           PDSEQ# = maxSequence + 1;  //TEXT('ORDER SEQ. NUMBER')
           PDSHPD = LRCRDY;           //TEXT('SHIP DATE CYMD')
           PDMAST = Master#;          //TEXT('MASTER NUMBER')
           PDCUST = 999996;           //TEXT('CUSTOMER NUMBER')
           PDITEM = LRITEM;           //TEXT('ITEM #')
           PDSIZE = LRSIZE;           //TEXT('SIZE CODE')
           PDQORD = available;        //TEXT('QTY ORDERED')
           PDQSCH = 0;                //TEXT('QTY SCHEDULED')
           PDQSCN = 0;                //TEXT('QTY SCANNED')
           PDLOTC = 'Y';              //TEXT('LOT CONTROL Y/N')
           PDPRTD = ' ';              //TEXT('PRINTED Y/N')
           PDLOOK = LRALPH;           //TEXT('ALPHA SEARCH')
           EvalR PDLOC = %Trim(OHLOC);//TEXT('ORDER LOCATION')
           PDORDY = today7;           //TEXT('ORDER DATE CYMD')
           PDBORD = ' ';              //TEXT('BACK ORDER B/ ')
           PDSTA  = ' ';              //TEXT('STA Y/N')
           PDRDYB = ' ';              //TEXT('READY BAY Y/ ')
           Write RPUTORD;
         ENDIF;
         Exec SQL Fetch C1 into :C1_DS;
       ENDDO;

       Exec SQL Close C1;

       *InLR = *On;
       Return;

      /End-Free
