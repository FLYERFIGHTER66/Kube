     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)

     D GRS600          PI
     D  Week_Selected                 7S 0
     D  Verified                       N

      // Field Definitions
     D Cust999990      S             11S 1

      // Function Prototypes
     D/COPY QFunctDefn,$_DATES
     D/COPY QFunctDefn,$Monday

      /Free
       //:````````````````````````````````````````````````````````````:?
       //: Verify that the Lot Week has no Negative Balancing Records.
       //:............................................................:?
       //:````````````````````````````````````````````````````````````:
       //: Created:  August 2013          ? Kube-Pak Corporation ?    :
       //:      by:  William J. Behr                                  :
       //:............................................................:
       //:````````````````````````````````````````````````````````````:
       //:   Program Description                                     ?:
       //: ```````````````````````                                   ?:
       //: Return TRUE if the Lot Week is Verified                   ?:
       //:............................................................:

         //Test to see if the Lot Week has nagative Balancing Records

         Week_Selected = $Date7($Monday($Date(0):'FRI')) ;

         Exec SQL
           SELECT  sum(LRQTOH)
           INTO    :Cust999990
           FROM    FDLOTRD
           WHERE   LRCRDY = :Week_Selected
             and   LRCUST = 999990
             and   LRQTOH < 0;

         *InLR = *On;

         If Cust999990 <> *Zero;
           Verified = *Off;
         Else;
           Verified = *On;
         ENDIF;

         Return;

      /End-Free
