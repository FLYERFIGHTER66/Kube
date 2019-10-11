/*********************************************************************/
/*   PROGRAM-------- BIR255CL                                        */
/*   DATE WRITTEN--- 09/08/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- OPEN ORDERS BY ORDER NUMBER                     */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (003 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIR255')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE(' Open Orders By +
                          Order Number ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(BIR255)
 END:        ENDPGM
