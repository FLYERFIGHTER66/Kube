/*********************************************************************/
/*   PROGRAM-------- GLC050CL                                        */
/*   DATE WRITTEN--- 08/21/99                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- ENTER G/L REPORT FORMATS                        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLR050')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('  G/L Report +
                          Format Entry ')
             CALL       PGM(GLC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             CALL       PGM(GLR050)
 END:        ENDPGM
