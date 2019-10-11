             PGM

             DCL        VAR(&STREAMFILE)   TYPE(*CHAR) LEN(80)
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10)

             QSYS/RTVOBJD OBJ(GRF010CL) OBJTYPE(*PGM) RTNLIB(&LIBR)

             CALL       PGM(GRF010) /*? BUILD GRIFFIN FILES ?*/

             CHGVAR     VAR(&STREAMFILE) +
         VALUE('/QDLS/FTP/CF002386/SEND/SPECIAL.CSV')

             CPYTOIMPF  FROMFILE(QTEMP/GRIFFINORD) +
                          TOSTMF(&STREAMFILE) MBROPT(*REPLACE) +
                          STMFCODPAG(*STDASCII) RCDDLM(*CRLF) +
                          DTAFMT(*DLM) STRDLM('"') FLDDLM(',')

             CLRPFM     FILE(&LIBR/QFTPSRC) MBR(GRF010FTP)
             CLRPFM     FILE(&LIBR/QFTPSRC) MBR(GRF010LOG)
             OVRDBF     FILE(INPUT) TOFILE(&LIBR/QFTPSRC) +
                          MBR(GRF010FTP)
             OVRDBF     FILE(OUTPUT) TOFILE(&LIBR/QFTPSRC) +
                          MBR(GRF010LOG)
             CALL       PGM(GRF020) /*? SEND GRIFFIN FILES ?*/
             FTP        RMTSYS(SERVERNOTFOUND)

             ENDPGM
