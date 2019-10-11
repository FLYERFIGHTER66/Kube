                                                                             /*+
?                                                                             +
?            THIS PROGRAM UPDATES THE LOT INVENTORY                           +
?       **   Deallocate Available Lot Inventory from Customers.               +
?       **   Balance the FDLOT file to the FDLOTRD File.                      +
?       **   Mark Lot Fixed once all Trays Scanned.                           +
?       **   Release Fixer Lot Inventory to Be Sold.                          +
?                                                                             +
?                                                                             */
             PGM

/* WJB       CALL       PGM(DLCLOTINV) /*    DEALLOCATE AVAILABLE +
  Removed per Bill S.     LOT INVENTORY FROM CUSTOMER     */

/*           CALL       PGM(BALLOTINV) /*    Balance the FDLOT file +
                          to the FDLOTRD File        */

             CALL       PGM(FIXLOTINV) /*    MARK LOT FIXED ONCE ALL +
                          TRAYS SCANNED             */

             CALL       PGM(RLSLOTINV) /*    RELEASE FIXER LOT +
                          INVENTORY TO BE SOLD  */

             ENDPGM
