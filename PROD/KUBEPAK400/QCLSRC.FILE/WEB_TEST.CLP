             PGM        PARM(&FROMFILE &STREAMFILE)
             DCL        VAR(&FROMFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STREAMFILE) TYPE(*CHAR) LEN(80)

/*? SEND .CSV FILE ?*/
             CPYTOIMPF  FROMFILE(*LIBL/&FROMFILE) TOSTMF(&STREAMFILE) +
                          MBROPT(*REPLACE) STMFCODPAG(*STDASCII) +
                          RCDDLM(*CRLF) DTAFMT(*DLM) +
                          STRDLM('"') FLDDLM(',')


 EOJ:        ENDPGM
