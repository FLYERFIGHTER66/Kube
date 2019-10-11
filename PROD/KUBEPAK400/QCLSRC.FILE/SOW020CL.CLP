/*********************************************************************/
/*   PROGRAM-------- SOW020CL                                        */
/*   DATE WRITTEN--- 12/07/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- BUILD SOW LINE FILE                             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&SOWL) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&SOWD) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&JOB#) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P) TYPE(*CHAR) LEN(10)

             DCL        VAR(&QDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&QTIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(90) VALUE('/Kube +
                          Pak/PDF/PRODUCTION_REPORTS/SOWLINE/SOW020ACL_')
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&QDATE)
             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT &QDATE *TCAT '_' +
                          *TCAT &QTIME *TCAT '.PDF')

             RTVDTAARA  DTAARA(SOWQRYCL (1 10)) RTNVAR(&P)
             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

             CALL       PGM(SOW001)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(SOW02)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/OVRPRTF FILE(SOW020) TOFILE(*LIBL/QSYSPRT) DEV(&P) +
                          DEVTYPE(*AFPDS) PAGESIZE(66 120) LPI(6) +
                          CPI(10) ALIGN(*NO) FORMTYPE(*NAR) +
                          COPIES(1) HOLD(*NO) SAVE(*NO) +
                          TOSTMF(&LINK) WSCST(*PDF) OVRSCOPE(*JOB)

             CALL       PGM(SOW020)

 END:        CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             ENDPGM
