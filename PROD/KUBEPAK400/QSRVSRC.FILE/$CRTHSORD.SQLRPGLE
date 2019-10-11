     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DatFmt(*USA)
     H BndDir('KPFUNCTION')
     H NoMain


      *??:````````````````````````````````````````````````````````````:?
      *??:   Create H&S Dummy Orders for Plug Shipping                :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Dec. 2013            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? : Adds an Dummy Order to FPUTORD for Ready Bay Additions    ?:
      *? :............................................................:

     FFHORDR    UF A E           K DISK    USROPN                               ?Order Header
     FFPPO      UF A E           K DISK    USROPN                               ?Order Location

      *? Function Prototypes
     D/Copy QFunctDefn,$CrtHSOrd
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$MDYdate
    ?D/COPY QFunctDefn,$date

     P $CrtHSOrd       B                   Export
     D $CrtHSOrd       PI
     D  weekSelected                  7S 0 Const

      * Data Structure
     D C1_DS           DS                  Inz
     D  orderToCreate                      Like(OHORD#)
     D  CLWEEK                        2S 0
     D  CLYEAR                        2S 0

      /Free
         If not %Open(FHORDR);
                 open FHORDR ;
         EndIf;
         If not %Open(FPPO  );
                 open FPPO   ;
         EndIf;

         //Establish SQL Cursor for Records to be inserted
         Exec SQL  Declare C1 Cursor For
         SELECT    980000 + (CLYEAR*100) + CLWEEK
              ,    CLWEEK
              ,    CLYEAR
         FROM      FALITEM, FCALENCY
         WHERE     AISHPD = CLCYMD
           and     AISHPD > AICRDY
           and     AICRDY = :weekSelected
           and     AIQTOA > 0
         ORDER BY  AISHPD;

         //Open the SQL Cursor
         Exec SQL Open C1;

         //Read through SQL Cursor and Write FHORDR & FPPO
         Exec SQL Fetch C1 into :C1_DS;
         DoW SQLSTT = '00000';
           //We have a good Record...  See if it exists on the FHORDR File
           Chain orderToCreate FHORDR;
           If not %Found(FHORDR);
             OHORD# = orderToCreate;
             OHLOC  = 'TBD';
             OHCUST = 999995;
             OHNAME = 'Hold and Ship Week 20' + %Char(CLYEAR) +
                      '-' + %EditW(CLWEEK:'0 ');
             OHDTLA = $MDYdate($date(0));
             OHTIME = $Now();
             OHUSER = '$CrtHSOrd';
             Write RHORDR;
           ENDIF;
           //Now check the FPPO File
           Chain (orderToCreate) FPPO;
           If not %Found(FPPO);
             POORD# = orderToCreate;
             POTAKN = '$CrtHSOrd';
             POENTR = '$CrtHSOrd';
             POPICK = '$CrtHSOrd';
             POPACK = '$CrtHSOrd';
             POCONF = '$CrtHSOrd';
             Write RPPO;
           EndIf;
           //Now get the Next Record
           Exec SQL Fetch C1 into :C1_DS;
         ENDDO;

         //Now close the data set and exit the program
         Exec SQL Close C1;

         If %Open(FHORDR);
            Close FHORDR ;
         EndIf;
         If %Open(FPPO  );
            Close FPPO   ;
         EndIf;


         *InLR = *On;
         Return;

      /End-Free

     P $CrtHSOrd       E
