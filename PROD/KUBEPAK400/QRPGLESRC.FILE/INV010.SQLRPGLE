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

    DCL-PI INV010;
    // This program is used to populate the static portions
    // of our available inventory on a daily basis. (FSTDPLGPF1)
    END-PI;

    // ---------------------------------------------------------------
    // Build Kube_Pak_Plugs_All_Lots
    // ---------------------------------------------------------------
    Exec SQL drop   Table qtemp.Kube_Pak_Plugs_All_Lots;
    Exec SQL create Table qtemp.Kube_Pak_Plugs_All_Lots as
             (SELECT  MONDAY_DATE            as Ready_Date
                    ,MONDAY_DATE_CYYMMDD    as Ready_Date_7
                    ,SowDate(IMITEM,IMSIZE,MONDAY_DATE)
                                            as SowDate
                    ,IMITEM                 as Item_Number
                    ,IMSIZE                 as Item_Size
                    ,IMDES1                 as Item_Description
                    ,IMLOOK                 as Item_Sort
                    ,IMSOWC                 as Sow_Code
                    ,IMFRSZ                 as From_Size
                    ,SZPERC                 as Seed_or_Cut_per_Cell
                    ,SZSALE                 as Saleable_Cells
                    ,current timestamp      as Retrieved_Time
            FROM      MONDAYS
               ,      KubePak_Plug_Items
            join      FMSIZE on IMSIZE = SZCODE
            WHERE Monday_Date between current date - 70 days
                                  and current date + 377 days )
            WITH DATA;
    Exec SQL Delete from Kube_Pak_Plugs_All_Lots;
    Exec SQL Insert into Kube_Pak_Plugs_All_Lots
                    (Select * from qtemp.Kube_Pak_Plugs_All_Lots);

    // ---------------------------------------------------------------
    // Standard Plug Inventory 2A (Items unavailable on FMAVDTE)
    // ---------------------------------------------------------------
    Exec SQL drop   Table qtemp.FSTDPLGP2A;
    Exec SQL create Table qtemp.FSTDPLGP2A as
                        (Select * from FSTDPLGL2A) WITH DATA;
    Exec SQL Delete from FSTDPLGP2A;
    Exec SQL Insert into FSTDPLGP2A (Select * from qtemp.FSTDPLGP2A);

    // ---------------------------------------------------------------
    // Standard Plug Inventory 2B (Past Sow (NEXT_SOW_DATE_xxxx) )
    // ---------------------------------------------------------------
    Exec SQL drop   Table qtemp.FSTDPLGP2B;
    Exec SQL create Table qtemp.FSTDPLGP2B as
                        (Select * from FSTDPLGL2B) WITH DATA;
    Exec SQL Delete from FSTDPLGP2B;
    Exec SQL Insert into FSTDPLGP2B (Select * from qtemp.FSTDPLGP2B);

    // ---------------------------------------------------------------
    // Standard Plug Inventory 3A (Available Seed Items - 500's)
    // ---------------------------------------------------------------
    Exec SQL drop   Table qtemp.FSTDPLGP3A;
    Exec SQL create Table qtemp.FSTDPLGP3A as
                        (Select * from FSTDPLGL3A) WITH DATA;
    Exec SQL Delete from FSTDPLGP3A;
    Exec SQL Insert into FSTDPLGP3A (Select * from qtemp.FSTDPLGP3A);

    // ---------------------------------------------------------------
    // Standard Plug Inventory 3B (Seed Items (From Transplant) we CAN produce)
    // ---------------------------------------------------------------
    Exec SQL drop   Table qtemp.FSTDPLGP3B;
    Exec SQL create Table qtemp.FSTDPLGP3B as
                        (Select * from FSTDPLGL3B) WITH DATA;
    Exec SQL Delete from FSTDPLGP3B;
    Exec SQL Insert into FSTDPLGP3B (Select * from qtemp.FSTDPLGP3B);

    // ---------------------------------------------------------------
    // Standard Plug Inventory 3C (CUT Items w/out Supp. Inventory)
    // ---------------------------------------------------------------
    Exec SQL drop   Table qtemp.FSTDPLGP3C;
    Exec SQL create Table qtemp.FSTDPLGP3C as
                        (Select * from FSTDPLGL3C) WITH DATA;
    Exec SQL Delete from FSTDPLGP3C;
    Exec SQL Insert into FSTDPLGP3C (Select * from qtemp.FSTDPLGP3C);

    // ---------------------------------------------------------------
    // Add all PF versions to master PF file FSTDPLGPF1
    // ---------------------------------------------------------------
    Exec SQL call QSYS2/QCMDEXEC('HLDB2BALL'); // hold B2B

    Exec SQL Delete from FSTDPLGPF1;

    Exec SQL Insert into FSTDPLGPF1 (Select * from FSTDPLGP2A);
    Exec SQL Insert into FSTDPLGPF1 (Select * from FSTDPLGP2B);
    Exec SQL Insert into FSTDPLGPF1 (Select * from FSTDPLGP3A);
    Exec SQL Insert into FSTDPLGPF1 (Select * from FSTDPLGP3B);
    Exec SQL Insert into FSTDPLGPF1 (Select * from FSTDPLGP3C);

    Exec SQL call QSYS2/QCMDEXEC('RLSB2BALL'); // Release B2B

    *InLR = *On;
    Return;

