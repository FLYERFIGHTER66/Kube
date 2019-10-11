/*********************************************************************/
/*   PROGRAM-------- ARC238CL                                        */
/*   DATE WRITTEN--- 02/07/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- POST A/R SUMMARY INVOICE ENTRY                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (29 8)) VALUE('ARC238')
             CHGDTAARA  DTAARA(*LDA (37 30)) VALUE(' Post Summary +
                          Invoice Entry ')
             CALL       PGM(ARC999)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 4)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (114 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (117 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (121 4)) RTNVAR(&SAVE)
             QSYS/OVRPRTF FILE(ARR238) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             CALL       PGM(ARR238)
 END:        ENDPGM
