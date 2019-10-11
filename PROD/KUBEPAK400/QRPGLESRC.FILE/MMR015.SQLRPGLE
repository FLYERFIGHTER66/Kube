     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      //  :````````````````````````````````````````````````````````````:
      //  :     Multiple Master Includes this Order ?                  :
      //  :............................................................:
      //  :````````````````````````````````````````````````````````````:
      //  : Created:  February 27, 2009    ? Kube-Pak Corporation      :
      //  :      by:  William J. Behr                                  :
      //  :............................................................:
      //  :````````````````````````````````````````````````````````````:
      //  :   Program Description                                      :
      //  : ```````````````````````                                    :
      //  :                                                            :
      //  :............................................................:
      //  :````````````````````````````````````````````````````````````:
      //  :   Subroutine Usage                                         :
      //  :                                                            :
      //  :  *INZSR   - Initialization Subroutine                      :
      //  :............................................................:
      //  :````````````````````````````````````````````````````````````:
      //  :   Function Usage                                           :
      //  :                                                            :
      //  :  FUNCT  - FUNCT DESRIPTION HERE                            :
      //  :............................................................:
      //  :````````````````````````````````````````````````````````````:
      //  :   Indicator Usage                                          :
      //  :                                                            :
      //  :  LR       Does this really need a description ?            :
      //  :............................................................:

     FFMMASTSQ  IF   E           K DISK                                          Multiple Master
     FFHORDR    IF   E           K DISK                                          Order Header

      //  Function Prototypes
     D/COPY QFunctDefn,$Date
     D/COPY QFunctDefn,$Date7
     D/COPY QFunctDefn,$MDYDate
     D/COPY QFunctDefn,$DateMDY
     D/COPY QFunctDefn,$AddDate
     D/COPY QFunctDefn,$Monday

      //  Arrays
     D   DAYS          S             10A   Dim(0007) CtData                      Days of the Week
     D   WeekDay       S              6S 0 Dim(0007)                             Week Days

      //  Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

      //  Field Definitions
     D   Wanted        S               D                                         Date Wanted
     D   Friday        S               D                                         Today
     D   SDate         S              6S 0 Inz(0)                                Ship Date MDY
     D   SDateYMD7     S              7S 0                                       Ship Date YMD7
     D   MMOrders      S              2S 0                                       Count Orders
     D   Orders        S                   Like(MMOrders)                        Count Orders
     D   X             S              2S 0                                       Generic Counter
     D   Included      S               N                                         Order Included ?
     D   Excluded      S               N                                         Order Excluded ?
     D   MMWANTED#     S              6S 0

     C     *ENTRY        PList
     C                   Parm                    Order#            6 0
     C                   Parm                    Master            2 0
     C                   Parm                    SDateYMD7         7 0          |Ship Week (Mon) 7
     C                   Parm                    Included
      /FREE
       If Order# >= 999000;
         ExSr SpecialOrder;
       Else;
         Included = *Off;

         Wanted = $Date(SDateYMD7);                                           // Today MDY
         SDate = $MDYDate($Monday(Wanted:'SAT'));                             // Ship Date MDY

         Friday = $AddDate($DateMDY(SDate):-3);                               // Friday
         X = 1;
         DoW X <= 7;
           WeekDay(x) = $MDYDate($AddDate(Friday:X));                         // Populate  MDY
           X = X + 1;
         EndDo;

         Orders = *Zero;

         If Master > 0;
           ExSr ChkOrder;
         Else;
           Excluded = *Off;
           Exec SQL SELECT '1' INTO :Excluded FROM XATABL_SX, FHORDR
                    WHERE   XATABL_SX.TBSVIA=FHORDR.OHSHPC
                      AND   FHORDR.OHORD# = :Order#;
         EndIf;

         If Orders > 0 or ( Master = 0 and not Excluded );
           Included = *On;
         Else;
           Included = *Off;
         EndIf;

       EndIf;

       Return;

       //   ...........................................................
       //   :      ChkOrder - Check if Order is in selected Master    :
       //   :.........................................................:
       BegSr ChkOrder;

         SetLL Master FMMASTSQ;
         ReadE Master FMMASTSQ;
         Chain Order# FHORDR;
         DoW not %EOF(FMMASTSQ)
               and %Found(FHORDR)
               and Orders = *Zero;
           ExSr SQLCount;
           Orders = Orders + MMOrders;
           ReadE Master FMMASTSQ;
         EndDo;

       EndSr;

       //   ...........................................................
       //   :      SQLCount - Record Count Subroutine                 :
       //   :.........................................................:
       BegSr SQLCount;

         x=1;
         x=%lookup(MMWanted:Days:1);
         MMWANTED# = 0;
         If x <> *Zero;
           MMWANTED# = WeekDay(X);
         EndIf;
         MMOrders = 0;
         If 1=2;  // Skip the SQL
           exec sql
             SELECT  count(OHCUST)
             INTO   :MMOrders
             FROM    FHORDR
             WHERE   OHORD# = :Order#
               and   OHDTRY = :SDateYMD7
               and   OHSTAT = 'A'
               and  (OHDTCN = :MMWANTED# or  :MMWANTED  = '*ANY' )
               and  (OHCUST between :MMFRCUST and :MMTOCUST
                         or :MMFRCUST = 0     )
               and  (OHSHPC between :MMFRSVIA and :MMTOSVIA
                         or :MMFRSVIA = ' '   );
         EndIf;  // Skip the SQL

         If     OHSTAT = 'A' and OHDTRY = SDateYMD7
         and (  MMWANTED = '*ANY' or OHDTCN = MMWANTED# )
         and (( OHCUST >= MMFRCUST and OHCUST <= MMTOCUST) or MMFRCUST = 0 )
         and (( OHSHPC >= MMFRSVIA and OHSHPC <= MMTOSVIA) or MMFRSVIA = ' ');
           MMOrders = MMOrders + 1;
         EndIf;

       EndSr;

      //*   ...........................................................
      //*   :      SpecialOrder - Include Special Order               :
      //*   :.........................................................:
       BegSr SpecialOrder;

         Exec SQL
           SELECT   count(*)
           INTO    :MMOrders
           FROM     FMMAST
           WHERE    MMNUMB = :Master
             and   :Order# between MMFRCUST and MMTOCUST;

         If MMOrders <> *Zero;
           Included = *On;
         Else;
           Included = *Off;
         ENDIF;

         Return;

       EndSr;
**
&SATURDAY 1
&SUNDAY   2
&MONDAY   3
&TUESDAY  4
&WEDNESDAY5
&THURSDAY 6
&FRIDAY   7
