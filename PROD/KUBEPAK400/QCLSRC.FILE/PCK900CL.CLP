
             PGM
             DCLF       FILE(PCK900FM)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&THISDATE) TYPE(*DEC) LEN(6 0) VALUE(0)
             DCL        VAR(&THISORDER) TYPE(*DEC) LEN(6 0) VALUE(0)
             DCL        VAR(&JOBDATE7) TYPE(*CHAR) LEN(7)
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(20)
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(90) VALUE('/kube +
                          pak/PDF/PICKS/')
             DCL        VAR(&ISBATCH) TYPE(*LGL) LEN(1)
             DCL        VAR(&UNPRT) TYPE(*LGL) LEN(1)  VALUE('0')

             RTVJOBA    DATE(&DATE)
             CHGVAR     VAR(&SELDATE) VALUE(&DATE)
             CHGVAR     VAR(&PRINTER) VALUE('XERPRT01')

 SCREEN01:   SNDRCVF    RCDFMT(PCK90001)
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(EOJ))
             IF         COND(&IN11 *EQ '1') THEN(GOTO CMDLBL(SCREEN02))

             CHGVAR     VAR(&THISDATE) VALUE(&SELDATE)
             CHGVAR     VAR(&THISORDER) VALUE(0)
             IF         COND(&UNPRTYN = 'Y') THEN(CHGVAR VAR(&UNPRT) +
                          VALUE('1'))

             CALLSUBR   SUBR(PRINT_PICK)
             CALLSUBR   SUBR(DSPLY_PICK)

             DLTOVR     FILE(*ALL)
             GOTO       CMDLBL(EOJ)

 SCREEN02:   SNDRCVF    RCDFMT(PCK90002)
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(EOJ))
             IF         COND(&IN11 *EQ '1') THEN(GOTO CMDLBL(SCREEN01))

             CHGVAR     VAR(&THISDATE) VALUE(0)
             CHGVAR     VAR(&THISORDER) VALUE(&SELORDER)
             CHGVAR     VAR(&UNPRT) VALUE('0')

             CALLSUBR   SUBR(PRINT_PICK)
             CALLSUBR   SUBR(DSPLY_PICK)

             DLTOVR     FILE(*ALL)
             GOTO       CMDLBL(SCREEN02)

/*============================================================================*/
             SUBR       SUBR(PRINT_PICK)

             IF         COND(&PRINTER *NE '*PDF') THEN(DO)
             OVRPRTF    FILE(PCK900P) TOFILE(*LIBL/PCK900P) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) +
                          LPI(7.5) CPI(12) FRONTMGN(.25 .25) +
                          PAGRTT(0) MULTIUP(1) FRONTOVL(HEADER) +
                          SPOOL(*YES) OUTQ(&PRINTER) FORMTYPE(*NAR)
             ENDDO

             ELSE       CMD(DO)

             RTVJOBA    JOB(&JOBNAME) CYMDDATE(&JOBDATE7) +
                          DATETIME(&TIMESTAMP)

             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT &JOBDATE7)
             CRTDIR     DIR(&LINK)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT '/' *TCAT 'PCK900' +
                          *TCAT '-' *TCAT &TIMESTAMP *TCAT '.pdf')
             OVRPRTF    FILE(PCK900P) TOFILE(*LIBL/PCK900P) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) +
                          LPI(7.5) CPI(12) FRONTMGN(.25 .25) +
                          PAGRTT(0) MULTIUP(1) FRONTOVL(HEADER) +
                          TOSTMF(&LINK) WSCST(*PDF)
             ENDDO

             CALL       PGM(PCK900) PARM(&THISDATE &THISORDER &UNPRT)

             ENDSUBR
/*============================================================================*/
             SUBR       SUBR(DSPLY_PICK)

             CALL       PGM(#ISBATCH) PARM(&ISBATCH)

             IF         COND(&PRINTER *EQ '*PDF' *AND &ISBATCH *EQ +
                          '0') THEN(DO)
             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD('"//10.151.151.1' *TCAT &LINK *TCAT +
                          '"') PAUSE(*NO)
             ENDDO

             ENDSUBR
/*============================================================================*/
 EOJ:        ENDPGM

