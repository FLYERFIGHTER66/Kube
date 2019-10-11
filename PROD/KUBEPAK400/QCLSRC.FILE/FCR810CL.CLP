             PGM

             XLSTABLE   XLS('/KUBE PAK/XLSIMPORT/FINPRDMRG.XLSX') +
                          FILE(QTEMP/FFINPPDUP2) CRTFILE(*YES) +
                          SRCFILE(TGMSDATA/QDDSSRC) HLINES(1) +
                          DATECOL(1 2)


             RUNQRY     QRYFILE((QTEMP/FFINPPDUP2)) OUTTYPE(*DISPLAY)

             ENDPGM
