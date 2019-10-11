             PGM

             CPYF       FROMFILE(QTEMP/FARWRK) +
                          TOFILE(TGMSDATA/FARWRK) MBROPT(*REPLACE)

             CPYF       FROMFILE(QTEMP/FARHIST) +
                          TOFILE(TGMSDATA/FARHIST) MBROPT(*REPLACE)

             CPYF       FROMFILE(QTEMP/FMTRAN) +
                          TOFILE(TGMSDATA/FMTRAN) MBROPT(*REPLACE)

             CPYF       FROMFILE(QTEMP/FAROPN) +
                          TOFILE(TGMSDATA/FAROPN) MBROPT(*REPLACE)

/*           CPYF       FROMFILE(QTEMP/FMCUST) +
                          TOFILE(TGMSDATA/FMCUST) MBROPT(*REPLACE) */

             ENDPGM
