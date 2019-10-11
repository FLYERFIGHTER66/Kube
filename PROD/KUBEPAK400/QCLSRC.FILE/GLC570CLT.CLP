/*********************************************************************/
/*   PROGRAM-------- GLC570CL                                        */
/*   DATE WRITTEN--- 02/25/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- TRIAL BALANCE BY ACCOUNT                        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCLF       FILE(HISTYEARS)
             DCL        VAR(&LDAPOS) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&TYEAR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&LYEAR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&YEAR2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&OVRLIBNAM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRTR) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)

             RTVSYSVAL  SYSVAL(QYEAR) RTNVAR(&YEAR2)
             CHGVAR     VAR(&LYEAR) VALUE('20' || &YEAR2)
             CHGVAR     VAR(&TYEAR) VALUE(&LYEAR)
             CHGVAR     VAR(&LYEAR) VALUE('2007')
             CHGVAR     VAR(&TYEAR) VALUE('2007')

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLC570')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   Trial +
                          Balance By Account ')

             CALL       PGM(GLC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

/*  GET AVAILABLE YEARS  */
             DSPOBJD    OBJ(QSYS/LSTYR*) OBJTYPE(*LIB) +
                          OUTPUT(*OUTFILE) OUTFILE(HISTYEARS)
             OVRDBF     FILE(HISTYEARS) SHARE(*YES)
             OPNQRYF    FILE((HISTYEARS)) KEYFLD((ODOBNM))

/*  LOAD YEARS INTO LDA  */
             CHGVAR     VAR(&LDAPOS) VALUE(178)
 LOOP1:      RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDLOOP1))
             CHGDTAARA  DTAARA(*LDA (&LDAPOS 10)) VALUE(&ODOBNM)
             CHGVAR     VAR(&LDAPOS) VALUE(&LDAPOS + 10)
             GOTO       CMDLBL(LOOP1)
 ENDLOOP1:   CLOF       OPNID(HISTYEARS)
             CHGDTAARA  DTAARA(*LDA (174 4)) VALUE(&LYEAR)

 SELECT:     CALL       PGM(GLC570)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             QSYS/RTVDTAARA DTAARA(*LDA (174 4)) RTNVAR(&LYEAR)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
 YEAR:
             IF         COND(&EOJ = 'Y') THEN(DO)
             CHGDTAARA  DTAARA(*LDA (133 1)) VALUE(' ')

             CALL       PGM(KUBEALLLBL)
             IF         COND(&LYEAR *NE &TYEAR) THEN(DO)
             CHGVAR     VAR(&YEAR2) VALUE(%SST(&LYEAR 3 2))
             CHGVAR     VAR(&OVRLIBNAM) VALUE('LSTYR' *CAT &YEAR2 +
                          *CAT '01')
             ADDLIBLE   LIB(&OVRLIBNAM)
             MONMSG     MSGID(CPF2103)
             ENDDO
             GOTO       CMDLBL(SELECT)
             ENDDO

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRTR)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)

             IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NOJ))
             SBMJOB     CMD(CALL PGM(*LIBL/GLC570CLJQ))
                        GOTO END

 NOJ:        CALL       PGM(GLC570CLJQ)
             GOTO       CMDLBL(SELECT)
 END:        CALL       PGM(KUBEALLLBL)
             ENDPGM
