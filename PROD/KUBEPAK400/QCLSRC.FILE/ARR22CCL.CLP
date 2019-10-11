/*********************************************************************/
/*   PROGRAM-------- ARR22CCCL                                       */
/*   DATE WRITTEN---  9/06/99                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- A/R BALANCE INQUIRY                             */
/*   REVISIONS------ CALLED NO COMPANY VERIFICATION NEEDED           */
/*                  (NO LDA USED)                                    */
/*********************************************************************/
             PGM        PARM(&LCO &LCUST)
             DCL        VAR(&LCO) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&LCUST) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&HIST) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             OVRPRTF    FILE(ARR22A) TOFILE(QSYSPRT) PAGESIZE(66 +
                          120) LPI(6) CPI(15) ALIGN(*NO) FORMTYPE(*NAR)
             OVRPRTF    FILE(ARR220) TOFILE(QSYSPRT) PAGESIZE(66 +
                          120) LPI(6) CPI(15) ALIGN(*NO) FORMTYPE(*NAR)

 NXT:        CALL       PGM(ARR220C) PARM(&LCO &LCUST)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (134 1)) RTNVAR(&HIST)
             IF         COND(&HIST = ' ') THEN(GOTO CMDLBL(END))
             CALL       PGM(ARR226)

 END:        ENDPGM
