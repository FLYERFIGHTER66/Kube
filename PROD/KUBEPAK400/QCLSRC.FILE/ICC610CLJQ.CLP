/*********************************************************************/
/*   PROGRAM-------- ICC610CLJQ                                      */
/*   DATE WRITTEN--- 09/12/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PHYSICAL TO BOOK COMPARISON                     */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRTR) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRTR)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             QSYS/OVRPRTF FILE(ICR610) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRTR) PAGESIZE(88 120) LPI(8) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)

             CALL       PGM(ICR610)

 END:        ENDPGM
