             PGM

             OVRDBF     FILE(FMCUSTBILL) TOFILE(FMCUST)
             OVRDBF     FILE(FOECTL0) TOFILE(FOECTL)

             CRTBNDRPG  PGM(*CURLIB/RBR010) SRCFILE(*LIBL/QRPGLESRC) +
                          SRCMBR(RBR010) DFTACTGRP(*NO) +
                          BNDDIR(*LIBL/KPFUNCTION) REPLACE(*YES)

             ENDPGM
