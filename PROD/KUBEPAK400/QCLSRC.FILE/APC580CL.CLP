/*********************************************************************/
/*   PROGRAM-------- APC580CL                                        */
/*   DATE WRITTEN--- 02/25/97                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- SUMMARY MONTH END                               */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&SEQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&DISB) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&EXP) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&ANAL) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&OPEN) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&AGED) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&GL) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APC580')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('    A/P Summary +
                          Month End ')

             CALL       PGM(APC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(APC580)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)
             QSYS/RTVDTAARA DTAARA(*LDA (90 1)) RTNVAR(&DISB)
             QSYS/RTVDTAARA DTAARA(*LDA (91 1)) RTNVAR(&EXP)
             QSYS/RTVDTAARA DTAARA(*LDA (92 1)) RTNVAR(&ANAL)
             QSYS/RTVDTAARA DTAARA(*LDA (93 1)) RTNVAR(&OPEN)
             QSYS/RTVDTAARA DTAARA(*LDA (94 1)) RTNVAR(&AGED)
             QSYS/RTVDTAARA DTAARA(*LDA (95 1)) RTNVAR(&GL)
             QSYS/RTVDTAARA DTAARA(*LDA (18 1)) RTNVAR(&SEQ)

             IF         COND(&DISB = 'N') THEN(GOTO CMDLBL(EXP))

             QSYS/OVRPRTF FILE(APR500) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)

             CALL       PGM(APR500)

 EXP:        IF         COND(&EXP = 'N') THEN(GOTO CMDLBL(ANAL))
             QSYS/OVRPRTF FILE(APR510) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             CALL       PGM(APR510)

 ANAL:       IF         COND(&ANAL = 'N') THEN(GOTO CMDLBL(OPEN))
             QSYS/OVRPRTF FILE(APR540) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             IF         COND(&SEQ = 'A') THEN(GOTO CMDLBL(ASEQ))
             CALL       PGM(APR540)
                        GOTO OPEN

 ASEQ:       CALL       PGM(APR542)

 OPEN:       IF         COND(&OPEN = 'N') THEN(GOTO CMDLBL(AGED))
             QSYS/OVRPRTF FILE(APR395) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             IF         COND(&SEQ = 'A') THEN(GOTO CMDLBL(OSEQ))
             CALL       PGM(APR395)
                        GOTO AGED

 OSEQ:       CALL       PGM(APR396)

 AGED:       IF         COND(&AGED = 'N') THEN(GOTO CMDLBL(GL))
             QSYS/OVRPRTF FILE(APR360) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             IF         COND(&SEQ = 'A') THEN(GOTO CMDLBL(ALP))
             CALL       PGM(APR360)
                        GOTO GL
 ALP:        CALL       PGM(APR361)

 GL:         IF         COND(&GL = 'N') THEN(GOTO CMDLBL(END))
             CALL       PGM(APR550)
             CALL       PGM(APR560)
             CALL       GLR870CL
 END:        ENDPGM
