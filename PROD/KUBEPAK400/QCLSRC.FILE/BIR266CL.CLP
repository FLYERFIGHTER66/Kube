/*********************************************************************/
/*   PROGRAM-------- BIR266CL                                        */
/*   DATE WRITTEN---  4/03/00                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- OPEN ORDERS BY ITEM    WITH SOW DATE            */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIR266')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('     Open +
                          Orders By Item ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(BIR266)
 END:        ENDPGM
