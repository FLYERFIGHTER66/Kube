/*********************************************************************/
/*   PROGRAM-------- ARH210CL                                        */
/*   DATE WRITTEN---  8/03/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- A/R CHECK # INQUIRY                             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&HIST) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARH210')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('      A/R +
                          Balance Inquiry')

             CALL       PGM(ARC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             OVRPRTF    FILE(ARH210) TOFILE(QSYSPRT) PAGESIZE(66 80) +
                          LPI(6) CPI(10) ALIGN(*NO) PAGRTT(0) +
                          FORMTYPE(*NAR)
             CALL       PGM(ARH210)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

 END:        ENDPGM
