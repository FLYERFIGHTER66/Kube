/*********************************************************************/
/*   PROGRAM-------- SCR300CL                                        */
/*   DATE WRITTEN---  2/22/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- SCANNER ERROR LIST FOR ORDER VERIFY             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ORDER &SHCYM)
             DCL        VAR(&ORDER) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&SHCYM) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
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

             QSYS/OVRPRTF FILE(NCR300) TOFILE(*LIBL/QSYSPRT) DEV(R6) +
                          PAGESIZE(66 80) LPI(6) CPI(10) ALIGN(*NO) +
                          FORMTYPE(*NAR)

             CALL       PGM(NCR300) PARM(&ORDER &SHCYM)

 END:        ENDPGM
