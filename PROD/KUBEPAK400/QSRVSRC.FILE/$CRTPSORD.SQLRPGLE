     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DatFmt(*USA)
     H BndDir('KPFUNCTION')
     H NoMain

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

     FFPLGSETO# UF A E           K DISK    UsrOpn                               ?Plug Setup

      *? Function Prototypes
    ?D/COPY QFunctDefn,$CrtPSOrd
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$_Dates

     P $CrtPSOrd       B                   Export
     D $CrtPSOrd       PI
     D  SDateYMD7                     7S 0 Const
     D  SGMSTR                        2S 0 Const

      * Data Structure
     D C1_DS           DS                  Inz
     D  HSOrder                            Like(PGORD#)
     D  CLWEEK                        2S 0
     D  CLYEAR                        2S 0
     D  TrayCount                    15S 2


      /Free

         If not %Open(FPLGSETO#);
                 open FPLGSETO# ;
         EndIf;

         //Establish SQL Cursor for Records to be inserted
         Exec SQL  Declare C1 Cursor For
           SELECT    980000 + (CLYEAR*100) + CLWEEK
                ,    CLWEEK
                ,    CLYEAR
                ,    Sum(AIQTOA)
           FROM      FALITEM, FCALENCY
           WHERE     AISHPD = CLCYMD
             and     AISHPD > AICRDY
             and     AICRDY = :SDateYMD7
             and     AIQTOA > 0
           GROUP BY  980000 + (CLYEAR*100) + CLWEEK
                ,    CLWEEK
                ,    CLYEAR
           ORDER BY  980000 + (CLYEAR*100) + CLWEEK
                ,    CLWEEK
                ,    CLYEAR;

         //Open the SQL Cursor
         Exec SQL Open C1;

         //Read through SQL Cursor and Write FPLGSET Records
         Exec SQL Fetch C1 into :C1_DS;
         DoW SQLSTT = '00000';
         //We have a good Record...  See if it exists on the FHORDR File
           Chain (SDateYMD7:SGMSTR:HSOrder) FPLGSETO#;
           If %Found(FPLGSETO#);
             PGLGFL = TrayCount;
             Update RPLGSET;
            Else;
             If TrayCount > 0;
               PGWKDT = SDateYMD7;
               PGMSTR = SGMSTR;
               PGSVIA = '40';
               PGSEQ2 = 01;
               PGSEQ1 = 01;
               PGSORT = 'Kube-Pak H&S. Ships: 20' +
                         %Char(CLYEAR) + '-' + %EditW(CLWEEK:'0 ');
               PGSKIP = ' ';
               PGORD# = HSOrder;
               PGNAME = 'Kube-Pak H&S. Ships: 20' +
                         %Char(CLYEAR) + '-' + %EditW(CLWEEK:'0 ');
               PGSHP2 = 'ALLENTOWN';
               PGSHST = 'NJ';
               PGLOC  = ' ';
               PGLGFL = TrayCount;
               PGSMFL = 0;
               CLDTLA = $MDYDate($Date(0));
               CLTIME = $Now();
               CLUSER = $User();
               CLPGMN = 'PSR301';
               Write  RPLGSET;
             EndIf;
           EndIf;



           //Now get the Next Record
           Exec SQL Fetch C1 into :C1_DS;
         ENDDO;

         //Now close the data set and exit the program
         Exec SQL Close C1;

         *InLR = *On;
         Return;

         If %Open(FPLGSETO#);
            Close FPLGSETO# ;
         EndIf;

      /End-Free

     P $CrtPSOrd       E
