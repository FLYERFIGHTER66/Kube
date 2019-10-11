/*********************************************************************/
/*   PROGRAM-------- ARH220CL                                        */
/*   DATE WRITTEN---  8/10/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- A/R TRANSACTION INQUIRY BY DATE                 */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&HIST) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARH220')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE(' A/R +
                          Transaction Inquiry')

             CALL       PGM(ARC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             OVRPRTF    FILE(ARH220) TOFILE(QSYSPRT) PAGESIZE(66 +
                          120) LPI(6) CPI(10) ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(ARH220)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

 END:        ENDPGM
