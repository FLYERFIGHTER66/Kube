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

    DCL-PI MNGIDXADV;
    // This program is used to create and delete indexes based on usage
    END-PI;

      Exec SQL
      CREATE OR REPLACE PROCEDURE DBESTUDY.WEEKLY_INDEX_MANAGEMENT()
            LANGUAGE SQL
            BEGIN
                CALL SYSTOOLS.ACT_ON_INDEX_ADVICE(DATA_LIBRARY, NULL, NULL, 500, NULL);
                CALL SYSTOOLS.REMOVE_INDEXES(DATA_LIBRARY, 500, ' 7 DAYS ');
            END;

      Exec SQL
         CALL DBESTUDY.WEEKLY_INDEX_MANAGEMENT();

      *InLR = *On;
      Return;

