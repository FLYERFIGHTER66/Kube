     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      //? :````````````````````````````````````````````````````````````:?
      //? :   Title:  Create a Finished Order from list of Items       :?
      //? :............................................................:?
      //? :````````````````````````````````````````````````````````````:
      //? : Created:  August 2014          ? Kube-Pak Corporation ?    :
      //? :      by:  William J. Behr                                  :
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :   Program Description                                     ?:
      //? : ```````````````````````                                   ?:
      //? :                                                           ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Edit Log                                                ?:
      //? :                                                           ?:
      //? :  WJB    -? 8/13/14 - Initial Programming                  ?:
      //? :         -?  /  /   - _____________________________________?:
      //? :............................................................:
     FFMUPCUPC  IF   E           K DISK                                         ?Item/UPC Master
     FFIORDRL10 UF   E           K DISK                                         ?Order Detail

      //? Main procedure prototype & interface
     D NCR715          PR                  ExtPgm('NCR715')
     D  #Order#                       6S 0
     D NCR715          PI
     D  #Order#                       6S 0

      //? Function Prototypes
     D Load01          PR
     D NCR725          PR                  ExtPgm('NCR725')
     D   #TimeStamp                    Z   CONST
     D   #SelOrder                    6S 0 CONST
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$_IC

      //? Field Definitions
     D  SelOrder       S              6S 0
     D  SelUPC         S             12S 0
     D  TimeStamp      S               Z

      //? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

       //?  ...........................................................
       //?  :   MAIN PROGRAM CALCS                                    :
       //?  :.........................................................:
      /Free
         // Create a Unique TimeStamp for this run
         SelOrder  = #Order#;
         TimeStamp = $TimeStamp();                                            //?Scan TimeStamp

         // Clear FFINCRT from any previous Run
         Exec SQL  // Delete previous Order scans
           Delete from FFINCRT where FOCUST = :SelOrder;

         // Check for anything scanned that is not on the order and add it to FFINCRT
         Exec SQL  // Select new items from scans
           INSERT INTO FFINCRT
           SELECT  'A'
                , :TimeStamp
                ,  PSORD#
                ,  PSUSER
                ,  PSITEM
                ,  PSSIZE
                ,  PSUPC
                ,  PSLOOK
                ,  PSCSCN
                ,  PSTIME
           FROM    NPUTSCN
           WHERE   PSORD#=:SelOrder
             and   PSMSTR = 99
             and   PSITEM||PSSIZE not in
                 ( Select OIITEM||OISIZE
                   from   FIORDR
                   where  OIORD# = :SelOrder
                     and  OISTAT='A'  );

         // Run NCR725 to add new products to Order
         CallP NCR725(TimeStamp:SelOrder);

         // Clear the Release Quantities for entire Order
         Exec SQL // Set OIRQTY=Zero on FIORDR
           Update   FIORDR
           SET      OIRQTY = 0
           WHERE    oiord# = :SelOrder;

         // Add Scanned Quantity to Released Quantity for Item.
           // If Released Quantity > Ordered Quantity then Increase Ordered Quantity
         Exec SQL //Get a record from NPUTERR, Process the UPC.
           SELECT PEUPC into :SelUPC
             FROM nputerr WHERE PEORD# = :SelOrder
             Fetch First Row Only;
         DoW SelUPC <> 0;
           ProcessUPC(SelUPC);
           SelUPC = 0;
           Exec SQL //Get next record from NPUTERR, Process the UPC.
             SELECT PEUPC into :SelUPC
               FROM nputerr WHERE PEORD# = :SelOrder
               Fetch First Row Only;
         EndDo;

         *InLR = *On;
         Return;

      /End-Free
       //?  ...........................................................
       //?  :   SUB-PROCEDURES                                        :
       //?  :.........................................................:

       //?Wrt_HORDR - Write the Order Header
     P ProcessUPC      B
     D ProcessUPC      PI
     D  SelUPC                       12S 0
     D  UPCQty         S             11S 1
     D  ToRelease      S             11S 1
      /Free
         Exec SQL // Get Quantity to Release from NPUTERR
           SELECT PESCAN
           INTO  :UPCQty
           FROM   nputerr
           WHERE  PEORD# = :SelOrder
             and  PEUPC  = :SelUPC;
         Exec SQL //Delete NPUTERR once processed.
           Delete nputerr
           WHERE  PEORD# = :SelOrder
             and  PEUPC  = :SelUPC;

         Chain (SelUPC) FMUPCUPC;
         If %Found(FMUPCUPC); //Go through order details and release
           ToRelease = UPCQty;

           SetLL (SelOrder:UPCITEM:UPCSIZE) FIORDRL10;
           Reade (SelOrder:UPCITEM:UPCSIZE) FIORDRL10;
           DoW not %EOF(FIORDRL10) and ToRelease > 0;
             If OIQORD - OIQSHP >= OIRQTY + ToRelease;
               OIRQTY += ToRelease;
               ToRelease = 0;
              Else;
               ToRelease = ToRelease - (OIQORD - OIQSHP);
               OIRQTY += (OIQORD - OIQSHP);
             EndIf;
             Update RIORDR;
           Reade (SelOrder:UPCITEM:UPCSIZE) FIORDRL10;
           EndDo;

           If ToRelease > 0; //If not enough ordered, add to first detail record found
             Chain (SelOrder:UPCITEM:UPCSIZE) FIORDRL10;
             If %Found(FIORDRL10);
               OIQORD += ToRelease;
               OIRQTY += ToRelease;
               Update RIORDR;
             EndIf;
           EndIf;
         EndIf;
      /End-Free
     P ProcessUPC      E
