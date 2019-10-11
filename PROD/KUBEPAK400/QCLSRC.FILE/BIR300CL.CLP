/*********************************************************************/
/*   PROGRAM-------- BIR300CL                                        */
/*   DATE WRITTEN--- 09/25/95                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ORDER PROOF LIST                                */
/*   REVISIONS------ 9/5/97 ADDED PRINT STATUS GD                    */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(4)
             QSYS/RTVDTAARA DTAARA(*LDA (7 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (3 4)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (25 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (17 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (21 4)) RTNVAR(&SAVE)
             OVRPRTF    FILE(BIR300) TOFILE(QSYSPRT) DEV(&PRT) +
                          PAGESIZE(66 132) LPI(6) CPI(10) +
                          FORMTYPE(&FORM) COPIES(&COPY) HOLD(&HOLD) +
                          SAVE(&SAVE)
             CALL       PGM(BIR300)
             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
