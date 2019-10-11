             PGM        PARM(&SHIPDATE@)

             DCL        VAR(&SHIPDATE) TYPE(*DEC) LEN(6 0) +
                          VALUE(011606)
             DCL        VAR(&SHIPDATE@)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&NEXTSEQ#)    TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&NEXTSEQ@)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&MEMBERNAME)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBERDESC)   TYPE(*CHAR) LEN(50)
             DCL        VAR(&STREAMFILE)   TYPE(*CHAR) LEN(80)
             DCL        VAR(&RECORDS) TYPE(*DEC) LEN(10 0)

             CHGVAR     VAR(&SHIPDATE) VALUE(&SHIPDATE@)
             DSPFD      FILE(MTDSHIST) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) FILEATR(*PF) +
                          OUTFILE(QTEMP/DSPFD)

             OVRDBF     FILE(MTDSHIST) TOFILE(*LIBL/MTDSHIST) +
                          MBR(MT99999999)
             CALL       PGM(MTI010) PARM(&SHIPDATE &NEXTSEQ#)
             DLTOVR     FILE(MTDSHIST)

             RTVMBRD    FILE(MTDROPSHIP) NBRCURRCD(&RECORDS)

             IF         COND(&RECORDS *GT 0) THEN(DO)

             CHGVAR     VAR(&SHIPDATE@)  VALUE(&SHIPDATE)
             CHGVAR     VAR(&NEXTSEQ@)   VALUE(&NEXTSEQ#)

             CHGVAR     VAR(&MEMBERNAME) VALUE('MT' *CAT +
                          %SST(&SHIPDATE@ 5 2) *CAT %SST(&SHIPDATE@ +
                          1 2) *CAT %SST(&SHIPDATE@ 3 2) *CAT +
                          &NEXTSEQ@)
             CHGVAR     VAR(&MEMBERDESC) VALUE('Master Tag - Drop +
                          Ship File ' *CAT %SST(&SHIPDATE@ 1 2) +
                          *CAT '/' *CAT %SST(&SHIPDATE@ 3 2) *CAT +
                          '/20' *CAT %SST(&SHIPDATE@ 5 2) *CAT ' #' +
                          *CAT &NEXTSEQ@)

             CHGVAR     VAR(&STREAMFILE) VALUE('/QDLS/FTP/VF000477/SEND/' +
                          *CAT &SHIPDATE@ *CAT &NEXTSEQ@ *CAT '.DAT')

             CPYTOIMPF  FROMFILE(MTDROPSHIP) +
                          TOSTMF(&STREAMFILE) MBROPT(*REPLACE) +
                          STMFCODPAG(*STDASCII) RCDDLM(*CRLF) +
                          DTAFMT(*DLM) STRDLM(*NONE) FLDDLM('|')

             ADDPFM     FILE(MTDSHIST) MBR(&MEMBERNAME) +
                          TEXT(&MEMBERDESC)
             CPYF       FROMFILE(MTDROPSHIP) TOFILE(MTDSHIST) +
                          TOMBR(&MEMBERNAME) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             OVRDBF     FILE(MTDSHIST) MBR(&MEMBERNAME)
             QSYS/RUNSQL SQL('update mtdshist set MTTMSTMP = current +
                          time where YEAR(MTTMSTMP) = 1') COMMIT(*NONE)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(MTDSHIST)
             CPYF       FROMFILE(MTDROPSHIP) TOFILE(MTDSHIST) +
                          TOMBR(MT99999999) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)

             ENDDO

             ENDPGM
