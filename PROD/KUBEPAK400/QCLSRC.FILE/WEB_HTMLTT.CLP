             PGM

             CPYTOIMPF  FROMFILE(HTMLOUTF) +
                          TOSTMF('/QDLS/FTP/WEBSITE/FUTURE.HTM') +
                          MBROPT(*REPLACE) STMFCODPAG(*STDASCII) +
                          RCDDLM(*CRLF) DTAFMT(*FIXED) +
                          STRDLM(*NONE) FLDDLM(',')

 EOJ:        ENDPGM
