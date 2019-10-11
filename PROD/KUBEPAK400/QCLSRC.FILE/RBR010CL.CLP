             PGM

             OVRDBF     FILE(FMCUSTBILL) TOFILE(FMCUST)
             OVRDBF     FILE(FOECTL0) TOFILE(FOECTL)

             CALL       PGM(RBR010)

             ENDPGM
