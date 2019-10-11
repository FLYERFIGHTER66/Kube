**Free
       CTL-OPT
           DftActGrp(*no)
           DatFmt(*usa);

       dcl-pi RBR651;    // Program Interface (No Parameters)
       END-PI;

       dcl-f RBR651FM WORKSTN;

       dcl-pr EndCurrentInventory extpgm('RBR655');
       end-pr ;

       dcl-pr Adjust_RB_Inventory extpgm('RBR654');
       end-pr ;

       dcl-s Count Zoned(5:0) Inz(0);
       dcl-s Screen Zoned(2:0) Inz(0);

       DoW not *InLR;
         Select;
           When Screen = 1;  // Inventory Data Already Exists
             Edit01();
           When Screen = 2;  // Ready to Inventory use F13 to prep Inventory Files
             Edit02();
           When Screen = 3;  // Inventory in Progress use F13 to Complete.
             Edit03();
           Other;
             Exec SQL Select count(*) into :Count from RBLOTRD;
             If Count > 0;  // Inventory Data Already Exists
               Scrn01();
              Else;
               Scrn02();
             EndIf;
         ENDSL;
       EndDo;

       Return;

       //=======================================================================

       DCL-PROC Scrn01;
         Screen = 1;
         exfmt RBR65101;
       END-PROC;

       DCL-PROC Scrn02;
         Screen = 2;
         exfmt RBR65102;
       END-PROC;

       DCL-PROC Scrn03;
         Screen = 3;
         exfmt RBR65103;
       END-PROC;

       //=======================================================================

       DCL-PROC Edit01;
         Select;
           When *In03;
             *InLR = *On;
           When *In15;
             SCRN03();  //  Scan in progress screen
           When *In13;
             EndCurrentInventory();  // End current inventory run
             Screen = 0;
           Other;
             SCRN01();
         ENDSL;
       END-PROC;

       DCL-PROC Edit02;
         Select;
           When *In03;
             *InLR = *On;
           Other;
             Prep_Inventory();
             SCRN03();  // Scan in Progress Screen
         ENDSL;
       END-PROC;

       DCL-PROC Edit03;
         Select;
           When *In03;
             *InLR = *On;
           When *In13;
             Adjust_RB_Inventory();  // Adjust the Inventory to match scans
             EndCurrentInventory();  // End current inventory run
             *InLR = *On;
           Other;
             SCRN03();  // Scan in Progress Screen
         ENDSL;
       END-PROC;

       //=======================================================================

       DCL-PROC Prep_Inventory;
         Exec SQL  // Prepare RB inventory file based on current Inventory
           Insert   into RBLOTRD
           Select   *
           From     FDLOTRD
           Where    LRGLOC = 'R'
             and    LRQTAV > 0  ;
         Exec SQL  // Initialize On-Hand Quantity on RB inventory File
           UPDATE   RBLOTRD Set LRQTOH = 0  ;
         Exec SQL  // Convert Item numbers for Partial Inventory
           UPDATE   RBLOTRD
           Set      LRITEM = trim(LRITEM)||'P'
           Where    LRCUST = 999997 ;
         Exec SQL  // Clear out the Last Run file.
           Delete   from RB_TRAY_LR;
         Exec SQL  // Save Last Run Inventory Scans in Last Run File
           Insert into RB_TRAY_LR Select * from RB_TRAY;
         Exec SQL  // Clear the RB scan file
           Delete   from RB_TRAY;
       END-PROC;
