/*********************************************************************/
/*   PROGRAM-------- GLR228CL                                        */
/*   DATE WRITTEN--- 08/20/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ACCOUNT DETAIL INQUIRY WITH VENDOR              */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLR228')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   Account +
                          Detail Inquiry ')

             CALL       PGM(GLC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(GLR228)
 END:        ENDPGM
