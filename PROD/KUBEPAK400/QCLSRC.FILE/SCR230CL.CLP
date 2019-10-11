/*********************************************************************/
/*   PROGRAM-------- SCR230CL                                        */
/*   DATE WRITTEN---  2/22/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT PUT DOWN LIST FROM GREENHOUSE             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CART &SHPD &MAST &CNTL &MODE)
             DCL        VAR(&CART) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&SHPD) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&MAST) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&CNTL) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
       /*    QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)    */
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             RTVDTAARA  DTAARA(SCR230PRT) RTNVAR(&PRT)
             QSYS/OVRPRTF FILE(SCR230) TOFILE(*LIBL/QSYSPRT) DEV(&PRT) PAGESIZE(66 80) LPI(6) +
                          CPI(10) ALIGN(*NO) FORMTYPE(*NAR)

             QSYS/OVRPRTF FILE(SCR230E) TOFILE(*LIBL/QSYSPRT) DEV(&PRT) PAGESIZE(66 80) LPI(6) +
                          CPI(10) ALIGN(*NO) FORMTYPE(*NAR)

             OVRPRTF    FILE(SCR230P)  DEV(R9) ALIGN(*NO) FORMTYPE(*NAR)
             OVRPRTF    FILE(SCR230P2) DEV(P7) ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(SCR230) PARM(&CART &SHPD &MAST &CNTL &MODE)
             DLTOVR     FILE(SCR230P)
             DLTOVR     FILE(SCR230P2)
             DLTOVR     FILE(SCR230E)

 END:        ENDPGM
