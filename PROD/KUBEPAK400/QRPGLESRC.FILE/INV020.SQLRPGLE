**Free
    CTL-OPT
        DftActGrp(*no)
        Actgrp(*caller)
        Thread(*serialize)
        BndDir('*LIBL/KPFUNCTION')
        Debug(*Yes)
        Pgminfo(*Pcml:*Module)
        Option(*SrcStmt : *NoDebugIO)
        DatFmt(*usa);

    DCL-PI INV020;
    // This program is used to populate the static portions of our
    // available inventory based on availability from suppliers. (FSTDPLGPF2)
    // **NOTE** This pgm should be run whenever suppliers inventory changes.
    END-PI;

 // Dcl-Ds Pgmstatus PSDS Qualified;
 //    Job     Char(10) Pos(244);
 //    User    Char(10) Pos(254);
 //    Rundate Zoned(6) Pos(276);
 //    Runtime Zoned(6) Pos(282);
 //    Pgm     Char(10) Pos(334);
 // End-Ds;
 //
 // dcl-pr qCmdExc extpgm ;
 //     *n char(1000) options(*varsize) const ;
 //     *n packed(15:5) const ;
 // end-pr ;




    // Standard Plug Inventory 2C
    Exec SQL
             drop Table qtemp.FSTDPLGP2C;
    Exec SQL
             create Table qtemp.FSTDPLGP2C as
                        (Select * from FSTDPLGL2C) WITH DATA;
    Exec SQL
             Delete from FSTDPLGP2C;
    Exec SQL
             Insert into FSTDPLGP2C (Select * from qtemp.FSTDPLGP2C);

    // Standard Plug Inventory 4A
    Exec SQL
             drop Table qtemp.FSTDPLGP4A;
    Exec SQL
             create Table qtemp.FSTDPLGP4A as
                        (Select * from FSTDPLGL4A) WITH DATA;
    Exec SQL
             Delete from FSTDPLGP4A;
    Exec SQL
             Insert into FSTDPLGP4A (Select * from qtemp.FSTDPLGP4A);

    // Build Static PF 2
    Exec SQL
      Drop Table qtemp.FSTDPLGPF2;
    Exec SQL
      Create Table qtemp.FSTDPLGPF2 as (Select * from FSTDPLGPF2) with no Data;
    Exec SQL
      Insert into qtemp.FSTDPLGPF2 (Select * from qtemp.FSTDPLGP2C);
    Exec SQL
      Insert into qtemp.FSTDPLGPF2 (Select * from qtemp.FSTDPLGP4A);
    Exec SQL  // hold B2B
      call QSYS2/QCMDEXEC('HLDB2BALL');
    Exec SQL
        delete from FSTDPLGPF2;
    Exec SQL
        insert into FSTDPLGPF2 (
        Select    View_Control_Type
                , Ready_Date
                , Ready_Date_7
                , SowDate
                , Item_Number
                , Item_Size
                , Item_Description
                , Item_Sort
                , sum(Quantity_Available)
                , current timestamp as Retrieved_Time
        from qtemp.FSTDPLGPF2
        group by   View_Control_Type
                , Ready_Date
                , Ready_Date_7
                , SowDate
                , Item_Number
                , Item_Size
                , Item_Description
                , Item_Sort
                , current timestamp
        );
    Exec SQL  // release B2B
      call QSYS2/QCMDEXEC('RLSB2BALL');

    *InLR = *On;
    Return;

