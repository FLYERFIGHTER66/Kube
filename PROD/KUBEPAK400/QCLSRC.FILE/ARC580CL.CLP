/*********************************************************************/
/*   PROGRAM-------- ARC580CL                                        */
/*   DATE WRITTEN--- 09/24/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- SUMMARY MONTH END                               */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&INV) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&CM) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&CASH) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&SALE) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&LATE) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&TAX) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&AGE) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&GL) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARC580')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('    A/R Summary +
                          Month End ')

             CALL       PGM(ARC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(ARC580)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)
             QSYS/RTVDTAARA DTAARA(*LDA (90 1)) RTNVAR(&INV)
             QSYS/RTVDTAARA DTAARA(*LDA (91 1)) RTNVAR(&CM)
             QSYS/RTVDTAARA DTAARA(*LDA (92 1)) RTNVAR(&CASH)
             QSYS/RTVDTAARA DTAARA(*LDA (93 1)) RTNVAR(&SALE)
             QSYS/RTVDTAARA DTAARA(*LDA (94 1)) RTNVAR(&LATE)
             QSYS/RTVDTAARA DTAARA(*LDA (95 1)) RTNVAR(&TAX)
             QSYS/RTVDTAARA DTAARA(*LDA (96 1)) RTNVAR(&AGE)
             QSYS/RTVDTAARA DTAARA(*LDA (95 1)) RTNVAR(&GL)

             IF         COND(&INV = 'N') THEN(GOTO CMDLBL(CM))

             QSYS/OVRPRTF FILE(ARR530) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)

             CALL       PGM(ARR530)

 CM:         IF         COND(&CM = 'N') THEN(GOTO CMDLBL(CASH))

             QSYS/OVRPRTF FILE(ARR535) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             CALL       PGM(ARR535)

 CASH:       IF         COND(&CASH = 'N') THEN(GOTO CMDLBL(SALE))

             QSYS/OVRPRTF FILE(ARR520) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)

             CALL       PGM(ARR520)

 SALE:       IF         COND(&SALE = 'N') THEN(GOTO CMDLBL(LATE))



 LATE:       IF         COND(&LATE = 'N') THEN(GOTO CMDLBL(TAX))



 TAX:        IF         COND(&TAX = 'N') THEN(GOTO CMDLBL(GL))



 GL:         IF         COND(&GL = 'N') THEN(GOTO CMDLBL(END))



 END:        ENDPGM
