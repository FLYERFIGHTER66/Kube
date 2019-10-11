/*********************************************************************/
/*   PROGRAM-------- APC330CL                                        */
/*   DATE WRITTEN--- 04/15/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- CHECK PRINT                                     */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&REP) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT1) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&PRT2) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM1) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM2) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APC330')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('       A/P +
                          Check Print     ')

             CALL       PGM(APC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(APC330)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (76 1)) RTNVAR(&REP)
             IF         COND(&REP = 'Y') THEN(GOTO CMDLBL(RPRT))

             CALL       PGM(APR325)

 RPRT:       CALL       PGM(APR331)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (81 10)) RTNVAR(&PRT1)
             IF         COND(&PRT1 = '          ') THEN(DO)
             RTVSYSVAL  SYSVAL(QPRTDEV) RTNVAR(&PRT1)
                        ENDDO
             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT2)
             IF         COND(&PRT2 = '          ') THEN(DO)
             RTVSYSVAL  SYSVAL(QPRTDEV) RTNVAR(&PRT2)
                        ENDDO
             QSYS/RTVDTAARA DTAARA(*LDA (114 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (163 10)) RTNVAR(&FORM1)
             QSYS/RTVDTAARA DTAARA(*LDA (173 10)) RTNVAR(&FORM2)
             IF         COND(&FORM2 = '          ') THEN(DO)
             CHGVAR     VAR(&FORM2) VALUE(*NAR)
                        ENDDO

             QSYS/OVRPRTF FILE(APR330) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT1) PAGESIZE(42 90) LPI(6) CPI(10) +
                          OVRFLW(42) ALIGN(*NO) PRTQLTY(*NLQ) +
                          PAGRTT(0) FORMTYPE(&FORM1) COPIES(1)

             QSYS/OVRPRTF FILE(APR33A) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT2) PAGESIZE(66 120) LPI(6) +
                          CPI(15) ALIGN(*NO) PRTQLTY(*DRAFT) +
                          FORMTYPE(&FORM2) COPIES(&COPY) HOLD(*YES)

             CALL       PGM(APR330)

 END:        ENDPGM
