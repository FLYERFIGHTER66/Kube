/*********************************************************************/
/*   PROGRAM-------- GLC350CLJQ                                      */
/*   DATE WRITTEN--- 02/26/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- POST TO G/L BALANCE FILE                        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&PRTR) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&CONO) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&PERD) TYPE(*CHAR) LEN(2)

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRTR)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             CHGVAR     VAR(&PRTR) VALUE('DONTPRINT')

             QSYS/OVRPRTF FILE(GLR350) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRTR) PAGESIZE(88 120) LPI(8) +
                          CPI(15) OVRFLW(82) ALIGN(*NO) +
                          FORMTYPE(&FORM) COPIES(&COPY) HOLD(&HOLD) +
                          SAVE(&SAVE)
             QSYS/OVRPRTF FILE(GLR350E) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRTR) PAGESIZE(88 120) LPI(8) +
                          CPI(15) OVRFLW(82) ALIGN(*NO) +
                          FORMTYPE(&FORM) COPIES(&COPY) HOLD(&HOLD) +
                          SAVE(&SAVE)

             CALL       PGM(GLR350)

             QSYS/OVRPRTF FILE(GLR390) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRTR) PAGESIZE(66 120) LPI(6) +
                          CPI(15) OVRFLW(57) ALIGN(*NO) +
                          FORMTYPE(&FORM) COPIES(&COPY) HOLD(&HOLD) +
                          SAVE(&SAVE)

             CALL       PGM(GLR390)

/* POST GLBALT FILE                                                  */
             CLRPFM     FILE(FGLBALT) /* Clear to get rid of any +
                          deleted records */
             OVRDBF     FILE(FGLBALSB) TOFILE(*LIBL/FGLBALS)
             CALL       PGM(GLR351)

             QSYS/RTVDTAARA DTAARA(*LDA (1 2)) RTNVAR(&CONO)
             QSYS/RTVDTAARA DTAARA(*LDA (3 2)) RTNVAR(&PERD)

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (200 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('GLR350    ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE(&CONO)
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE(&PERD)
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('General Ledger +
                          Post Balances')
             CALL       PGM(STSUPD)

 END:        ENDPGM
