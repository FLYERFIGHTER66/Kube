/*********************************************************************/
/*   PROGRAM-------- GLR225CL                                        */
/*   DATE WRITTEN--- 08/03/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ACCOUNT DETAIL INQUIRY                          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLR225')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   Account +
                          Detail Inquiry ')

             CALL       PGM(GLC998)

             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(GLR225)
 END:        ENDPGM
